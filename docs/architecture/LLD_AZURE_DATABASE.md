# LLD — Azure Database Architecture
## NAPLANPrep — PostgreSQL on Azure Database for PostgreSQL Flexible Server

**Version:** 1.0  
**Date:** 2026-08-16  
**Status:** APPROVED FOR IMPLEMENTATION

---

## 1. Overview

NAPLANPrep uses PostgreSQL as its primary relational database. The current deployment is on Railway's managed PostgreSQL 16 service. The Azure target is **Azure Database for PostgreSQL Flexible Server**, which is the current recommended service (the older Single Server is on the retirement path).

All Flyway migrations V54–V379 are production content and **must not be modified**. The schema is managed exclusively by Flyway with `validate-on-migrate=true` and `repair-on-migrate=false` in production.

---

## 2. SKU Selection

### Recommended Production SKU

| Parameter | Value | Rationale |
|---|---|---|
| Service tier | General Purpose | Balanced CPU/memory for OLTP + Flyway migrations |
| Compute SKU | Standard_D4s_v3 | 4 vCores, 16 GB RAM — adequate for ~10k concurrent sessions with HikariCP max 20 |
| Storage | 128 GB Premium SSD | Covers exam content + user data with room to grow |
| Storage auto-grow | Enabled | Prevents outage if storage fills unexpectedly |
| PostgreSQL version | 16 | Matches current Railway version (postgres:16-alpine) |
| Region | Australia East | Data residency + lowest latency for AU students |

### Scale Path

| Load Phase | SKU | Action |
|---|---|---|
| Launch (0–5k students) | Standard_D4s_v3 | Initial SKU |
| Growth (5k–20k students) | Standard_D8s_v3 | Vertical scale via Azure Portal (brief failover) |
| High scale (20k+) | Standard_D16s_v3 + read replica | Add replica for analytics/reporting |

---

## 3. High Availability Configuration

```
Australia East — Availability Zone 1 (Primary)
    npp-prod-pg (read/write)
        │
        │  Synchronous replication
        ▼
Australia East — Availability Zone 2 (Standby)
    npp-prod-pg (standby — not addressable directly)
```

| Parameter | Value |
|---|---|
| HA mode | Zone-redundant |
| Primary AZ | 1 |
| Standby AZ | 2 |
| Failover time | Typically 60–120 seconds |
| Failover trigger | Automatic (zone failure) or manual |
| Standby readable | No (zone-redundant HA standby is not a read replica) |

**Failover behavior:** Container Apps backend will experience ~60–120s of connection errors during automatic failover. Hikari's connection timeout (30s) and retry logic will reconnect automatically. The application is stateless; no session data is lost.

---

## 4. Backup Configuration

| Parameter | Value |
|---|---|
| Backup retention | 35 days |
| Backup redundancy | Geo-redundant |
| DR region | Australia Southeast |
| PITR granularity | 5-minute intervals |
| Backup window | Managed by Azure (automatic) |

### PITR Restore Procedure

```bash
# READ-ONLY — list available restore points
az postgres flexible-server show \
  --resource-group npp-prod-rg-data \
  --name npp-prod-pg \
  --query "backup.{retention:backupRetentionDays,redundancy:geoRedundantBackup}"

# SAFE — restore to new server (does not affect primary)
az postgres flexible-server restore \
  --resource-group npp-prod-rg-data \
  --name npp-prod-pg-restored-$(date +%Y%m%d%H%M) \
  --source-server npp-prod-pg \
  --restore-time "2026-08-15T10:00:00Z"
```

> **NOTE:** Always restore to a new server first. Verify data integrity before any cutover. Never restore over the production server without documented approval.

---

## 5. Network Configuration

### Private Access Only

The production PostgreSQL server has **no public endpoint**. All connectivity is via private endpoint.

```
Azure Virtual Network: npp-prod-vnet (10.0.0.0/16)
  Subnet: npp-prod-snet-pe (10.0.2.0/24)
    Private Endpoint: npp-prod-pe-pg
      → npp-prod-pg.postgres.database.azure.com (private IP: 10.0.2.4)

Private DNS Zone: privatelink.postgres.database.azure.com
  A record: npp-prod-pg → 10.0.2.4
```

### DNS Resolution

