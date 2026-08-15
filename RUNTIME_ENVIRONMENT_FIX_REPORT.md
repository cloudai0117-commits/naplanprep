# Runtime / Test-Environment Fix Report

**Date:** 2026-08-15  
**Branch:** develop  

---

## Issues Fixed

### Issue 1 — JWT: Ephemeral Keys in Non-Dev Profiles

**Symptom:** `"Could not load RSA keys from config, generating ephemeral keys for dev: Location must not be null"`

**Root cause:** `application-test.yml` did not set `app.jwt.private-key-path` or `app.jwt.public-key-path`. When properties are absent, the paths are null. `JwtTokenProvider.init()` caught the NullPointerException and fell back to generating random ephemeral keys each JVM startup — correct for dev, catastrophic for UAT/prod (tokens issued by one instance cannot be verified by another after restart).

**Fix:**
1. Generated a deterministic RSA-2048 key pair using JDK's `KeyPairGenerator` and stored the PEM files as test classpath resources:
   - `backend/src/test/resources/jwt/test-private.pem`
   - `backend/src/test/resources/jwt/test-public.pem`
2. Added to `application-test.yml`:
   ```yaml
   app:
     jwt:
       private-key-path: classpath:jwt/test-private.pem
       public-key-path: classpath:jwt/test-public.pem
   ```
3. Modified `JwtTokenProvider.init()` to inject `Environment` and fail-fast when the active profile is `uat` or `prod`:
   ```java
   for (String profile : environment.getActiveProfiles()) {
       if ("uat".equals(profile) || "prod".equals(profile)) {
           throw new IllegalStateException(
               "JWT RSA keys are required in " + profile + " profile. ...");
       }
   }
   ```

**Check 1 — No ephemeral-key warning in test logs:** PASS (keys load from classpath)  
**Check 2 — UAT/prod startup fails when keys absent:** PASS (IllegalStateException thrown)

---

### Issue 2 — Scheduler Fires Against Stopped Testcontainer DB

**Symptom:** `HikariPool: Connection to localhost:32769 refused` — `ExamService.expireOverdueSessions()` fires every 60 seconds via `@Scheduled` even when the Testcontainer PostgreSQL has been stopped.

**Root cause:** `@EnableScheduling` was unconditionally on `NaplanprepApplication`, so `@Scheduled` methods ran in ALL contexts including integration tests. After a test suite finishes and Testcontainer stops, the next scheduler tick tries a DB connection that no longer exists.

**Fix:**
1. Removed `@EnableScheduling` from `NaplanprepApplication.java`.
2. Created `SchedulerConfig.java`:
   ```java
   @Configuration
   @EnableScheduling
   @ConditionalOnProperty(name = "app.scheduler.enabled", havingValue = "true", matchIfMissing = true)
   public class SchedulerConfig {}
   ```
   `matchIfMissing = true` keeps scheduling ON for dev/UAT/prod where the property is absent.
3. Added to `application-test.yml`:
   ```yaml
   app:
     scheduler:
       enabled: false
   ```

**Check 3 — No Hikari connection-refused errors from scheduler in test logs:** PASS

---

### Issue 3 — Flyway "Already in a Transaction" Warnings

**Symptom:** `DB: there is already a transaction in progress` repeated for each V100–V374 content migration.

**Root cause:** Content migrations V100–V374 all start with a standalone `BEGIN;` statement (they own their own transaction boundaries). Flyway 9.x wraps each migration in its own transaction by default, so when the script's `BEGIN;` runs, PostgreSQL issues a WARNING about a nested transaction begin (the outer Flyway transaction is already open). Migrations still run correctly, but the warnings pollute logs.

**Fix:** Added to `application-test.yml`:
```yaml
spring:
  flyway:
    execute-in-transaction: false
```
With `execute-in-transaction: false`, Flyway does not wrap migrations in a transaction. Each migration's own `BEGIN;`/`COMMIT;` controls the transaction boundary, which is what the scripts were designed for.

Note: The content migration files (V100–V374) were NOT modified — the fix is applied at the Flyway layer only, per "do NOT modify content migrations unless a deployment blocker is proven."

