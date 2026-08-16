# NAPLANPrep — Azure Disaster Recovery Plan

## 1. Overview

| Item | Value |
|---|---|
| Primary region | Australia East |
| DR region | Australia Southeast |
| RTO target | 4 hours |
| RPO target | 1 hour |
| DR tier | Warm standby (data replicated; compute spun on demand) |

The platform uses a warm standby DR model: data is continuously replicated to Australia Southeast; compute (Container Apps, Static Web Apps, Front Door) remains in the primary region and is re-provisioned from IaC during a disaster. This minimises cost while meeting the 4-hour RTO.

---

## 2. In-Scope Services and Replication Mechanisms

| Service | Primary | DR Mechanism |
|---|---|---|
| PostgreSQL Flexible Server | Australia East | Geo-redundant backup (35-day retention) |
| Azure Cache for Redis | Australia East | RDB snapshots to geo-redundant storage |
| Azure Container Registry | Australia East | Geo-replication to Australia Southeast |
| Azure Key Vault | Australia East | Geo-redundant storage (built-in) |
| Static Web App (frontend, admin) | East Asia (Azure SWA constraint) | Built from source in CI/CD |
| Container App image | npprodacr (ACR) | Geo-replicated ACR replica in Australia Southeast |
| Terraform state | npprodtfstate (GRS Storage Account) | Standard_GRS — automatic geo-replication |
| Log Analytics / App Insights | Australia East | Not replicated — logs are investigative, not operational |

---

## 3. Disaster Scenarios and Responses

### 3.1 Australia East region outage

**Trigger**: Azure Service Health shows prolonged (>30 min) region outage affecting Container Apps, PostgreSQL, or Redis.

**Response**:

| Step | Action | Owner | Duration |
|---|---|---|---|
| 1 | Confirm region outage via Azure Service Health | On-call | 15 min |
| 2 | Notify stakeholders — declare DR event | On-call | 10 min |
| 3 | Restore PostgreSQL from geo-redundant backup to Australia Southeast | DBA | 60 min |
| 4 | Provision DR Redis (Standard C1) in Australia Southeast | Infra | 15 min |
| 5 | Update Terraform variables: `location = "australiasoutheast"` | Infra | 10 min |
| 6 | Run `terraform apply` scoped to compute + networking in DR region | Infra | 30 min |
| 7 | Update Front Door origins to point to DR Container App | Infra | 15 min |
| 8 | Validate health probes green in DR region | On-call | 15 min |
| 9 | Publish status page update | Comms | 10 min |
| **Total** | | | **~2.5 hours** |

### 3.2 PostgreSQL failure (single-server failure, primary region healthy)

PostgreSQL Flexible Server is deployed with **Zone-Redundant High Availability** (primary AZ 1, standby AZ 2). Azure handles automatic failover to the standby within 60–120 seconds with no application change required.

**Manual steps**: None. Monitor via Azure Service Health.

### 3.3 Redis failure

The rate limiter and JWT blacklist are both Redis-backed with graceful degradation:
- On Redis failure, the rate limiter allows requests (logged as `RATE_LIMIT_REDIS_ERROR`).
- On Redis failure, the JWT blacklist check is skipped (logged as `JWT_BLACKLIST_REDIS_ERROR`); JWT cryptographic validation still runs.

**Response**: Provision a replacement Redis instance; update the Container App env vars `REDIS_HOST` / `REDIS_PASSWORD` and trigger a new revision.

Estimated recovery time: **15–30 minutes**.

### 3.4 Key Vault unavailability

Container App reads secrets at startup. If Key Vault is unavailable:
- Already-running replicas continue operating (secrets cached in process memory).
- New replicas / cold starts will fail to start.

Key Vault uses geo-redundant storage and is typically recovered by Azure within the same region. If full DR is required, manually create a new Key Vault in the DR region and populate from a Key Vault backup.

### 3.5 ACR unavailability

ACR is geo-replicated to Australia Southeast. If the Australia East replica is unavailable, Container Apps will automatically pull from the Australia Southeast replica (ACR geo-replication is transparent to clients).

---

## 4. RTO / RPO Validation

### 4.1 Quarterly DR drill

Every quarter:
1. Restore a PostgreSQL geo-backup to a test server in Australia Southeast.
2. Point a staging Container App at the test server.
3. Run the full regression test suite against the staging environment.
4. Record time taken and compare against RTO/RPO targets.
5. Update this document with findings.

### 4.2 Backup verification

Monthly: restore a 24-hour-old PostgreSQL backup to a scratch server and verify row counts match production via:
```sql
SELECT schemaname, tablename, n_live_tup
FROM pg_stat_user_tables
ORDER BY n_live_tup DESC;
```

---

## 5. Data Recovery Procedures

### 5.1 Restore PostgreSQL from geo-redundant backup

```bash
# List available restore points
az postgres flexible-server geo-restore \
  --name npp-dr-pg \
  --resource-group npp-dr-rg-data \
  --location australiasoutheast \
  --source-server /subscriptions/{sub}/resourceGroups/npp-prod-rg-data/providers/\
Microsoft.DBforPostgreSQL/flexibleServers/npp-prod-pg \
  --restore-time $(date -u -d '1 hour ago' +%Y-%m-%dT%H:%M:%SZ)
```

### 5.2 Redis data recovery

Redis contains transient data (JWT blacklist TTL 900s, rate limit windows). No persistent restore needed — a fresh Redis instance is functionally correct. Any users whose revoked tokens have not yet expired will need to re-authenticate.

---

## 6. Communication Plan

| Audience | Channel | Trigger | Owner |
|---|---|---|---|
| Internal team | Slack #incidents | Immediately on DR declaration | On-call |
| Users | Status page (statuspage.io or similar) | Within 30 min of declaration | Comms |
| Stripe (if webhooks fail) | Stripe dashboard — pause webhook retries | After 15 min of failures | On-call |
| Schools / teachers | Email | If outage > 2 hours during school hours | Comms |

---

## 7. Post-DR Recovery

After the primary region recovers:
1. Assess data divergence between DR PostgreSQL restore and primary server.
2. If primary region data is intact: point Front Door back to the primary Container App.
3. If primary region data is lost: use the DR server as the new primary and let geo-backup restart from it.
4. Decommission the DR resources provisioned during the event to avoid ongoing cost.
5. Write a post-incident report within 5 business days.

---

## 8. Document Maintenance

Review this plan after:
- Any DR drill or real incident.
- A significant architecture change (new services, changed HA config).
- An Azure region availability change for Australia East or Australia Southeast.

Last reviewed: 2026-08-16
