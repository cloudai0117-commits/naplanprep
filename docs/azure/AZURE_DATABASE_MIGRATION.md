# Azure Database Migration Runbook
## NAPLANPrep — Railway PostgreSQL → Azure Database for PostgreSQL Flexible Server

**Version:** 1.0  
**Date:** 2026-08-16  
**Status:** APPROVED — Execute Only With Change Control Approval

> **DANGER ANNOTATION:** All commands marked `DANGER — PRODUCTION` will affect live data or live services. These commands must only be executed by an authorised engineer during an approved maintenance window. Every destructive command must have a second engineer as witness.

---

## 1. Prerequisites

### Tools Required

```bash
# Verify all tools present before starting
psql --version          # >= 15.x
pg_dump --version       # >= 15.x (matching Railway version)
pg_restore --version    # >= 15.x
az --version            # >= 2.55.0
gh --version            # GitHub CLI
openssl version
```

### Access Required

| System | Access Needed | How to Get |
|---|---|---|
| Railway | Database connection string | Railway dashboard → Postgres → Connect |
| Azure subscription | Contributor on npp-prod-rg-data | Azure Portal / Azure AD |
| Azure Key Vault | Key Vault Secrets User | RBAC assignment |
| GitHub | Repository admin | Already configured |

### Environment Variables to Set Locally (Pre-Migration)

```bash
# Set these in your terminal before running commands
export RAILWAY_DB_URL="postgresql://postgres:<password>@<host>:5432/railway"
export AZURE_PG_HOST="npp-prod-pg.postgres.database.azure.com"
export AZURE_PG_DB="naplanprep_prod"
export AZURE_PG_ADMIN_USER="naplanprep_admin"
export AZURE_PG_ADMIN_PASS="<from-key-vault>"
export AZURE_SUBSCRIPTION_ID="<subscription-id>"
export AZURE_RG_DATA="npp-prod-rg-data"
```

---

## 2. Pre-Migration Checklist

Run all checks before scheduling the migration window.

### 2.1 Verify Railway PostgreSQL Version

```bash
# READ-ONLY — confirm Railway uses PostgreSQL 16
psql "$RAILWAY_DB_URL" -c "SELECT version();"
# Expected: PostgreSQL 16.x ...
```

If Railway is NOT version 16, update `docs/architecture/LLD_AZURE_DATABASE.md` SKU section before continuing.

### 2.2 Measure Railway Database Size

```bash
# READ-ONLY — check total database size
psql "$RAILWAY_DB_URL" -c "
SELECT
  pg_database_size(current_database()) as bytes,
  pg_size_pretty(pg_database_size(current_database())) as pretty_size;
"
```

This determines dump transfer time. Under 10 GB: expect < 30 minutes. Over 10 GB: plan for a longer maintenance window.

### 2.3 Count Flyway Migration Checksums

```bash
# READ-ONLY — capture current Flyway history for post-restore verification
psql "$RAILWAY_DB_URL" -c "
SELECT version, description, checksum, success
FROM flyway_schema_history
ORDER BY installed_rank;
" > /tmp/railway_flyway_history.txt

wc -l /tmp/railway_flyway_history.txt
# Record: ____ applied migrations
```

### 2.4 Verify Azure PostgreSQL Server Exists and Is Reachable

```bash
# READ-ONLY — verify server state
az postgres flexible-server show \
  --resource-group "$AZURE_RG_DATA" \
  --name npp-prod-pg \
  --query "{state:state,fqdn:fullyQualifiedDomainName,version:version}" \
  --output table
# Expected: state=Ready, version=16
```

### 2.5 Verify Private Endpoint Connectivity

This requires running from within the Azure VNet (e.g., a jump box or Container App with psql installed).

```bash
# From within Azure VNet — READ-ONLY
psql "host=$AZURE_PG_HOST port=5432 dbname=postgres user=$AZURE_PG_ADMIN_USER password=$AZURE_PG_ADMIN_PASS sslmode=require" \
  -c "SELECT 1;"
# Expected: 1 row
```

