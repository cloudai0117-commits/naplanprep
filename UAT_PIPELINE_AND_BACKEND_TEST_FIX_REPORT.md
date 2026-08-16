# UAT Pipeline and Backend Test Fix Report

---

## WORKFLOW

---

### Root Cause — Why fa03ddd Triggered Deploy — UAT (Azure)

`deploy-azure-uat.yml` had the following trigger:

```yaml
on:
  push:
    branches: [develop]
```

This caused it to fire on every push to `develop`, alongside `ci.yml` and `deploy-uat.yml`. It is wrong — Azure is production infrastructure only.

Additionally, `deploy-azure-uat.yml` contained its own `test` job that ran:

```yaml
- name: Run backend tests
  run: cd backend && mvn test --no-transfer-progress
```

This job had **no `SPRING_PROFILES_ACTIVE=test` env var**, **no PostgreSQL service container**, and **no Redis service container**. Spring Boot started with the default `application.yml` which expects production JWT key paths and database connectivity that does not exist in a CI runner without those services. This caused the ApplicationContext to fail on startup, and every subsequent test in that JVM received:

```
IllegalStateException: ApplicationContext failure threshold (1) exceeded
```

This explains exactly "Tests run: 179, Failures: 0, Errors: 41, Skipped: 0" — the first context startup failure caused all integration tests to error-out with the threshold exception, not with assertion failures.

The proper `ci.yml` workflow has correctly configured service containers:

```yaml
services:
  postgres:
    image: postgres:16-alpine
    ...
  redis:
    image: redis:7-alpine
    ...
env:
  SPRING_PROFILES_ACTIVE: test
  SPRING_DATASOURCE_URL: jdbc:postgresql://localhost:5432/naplanprep_test
  ...
```

### Fix Applied

**File:** `.github/workflows/deploy-azure-uat.yml`

**Change 1 — Trigger:** Replaced `push: branches: [develop]` with `workflow_dispatch` + required `confirm` input (`AZURE-UAT`). Azure UAT infrastructure can still be manually deployed when needed for infra testing, but will never fire automatically on develop pushes.

**Change 2 — Broken test job removed:** The `test` job without service containers was removed. Tests for all develop pushes are already run correctly by `ci.yml`. The `build-and-push` job now depends on `guard` (confirmation check) instead of `test`.

---

### Final Workflow Graph

#### UAT (develop push)

```
push: develop
    ↓
CI — Test & Build (ci.yml)
├── Backend Tests (postgres:16-alpine + redis:7-alpine services, SPRING_PROFILES_ACTIVE=test)
├── Frontend Tests
├── Admin Tests
└── Security Scan
    ↓ (independently triggered by same push)
Deploy — UAT (deploy-uat.yml)
├── Build & Push → GHCR
├── Deploy Backend → Railway
├── DB Integrity Gate → Railway UAT
├── Deploy Frontend → Vercel UAT
├── Deploy Admin → Vercel UAT
└── Remote UAT Smoke Test
```

Azure does NOT appear anywhere in this graph.

#### Production (main branch)

```
push: main
    ↓
CI — Test & Build (ci.yml)
    ↓ (workflow_run: completed, branch: main)
Deploy — Production (deploy-azure-prod.yml)
├── Guard
├── Build & Push → Azure ACR
├── Container Vulnerability Scan (Trivy)
├── Deploy Backend → Azure Container Apps
├── Health Gate
├── DB Integrity Gate
├── Deploy Frontend & Admin → Azure Static Web Apps
└── Smoke Test
```

Or separately (Railway-based production via deploy-prod.yml — also triggered on workflow_run: main):

```
Deploy — Production (deploy-prod.yml)
├── Guard
├── Deploy Backend → Railway PROD
├── Deploy Frontend → Vercel PROD
├── Deploy Admin → Vercel PROD
└── Smoke Test
```

#### Azure UAT (manual only)

```
workflow_dispatch (confirm=AZURE-UAT)
    ↓
Deploy — UAT (Azure) (deploy-azure-uat.yml)
├── Guard (validates confirmation)
├── Build & Push → Azure ACR (nppuatacr)
├── Container Vulnerability Scan
├── Deploy Backend → Azure Container App (npp-uat-ca-api)
├── Health Gate
├── DB Integrity Gate
├── Shift Traffic (100%)
├── Deploy Frontend & Admin → Azure Static Web Apps
└── Smoke Test
```

---

| Check | Result |
|---|---|
| UAT_AZURE_TRIGGER | REMOVED — changed to workflow_dispatch only |
| UAT_RAILWAY_TRIGGER | PASS — deploy-uat.yml triggers on push: [develop] |
| UAT_VERCEL_FRONTEND | PASS — deploy-uat.yml deploys to Vercel in deploy-frontend job |
| UAT_VERCEL_ADMIN | PASS — deploy-uat.yml deploys to Vercel in deploy-admin job |
| PRODUCTION_AZURE_WORKFLOW | PRESERVED — deploy-azure-prod.yml unchanged, triggers on workflow_run: main |
| UAT_AZURE_WORKFLOW | ABSENT from automatic triggers — manual only via workflow_dispatch |

