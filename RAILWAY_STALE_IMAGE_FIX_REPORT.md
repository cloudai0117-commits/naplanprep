# Railway Stale Image Fix Report

**Date:** 2026-08-15  
**Commit:** see RAILWAY_DEPLOYMENT_ID after next pipeline run  
**Status:** WORKFLOW FIXED — awaiting next pipeline run

---

## Problem

Railway was running `ghcr.io/cloudai0117-commits/naplanprep-backend:uat-a664e94`
(approximately 1 hour old) while the latest GitHub commit was `8183634`.

The deployment pipeline was not actually deploying the newly built image to Railway.

---

## Root Cause Analysis

### Root Cause 1 — GraphQL errors were silently swallowed

`serviceInstanceUpdate` is a Railway GraphQL mutation. GraphQL **always** returns
HTTP 200, even when the mutation fails. The previous workflow used:

```sh
curl -sf -X POST "$RAILWAY_API" ...
```

`-sf` fails on HTTP 4xx/5xx, but GraphQL errors return HTTP 200 with an `errors`
array in the body. So a failed mutation (e.g. permission denied, invalid service ID,
authentication failure) was logged as success. Railway never changed its source image.

**Fix:** Capture the full response body and check for a non-empty `errors` field.
If any GraphQL errors are present, exit 1 immediately with a diagnostic message.

### Root Cause 2 — No deployment tracking

After calling `environmentTriggersDeploy`, the previous workflow:
- Did not capture a deployment ID
- Did not poll Railway's deployment status
- Went straight to polling `/actuator/health` — which hits whatever container
  Railway happens to be running (possibly the old one)

So the health gate was passing against the previous deployment's container, not
the new one. "Backend is UP" did not mean "the new image is running."

**Fix:** After triggering:
1. Query `deployments` API to get the latest deployment ID
2. Poll `deployment(id: ...)` until status is `SUCCESS` or `ACTIVE`
3. Fail immediately on `FAILED`, `CRASHED`, `REMOVED`, `ERROR`
4. Only then proceed to health polling

### Root Cause 3 — Image digest not captured or verified

The `docker/build-push-action` emits a `digest` output (e.g. `sha256:...`).
The previous workflow did not capture this, so there was no proof that the
GHCR push succeeded before proceeding to Railway.

**Fix:** Added `id: build-backend` to the backend build step and exposed
`backend-digest` as a job output. Verified the digest is non-empty before
proceeding to `deploy-backend`.

---

## Changes Made

### `.github/workflows/deploy-uat.yml`

**`build-and-push` job:**
- Added `id: build-backend` to the backend build step to capture the digest output
- Added `backend-digest: ${{ steps.build-backend.outputs.digest }}` job output
- Added "Verify GHCR push artifacts" step that fails immediately if digest is empty

**`deploy-backend` job — new steps:**

| Step | What it does |
|------|-------------|
| Deployment diagnostic header | Prints COMMIT_SHA, IMAGE_TAG, IMAGE_DIGEST, EXPECTED_IMAGE. Fails if digest missing. |
| Update Railway service source image | Calls `serviceInstanceUpdate` with `uat-<sha>` tag. **Checks GraphQL errors explicitly.** Fails if any errors present. |
| Trigger Railway deployment | Calls `environmentTriggersDeploy`. Checks GraphQL errors. Waits 15s, then queries `deployments` API to get the new deployment ID. Fails if image mismatch detected. |
| Poll Railway deployment status | Polls `deployment(id)` every 20s for up to 15 min. Fails on `FAILED`/`CRASHED`/`REMOVED`/`ERROR`. Passes only on `SUCCESS`/`ACTIVE`. |
| Print deployment summary | Prints all diagnostic fields before health poll. |
| Poll backend health | Unchanged logic, but only runs after Railway confirms deployment is ACTIVE. |

**Image tagging strategy:**
- Immutable tag `uat-<sha>` used for all Railway deployments (never `uat-latest`)
- `uat-latest` still pushed as a convenience alias but never used as deployment reference

---

## Pipeline Flow (After Fix)

```
build-and-push
  ├── Build & push backend (id: build-backend → captures digest)
  ├── Build & push frontend
  ├── Build & push admin
  └── Verify GHCR push artifacts (fails if digest empty)
       ↓
deploy-backend
  ├── Diagnostic header (prints commit + digest + expected image)
  ├── Set env vars on Railway (unchanged)
  ├── Update Railway service source image (checks GraphQL errors)
  ├── Trigger Railway deployment (checks errors + captures deployment ID)
  ├── Poll Railway deployment status until SUCCESS/ACTIVE
  ├── Print deployment summary
  └── Poll backend health until UP (/actuator/health = 200 + status=UP)
       ↓
db-integrity-gate
  └── /actuator/health/dbIntegrity (authenticated, canonical counts)
       ↓
deploy-frontend + deploy-admin (parallel, gated on db-integrity-gate)
       ↓
smoke-test
```

---

## Required Diagnostic Output (each pipeline run)

```
COMMIT_SHA=
BACKEND_IMAGE_TAG=
BACKEND_IMAGE_DIGEST=

RAILWAY_DEPLOYMENT_ID=
RAILWAY_DEPLOYED_IMAGE=

EXPECTED_IMAGE=
IMAGE_MATCH=PASS/FAIL/UNKNOWN

RAILWAY_DEPLOYMENT_STATUS=

BACKEND_HEALTH_HTTP=
BACKEND_HEALTH_STATUS=
```

---

## Failure Conditions

| Condition | Old behaviour | New behaviour |
|-----------|--------------|---------------|
| `serviceInstanceUpdate` GraphQL error | Silent pass | Immediate fail with error detail |
| Image not matching after trigger | Not detected | Fail if Railway API reports different image |
| Railway deployment FAILED/CRASHED | Not detected | Immediate fail with deployment ID |
| Health poll hits old container | Possible (no deployment gate) | Prevented (Railway status must reach SUCCESS first) |
| GHCR push failed | Not detected | Fail if digest is empty |

---

## Final Status (pending next pipeline run)

```
OLD_RAILWAY_IMAGE      = ghcr.io/cloudai0117-commits/naplanprep-backend:uat-a664e94

NEW_GHCR_IMAGE         = PENDING (next push will produce uat-<sha>)
NEW_IMAGE_DIGEST       = PENDING

RAILWAY_DEPLOYMENT_ID  = PENDING
RAILWAY_DEPLOYED_IMAGE = PENDING

IMAGE_MATCH            = PENDING
RAILWAY_DEPLOYMENT     = PENDING
BACKEND_HEALTH         = PENDING
DB_INTEGRITY           = PENDING
SMOKE_TEST             = PENDING
```
