# Azure Rollback Runbook

**Project:** NAPLANPrep  
**Version:** 1.0  
**Date:** 2026-08-16  
**Status:** Draft — Execute if cutover fails or critical incident detected post-cutover

---

## When to Execute This Runbook

Execute this runbook if any of the following occurs during or after cutover:

- DB integrity gate fails (any of 10 invariants mismatch)
- Backend health check does not reach UP within 8 minutes
- Stripe live mode webhook failures (payments failing)
- Student login failing for > 5% of attempts
- Data corruption detected in Azure PostgreSQL
- Critical security incident on Azure infrastructure
- Exam sessions being lost / corrupted
- Explicit decision by Tech Lead to abort cutover

**Do NOT execute this runbook for minor issues that can be fixed forward** (e.g. a misconfigured environment variable that can be corrected without downtime, a non-critical feature bug).

---

## Decision Matrix

| Symptom | Time Post-Cutover | Recommended Action |
|---|---|---|
| Backend won't start | < 60 min | Rollback |
| DB integrity fail | Any | Rollback immediately |
| Payment failures | < 24 hr | Rollback if > 2 failures |
| Auth failures | < 24 hr | Rollback if > 5% error rate |
| Performance degradation | Any | Investigate first; rollback only if SLA breach |
| Minor UI bug | Any | Fix forward (hotfix deploy) |
| Config error (env var) | Any | Fix forward (update Key Vault + redeploy) |

---

## Rollback Option A — Revision Rollback (Azure Only, < 2 Minutes)

Use when: the Azure Container App itself is the issue (bad image, config error) but the database is healthy.

**Step A.1 — List recent revisions:**

```bash
az containerapp revision list \
  --name npp-prod-ca-api \
  --resource-group npp-prod-rg-app \
  --query "[].{name:name,created:properties.createdTime,traffic:properties.trafficWeight,active:properties.active}" \
  --output table
```

**Step A.2 — Shift traffic to previous revision:**

```bash
# Replace PREVIOUS_REVISION with the name from A.1
az containerapp ingress traffic set \
  --name npp-prod-ca-api \
  --resource-group npp-prod-rg-app \
  --revision-weight PREVIOUS_REVISION=100
```

**Step A.3 — Verify health:**

```bash
curl -s "https://api.naplanprep.com.au/actuator/health" | python3 -m json.tool
```

Expected: `{"status": "UP"}`

**Step A.4 — Run DB integrity gate:**

```bash
CI_JWT=$(curl -s -X POST "https://api.naplanprep.com.au/v1/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"email":"'$CI_EMAIL'","password":"'$CI_PASSWORD'"}' | \
  python3 -c "import json,sys; print(json.load(sys.stdin)['data']['accessToken'])")

curl -s -H "Authorization: Bearer $CI_JWT" \
  "https://api.naplanprep.com.au/actuator/health/dbIntegrity" | python3 -m json.tool
```

---

## Rollback Option B — DNS Rollback to Railway/Vercel (Full Rollback, 30–60 Minutes)

Use when: Azure infrastructure has a fundamental issue that cannot be resolved quickly, OR database integrity is compromised. This restores Railway/Vercel as the production system.

**PREREQUISITE:** Railway and Vercel must still be running (not decommissioned). This is why Railway is not decommissioned until 7 days post-stable-cutover.

### B.1 — Reactivate Railway Backend

**DANGER — Only if Railway is currently in maintenance mode / scaled to 0**

```bash
# Scale Railway backend back up
# Use Railway CLI
railway service restart --service naplanprep-backend

# Wait for health
for i in $(seq 1 12); do
  HTTP=$(curl -s -o /dev/null -w "%{http_code}" "https://<railway-backend-url>/actuator/health")
  echo "Attempt $i: HTTP $HTTP"
  [ "$HTTP" = "200" ] && break
  sleep 10
done
```

### B.2 — Verify Railway Database Still Intact