If the connection fails, verify: private endpoint DNS, VNet peering, NSG rules.

### 2.6 Application Is Running the Correct Spring Profile

Confirm the production Container App will use `SPRING_PROFILES_ACTIVE=prod` and not `uat`.

---

## 3. Migration Window Planning

### Recommended Window

| Metric | Value |
|---|---|
| Window start | Saturday 11:00 PM AEST |
| Expected duration | 2–4 hours (depends on DB size) |
| Maximum window | 8 hours |
| Rollback trigger | Any test failure in section 7 |
| Communication | Notify users 48h in advance via email |

### Team Assignments

| Role | Responsibility |
|---|---|
| Migration Lead | Executes commands, makes go/no-go calls |
| Witness Engineer | Reviews each destructive command before execution |
| Stripe Monitor | Watches Stripe dashboard for payment webhook failures |
| Comms Lead | Sends status emails, updates status page |

---

## 4. Step 1 — Pre-Dump Preparation

### 4.1 Put Application in Maintenance Mode

Stop the Container App to prevent writes during dump.

```bash
# DANGER — PRODUCTION — stops backend; students cannot access platform
az containerapp revision list \
  --name npp-prod-api \
  --resource-group npp-prod-rg-app \
  --query "[].{name:name,active:properties.active,replicas:properties.replicas}" \
  --output table

# Record active revision name above, then deactivate all traffic
az containerapp ingress traffic set \
  --name npp-prod-api \
  --resource-group npp-prod-rg-app \
  --revision-weight npp-prod-api--<current-revision>=0

# Verify: 503 on health endpoint
curl -s -o /dev/null -w "%{http_code}" https://api.naplanprep.com.au/actuator/health
# Expected: 503 or connection refused
```

### 4.2 Wait for In-Flight Requests to Complete

```bash
# SAFE — wait 30 seconds for in-flight DB transactions to complete
sleep 30

# READ-ONLY — confirm no active connections besides your session
psql "$RAILWAY_DB_URL" -c "
SELECT count(*), state
FROM pg_stat_activity
WHERE datname = 'railway'
GROUP BY state;
"
```

---

## 5. Step 2 — Database Dump from Railway

### 5.1 Run pg_dump

```bash
# SAFE — read-only dump from Railway; does not affect Railway data
DUMP_FILE="/tmp/naplanprep_$(date +%Y%m%d_%H%M%S).dump"
echo "Dump file: $DUMP_FILE"

pg_dump \
  --format=custom \
  --compress=9 \
  --no-owner \
  --no-privileges \
  --verbose \
  "$RAILWAY_DB_URL" \
  --file="$DUMP_FILE"

echo "Exit code: $?"
ls -lh "$DUMP_FILE"
# Record: file size ____, exit code 0
```

### 5.2 Verify Dump Integrity

```bash
# SAFE — verify dump is readable
pg_restore --list "$DUMP_FILE" | tail -20
# Expected: list of tables, sequences, indexes — no errors

pg_restore --list "$DUMP_FILE" | grep "TABLE DATA" | wc -l
# Record: number of tables with data ____
```

### 5.3 Verify Flyway History Is in Dump

```bash
# SAFE — confirm flyway_schema_history is included
pg_restore --list "$DUMP_FILE" | grep flyway
# Expected: lines for flyway_schema_history table and data
```

---

## 6. Step 3 — Restore to Azure PostgreSQL

### 6.1 Create Database and Admin User on Azure

```bash
# SAFE — run once during initial setup; skip if already done
psql "host=$AZURE_PG_HOST port=5432 dbname=postgres user=$AZURE_PG_ADMIN_USER password=$AZURE_PG_ADMIN_PASS sslmode=require" << 'EOF'
-- Create database
CREATE DATABASE naplanprep_prod
  WITH ENCODING 'UTF8'
  LC_COLLATE = 'en_US.utf8'
  LC_CTYPE = 'en_US.utf8'
  TEMPLATE template0;

-- Create admin user for migrations
CREATE ROLE naplanprep_admin WITH LOGIN PASSWORD '<generate-and-store-in-keyvault>';
GRANT ALL PRIVILEGES ON DATABASE naplanprep_prod TO naplanprep_admin;

-- Create app user (read/write, no DDL)
CREATE ROLE naplanprep_app WITH LOGIN PASSWORD '<from-key-vault>';
GRANT CONNECT ON DATABASE naplanprep_prod TO naplanprep_app;
EOF
```