When the Container App resolves `npp-prod-pg.postgres.database.azure.com`:
1. Query goes to Azure DNS (168.63.129.16)
2. Azure DNS consults linked private DNS zone
3. Returns private IP 10.0.2.4 (within the VNet)
4. Connection established over private endpoint (never traverses internet)

---

## 6. Connection String (Spring Boot)

### JDBC URL Format

```
jdbc:postgresql://npp-prod-pg.postgres.database.azure.com:5432/naplanprep_prod?sslmode=require
```

### application-prod.yml (database section)

```yaml
spring:
  datasource:
    url: ${DATABASE_URL}
    username: ${DB_USERNAME}
    password: ${DB_PASSWORD}
    driver-class-name: org.postgresql.Driver
    hikari:
      maximum-pool-size: 20
      minimum-idle: 5
      connection-timeout: 30000
      validation-timeout: 5000
      idle-timeout: 600000
      max-lifetime: 1800000
      connection-test-query: SELECT 1
      pool-name: NAPLANPrepHikari
  jpa:
    hibernate:
      ddl-auto: validate
    properties:
      hibernate:
        dialect: org.hibernate.dialect.PostgreSQLDialect
    open-in-view: false
  flyway:
    enabled: true
    locations: classpath:db/migration,classpath:db/migration/data
    validate-on-migrate: true
    repair-on-migrate: false
    out-of-order: false
    baseline-on-migrate: false
```

### Container App Environment Variables

| Variable | Source | Value |
|---|---|---|
| `DATABASE_URL` | Key Vault secret ref | `jdbc:postgresql://npp-prod-pg.postgres.database.azure.com:5432/naplanprep_prod?sslmode=require` |
| `DB_USERNAME` | Key Vault secret ref | `naplanprep_app` |
| `DB_PASSWORD` | Key Vault secret ref | (from Key Vault secret `db-password`) |

---

## 7. HikariCP Configuration

| Parameter | Value | Notes |
|---|---|---|
| `maximum-pool-size` | 20 | Matches UAT config; Azure D4s_v3 supports 100+ connections |
| `minimum-idle` | 5 | Keeps 5 connections warm at all times |
| `connection-timeout` | 30,000 ms | Time to wait for a pool connection before throwing |
| `validation-timeout` | 5,000 ms | Timeout for connection validation query |
| `idle-timeout` | 600,000 ms | Connection is evicted after 10 min idle |
| `max-lifetime` | 1,800,000 ms | Max 30 min lifetime per connection (avoids stale connections) |
| `connection-test-query` | `SELECT 1` | Validate before hand-out |

### PostgreSQL max_connections

Azure PostgreSQL Flexible Server Standard_D4s_v3 defaults to approximately 672 max_connections. With 2 Container App replicas × 20 connections = 40 connections — well within limits. Vertical scaling to D8s_v3 raises this to ~1,343.

### PgBouncer Consideration

Azure PostgreSQL Flexible Server includes **built-in PgBouncer** (connection pooler). For the initial production launch with 2 replicas × 20 HikariCP connections = 40 connections, PgBouncer is **not required**. If scaling to 10+ replicas is anticipated, enable the built-in PgBouncer in transaction mode to reduce server-side connection overhead.

To enable:
```bash
# SAFE — enable PgBouncer on the Flexible Server
az postgres flexible-server update \
  --resource-group npp-prod-rg-data \
  --name npp-prod-pg \
  --set pooler.enabled=true \
  --set pooler.mode=Transaction
```
PgBouncer port is 6432 (vs standard 5432). Update `DATABASE_URL` accordingly if enabled.

---

## 8. Database Users

| User | Purpose | Privileges |
|---|---|---|
| `naplanprep_admin` | Schema owner, Flyway migrations | SUPERUSER or CREATEROLE + schema owner |
| `naplanprep_app` | Application runtime | SELECT, INSERT, UPDATE, DELETE on all application tables; no DDL |
| `azure_pg_admin` | Azure admin (managed by Azure) | Full admin — used only for provisioning |

### User Creation SQL

