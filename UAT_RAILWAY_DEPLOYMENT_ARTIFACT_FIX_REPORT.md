# UAT Railway Deployment Artifact Fix Report

---

## Investigation Summary

### Confirmed No-Op Operations (return `true`, create nothing)

| Mutation | Result | Evidence |
|---|---|---|
| `environmentTriggersDeploy` | `true` | No new deployment appeared after 3 min polling |
| `deploymentRestart` | `true` | No new deployment appeared after 3 min polling |

### Confirmed Schema Gaps

| Mutation | Result |
|---|---|
| `deploymentCreate` | Does not exist in Railway schema |

### Available Deployment Mutations (from Railway GQL error)

`deploymentRemove`, `deploymentCancel`, `deploymentRestart`, `deploymentApprove`, `deploymentStop`

---

## OLD_DEPLOYMENT_ID

```
58550594-9f4f-40c5-8a15-54e5314e246c
status    = SUCCESS
createdAt = 2026-08-15T17:48:15.791Z
```

---

## Fix History

### Commit `96108cc` — PRE_TRIGGER_TIME + sort-descending approach
- Added `PRE_TRIGGER_TIME` guard to detect new vs. stale deployment
- Used `environmentTriggersDeploy` as trigger
- Result: `environmentTriggersDeploy` confirmed silent no-op

### Commit `4f140cf` — Heredoc indentation fix
- Fixed Python heredoc content at column 0 inside `run: |` block
- Required 10-space indentation inside YAML literal block scalar
- Result: YAML parse fixed, but `environmentTriggersDeploy` still no-op

### Commit `9b0f30f` — Collapsed multi-line Python to single line
- Eliminated remaining column-0 content in YAML run blocks
- Result: CI test suite now passes; deploy still failing

### Commit `67e9282` — Replaced with `deploymentRestart`
- Railway schema error confirmed `deploymentCreate` does not exist
- Tried `deploymentRestart(id)` on the latest SUCCESS deployment
- Result: Returns `true`, no new deployment created

### Commit `9451ec7` — `serviceInstanceRedeploy` + Railway CLI fallback
- Added source verification after `serviceInstanceUpdate` (query `serviceInstance`)
- Added Railway schema introspection (prints ALL mutation names to CI log)
- Primary: `serviceInstanceRedeploy(serviceId, environmentId)`
- Fallback: `npm install -g @railway/cli && railway redeploy --service <id> --yes`
- New deployment detection: requires BOTH `createdAt > PRE_TRIGGER_TIME` AND `id != PREVIOUS_DEPLOY_ID`

---

## RAILWAY_SOURCE_TYPE

Docker Image (GHCR) — `ghcr.io/cloudai0117-commits/naplanprep-backend:uat-<sha>`

---

## Status as of `9451ec7`

Superseded by `afdc04d` — see final confirmed status below.

---

## Final Confirmed Status — commit `afdc04d`

All CI jobs completed successfully for commit `afdc04d` (run `31954499806`).

| Field | Value |
|---|---|
| RAILWAY_SOURCE_TYPE | Docker Image (GHCR) |
| COMMIT_SHA | `afdc04d` |
| EXPECTED_IMAGE | `ghcr.io/cloudai0117-commits/naplanprep-backend:uat-afdc04d` |
| CONFIGURED_IMAGE_AFTER_UPDATE | `ghcr.io/cloudai0117-commits/naplanprep-backend:uat-afdc04d` |
| SERVICE_IMAGE_SOURCE_VERIFIED | PASS |
| PREVIOUS_DEPLOYMENT_ID | `d4ca1a26-17be-46d8-8038-59fd1d3719d8` |
| NEW_DEPLOYMENT_ID | `1075d153-050f-4c11-a311-132b4d13ff1e` |
| NEW_DEPLOYMENT_FOUND | attempt 1 (detected immediately — timestamp fix confirmed working) |
| NEW_DEPLOYMENT_CREATED | `2026-08-16T15:07:01.853Z` |
| NEW_DEPLOYMENT_STATUS | SUCCESS |
| TIMESTAMP_COMPARISON | PASS (`datetime.fromisoformat` fix working) |
| IMAGE_MATCH | PASS |
| BACKEND_HEALTH | PASS (DB Integrity Gate job: SUCCESS) |
| DB_INTEGRITY | PASS |
| FRONTEND | PASS (Deploy Frontend to Vercel: SUCCESS) |
| ADMIN | PASS (Deploy Admin to Vercel: SUCCESS) |
| SMOKE_TEST | PASS (Remote UAT Smoke Test: SUCCESS) |
| UAT_DEPLOYMENT | **PASS** |

### CI Job Results

| Job | Result | Duration |
|---|---|---|
| Build & Push Docker Images | ✓ SUCCESS | 3m39s |
| Deploy Backend to Railway | ✓ SUCCESS | 51s |
| DB Integrity Gate | ✓ SUCCESS | 5s |
| Deploy Admin to Vercel | ✓ SUCCESS | 37s |
| Deploy Frontend to Vercel | ✓ SUCCESS | 51s |
| Remote UAT Smoke Test | ✓ SUCCESS | 7s |

---

## Expected CI Log Output (if `serviceInstanceRedeploy` works)

```
===== DEPLOY NEW RAILWAY IMAGE =====
COMMIT_SHA=9451ec7...
EXPECTED_IMAGE=ghcr.io/cloudai0117-commits/naplanprep-backend:uat-9451ec7
EXPECTED_DIGEST=sha256:...
PRE_TRIGGER_TIME=2026-08-16T...

PREVIOUS_DEPLOYMENT_ID=58550594-9f4f-40c5-8a15-54e5314e246c

===== RAILWAY SCHEMA INTROSPECTION (all mutations) =====
  deploymentApprove
  deploymentCancel
  deploymentRemove
  deploymentRestart
  deploymentStop
  serviceCreate
  serviceInstanceRedeploy      <-- this is what we call
  serviceInstanceUpdate
  ...
===== END SCHEMA INTROSPECTION =====

Attempting serviceInstanceRedeploy(serviceId, environmentId)...
serviceInstanceRedeploy response:
{ "data": { "serviceInstanceRedeploy": true } }
serviceInstanceRedeploy = ACCEPTED (no GQL errors)

Waiting 15s for Railway to register the new deployment (attempt 1/16)...
New Railway deployment found after attempt N: <new-id>

RAILWAY_DEPLOYMENT_ID=<new-id>
RAILWAY_DEPLOYMENT_PREVIOUS_ID=58550594-9f4f-40c5-8a15-54e5314e246c
RAILWAY_DEPLOYMENT_STATUS=BUILDING
RAILWAY_DEPLOYMENT_CREATED=2026-08-16T...
NEW_DEPLOYMENT_ID_DIFFERS_FROM_PREVIOUS=YES
DEPLOYMENT_IS_NEW=YES
DEPLOYMENT_ID_CAPTURE = PASS
```

---

## Final Gate

```
UAT_DEPLOYMENT = PASS

ONLY IF:
  A NEW Railway deployment was created (id != OLD_DEPLOYMENT_ID)
  AND the NEW deployment corresponds to the newly built GHCR image
  AND the NEW deployment reaches SUCCESS
  AND backend health = UP
  AND DB Integrity = PASS
  AND Remote UAT Smoke = PASS
```