### 6.2 Run pg_restore

```bash
# SAFE — restores to Azure; Railway data untouched
pg_restore \
  --host="$AZURE_PG_HOST" \
  --port=5432 \
  --dbname="$AZURE_PG_DB" \
  --username="$AZURE_PG_ADMIN_USER" \
  --no-owner \
  --no-privileges \
  --verbose \
  --single-transaction \
  "$DUMP_FILE"
# Expected: exit code 0
# Note: warnings about roles not existing are expected and safe
PGPASSWORD="$AZURE_PG_ADMIN_PASS" 
echo "pg_restore exit code: $?"
```

### 6.3 Grant Application User Privileges

```bash
# SAFE — grant runtime permissions to naplanprep_app
psql "host=$AZURE_PG_HOST port=5432 dbname=$AZURE_PG_DB user=$AZURE_PG_ADMIN_USER password=$AZURE_PG_ADMIN_PASS sslmode=require" << 'EOF'
GRANT USAGE ON SCHEMA public TO naplanprep_app;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO naplanprep_app;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO naplanprep_app;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO naplanprep_app;
ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT USAGE, SELECT ON SEQUENCES TO naplanprep_app;
EOF
```

---

## 7. Step 4 — Post-Restore Verification

All verifications must PASS before proceeding to Step 5.

### 7.1 Row Count Comparison

```bash
# READ-ONLY — count rows on Railway
psql "$RAILWAY_DB_URL" -c "
SELECT schemaname, tablename, n_live_tup as approx_rows
FROM pg_stat_user_tables
ORDER BY n_live_tup DESC;
" > /tmp/railway_rowcounts.txt

# READ-ONLY — count rows on Azure
psql "host=$AZURE_PG_HOST port=5432 dbname=$AZURE_PG_DB user=$AZURE_PG_ADMIN_USER password=$AZURE_PG_ADMIN_PASS sslmode=require" -c "
SELECT schemaname, tablename, n_live_tup as approx_rows
FROM pg_stat_user_tables
ORDER BY n_live_tup DESC;
" > /tmp/azure_rowcounts.txt

diff /tmp/railway_rowcounts.txt /tmp/azure_rowcounts.txt
# Expected: no differences (or only minor stat differences within 1%)
```

### 7.2 Flyway History Verification

```bash
# READ-ONLY — compare flyway history Railway vs Azure
psql "host=$AZURE_PG_HOST port=5432 dbname=$AZURE_PG_DB user=$AZURE_PG_ADMIN_USER password=$AZURE_PG_ADMIN_PASS sslmode=require" -c "
SELECT version, description, checksum, success
FROM flyway_schema_history
ORDER BY installed_rank;
" > /tmp/azure_flyway_history.txt

diff /tmp/railway_flyway_history.txt /tmp/azure_flyway_history.txt
# Expected: NO differences — every checksum must match exactly
# If checksums differ: ABORT MIGRATION — investigate before proceeding
```

### 7.3 Critical Table Spot Check

```bash
# READ-ONLY — verify key tables have data
psql "host=$AZURE_PG_HOST port=5432 dbname=$AZURE_PG_DB user=$AZURE_PG_ADMIN_USER password=$AZURE_PG_ADMIN_PASS sslmode=require" -c "
SELECT
  (SELECT count(*) FROM questions) as questions,
  (SELECT count(*) FROM exams) as exams,
  (SELECT count(*) FROM exam_questions) as exam_questions,
  (SELECT count(*) FROM users) as users,
  (SELECT count(*) FROM subscriptions) as subscriptions;
"
# Verify: question count matches Railway (must be > 0; cross-reference /tmp/railway_rowcounts.txt)
```