**Check 4 — No Flyway nested-BEGIN warnings in test logs:** PASS

---

### Issue 4 — Stripe Webhook Signature Bypass in Tests

**Symptom:** `WEBHOOK_SIGNATURE_SKIP — webhook secret not configured; signature validation disabled.`

**Root cause:** `application-test.yml` set `webhook-secret: whsec_dummy_not_a_real_secret`. The string "dummy" is in the skip-verification allowlist in `SubscriptionService.parseAndValidate()`:
```java
boolean skipVerification = webhookSecret.contains("dummy") || ...;
```
`SubscriptionFlowApiTest.webhook()` sent `"stripe-signature", "t=1,v1=dummy_bypass"` — a fake signature that only worked because verification was disabled. This means the test was not verifying that the webhook security path works.

**Fix:**
1. Changed `application-test.yml` webhook secret to a deterministic CI value that does not contain "dummy" or "placeholder":
   ```yaml
   webhook-secret: ${STRIPE_WEBHOOK_SECRET:whsec_naplanprep_ci_test_signing_key_2024}
   ```
2. Added `stripeSignatureHeader()` static helper to `SubscriptionFlowApiTest` that computes a real `HMAC-SHA256` signature in the Stripe format (`t=<ts>,v1=<hex>`).
3. Updated `webhook()` helper to call `stripeSignatureHeader(payload, TEST_WEBHOOK_SECRET, now)` — tests now exercise the real signature verification path.
4. Updated the cancellation test's inline webhook call to use the same signature helper.
5. Added two new tests:
   - `webhook_with_invalid_signature_is_rejected` — sends `v1=invalid_signature_value` → expects 400
   - `webhook_with_valid_signature_is_accepted` — sends correct HMAC for a no-op event type → expects 200

**Check 5 — No WEBHOOK_SIGNATURE_SKIP in integration test logs:** PASS (real HMAC used)  
**Check 6 — Invalid signature returns 400:** PASS (new negative test added)  
**Check 7 — Valid signature returns 200:** PASS (new positive test added)

---

## Summary

| Check | Description | Status |
|-------|-------------|--------|
| 1 | No ephemeral-key warning in test logs | PASS |
| 2 | UAT/prod startup fails fast when JWT keys absent | PASS |
| 3 | No scheduler Hikari errors after Testcontainer stops | PASS |
| 4 | No Flyway nested-BEGIN warnings in test logs | PASS |
| 5 | No WEBHOOK_SIGNATURE_SKIP in integration test logs | PASS |
| 6 | Invalid webhook signature → 400 | PASS |
| 7 | Valid webhook signature → 200 | PASS |

**RUNTIME_ENVIRONMENT_READY = YES**

---

## Files Changed

| File | Change |
|------|--------|
| `backend/src/test/resources/jwt/test-private.pem` | New: RSA-2048 PKCS8 private key for test context |
| `backend/src/test/resources/jwt/test-public.pem` | New: RSA-2048 X.509 public key for test context |
| `backend/src/main/resources/application-test.yml` | Added JWT key paths, scheduler.enabled=false, flyway.execute-in-transaction=false, replaced dummy webhook secret |
| `backend/src/main/java/.../config/JwtTokenProvider.java` | Injected `Environment`; added UAT/prod fail-fast in `init()` |
| `backend/src/main/java/.../NaplanprepApplication.java` | Removed `@EnableScheduling` |
| `backend/src/main/java/.../config/SchedulerConfig.java` | New: `@ConditionalOnProperty` scheduling config |
| `backend/src/test/java/.../subscription/SubscriptionFlowApiTest.java` | `stripeSignatureHeader()` helper; real HMAC in all webhook calls; new positive/negative sig tests |

---

## Security Attestation

- No real Stripe credentials exist in source control.
- The test webhook secret `whsec_naplanprep_ci_test_signing_key_2024` is a synthetic test value; it is not a real Stripe webhook secret and does not authenticate with Stripe's API.
- RSA private test key at `src/test/resources/jwt/test-private.pem` is a test-only key used only to sign JWTs in the test context. It is not used in UAT or production. It does not need to be rotated.
- No private keys are committed that protect real user data or production secrets.
