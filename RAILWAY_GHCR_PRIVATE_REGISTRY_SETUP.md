# Railway GHCR Private Registry Setup

**Project:** NAPLANPrep  
**Updated:** 2026-08-17  
**Status:** REQUIRED — Railway cannot pull backend image without this credential

---

## Architecture

```
GitHub Actions CI
  ↓  pushes uat-<sha> image (GITHUB_TOKEN, packages: write)
GHCR (private)
  ↓  Railway pulls uat-<sha> image (PAT, read:packages)
Railway UAT backend

GitHub Actions CI
  ↓  deploys from source (Vercel token)
Vercel (frontend, admin)    ← does NOT use GHCR images
```

Only Railway needs GHCR pull credentials. Vercel builds React apps from source code.

---

## Package Visibility

All three packages are PRIVATE and must remain PRIVATE:

| Package | Visibility | Consumer |
|---------|-----------|----------|
| `ghcr.io/cloudai0117-commits/naplanprep-backend` | PRIVATE | Railway (credentials required) |
| `ghcr.io/cloudai0117-commits/naplanprep-frontend` | PRIVATE | Vercel (unused — builds from source) |
| `ghcr.io/cloudai0117-commits/naplanprep-admin` | PRIVATE | Vercel (unused — builds from source) |

Do not change visibility to public.

---

## Step 1 — Create a GitHub PAT (read:packages only)

### Recommended: Fine-grained personal access token

1. Go to: **GitHub → Settings → Developer settings → Personal access tokens → Fine-grained tokens**
2. Click **Generate new token**
3. Set:
   - Token name: `railway-ghcr-pull` (or similar descriptive name)
   - Expiration: 1 year (set a calendar reminder to rotate)
   - Resource owner: `cloudai0117-commits`
   - Repository access: **Only select repositories** → `naplanprep`
   - Permissions:
     - Under **Repository permissions** → **Packages**: `Read` only

4. Click **Generate token** and copy the value immediately (shown only once)

### Note on fine-grained tokens and GHCR
GitHub fine-grained PATs with `Packages: Read` permission support pulling from GHCR for packages associated with the selected repository. If this doesn't work (fine-grained PATs have limited GHCR support), fall back to a classic PAT:

### Classic PAT fallback

1. Go to: **GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)**
2. Click **Generate new token (classic)**
3. Set:
   - Note: `railway-ghcr-pull`
   - Expiration: 90 days (shorter for classic PATs; rotate more frequently)
   - Scopes: **`read:packages` only**
4. Click **Generate token** and copy the value

### Required permission scope

| Scope | Required? | Why |
|-------|-----------|-----|
| `read:packages` | YES | Pull images from ghcr.io |
| `write:packages` | NO | Not needed for pull |
| `delete:packages` | NO | Not needed for pull |
| `repo` | NO | Not needed for GHCR pull |

### What NOT to do
- Do NOT store the PAT in source code
- Do NOT put it in any `.env` file committed to Git
- Do NOT log it in CI
- Do NOT give it to frontend/admin applications

---

## Step 2 — Configure Railway Registry Credential

### Via Railway Dashboard

