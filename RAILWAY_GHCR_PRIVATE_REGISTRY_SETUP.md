# Railway GHCR Private Registry Setup

**Project:** NAPLANPrep  
**Updated:** 2026-08-17  
**Status:** CI-MANAGED — credentials set automatically on each deploy via Railway GraphQL API

---

## Architecture

```
GitHub Actions CI
  ↓  pushes uat-<sha> image (GITHUB_TOKEN, packages: write)
GHCR (private)
  ↓  Railway pulls uat-<sha> image (PAT via Railway API, read:packages)
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

## How Credentials Are Configured

Railway's UI Settings → Source shows only a Docker image edit control with **no credential field**. Credentials are configured via Railway's GraphQL API by CI on every push to `develop`.

The CI step "Configure GHCR pull credentials on Railway" (in `deploy-backend` job):

1. **Introspects** Railway's `ServiceInstanceSourceInput` GraphQL type to find the credential field name (Railway may use `imageCredentials`, `registryCredentials`, `credentials`, or `auth`)
2. **Calls** `serviceInstanceUpdate` with both the image tag and credential fields atomically
3. **Reports** `PRIVATE_REGISTRY_AUTH_SUPPORTED = YES/NO` and `CURRENT_CREDENTIAL_CONFIGURED = YES/NO_CONFIRMED`

If Railway's schema has no credential field, CI prints `PRIVATE_REGISTRY_EXISTING_SERVICE_SUPPORT = NO` and skips (the deploy proceeds; pull will fail with 401 if no credentials were pre-configured).

---

## One-Time Setup — GHCR_READ_TOKEN Secret

CI uses a secret `GHCR_READ_TOKEN` to pass the GHCR pull credential to Railway. This must be added once to GitHub Actions.

### Step 1 — Create a GitHub PAT (read:packages only)

**Recommended: Classic PAT** (fine-grained PAT GHCR support is limited)

1. Go to: **GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)**
2. Click **Generate new token (classic)**
3. Set:
   - Note: `railway-ghcr-pull`
   - Expiration: 90 days (set a calendar reminder to rotate)
   - Scopes: **`read:packages` only** — no other scopes
4. Click **Generate token** and copy the value (shown only once)

| Scope | Required? | Why |
|-------|-----------|-----|
| `read:packages` | YES | Pull images from ghcr.io |
| `write:packages` | NO | Not needed for pull |
| `repo` | NO | Not needed for GHCR pull |

### Step 2 — Add GHCR_READ_TOKEN as a GitHub Actions Secret

1. Go to: **GitHub → Repository → Settings → Secrets and variables → Actions**
2. Click **New repository secret**
3. Name: `GHCR_READ_TOKEN`
4. Value: (paste the PAT from Step 1)
5. Click **Add secret**

The CI references this as `${{ secrets.GHCR_READ_TOKEN }}` — only the secret name appears in YAML, never the value.

### Step 3 — Trigger a deploy

Push any commit to `develop`. The "Configure GHCR pull credentials on Railway" CI step will:
- Read `GHCR_READ_TOKEN` from secrets (masked in CI logs)
- Introspect Railway schema to find the credential field
- Call `serviceInstanceUpdate` with image + credential atomically
- Report `RAILWAY_GHCR_CREDENTIAL = CONFIGURED`

---

## Credential Security

| Concern | Status |
|---------|--------|
| PAT stored in Git / YAML value | NEVER — only the secret NAME appears in YAML |
| PAT in CI logs | NEVER — masked via `::add-mask::` before use |
| PAT in Docker image | NEVER — not a build arg or env var |
| PAT in Railway env vars | NEVER — passed to Railway API only for image pull config |
| PAT exposed to frontend | NEVER — frontend has no access to Railway internals |
| Minimum permissions | YES — `read:packages` only |
| Independently revocable | YES — dedicated PAT, revoke at github.com/settings/tokens |
| Separate from CI push token | YES — CI uses GITHUB_TOKEN (packages: write), Railway uses PAT (read only) |

---

## Expected CI Flow (after GHCR_READ_TOKEN is configured)

```
Build & Push Docker Images
  ├── Log in to GHCR (GITHUB_TOKEN, packages:write)
  ├── Build & push backend image → ghcr.io/.../naplanprep-backend:uat-<sha>
  └── Verify GHCR push artifacts (digest check)

