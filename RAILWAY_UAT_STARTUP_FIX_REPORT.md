# Railway UAT Startup Fix Report

**Date:** 2026-08-15  
**Task:** Session H — Fix Railway UAT Startup / JWT RSA Key Deployment  
**Status:** CODE COMPLETE — pending Railway redeployment

---

## Root Cause

```
ROOT_CAUSE = JwtTokenProvider had no knowledge of JWT_PRIVATE_KEY / JWT_PUBLIC_KEY
             environment variables. It only read app.jwt.private-key-path (a Spring
             resource path). That property was being resolved to classpath:keys/private.pem
             (from a stale Railway Variable APP_JWT_PRIVATE_KEY_PATH or JWT_PRIVATE_KEY_PATH
             set to that value), which does not exist in the JAR. ClassPathResource threw
             FileNotFoundException → IllegalStateException in uat profile → BeanCreationException
             → Tomcat startup failure → Railway returns 502.

             Additionally, the deploy-backend Railway mutation set startCommand to
             "java ... -jar app.jar", bypassing the Docker ENTRYPOINT (entrypoint.sh)
             entirely — so key materialisation from env vars never ran.
```

---

## JWT Implementation

```
JWT_IMPLEMENTATION = JwtTokenProvider reads keys via two modes (after this fix):

  Mode 1 (preferred — cloud/Railway):
    System.getenv("JWT_PRIVATE_KEY")  → full PKCS#8 PEM content
    System.getenv("JWT_PUBLIC_KEY")   → full X.509 PEM content
    Checked FIRST in init(). When set, path-based config is ignored.

  Mode 2 (fallback — local/test):
    app.jwt.private-key-path  → Spring resource path (classpath:..., file:...)
    app.jwt.public-key-path   → Spring resource path
    Used when JWT_PRIVATE_KEY / JWT_PUBLIC_KEY are not set.

RAILWAY_VARIABLES_USED = JWT_PRIVATE_KEY / JWT_PUBLIC_KEY (env var PEM content, Mode 1)
```

---

## Changes Made

### 1. `JwtTokenProvider.java` — support env var PEM content (Mode 1)

**`init()` change:** Check `JWT_PRIVATE_KEY` / `JWT_PUBLIC_KEY` env vars first. If both are set, parse them as PEM directly and return — `app.jwt.private-key-path` is never consulted.

**`readKeyContent()` change:** Renamed from `readKeyFile`. Added inline PEM detection: if the string starts with `-----BEGIN`, treat it as PEM content (return its bytes directly). Otherwise load as a Spring resource path. This makes `loadPrivateKey` / `loadPublicKey` work with either a PEM string or a file path.

**Logging added (no secrets):**
```
JWT_PRIVATE_KEY configured = true
JWT_PUBLIC_KEY configured = true
JWT RSA keys loaded from environment variables (JWT_PRIVATE_KEY / JWT_PUBLIC_KEY)
```

**Tests unaffected:** Test profile uses `classpath:jwt/test-private.pem` via `app.jwt.private-key-path` in `application-test.yml`. Since `JWT_PRIVATE_KEY` is not set in CI test runs, Mode 2 (path-based) is used — no change in test behavior.

### 2. `backend/entrypoint.sh` — fail-fast + Spring Boot CLI args

Updated to:
- Exit 1 immediately if `JWT_PRIVATE_KEY` or `JWT_PUBLIC_KEY` is not set (rather than silently continuing)
- Pass `--app.jwt.private-key-path` and `--app.jwt.public-key-path` as Spring Boot command-line args (rank 1 priority, overrides all Railway Variables)

This acts as defense-in-depth: even if `APP_JWT_PRIVATE_KEY_PATH=classpath:keys/private.pem` remains in Railway Variables, the CLI arg overrides it when Mode 2 is reached. Combined with Mode 1 (env var check first), this gives two layers of protection.

### 3. `.github/workflows/deploy-uat.yml`

**`serviceInstanceUpdate` mutation:** Changed `startCommand` from `"java ... -jar app.jar"` to `null`. This clears the Railway override so the Docker ENTRYPOINT (`/bin/sh /app/entrypoint.sh`) is authoritative. The old override bypassed `entrypoint.sh` entirely.