```sql
-- SAFE — run as naplanprep_admin after pg_restore

-- Create application user (least privilege)
CREATE ROLE naplanprep_app WITH LOGIN PASSWORD '<from-key-vault>';

-- Grant schema access
GRANT CONNECT ON DATABASE naplanprep_prod TO naplanprep_app;
GRANT USAGE ON SCHEMA public TO naplanprep_app;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO naplanprep_app;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO naplanprep_app;

-- Ensure future tables also grant access
ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO naplanprep_app;
ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT USAGE, SELECT ON SEQUENCES TO naplanprep_app;
```

---

## 9. Flyway Configuration (Production Profile)

`application-prod.yml` Flyway section:

```yaml
spring:
  flyway:
    enabled: true
    locations: classpath:db/migration,classpath:db/migration/data
    validate-on-migrate: true       # MUST be true — catches checksum mismatches
    repair-on-migrate: false        # MUST be false — never silently repair in prod
    out-of-order: false             # MUST be false — production-like ordering
    baseline-on-migrate: false      # Do not baseline — full migration history is present
    schemas: public
    default-schema: public
```

**Critical Flyway rules for production:**
- V54–V379 content migrations must have identical checksums to Railway (verified during migration)
- No migration file may be modified after it has been applied to any non-dev environment
- Any new migration must use a version number > V379
- Flyway validate runs automatically on each Container App startup — a checksum mismatch will prevent startup

---

## 10. Index Recommendations

### Existing Indexes (from Flyway migrations)
The application's Flyway migrations include primary key and foreign key indexes. The following additional indexes are recommended for production query performance:

```sql
-- READ-ONLY — verify these exist after migration
\d exams
\d questions
\d exam_questions
\d exam_sessions

-- SAFE — add if missing
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_exams_status_year
  ON exams (status, year_level)
  WHERE status = 'PUBLISHED';

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_exam_sessions_user_id
  ON exam_sessions (user_id);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_exam_sessions_status
  ON exam_sessions (status, created_at DESC);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_questions_domain_year
  ON questions (domain, year_level);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_subscriptions_user_id_status
  ON subscriptions (user_id, status);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_subscriptions_payment_intent
  ON subscriptions (stripe_payment_intent_id)
  WHERE stripe_payment_intent_id IS NOT NULL;
```

> Use `CREATE INDEX CONCURRENTLY` to avoid table locks in production.

---

## 11. Read Replica (Optional — Not Required Day 1)

A read replica is not required for the initial production launch. When analytics or reporting needs arise:

```bash
# SAFE — create read replica (does not affect primary)
az postgres flexible-server replica create \
  --replica-name npp-prod-pg-replica \
  --source-server npp-prod-pg \
  --resource-group npp-prod-rg-data \
  --location australiaeast
```

The replica can be used for:
- Admin panel analytics queries
- Business reporting (exam completion rates, entitlement stats)
- DbIntegrityHealthIndicator queries (offloading from primary)

The Spring Boot application would need a separate `DataSource` bean for read-only operations.

---

## 12. Monitoring and Alerting

### Azure Monitor Metrics

| Metric | Alert Threshold | Severity |
|---|---|---|
| `active_connections` | > 15 | P2 Warning (pool max is 20) |
| `cpu_percent` | > 80% sustained 5 min | P2 Warning |
| `storage_percent` | > 80% | P2 Warning |
| `storage_percent` | > 90% | P1 Critical |
| `connections_failed` | > 10/min | P2 Warning |
| `deadlocks` | > 5/min | P2 Warning |
| `long_running_queries` | > 30 seconds | P2 Warning |
| Replica lag | > 30 seconds | P2 Warning (when replica exists) |

### Log Analytics Queries

```kusto
-- Slow queries (KQL for Log Analytics)
AzureDiagnostics
| where ResourceType == "FLEXIBLESERVERS"
| where Category == "PostgreSQLSlowLogs"
| where duration_s > 5
| order by TimeGenerated desc
| take 50

-- Connection counts over time
AzureMetrics
| where ResourceId contains "npp-prod-pg"
| where MetricName == "active_connections"
| summarize avg(Average) by bin(TimeGenerated, 5m)
| render timechart
```

### Application Insights Integration

Spring Boot Actuator metrics are exported to Application Insights via the `applicationinsights-agent` Java agent:

```dockerfile
# In backend Dockerfile — add AI agent
COPY applicationinsights-agent-3.x.x.jar /app/ai-agent.jar
# In entrypoint.sh — add JVM arg
exec java \
  -javaagent:/app/ai-agent.jar \
  -XX:+UseContainerSupport \
  -XX:MaxRAMPercentage=75.0 \
  ...
```

