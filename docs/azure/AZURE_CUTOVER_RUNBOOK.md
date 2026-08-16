# Azure Cutover Runbook

**Project:** NAPLANPrep  
**Version:** 1.0  
**Date:** 2026-08-16  
**Status:** Draft — Execute only after UAT sign-off  

---

## Critical Rules

- **DANGER markers** indicate irreversible or high-impact actions
- Every step must be completed and verified before proceeding
- If any step fails, execute the [AZURE_ROLLBACK_RUNBOOK.md](AZURE_ROLLBACK_RUNBOOK.md) immediately
- Cutover requires at least 2 operators: one executing, one verifying
- Target maintenance window: off-peak (Sunday 02:00–06:00 AEST)
- Estimated duration: 2–3 hours

---

## Pre-Cutover Checklist (Complete T-7 Days Before)

- [ ] All 19 migration phases completed and tested in UAT
- [ ] DB integrity gate passes in UAT (320 exams, all counts verified)
- [ ] All P0/P1/P2 security findings closed (FINAL_PLATFORM_SECURITY_FUNCTIONAL_AUDIT.md = PRODUCTION_READY)
- [ ] Azure PostgreSQL Flexible Server provisioned (Australia East, HA enabled)
- [ ] Azure Managed Redis provisioned (VNet-integrated)
- [ ] Azure Key Vault provisioned; all secrets loaded
- [ ] Azure Container Apps Environment provisioned (VNet-integrated)
- [ ] Azure Front Door Premium provisioned with WAF policy
- [ ] Azure Static Web Apps provisioned (frontend + admin)
- [ ] ACR provisioned; prod images pushed with `prod-{sha}` tags
- [ ] GitHub OIDC federated credentials configured for `prod` environment
- [ ] GitHub Environment `prod` has 1 required reviewer configured
- [ ] Stripe live mode: webhook endpoint registered for `api.naplanprep.com.au`
- [ ] Stripe live mode: price IDs loaded in Key Vault
- [ ] Custom domains verified in Front Door: `api.naplanprep.com.au`, `app.naplanprep.com.au`, `admin.naplanprep.com.au`
- [ ] TLS certificates issued (managed by Front Door)
- [ ] Communication sent to students: "scheduled maintenance 02:00–06:00 AEST Sunday {DATE}"
- [ ] Rollback runbook reviewed by both operators

---

## Pre-Cutover Checklist (Complete T-24 Hours Before)

- [ ] Final full database dump from Railway production PostgreSQL saved to secure location
- [ ] Stripe live publishable key confirmed working (test charge in live mode with test card)
- [ ] Azure Container App manually deployed from most recent `prod-{sha}` image, confirmed healthy
- [ ] DB integrity gate passes against Azure production database
- [ ] Log Analytics / Application Insights verified receiving data
- [ ] PagerDuty / Slack alert channels configured for Azure resources

---

## Phase 1 — Enable Maintenance Mode (T-0, 02:00 AEST)

**Duration:** 5 minutes

**Step 1.1** — Announce maintenance to any active users via in-app banner (if implemented). If no banner: proceed to DNS cutover which will show Front Door maintenance page.

**Step 1.2** — Set Railway backend to return 503 for all requests:

```bash
# Option A: Update Railway environment variable to trigger health check failure
# Consult current Railway deploy config for the safest approach
# Do NOT destroy Railway resources until Azure is confirmed healthy

# Option B: Enable maintenance mode page in Railway if available
```

**Step 1.3** — Verify no active exam sessions are in progress:

```sql
-- Run against Railway PostgreSQL (production)
SELECT COUNT(*) FROM exam_sessions WHERE status = 'IN_PROGRESS' AND started_at > NOW() - INTERVAL '30 minutes';
```

If count > 0, wait for sessions to complete or explicitly decide to proceed (sessions will be lost if cutover proceeds).

---

## Phase 2 — Final Data Synchronisation (T+5, 02:05 AEST)

**Duration:** 20–30 minutes

**Step 2.1 — Take final Railway PostgreSQL dump:**

```bash
# DANGER — This is the production database. Treat the dump file as sensitive.
pg_dump \
  --host=<railway-postgres-host> \
  --port=<railway-postgres-port> \
  --username=<railway-postgres-user> \
  --dbname=<railway-postgres-db> \
  --no-owner \
  --no-acl \
  --format=custom \
  --file=/secure/naplanprep-prod-cutover-$(date +%Y%m%d-%H%M%S).dump

# Verify dump is non-empty
ls -lh /secure/naplanprep-prod-cutover-*.dump
```

**Step 2.2 — Restore to Azure PostgreSQL Flexible Server:**

```bash
# DANGER — This will overwrite any existing data in the Azure database.
# Only run if the Azure database is empty or contains only test data.
pg_restore \
  --host=<azure-pg-host>.postgres.database.azure.com \
  --port=5432 \
  --username=naplanprep_admin \
  --dbname=naplanprep \
  --no-owner \
  --no-acl \
  --clean \
  --if-exists \
  --verbose \
  /secure/naplanprep-prod-cutover-*.dump
```