```bash
# Connect to Railway PostgreSQL and check row counts
psql "postgresql://<user>:<password>@<host>:<port>/<db>" << 'EOF'
SELECT 'exams' AS t, COUNT(*) FROM exams
UNION ALL SELECT 'questions', COUNT(*) FROM questions
UNION ALL SELECT 'users', COUNT(*) FROM users
UNION ALL SELECT 'subscriptions', COUNT(*) FROM subscriptions;
EOF
```

If Railway database is ahead of Azure database (new transactions occurred during the cutover attempt), determine whether to discard those transactions or merge them. If there are no new student/subscription records (maintenance mode was effective), proceed.

### B.3 — Revert DNS

**DANGER — PRODUCTION DNS CHANGE**

In your DNS provider, restore original CNAME records:

```
# Restore Railway/Vercel CNAMEs (get current values from your records saved pre-cutover)
api.naplanprep.com.au     CNAME   <original-railway-backend-domain>
app.naplanprep.com.au     CNAME   <original-vercel-frontend-domain>
admin.naplanprep.com.au   CNAME   <original-vercel-admin-domain>
```

### B.4 — Verify DNS Propagation

```bash
for resolver in 8.8.8.8 1.1.1.1 9.9.9.9; do
  echo -n "Resolver $resolver: "
  dig +short @$resolver api.naplanprep.com.au CNAME
done
```

Wait for all resolvers to return Railway CNAME.

### B.5 — Verify Service Restored via Custom Domain

```bash
curl -s "https://api.naplanprep.com.au/actuator/health" | python3 -m json.tool
curl -s -o /dev/null -w "%{http_code}" "https://app.naplanprep.com.au/"
```

Both must return 200.

### B.6 — Verify DB Integrity via Railway

```bash
CI_JWT=$(curl -s -X POST "https://api.naplanprep.com.au/v1/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"email":"'$CI_EMAIL'","password":"'$CI_PASSWORD'"}' | \
  python3 -c "import json,sys; print(json.load(sys.stdin)['data']['accessToken'])")

curl -s -H "Authorization: Bearer $CI_JWT" \
  "https://api.naplanprep.com.au/actuator/health/dbIntegrity" | python3 -m json.tool
```

### B.7 — Notify Stakeholders

- Send incident notification to team Slack channel
- Update status page
- If student payments failed during the cutover window, contact Stripe for refund processing

---

## Rollback Option C — Azure Database Point-in-Time Restore

Use when: Azure PostgreSQL data is corrupted or a destructive migration ran incorrectly.

**DANGER — PRODUCTION DATABASE RESTORATION — DATA LOSS RISK**

```bash
# List available restore points
az postgres flexible-server backup list \
  --name npp-prod-pg-server \
  --resource-group npp-prod-rg-data \
  --output table

# Restore to a new server (do NOT overwrite primary directly)
az postgres flexible-server restore \
  --resource-group npp-prod-rg-data \
  --name npp-prod-pg-restored \
  --source-server npp-prod-pg-server \
  --restore-time "2026-08-16T02:00:00Z"
```

After validating the restored server has correct data, update the `DATABASE_URL` Key Vault secret to point to the restored server and redeploy the Container App.

---

## Post-Rollback Actions

1. **Do NOT delete the Azure deployment** after DNS rollback — investigate root cause first
2. Document all rollback steps taken with timestamps
3. Conduct post-incident review within 48 hours
4. Identify root cause and remediation before re-attempting cutover
5. Set new cutover date only after root cause is confirmed fixed and re-tested in UAT

---

## Rollback Decision Log Template

```
ROLLBACK DECISION LOG
=====================
Date/Time:
Operators:
Trigger:
Option Executed: A / B / C
Steps Completed:
Time to Restore Service:
Data Impact:
Root Cause (initial):
Next Steps:
```

---

## Emergency Contacts

| Role | Contact | Notes |
|---|---|---|
| Tech Lead | — | Primary decision-maker for rollback |
| Azure Support | via Azure Portal | P1 severity for production outage |
| Stripe Support | dashboard.stripe.com/support | For payment/webhook issues |
| Railway Support | railway.app/help | If Railway backend needs help |