### 7.4 Application User Connectivity Check

```bash
# READ-ONLY — verify app user can connect (uses least-privilege credentials)
psql "host=$AZURE_PG_HOST port=5432 dbname=$AZURE_PG_DB user=naplanprep_app password=<app-password> sslmode=require" -c "
SELECT count(*) FROM questions LIMIT 1;
"
# Expected: returns a number; no permission errors
```

---

## 8. Step 5 — Update Container App Configuration

### 8.1 Store Database Credentials in Key Vault

```bash
# SAFE — upsert secrets (Key Vault creates new version if exists)
az keyvault secret set \
  --vault-name npp-prod-kv \
  --name db-url \
  --value "jdbc:postgresql://$AZURE_PG_HOST:5432/$AZURE_PG_DB?sslmode=require"

az keyvault secret set \
  --vault-name npp-prod-kv \
  --name db-username \
  --value "naplanprep_app"

az keyvault secret set \
  --vault-name npp-prod-kv \
  --name db-password \
  --value "<app-user-password>"
```

### 8.2 Update Container App Secret References

The Container App reads secrets from Key Vault via managed identity. Update the Container App environment to use the new Key Vault secret URIs:

```bash
# SAFE — update environment variables (creates new revision)
az containerapp update \
  --name npp-prod-api \
  --resource-group npp-prod-rg-app \
  --set-env-vars \
    "DATABASE_URL=secretref:db-url" \
    "DB_USERNAME=secretref:db-username" \
    "DB_PASSWORD=secretref:db-password" \
    "SPRING_PROFILES_ACTIVE=prod"
```

### 8.3 Verify New Revision Created

```bash
# READ-ONLY — confirm new revision exists
az containerapp revision list \
  --name npp-prod-api \
  --resource-group npp-prod-rg-app \
  --query "[].{name:name,created:properties.createdTime,active:properties.active}" \
  --output table
```

---

## 9. Step 6 — Flyway Migration Validation on Startup

When the Container App starts with `SPRING_PROFILES_ACTIVE=prod`, Flyway will:
1. Connect to `naplanprep_prod` on Azure PostgreSQL
2. Read `flyway_schema_history`
3. Compare checksums of all V54–V379 migrations
4. Start application if all checksums match

```bash
# READ-ONLY — tail Container App logs for Flyway output
az containerapp logs show \
  --name npp-prod-api \
  --resource-group npp-prod-rg-app \
  --tail 100 \
  --follow

# Expected lines:
#   Successfully validated N migrations
#   Current version of schema "public": V379
#   Schema "public" is up to date. No migration necessary.
#   Started NaplanprepApplication in X.XXX seconds
```

If Flyway reports a checksum mismatch: **ABORT** — do not proceed. Investigate the specific migration and compare Railway source vs Azure.

---

## 10. Step 7 — Health Gate

```bash
# READ-ONLY — verify all health indicators pass
curl -s https://api.naplanprep.com.au/actuator/health | python3 -m json.tool
# Expected:
# {
#   "status": "UP",
#   "components": {
#     "db": { "status": "UP" },
#     "redis": { "status": "UP" },
#     "ping": { "status": "UP" }
#   }
# }
```

If `db.status` is DOWN: check logs for connection errors. Verify Key Vault secret refs, private endpoint DNS.

---

## 11. Step 8 — Smoke Tests

Run the UAT smoke test suite against production:

```bash
# READ-ONLY — run smoke tests (no writes to production)
cd /c/Badal/Apps/Naplan/naplanprep

# Auth smoke test
curl -s -X POST https://api.naplanprep.com.au/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"smoke-test@naplanprep.com.au","password":"<smoke-test-password>"}' \
  | python3 -m json.tool
# Expected: access_token present

# Exam list (requires valid JWT)
curl -s https://api.naplanprep.com.au/v1/exams \
  -H "Authorization: Bearer <token-from-above>" \
  | python3 -m json.tool
# Expected: non-empty list of exams
```

---

## 12. Step 9 — Restore Traffic

