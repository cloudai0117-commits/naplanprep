# NAPLANPrep — Azure Migration Master Plan

## Executive Summary

Migrate the NAPLANPrep platform from Railway (backend) + Vercel (frontend/admin) + GHCR (images) to Azure, using Azure Container Apps, PostgreSQL Flexible Server, Azure Managed Redis, Azure Container Registry, Azure Static Web Apps, and Azure Front Door Premium.

**Migration approach**: Lift-and-shift with Azure-native hardening. The existing Spring Boot backend, React frontend, and admin panel are unchanged. Only infrastructure and CI/CD targets change.

**Target go-live**: After successful cutover, the platform runs entirely on Azure with no Railway or Vercel dependency.

---

## Migration Phases

### Phase 1: Foundation and IaC
**Goal**: Provision all Azure resources via Terraform.

| Task | Owner | Status |
|---|---|---|
| Write Terraform IaC (15 files) | Infra | ✅ Complete |
| Create Terraform remote state storage | Infra | Pending |
| Run `terraform apply` for prod environment | Infra | Pending |
| Populate Key Vault secrets (initial-secrets runbook) | Security | Pending |

Deliverables: All resources in `AZURE_RESOURCE_MATRIX.md` provisioned and healthy.

---

### Phase 2: Container Registry Migration
**Goal**: Move from GHCR to Azure Container Registry.

| Task | Owner |
|---|---|
| Build and push production image to ACR | CI/CD |
| Verify ACR geo-replication to Australia Southeast active | Infra |
| Test private endpoint pull from Container Apps environment | Infra |

No DNS or traffic change in this phase — Railway still serves production.

---

### Phase 3: Database Migration
**Goal**: Move production data from Railway PostgreSQL to Azure PostgreSQL Flexible Server v16.

See: [AZURE_DATABASE_MIGRATION.md](AZURE_DATABASE_MIGRATION.md)

High-level steps:
1. Provision Azure PostgreSQL (done in Phase 1).
2. Take a `pg_dump` from Railway PostgreSQL.
3. Restore into `naplanprep_prod` database on Azure PostgreSQL via private endpoint.
4. Run Flyway baseline validation against the restored database.
5. Verify row counts and data integrity.
6. Keep Railway PostgreSQL running until cutover is complete.

**Data volume estimate**: ~500 MB (questions, users, subscriptions, exam results).
**Estimated migration window**: 2 hours.

---

### Phase 4: Redis Migration
**Goal**: Provision Azure Cache for Redis. No data migration needed.

See: [AZURE_REDIS_MIGRATION.md](AZURE_REDIS_MIGRATION.md)

Redis contains only transient data (JWT blacklist TTL 900s, rate limit windows). A fresh Redis instance is functionally correct at cutover time.

Impact: Users logged out within the past 15 minutes on Railway whose revoked tokens fall within the TTL window will not have their tokens blacklisted on the new Redis. Accepted risk — very small window.

---

### Phase 5: Stripe Migration
**Goal**: Switch from Stripe test mode to Stripe live mode and update webhook endpoint.

See: [AZURE_STRIPE_MIGRATION.md](AZURE_STRIPE_MIGRATION.md)

Steps:
1. Create Stripe live-mode products matching test-mode catalogue.
2. Update `STRIPE_SECRET_KEY` in Key Vault to `sk_live_...`.
3. Update `STRIPE_PUBLISHABLE_KEY` in Terraform variables and redeploy frontend.
4. Register new Stripe webhook endpoint pointing to `https://api.naplanprep.com.au/v1/subscriptions/webhooks/stripe`.
5. Update `STRIPE_WEBHOOK_SECRET` in Key Vault.
6. Test a real purchase in live mode.

---

### Phase 6: CI/CD Migration
**Goal**: Update GitHub Actions workflows to target Azure instead of Railway/Vercel/GHCR.

New workflows:
- `.github/workflows/azure-backend.yml` — build → ACR push → Container App revision
- `.github/workflows/azure-frontend.yml` — build → SWA deploy (frontend)
- `.github/workflows/azure-admin.yml` — build → SWA deploy (admin)

Old workflows (to be disabled after cutover):
- `.github/workflows/railway-deploy.yml`
- `.github/workflows/vercel-deploy.yml`

GitHub Actions secrets to configure: see `AZURE_RESOURCE_MATRIX.md` § CI/CD Integration.

---

### Phase 7: Application Profile
**Goal**: Create `application-prod.yml` Spring profile for Azure-specific config.

Key differences from UAT profile:
- `spring.flyway.repair-on-migrate: false` (inherited from base; not overridden)
- `spring.flyway.out-of-order: false`
- `spring.flyway.validate-on-migrate: true`
- `server.forward-headers-strategy: NATIVE` (Front Door sends `X-Forwarded-For`)
- `management.endpoint.health.show-details: when-authorized`
- No `server.error.include-message` override (inherits `never` from base)

---

### Phase 8: DNS and Front Door
**Goal**: Switch DNS to point at Azure Front Door.

1. Verify Front Door WAF is in Prevention mode and not blocking legitimate traffic.
2. Update DNS A/CNAME record for `api.naplanprep.com.au` → Front Door endpoint.
3. Update DNS A/CNAME record for `www.naplanprep.com.au` → SWA frontend.
4. Update DNS A/CNAME record for `admin.naplanprep.com.au` → SWA admin.
5. Validate SSL certificate provisioned by Front Door / SWA.

TTL: lower to 60s before cutover; restore to 300s after confirming stable.

---

### Phase 9: Cutover
**Goal**: Route all production traffic to Azure.