Deploy Backend to Railway
  ├── Set env vars (Stripe, SPRING_PROFILES_ACTIVE=uat, etc.)
  ├── Configure GHCR pull credentials on Railway  ← NEW
  │     Introspect ServiceInstanceSourceInput schema
  │     serviceInstanceUpdate(image=uat-<sha>, <credField>={username, password})
  │     RAILWAY_GHCR_CREDENTIAL = CONFIGURED
  ├── serviceInstanceUpdate → source.image = uat-<sha> (verification re-confirms image)
  ├── Verify source persisted (FAIL if not)
  ├── serviceInstanceRedeploy → Railway pulls uat-<sha> from GHCR (authenticated)
  ├── Poll until deployment ACTIVE/SUCCESS
  └── Poll backend health until UP
```

---

## Credential Rotation

When the PAT expires or as a security precaution:

1. Create a new classic PAT with `read:packages` scope
2. Update the `GHCR_READ_TOKEN` GitHub Actions secret:
   - GitHub → Repository → Settings → Secrets → `GHCR_READ_TOKEN` → Update
3. Trigger a deploy to Railway — CI will push the new credential to Railway automatically
4. Revoke the old PAT at GitHub → Settings → Personal access tokens → Delete

Set a calendar reminder 2 weeks before the PAT expiry date.

---

## Troubleshooting

### CI: `PRIVATE_REGISTRY_EXISTING_SERVICE_SUPPORT = NO`

Railway's `ServiceInstanceSourceInput` has no credential field. The schema has changed or credentials are managed differently.

**Next steps:**
1. Check CI log for `Available fields:` — this shows what Railway's schema currently contains
2. If Railway added a new credential field name (not `imageCredentials`, `registryCredentials`, `credentials`, `auth`), update the candidate list in the "Configure GHCR pull credentials" step
3. If Railway does not support credentials for this service type, the service may need to be recreated with credential support enabled at creation time

### CI: `CURRENT_CREDENTIAL_CONFIGURED = NO` / `RAILWAY_GHCR_CREDENTIAL = NOT_CONFIRMED`

`serviceInstanceUpdate` returned GraphQL errors.

**Check:**
1. CI log for `WARN: serviceInstanceUpdate returned: ERRORS:` — inspect the error message
2. Verify `GHCR_READ_TOKEN` secret is set in GitHub Actions secrets
3. Verify `RAILWAY_TOKEN` has write access to the backend service

### Railway deploy logs: `unauthorized` / `denied` / `403`

Railway pulled with wrong or no credentials. Railway may not have accepted the credential update.

**Check:**
1. CI log for `RAILWAY_GHCR_CREDENTIAL =` — did the credential step succeed?
2. If `NOT_CONFIRMED`: check the error and fix, then re-run CI
3. If `CONFIGURED` but Railway still fails: Railway may have overwritten credentials in a subsequent call — check if the `Update Railway service source image and verify` step (which sets image without credentials) is clearing the credential due to replace semantics

### CI: `GHCR_READ_TOKEN secret not configured`

Add `GHCR_READ_TOKEN` as a GitHub Actions secret (see Step 2 above).
Railway must have credentials pre-configured from a previous successful run, or image pull will fail.

---

## Railway Schema — Expected State

From Railway GraphQL API introspection:
```
ServiceInstanceSourceInput: {
  image: String
  <credentialField>: { username: String, password: String }
  ...
}
```

The credential field name is detected dynamically from the schema each CI run. The first matching name in this priority order is used: `imageCredentials`, `registryCredentials`, `credentials`, `auth`.

If none match, the CI logs will show all available field names so the priority list can be updated.