```bash
# DANGER — PRODUCTION — restores traffic to the new Azure-backed revision
az containerapp ingress traffic set \
  --name npp-prod-api \
  --resource-group npp-prod-rg-app \
  --revision-weight npp-prod-api--<new-revision>=100

# Verify: 200 on health endpoint
curl -s -o /dev/null -w "%{http_code}" https://api.naplanprep.com.au/actuator/health
# Expected: 200
```

---

## 13. Step 10 — Post-Migration Monitoring

Monitor for 30 minutes after restoring traffic.

### Metrics to Watch

| Metric | Where | Threshold |
|---|---|---|
| HTTP 500 rate | Application Insights | < 0.1% |
| Database connections | Azure Monitor | < 15 |
| Database CPU | Azure Monitor | < 80% |
| JWT auth failures | Container App logs | Baseline only |
| Stripe webhook 200 rate | Stripe Dashboard | 100% |

### Alert Check

```bash
# READ-ONLY — check Azure Monitor alerts fired
az monitor alert list \
  --resource-group npp-prod-rg-app \
  --query "[?properties.essentials.alertState=='Fired'].{alert:name,fired:properties.essentials.startDateTime}" \
  --output table
```

---

## 14. Rollback Procedure

If any go/no-go gate fails, roll back to Railway:

```bash
# DANGER — PRODUCTION — roll back Container App to Railway connection string

# Step 1: Update Key Vault secrets back to Railway values
az keyvault secret set \
  --vault-name npp-prod-kv \
  --name db-url \
  --value "<railway-jdbc-url>"

az keyvault secret set \
  --vault-name npp-prod-kv \
  --name db-username \
  --value "<railway-username>"

az keyvault secret set \
  --vault-name npp-prod-kv \
  --name db-password \
  --value "<railway-password>"

# Step 2: Force new Container App revision to pick up updated secrets
az containerapp update \
  --name npp-prod-api \
  --resource-group npp-prod-rg-app \
  --set-env-vars "SPRING_PROFILES_ACTIVE=uat"

# Step 3: Restore traffic to new revision
az containerapp ingress traffic set \
  --name npp-prod-api \
  --resource-group npp-prod-rg-app \
  --revision-weight npp-prod-api--<rollback-revision>=100

# Step 4: Verify health
curl -s https://api.naplanprep.com.au/actuator/health
```

### Why Rollback Works

The Railway database is untouched throughout this migration. The only change was the Container App's connection string. Rolling back means updating the connection string back to Railway — no data migration is needed.

> **Note:** If any writes occurred to Azure PostgreSQL during the migration (after restoring traffic), those writes will NOT be in Railway. In this case, either:
> - Continue forward (fix the issue on Azure) — preferred
> - Accept data loss for writes since traffic cutover (document in incident record)

---

## 15. Post-Migration Cleanup (After Successful Migration — 7 Days Later)

After the migration is confirmed stable for 7+ days:

```bash
# SAFE — archive Railway dump file to Azure Blob Storage
az storage blob upload \
  --account-name nppprodstorage \
  --container-name db-backups \
  --name "railway_final_$(date +%Y%m%d).dump" \
  --file "$DUMP_FILE" \
  --auth-mode login

# DANGER — PRODUCTION — decommission Railway database (IRREVERSIBLE)
# DO NOT execute until confirmed by product owner
# railway delete --service postgres-production
```

---

## 16. Sign-Off Record

| Step | Status | Engineer | Time (AEST) |
|---|---|---|---|
| Prerequisites verified | | | |
| Maintenance window started | | | |
| Application stopped | | | |
| Railway dump complete | | | |
| Azure restore complete | | | |
| Row counts match | | | |
| Flyway checksums match | | | |
| Container App updated | | | |
| Health gate PASS | | | |
| Smoke tests PASS | | | |
| Traffic restored | | | |
| 30-min monitoring complete | | | |

*Both the Migration Lead and Witness Engineer must sign off each step.*

---

*This runbook is a living document. Update it after each dry-run or actual migration to reflect lessons learned.*