**Step 2.3 — Verify row counts match Railway database:**

```sql
-- Run against Azure PostgreSQL
SELECT 'exams' AS table_name, COUNT(*) FROM exams
UNION ALL SELECT 'questions', COUNT(*) FROM questions
UNION ALL SELECT 'exam_sessions', COUNT(*) FROM exam_sessions
UNION ALL SELECT 'student_answers', COUNT(*) FROM student_answers
UNION ALL SELECT 'users', COUNT(*) FROM users
UNION ALL SELECT 'subscriptions', COUNT(*) FROM subscriptions;
```

Compare with same query output from Railway database. Counts must match.

**Step 2.4 — Verify Flyway migration history:**

```sql
-- Check flyway_schema_history on Azure matches Railway
SELECT version, description, success FROM flyway_schema_history ORDER BY installed_rank;
-- Verify last row has version = 379 and success = true
```

---

## Phase 3 — Start Azure Backend (T+35, 02:35 AEST)

**Duration:** 5 minutes

**Step 3.1 — Scale Azure Container App to minimum replicas:**

```bash
az containerapp update \
  --name npp-prod-ca-api \
  --resource-group npp-prod-rg-app \
  --min-replicas 2 \
  --max-replicas 10
```

**Step 3.2 — Verify application health:**

```bash
# Poll health endpoint (via direct Container App FQDN — not Front Door yet)
FQDN=$(az containerapp show \
  --name npp-prod-ca-api \
  --resource-group npp-prod-rg-app \
  --query "properties.configuration.ingress.fqdn" -o tsv)

for i in $(seq 1 12); do
  HTTP=$(curl -s -o /dev/null -w "%{http_code}" "https://$FQDN/actuator/health")
  echo "Attempt $i: HTTP $HTTP"
  [ "$HTTP" = "200" ] && break
  sleep 10
done
```

**Step 3.3 — Run DB integrity gate against Azure backend:**

```bash
# Login with CI service account
CI_JWT=$(curl -s -X POST "https://$FQDN/v1/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"email":"'$CI_EMAIL'","password":"'$CI_PASSWORD'"}' | \
  python3 -c "import json,sys; print(json.load(sys.stdin)['data']['accessToken'])")

# Check integrity
curl -s -H "Authorization: Bearer $CI_JWT" \
  "https://$FQDN/actuator/health/dbIntegrity" | python3 -m json.tool
```

Expected: HTTP 200, `"status": "UP"`, all 10 catalogue invariants verified.

**Step 3.4 — Verify Stripe webhook endpoint:**

Confirm Stripe Dashboard shows webhook endpoint `https://api.naplanprep.com.au/v1/subscriptions/webhooks/stripe` active for live mode.

---

## Phase 4 — DNS Cutover (T+40, 02:40 AEST)

**Duration:** 5–30 minutes (TTL dependent)

**Pre-step — Record current DNS values for rollback:**

```bash
dig +short api.naplanprep.com.au CNAME
dig +short app.naplanprep.com.au CNAME
dig +short admin.naplanprep.com.au CNAME
```

**Step 4.1 — Update DNS to point to Azure Front Door:**

In your DNS provider (Cloudflare / Route53 / Azure DNS):

```
# Remove these records (Railway/Vercel)
api.naplanprep.com.au     CNAME   <railway-backend-domain>
app.naplanprep.com.au     CNAME   <vercel-frontend-domain>
admin.naplanprep.com.au   CNAME   <vercel-admin-domain>

# Add these records (Azure Front Door)
api.naplanprep.com.au     CNAME   npp-prod-fd-endpoint.z01.azurefd.net
app.naplanprep.com.au     CNAME   npp-prod-fd-endpoint.z01.azurefd.net
admin.naplanprep.com.au   CNAME   npp-prod-fd-endpoint.z01.azurefd.net
```

Set TTL to 60 seconds (if configurable) to allow fast rollback.

**Step 4.2 — Wait for DNS propagation:**

```bash
# Check from multiple external resolvers
for resolver in 8.8.8.8 1.1.1.1 9.9.9.9; do
  echo -n "Resolver $resolver: "
  dig +short @$resolver api.naplanprep.com.au CNAME
done
```

Wait until all resolvers return the Azure Front Door CNAME.

**Step 4.3 — Verify HTTPS response via custom domain:**

```bash
curl -v "https://api.naplanprep.com.au/actuator/health" 2>&1 | grep -E "< HTTP|status|TLS"
```

Expected: HTTP 200, valid TLS certificate for `api.naplanprep.com.au`.

---

## Phase 5 — Front Door Traffic Verification (T+45–T+70, 02:45–03:10 AEST)

**Duration:** 25 minutes

**Step 5.1 — Student frontend accessible:**

```bash
curl -s -o /dev/null -w "%{http_code}" "https://app.naplanprep.com.au/"
# Expected: 200
```

**Step 5.2 — Admin panel accessible:**

```bash
curl -s -o /dev/null -w "%{http_code}" "https://admin.naplanprep.com.au/"
# Expected: 200
```

**Step 5.3 — API responding via Front Door:**