1. Go to [railway.app](https://railway.app)
2. Open the **NAPLANPrep** project
3. Click the **backend UAT** service (service ID: `58b84f41-861e-41e1-9440-e73d5a54e18b`)
4. Click **Settings** tab
5. Under **Source / Deploy**, find **Image Source** or **Registry Credentials**
6. Add a registry credential:
   - **Registry:** `ghcr.io`
   - **Username:** `cloudai0117-commits`
   - **Password:** (paste the PAT from Step 1)
7. Save

### Verification
After saving, Railway should be able to pull `ghcr.io/cloudai0117-commits/naplanprep-backend:uat-<any-sha>` without authentication errors.

---

## Step 3 — Verify Image Source Configuration

Railway backend service must be configured to pull from:
```
ghcr.io/cloudai0117-commits/naplanprep-backend:uat-<GITHUB_SHA>
```

Each CI run sets this via GraphQL:
```graphql
mutation {
  serviceInstanceUpdate(
    serviceId: "58b84f41-861e-41e1-9440-e73d5a54e18b"
    environmentId: "588e636a-0be4-4fee-8a7e-02ce26f5ec6f"
    input: { source: { image: "ghcr.io/cloudai0117-commits/naplanprep-backend:uat-<sha>" } }
  )
}
```

CI then verifies the source persisted (hard-fail since commit `19a4985`). If the source does not persist, CI exits 1 before triggering deploy — preventing stale-image deploys.

### Immutable vs mutable tags

CI pushes two tags per build:
- `uat-<sha>` — **immutable** (pinned to exact commit, used as deployment artifact)
- `uat-latest` — **mutable** (overwritten each build, for reference only)

Railway is always configured to pull `uat-<sha>` (not `uat-latest`). This ensures the exact image tested by CI is what runs in UAT.

---

## Step 4 — Trigger Deployment

After configuring Railway credentials, push a commit to `develop`:

```bash
git commit --allow-empty -m "chore: trigger Railway deployment after GHCR credentials configured"
git push origin develop
```

Or simply wait for the next code push — any push to `develop` triggers the full deploy pipeline.

---

## Expected CI Flow (after credentials are configured)

```
Build & Push Docker Images
  ├── Log in to GHCR (GITHUB_TOKEN, packages:write)
  ├── Build & push backend image → ghcr.io/.../naplanprep-backend:uat-<sha>
  ├── Build & push frontend image (Vercel builds from source — image unused)
  ├── Build & push admin image (Vercel builds from source — image unused)
  └── Verify GHCR push artifacts (digest check)

Deploy Backend to Railway
  ├── Set env vars (Stripe, SPRING_PROFILES_ACTIVE=uat, etc.)
  ├── serviceInstanceUpdate → source.image = uat-<sha>
  ├── Verify source persisted (FAIL if not)
  ├── serviceInstanceRedeploy → Railway pulls uat-<sha> from GHCR (NOW WORKS with credentials)
  ├── Poll until deployment ACTIVE/SUCCESS
  └── Poll backend health until UP

DB Integrity Gate
  ├── Poll backend until UP
  ├── Authenticate CI service account → check /actuator/health/dbIntegrity
  │     V381/V382/V383/V384 migrations will have run → 320 exams, student_test_length populated
  └── Verify API returns studentTestLength (not old questionCount)
        STUDENT_TEST_LENGTH_GATE = PASS

Deploy Frontend to Vercel
Deploy Admin to Vercel

Remote UAT Smoke Test
  └── Verify studentTestLength for all 320 exams = non-null, correct values
```

---

## Credential Security

| Concern | Status |
|---------|--------|
| PAT stored in Git | NEVER — configured only in Railway dashboard |
| PAT in CI logs | NEVER — not passed through workflow YAML |
| PAT in Docker image | NEVER — not a build arg or env var |
| PAT exposed to frontend | NEVER — frontend has no access to Railway internals |
| Minimum permissions | YES — `read:packages` only |
| Independently revocable | YES — dedicated PAT, revoke at github.com/settings/tokens |
| Separate from CI push token | YES — CI uses GITHUB_TOKEN (packages: write), Railway uses PAT (read only) |

---

## Credential Rotation

When the PAT expires (or as a security precaution):

1. Create a new PAT at GitHub → Settings → Personal access tokens
2. Update Railway credential:
   - Railway dashboard → Backend service → Settings → Registry credentials
   - Replace old credential with new PAT
3. Trigger a test deployment to verify the new PAT works
4. Revoke the old PAT at GitHub → Settings → Personal access tokens → Delete

Set a calendar reminder 2 weeks before expiry.

---

## Troubleshooting

### Railway deployment fails with pull/auth error

Symptoms in Railway deploy logs:
```
unauthorized: authentication required
denied: access to the requested resource is not authorized
manifest unknown
```

Fix: Check that the Railway registry credential is saved for `ghcr.io` with the correct username (`cloudai0117-commits`) and a valid PAT.

### CI fails at "Update Railway service source image and verify"

```
FAIL: Railway service source shows '...' after update, expected 'ghcr.io/...:uat-<sha>'
```

This means `serviceInstanceUpdate` is not persisting the source. Check:
1. `RAILWAY_TOKEN` secret has write access to this service
2. Railway service is configured as "Docker image" source type (not GitHub source)
3. Railway API is not rejecting the mutation silently

### CI fails at "Verify API returns studentTestLength"

```
FAIL: API returns 'questionCount' instead of 'studentTestLength'. OLD CODE IS DEPLOYED.
```

Old code is running. Verify:
1. Railway registry credential is configured correctly
2. Railway service source shows `uat-<sha>` (check Railway dashboard)
3. The deployment pulled the new image (check Railway deploy logs for "Pulling image")

---

## Migration Notes

When new code deploys for the first time after old code was running:

Flyway will run V381, V382, V383, V384 in order:
- V381: ADD COLUMN student_test_length (may fail if column already exists from partial run)
- V382: Idempotent repair (runs even if V381 FAILED, via `ignore-migration-patterns: "*:Failed"`)
- V383: Fix stored exam_results.total_questions
- V384: Final corrective pass (handles any NULL/zero rows not covered above)

All 320 published exams will have `student_test_length > 0` after these migrations run.