**`deploy-backend` health gate:** Replaced the static `sleep 360` with active health polling:
- 60s initial wait (Railway image pull)
- Up to 21 × 20s = 7 min active polling of `/actuator/health`
- HTTP 502 after 3 attempts = immediate fail with `RAILWAY_BACKEND_UNHEALTHY`
- HTTP 200 + `status: UP` = PASS
- Timeout = fail

**`DEPLOYMENT_HEALTH_GATE`:** `deploy-backend` now only reports PASS when `/actuator/health` returns `UP`. A Railway API success alone is no longer sufficient.

---

## Priority Resolution (Why Mode 1 Wins)

Spring Boot property resolution order (highest to lowest):

| Rank | Source | Example |
|------|--------|---------|
| 1 | CLI args | `--app.jwt.private-key-path=...` |
| 5 | OS env vars (relaxed binding) | `APP_JWT_PRIVATE_KEY_PATH=...` |
| 7 | Application YAML | `app.jwt.private-key-path: ${JWT_PRIVATE_KEY_PATH:}` |

With Mode 1 active, `JwtTokenProvider.init()` reads `System.getenv("JWT_PRIVATE_KEY")` directly — bypassing Spring's entire property resolution chain. This is immune to any Railway Variable name collision.

---

## Railway Variables Required

| Variable | Purpose | Format | Who sets it |
|----------|---------|--------|-------------|
| `JWT_PRIVATE_KEY` | RSA private key PEM content | Full PKCS#8 PEM (multiline, including headers) | Manual — Railway dashboard |
| `JWT_PUBLIC_KEY` | RSA public key PEM content | Full X.509 PEM (multiline, including headers) | Manual — Railway dashboard |

These are already set. No action required.

**Stale variables to review (optional cleanup):**

If any of these exist in Railway Variables, they are now harmless (overridden) but can be removed:
- `JWT_PRIVATE_KEY_PATH`
- `JWT_PUBLIC_KEY_PATH`
- `APP_JWT_PRIVATE_KEY_PATH`
- `APP_JWT_PUBLIC_KEY_PATH`

---

## Expected Startup Log After Fix

```
JWT_PRIVATE_KEY configured = true
JWT_PUBLIC_KEY configured = true
[entrypoint] JWT private key written to /tmp/jwt/private.pem
[entrypoint] JWT public key written to /tmp/jwt/public.pem
[entrypoint] Starting application with key paths: /tmp/jwt/{private,public}.pem
...
JWT RSA keys loaded from environment variables (JWT_PRIVATE_KEY / JWT_PUBLIC_KEY)
...
CiServiceAccountBootstrap: CI service account ready: ci-integrity@naplanprep.internal
...
Tomcat started on port 8080
Started NaplanprepApplication in X.XXX seconds
```

No more:
- `class path resource [keys/private.pem] cannot be opened`
- `JWT RSA keys are required in uat profile`
- `generating ephemeral keys for dev`
- `BeanCreationException: Invocation of init method failed`

---

## Files Changed

| File | Change |
|------|--------|
| `backend/src/main/java/au/com/naplanprep/config/JwtTokenProvider.java` | Added Mode 1 (env var PEM), renamed `readKeyFile` → `readKeyContent` with inline PEM detection |
| `backend/entrypoint.sh` | Fail-fast on missing keys, pass key paths as Spring Boot CLI args |
| `.github/workflows/deploy-uat.yml` | Clear Railway `startCommand` (set null), replace `sleep 360` with active health polling, 502 diagnostics |

**NOT changed:** application-uat.yml, SecurityConfig, AppProperties, Stripe, Flyway, question content, test keys.

---

## Final Status

```
JWT_CONFIG_FIX          = PASS (code committed)

JWT_PERSISTENT_KEYS     = PASS (env var content is stable — same keys written on every
                          container start from the same Railway Variables)

DEPLOYMENT_HEALTH_GATE  = PASS (deploy-backend now polls /actuator/health)

RAILWAY_STARTUP         = PENDING (next push triggers deployment)
RAILWAY_HEALTH          = PENDING (after deployment)
JWT_AUTH                = PENDING (after health confirmed)
ACTUATOR_HEALTH         = PENDING (after health confirmed)
DB_INTEGRITY_GATE       = PENDING (after health confirmed)

PUBLISHED_EXAMS         = PENDING
EXPECTED                = 320
```
