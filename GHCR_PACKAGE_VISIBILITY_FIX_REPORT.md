# GHCR Package Visibility Fix Report

**Project:** NAPLANPrep  
**Report date:** 2026-08-17  
**Status:** FIX APPLIED — Package-visibility mutation removed from CI

---

## Package Visibility Audit

| Package | Exists | Visibility | Used by |
|---------|--------|------------|---------|
| `naplanprep-backend` | YES | **PRIVATE** | Railway (pulls on redeploy) |
| `naplanprep-frontend` | YES | **PRIVATE** | Vercel builds from **source** — GHCR image unused |
| `naplanprep-admin` | YES | **PRIVATE** | Vercel builds from **source** — GHCR image unused |

Checked via anonymous GHCR token test (`ghcr.io/token?service=ghcr.io&scope=repository:...:pull`).  
Result: all three return HTTP 403 on anonymous pull → PRIVATE confirmed.

---

## Root Cause of the 404 Failure

The `Make GHCR backend package public` step (added in commit `19a4985`) called:

```
PATCH https://api.github.com/user/packages/container/naplanprep-backend
Authorization: Bearer ${{ secrets.GITHUB_TOKEN }}
```

This returned HTTP 404 for two reasons:

1. **GITHUB_TOKEN is a GitHub App installation token (repo-scoped), not a user OAuth token.**  
   The `/user/packages/…` endpoint requires the token to act as the authenticated user.  
   `packages: write` permission in the workflow grants push rights only; it does NOT grant package administration rights via the `/user/packages/` REST API.

2. **Package visibility management is an administrative action** that requires a PAT with the  
   `write:packages` classic OAuth scope — which cannot be granted to the automatic GITHUB_TOKEN.

---

## Why the Step Was Wrong to Begin With

### Vercel does NOT use GHCR images

Vercel deploys frontend and admin directly from source code using the Vercel CLI  
(`vercel --prod`). The Docker images pushed to GHCR for frontend and admin serve no purpose in  
the current deployment pipeline and no visibility change is required for them.

### Railway UI has no credential field

Railway Settings → Source shows only a Docker image edit control. There is no visible
"Add registry credential" field for an existing Docker-image service. Credentials must be
configured via Railway's GraphQL API (`serviceInstanceUpdate`), not the dashboard.

CI now handles this automatically: the "Configure GHCR pull credentials on Railway" step
introspects `ServiceInstanceSourceInput`, finds the credential field name, and sets it on
every push. See `RAILWAY_GHCR_PRIVATE_REGISTRY_SETUP.md` for the required `GHCR_READ_TOKEN`
GitHub Actions secret setup.

### CI should never manage package visibility on every build

Package visibility is a one-time administrative setting. Repeating a visibility mutation on every  
push is fragile (token scope changes break it) and unnecessary (visibility does not change between  
builds).

---

## Fix Applied

**Removed** the `Make GHCR backend package public` step from `build-and-push` job in  
`.github/workflows/deploy-uat.yml` (commit `<pending>`).

The CI pipeline is now:

```
build-and-push:
  1. Log in to GHCR (docker/login-action with GITHUB_TOKEN)
  2. Set image tag (uat-<sha>)
  3. Set up Docker Buildx
  4. Build & push backend
  5. Build & push frontend
  6. Build & push admin
  7. Verify GHCR push artifacts (digest non-empty → PASS/FAIL)
  ↓
deploy-backend:
  8.  Deployment diagnostic header
  9.  Set env vars on Railway
  10. Update Railway service source image and verify ← HARD FAIL if source doesn't persist
  11. Deploy new Railway service image (serviceInstanceRedeploy)
  12. Poll Railway deployment status until ACTIVE/SUCCESS
  …
```

Step 10 was also upgraded from WARN → FAIL in `19a4985`:  
if `serviceInstanceUpdate` returns no GQL errors but the source image does not  
actually persist in Railway, CI aborts immediately instead of triggering a stale-image deploy.

---

## If Railway Pull Fails in the Future

If a future CI run fails because Railway cannot pull the private GHCR image (e.g., PAT expired),
the fix is **not** to add a visibility API call to CI. Instead:

1. Rotate `GHCR_READ_TOKEN` GitHub Actions secret with a new PAT (`read:packages` only)
2. Re-run CI — the "Configure GHCR pull credentials on Railway" step will push the new PAT
   to Railway automatically via `serviceInstanceUpdate`

See `RAILWAY_GHCR_PRIVATE_REGISTRY_SETUP.md` → Credential Rotation.

**Railway UI has no credential field** for this service — do not look for one in the dashboard.
All credential management goes through the Railway GraphQL API via CI.

---

## Result Summary

```
BACKEND_PACKAGE_EXISTS  = YES
BACKEND_VISIBILITY      = PRIVATE

FRONTEND_PACKAGE_EXISTS = YES
FRONTEND_VISIBILITY     = PRIVATE

ADMIN_PACKAGE_EXISTS    = YES
ADMIN_VISIBILITY        = PRIVATE

GHCR_PUSH               = PASS  (packages:write on GITHUB_TOKEN is sufficient)

PACKAGE_VISIBILITY_API_REQUIRED  = NO
PACKAGE_VISIBILITY_STEP_REMOVED  = YES

GHCR_PAT_REQUIRED       = YES (GHCR_READ_TOKEN GitHub Actions secret, read:packages only)
GHCR_PAT_IN_YAML        = NO  (referenced as ${{ secrets.GHCR_READ_TOKEN }}, value encrypted)
GHCR_PAT_TO_RAILWAY     = YES (CI calls serviceInstanceUpdate with credential field)
GHCR_PAT_IN_APP_VARS    = NO  (never set as Railway env var)

RAILWAY_UI_CREDENTIAL   = NOT_AVAILABLE (no UI field for existing service)
RAILWAY_API_CREDENTIAL  = CI-MANAGED (serviceInstanceUpdate on every push)
RAILWAY_IMAGE_PULL      = PENDING (next CI run after GHCR_READ_TOKEN secret is added)

UAT_BUILD               = PENDING  (next CI run will confirm)
UAT_DEPLOYMENT          = PENDING
REMOTE_UAT_SMOKE        = PENDING
```