```bash
curl -s "https://api.naplanprep.com.au/actuator/health" | python3 -m json.tool
# Expected: {"status": "UP", ...}
```

**Step 5.4 — Test authentication flow:**

```bash
curl -s -X POST "https://api.naplanprep.com.au/v1/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"email":"test-student@example.com","password":"<test-password>"}' | \
  python3 -c "import json,sys; d=json.load(sys.stdin); print('HTTP OK, got token:', bool(d.get('data',{}).get('accessToken')))"
```

**Step 5.5 — Test exam catalogue access:**

```bash
# Using token from 5.4
curl -s -H "Authorization: Bearer $STUDENT_JWT" \
  "https://api.naplanprep.com.au/v1/content/exams?size=5" | \
  python3 -c "import json,sys; d=json.load(sys.stdin); print('Exam count:', d.get('totalElements'))"
```

**Step 5.6 — DB integrity gate via Front Door:**

```bash
CI_JWT=$(curl -s -X POST "https://api.naplanprep.com.au/v1/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"email":"'$CI_EMAIL'","password":"'$CI_PASSWORD'"}' | \
  python3 -c "import json,sys; print(json.load(sys.stdin)['data']['accessToken'])")

curl -s -H "Authorization: Bearer $CI_JWT" \
  "https://api.naplanprep.com.au/actuator/health/dbIntegrity" | python3 -m json.tool
```

Expected: all 10 invariants = expected values.

---

## Phase 6 — Monitoring Validation (T+70–T+90, 03:10–03:30 AEST)

**Duration:** 20 minutes

**Step 6.1 — Verify Log Analytics receiving logs:**

```bash
az monitor log-analytics query \
  --workspace npp-prod-law \
  --analytics-query "ContainerAppConsoleLogs | where TimeGenerated > ago(10m) | count" \
  --output table
```

Expected: non-zero count.

**Step 6.2 — Verify no ERROR logs in backend:**

```bash
az monitor log-analytics query \
  --workspace npp-prod-law \
  --analytics-query "ContainerAppConsoleLogs | where TimeGenerated > ago(10m) and Log contains 'ERROR' | project TimeGenerated, Log" \
  --output table
```

Investigate any ERROR log before proceeding.

**Step 6.3 — Confirm Stripe webhook received test event:**

In Stripe Dashboard → Webhooks → npp-prod-stripe-webhook → Events:
Verify no failures in the last 30 minutes.

---

## Phase 7 — Exit Maintenance Mode (T+90, 03:30 AEST)

**Duration:** 5 minutes

**Step 7.1** — Remove maintenance mode from Railway (or confirm Railway is no longer serving traffic after DNS propagation).

**Step 7.2** — Send in-app notification or email to students: "Maintenance complete. NAPLANPrep is now available."

**Step 7.3** — Post status update to status page (if configured).

---

## Phase 8 — 24-Hour Observation Period

Monitor the following for 24 hours post-cutover:

| Signal | Alert Threshold | Action |
|---|---|---|
| Backend 5xx rate | > 1% of requests | Investigate immediately |
| Container App CPU | > 80% for 10 min | Scale up, investigate |
| Redis connection errors | Any | Check Redis health, connectivity |
| PostgreSQL connection errors | Any | Check DB health, connection pool |
| Stripe webhook failures | Any | Check Key Vault secrets, endpoint |
| Failed payments | Any | Immediate investigation |
| DB integrity check | Any invariant mismatch | Incident response |

---

## Phase 9 — Railway Decommission (T+7 Days)

**DANGER — PRODUCTION DECOMMISSION — Irreversible**

Only execute after 7 days of stable Azure operation.

- [ ] Final Railway PostgreSQL dump taken and archived
- [ ] All Railway services stopped
- [ ] Railway project deleted (or suspended)
- [ ] Vercel projects deleted (or suspended)
- [ ] GHCR images retained for 30 days, then pruned
- [ ] DNS TTL increased to 3600 seconds

---

## Acceptance Criteria (Must All Pass Before Signing Off)

| # | Criterion | Result |
|---|---|---|
| 1 | `GET /actuator/health` returns `{"status":"UP"}` via Front Door | PASS / FAIL |
| 2 | All 10 DB integrity invariants verified (320 exams) | PASS / FAIL |
| 3 | Student can log in and access exam catalogue | PASS / FAIL |
| 4 | PLATFORM_ADMIN can log in via admin panel | PASS / FAIL |
| 5 | Stripe webhook endpoint registered and active in live mode | PASS / FAIL |
| 6 | TLS certificate valid for all 3 custom domains | PASS / FAIL |
| 7 | Log Analytics receiving logs from Container App | PASS / FAIL |
| 8 | No unhandled ERROR logs in backend within first 10 minutes | PASS / FAIL |
| 9 | Railway still accessible as fallback (not decommissioned yet) | PASS / FAIL |
| 10 | Rate limiting active: 21st auth request in 1 min returns 429 | PASS / FAIL |

---

## Operator Sign-Off

| Role | Name | Signature | Time |
|---|---|---|---|
| Executing Operator | | | |
| Verifying Operator | | | |
| Tech Lead / CTO | | | |