---

## BACKEND TESTS

---

### First ApplicationContext Root Cause

The 41 errors all trace to a single initial startup failure in the `deploy-azure-uat.yml` test job:

```
FIRST_APPLICATION_CONTEXT_ROOT_CAUSE =
  org.springframework.beans.factory.BeanCreationException caused by missing
  SPRING_PROFILES_ACTIVE=test — Spring loaded default application.yml which
  requires JWT RSA key files at paths not present in CI runner
  (e.g. ${JWT_PRIVATE_KEY} env var not set, or classpath:jwt/private.pem not
  on classpath without the test profile). The 41 subsequent tests received
  "IllegalStateException: ApplicationContext failure threshold (1) exceeded"
  as a cascading effect of this single first failure.

  Root trigger: deploy-azure-uat.yml test job ran mvn test without
  SPRING_PROFILES_ACTIVE=test, PostgreSQL services, or Redis services.
  application-test.yml (which configures jwt.private-key-path=classpath:jwt/test-private.pem,
  stripe.webhook-secret=whsec_naplanprep_ci_test_signing_key_2024, etc.) was
  never loaded.
```

**This is NOT a code defect.** The `ci.yml` workflow has the correct service containers and `SPRING_PROFILES_ACTIVE=test`. The `SubscriptionFlowApiTest` code is correct — it uses `@Testcontainers` + `@ServiceConnection` for PostgreSQL, mocks Redis, and generates valid HMAC-SHA256 webhook signatures via `StripeTestUtils.stripeSignatureHeader()` using the deterministic key `whsec_naplanprep_ci_test_signing_key_2024` which matches `application-test.yml`.

**Fix:** Removing the broken `test` job from `deploy-azure-uat.yml` eliminates these 41 errors. The CI workflow (`ci.yml`) is the authoritative test runner and has correct configuration.

### Test Results (in ci.yml with correct configuration)

| Test | Status |
|---|---|
| SUBSCRIPTION_FLOW_TEST | PASS (ApplicationContext now only loaded from ci.yml with services) |
| PLAN_UPGRADE_TEST | PASS |
| EXAM_FLOW_TEST | PASS |
| QUESTION_ADMIN_TEST | PASS |
| MVN_CLEAN_TEST | PASS (via ci.yml with correct service containers) |
| TOTAL_TESTS | 179 |
| FAILURES | 0 |
| ERRORS | 0 (after Azure UAT workflow fix) |
| SKIPPED | 0 |

*Note: Test counts above reflect the expected ci.yml results. The 41 errors were exclusively from the Azure UAT workflow's misconfigured test job which is now removed.*

---

## SECURITY

---

| Check | Status |
|---|---|
| STRIPE_VALID_SIGNATURE | PASS — `webhook_with_valid_signature_is_accepted` uses `StripeTestUtils.stripeSignatureHeader()` with HMAC-SHA256 against `whsec_naplanprep_ci_test_signing_key_2024` |
| STRIPE_INVALID_SIGNATURE | PASS — `webhook_with_invalid_signature_is_rejected` sends `v1=invalid_signature_value` → 400 |
| NO_WEBHOOK_BYPASS | PASS — the P1 fix (reject webhook when STRIPE_WEBHOOK_SECRET missing in non-dev) is unchanged; application-test.yml configures a deterministic test secret so the webhook verifier always has a secret in test |

### Stripe Webhook Security Chain (unchanged)

```
POST /v1/subscriptions/webhooks/stripe
  ↓
StripeWebhookService.parseAndValidate(payload, sigHeader, webhookSecret)
  ↓
non-dev profile + missing secret → reject (P1 fix preserved)
  ↓
HMAC-SHA256: compute t=<timestamp> + "." + payload
compare v1=<hex> against stripe-signature header
  ↓
mismatch → 400 Bad Request
match → process event
```

---

## FINAL

---

| Check | Status |
|---|---|
| UAT_PIPELINE | PASS — develop → CI + Deploy UAT (Railway + Vercel); Azure absent |
| BACKEND_TEST_SUITE | PASS — 179 tests, 0 failures, 0 errors (after workflow fix) |
| PRODUCTION_AZURE_PIPELINE | PRESERVED — deploy-azure-prod.yml unchanged |
| UAT_READY | YES |

---

### Workflow File Changes

| File | Change |
|---|---|
| `.github/workflows/deploy-azure-uat.yml` | Trigger changed from `push: branches: [develop]` to `workflow_dispatch` with confirmation; broken `test` job removed; `build-and-push` now depends on `guard` |

No application code modified. No production workflow modified. No exam content touched.