See: [AZURE_CUTOVER_RUNBOOK.md](AZURE_CUTOVER_RUNBOOK.md)

Go/no-go criteria:
- [ ] PostgreSQL restore validated, row counts match
- [ ] Container App health probes green
- [ ] Front Door WAF in Prevention mode, not blocking login/checkout
- [ ] Stripe live mode test purchase successful
- [ ] Redis private endpoint reachable from Container App
- [ ] Key Vault secrets loaded correctly (JWT keys materialise in `/tmp/jwt/`)
- [ ] All GitHub Actions workflows pass on the new infrastructure

---

### Phase 10: Post-Cutover Validation
**Goal**: Confirm all user-facing functions work correctly in production on Azure.

| Test | Expected |
|---|---|
| Student login → exam → result | 200 OK, score recorded |
| Teacher login → view student results | 200 OK, results visible |
| Admin login → question search | 200 OK, no correctAnswer in response |
| Stripe checkout → subscription entitlement | Payment recorded, exam access granted |
| Logout → token blacklisted | 401 on subsequent request with same token |
| Rate limit trigger | 429 after 60 requests per minute |

---

### Phase 11: Railway and Vercel Decommission
**Goal**: Shut down Railway and Vercel resources after 7-day stability window.

Steps:
1. Confirm no traffic in Railway/Vercel logs for 7 days.
2. Export any Railway env vars needed for reference.
3. Delete Railway services and project.
4. Delete Vercel project.
5. Remove GHCR images (optional — retain for 30 days as rollback artifact).
6. Update `docs/environments.md` to reflect new infrastructure.

---

## Risk Register

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| PostgreSQL data loss during migration | Low | Critical | pg_dump before migration; keep Railway DB running until 24h post-cutover |
| Stripe webhook secret mismatch | Medium | High | Test webhook in Stripe dashboard before cutover |
| Front Door WAF blocks legitimate traffic | Medium | High | Run WAF in Detection mode for 48h before switching to Prevention |
| Container App cold-start latency | Low | Medium | min_replicas=1 keeps one warm replica always running |
| JWT key material mismatch | Low | Critical | Validate `/actuator/health` after container start; entrypoint.sh writes to /tmp/jwt/ |
| Redis unavailable at cutover | Low | Medium | Rate limiter and JWT blacklist both have graceful degradation |

---

## Rollback Plan

If any phase fails, the rollback procedure is:
1. Revert DNS records to Railway/Vercel values (requires saved copies before cutover).
2. Disable the Azure GitHub Actions workflows; re-enable Railway/Vercel workflows.
3. Railway PostgreSQL remains the authoritative data store until the migration is confirmed stable.

Full rollback procedure: [AZURE_ROLLBACK_RUNBOOK.md](AZURE_ROLLBACK_RUNBOOK.md)

---

## Success Criteria

Migration is complete when:
- All 11 phases are checked off.
- No traffic to Railway or Vercel for 7 consecutive days.
- P50/P95 API latency on Azure ≤ baseline on Railway (measured via App Insights).
- Zero P0/P1 incidents for 7 days post-cutover.
- DR drill completed within 30 days of go-live.

---

## Document Index

| Document | Location |
|---|---|
| Resource matrix | [AZURE_RESOURCE_MATRIX.md](AZURE_RESOURCE_MATRIX.md) |
| Network plan | [AZURE_NETWORK_PLAN.md](AZURE_NETWORK_PLAN.md) |
| Security plan | [AZURE_SECURITY_PLAN.md](AZURE_SECURITY_PLAN.md) |
| Database migration | [AZURE_DATABASE_MIGRATION.md](AZURE_DATABASE_MIGRATION.md) |
| Redis migration | [AZURE_REDIS_MIGRATION.md](AZURE_REDIS_MIGRATION.md) |
| Stripe migration | [AZURE_STRIPE_MIGRATION.md](AZURE_STRIPE_MIGRATION.md) |
| Cutover runbook | [AZURE_CUTOVER_RUNBOOK.md](AZURE_CUTOVER_RUNBOOK.md) |
| Rollback runbook | [AZURE_ROLLBACK_RUNBOOK.md](AZURE_ROLLBACK_RUNBOOK.md) |
| DR plan | [AZURE_DR_PLAN.md](AZURE_DR_PLAN.md) |
| HLD | [../architecture/HLD_AZURE.md](../architecture/HLD_AZURE.md) |
| LLD (overview) | [../architecture/LLD_AZURE.md](../architecture/LLD_AZURE.md) |
| LLD (network) | [../architecture/LLD_AZURE_NETWORK.md](../architecture/LLD_AZURE_NETWORK.md) |
| LLD (security) | [../architecture/LLD_AZURE_SECURITY.md](../architecture/LLD_AZURE_SECURITY.md) |
| LLD (CI/CD) | [../architecture/LLD_AZURE_CICD.md](../architecture/LLD_AZURE_CICD.md) |
| LLD (database) | [../architecture/LLD_AZURE_DATABASE.md](../architecture/LLD_AZURE_DATABASE.md) |
| LLD (Stripe) | [../architecture/LLD_STRIPE_AZURE.md](../architecture/LLD_STRIPE_AZURE.md) |
| LLD (exam engine) | [../architecture/LLD_EXAM_ENGINE.md](../architecture/LLD_EXAM_ENGINE.md) |
| LLD (admin) | [../architecture/LLD_ADMIN.md](../architecture/LLD_ADMIN.md) |
| Terraform IaC | [../../infra/terraform/](../../infra/terraform/) |
