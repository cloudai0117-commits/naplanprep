# CI DB Integrity Gate Fix Report

**Date:** 2026-08-15  
**Pipeline run fixed:** `b00e4e2` (triggered after fixes)  
**Status:** RESOLVED

---

## Root Causes

Three independent root causes caused the DB Integrity Gate to report ALL metrics as MISSING in GitHub Actions pipeline run #31876476837:

### Root Cause 1 — `show-details: always` absent from UAT profile
- `application.yml` had `show-details: always` and `show-components: always`
- `application-uat.yml` did NOT override these settings
- Railway activates the `uat` profile; the base `application.yml` settings were being ignored because `uat` profile entries take precedence
- `/actuator/health` returned `{"status":"UP"}` with no `components` map
- All DB integrity metrics appeared MISSING in the gate script

**Fix:** Added explicit `management.endpoint.health.show-details: always` and `show-components: always` to `application-uat.yml`.

### Root Cause 2 — `SecurityConfig` blocked `/actuator/health/**`
- `SecurityConfig.requestMatchers` permitted `/actuator/health` exactly
- `/actuator/health/dbIntegrity` (used by the gate to check the custom indicator directly) returned 401
- The gate script was reading from the wrong JSON path inside the base health endpoint

**Fix:** Changed `"/actuator/health"` to `"/actuator/health", "/actuator/health/**"` in `SecurityConfig.java`.

### Root Cause 3 — Railway wait insufficient for Flyway V1–V379
- CI waited 240 seconds before polling the health endpoint
- Running 379 Flyway migrations on a fresh Railway PostgreSQL DB takes longer
- Health polling began before the application was ready

**Fix:** Increased Railway wait from 240s to 360s. Poll step runs 18 attempts × 20s = 6 minutes maximum.

---

## Files Changed

| File | Change |
|------|--------|
| `backend/src/main/resources/application-uat.yml` | Added `management.endpoints` and `management.endpoint.health` config block |
| `backend/src/main/java/.../config/SecurityConfig.java` | Added `/actuator/health/**` to `permitAll()` matchers |
| `.github/workflows/deploy-uat.yml` | Rewrote DB Integrity Gate; increased Railway wait to 360s; polled `/actuator/health/dbIntegrity` directly |

---

## Commits

- `b00e4e2` — DB integrity gate fix (application-uat.yml + SecurityConfig + workflow rewrite)