---

## 13. Disaster Recovery

### RTO / RPO

| Metric | Target | How Achieved |
|---|---|---|
| RPO (data loss) | ≤ 5 minutes | PITR at 5-minute granularity |
| RTO (restore time) | ≤ 2 hours | Zone failover: 60–120s; Region failover: PITR to new server ~60 min |

### Zone Failover (Primary → Standby in same region)
- Automatic when Azure detects zone failure
- RTO: 60–120 seconds
- No data loss (synchronous replication to standby)
- Connection string does not change (same FQDN)

### Region Failover (Australia East → Australia Southeast)
- Manual process: restore from geo-redundant backup to Australia Southeast
- RTO: ~60 minutes (backup restore + Container App redeploy)
- RPO: last geo-redundant backup (~1 hour depending on backup timing)

### Region Failover Procedure (Documented — Do Not Execute Without Approval)

```bash
# DANGER — PRODUCTION — execute only during declared DR event

# Step 1: Create new server in Australia Southeast from geo-redundant backup
az postgres flexible-server geo-restore \
  --resource-group npp-dr-rg-data \
  --name npp-dr-pg \
  --source-server /subscriptions/<sub-id>/resourceGroups/npp-prod-rg-data/providers/Microsoft.DBforPostgreSQL/flexibleServers/npp-prod-pg \
  --location australiasoutheast

# Step 2: Update Container App DATABASE_URL secret to point to DR server
# Step 3: Redeploy Container App revision
# Step 4: Verify application health
# Step 5: Update DNS (api.naplanprep.com.au) to DR Front Door endpoint
```

---

## 14. Security Controls

| Control | Implementation |
|---|---|
| Encryption at rest | Azure-managed keys (default); customer-managed keys available if required |
| Encryption in transit | TLS 1.2+ required (`sslmode=require` in JDBC URL) |
| Network access | Private endpoint only — no public endpoint |
| Authentication | Password auth for `naplanprep_app`; Managed Identity connection future option |
| Audit logging | Azure PostgreSQL audit logs → Log Analytics |
| Parameter store | Password in Azure Key Vault, accessed via Container App managed identity |
| Vulnerability scanning | Microsoft Defender for Databases (recommended) |

---

## 15. Production Profile Summary

New `application-prod.yml` required (separate from `application-uat.yml`):

```yaml
server:
  forward-headers-strategy: NATIVE

spring:
  flyway:
    out-of-order: false
    validate-on-migrate: true
    repair-on-migrate: false
  jpa:
    hibernate:
      ddl-auto: validate
  datasource:
    url: ${DATABASE_URL}
    username: ${DB_USERNAME}
    password: ${DB_PASSWORD}
    driver-class-name: org.postgresql.Driver
    hikari:
      maximum-pool-size: 20
      minimum-idle: 5
      connection-timeout: 30000
      validation-timeout: 5000
      idle-timeout: 600000
      max-lifetime: 1800000
  data:
    redis:
      host: ${REDIS_HOST}
      port: ${REDIS_PORT:6380}
      password: ${REDIS_PASSWORD}
      ssl:
        enabled: true
      timeout: 2000ms
      connect-timeout: 3000ms

management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics
  endpoint:
    health:
      show-details: when-authorized

app:
  stripe:
    secret-key: ${STRIPE_SECRET_KEY}
    publishable-key: ${STRIPE_PUBLISHABLE_KEY}
    webhook-secret: ${STRIPE_WEBHOOK_SECRET}
    advanced-price-id: ${STRIPE_ADVANCED_PRICE_ID}
    pro-price-id: ${STRIPE_PRO_PRICE_ID}
  cors:
    allowed-origins:
      - https://naplanprep.com.au
      - https://www.naplanprep.com.au
      - https://admin.naplanprep.com.au
      - https://app.naplanprep.com.au
  frontend-url: https://naplanprep.com.au
  rate-limit:
    auth-attempts: 5
    auth-lockout-minutes: 15
```

---

*This document is authoritative for the Azure database architecture. Changes to PostgreSQL version, SKU, or Flyway configuration require a change control record.*
