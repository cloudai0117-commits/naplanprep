# Azure Redis Migration Runbook
## NAPLANPrep — Railway Redis → Azure Managed Redis

**Version:** 1.0  
**Date:** 2026-08-16  
**Status:** APPROVED FOR IMPLEMENTATION

> **DANGER ANNOTATION:** Commands marked `DANGER — PRODUCTION` affect live services. Execute only during approved maintenance windows with a second engineer as witness.

---

## 1. Overview

### What NAPLANPrep Uses Redis For

| Use Case | Key Pattern | TTL | Consequence of Loss |
|---|---|---|---|
| JWT blacklist (logout/revoke) | `blacklist:<token>` | Token expiry time | Logged-out tokens briefly valid until JWT expiry (low risk: tokens expire quickly) |
| Distributed rate limiting | `ratelimit:<group>:<ip>:<window>` | Window duration + 1s | Rate limits reset (counters start fresh) — brief open window |
| Session / refresh token state | (if used) | Variable | Users may need to re-login |

### Migration Decision: Clean Init (Not Replicate)

**Decision: Azure Managed Redis is initialized empty. Railway Redis data is NOT migrated.**

**Rationale:**

1. **JWT blacklist keys** — All blacklist keys have a TTL equal to the remaining JWT lifetime. The maximum JWT lifetime in this application is 24 hours. During the migration window, we drain traffic before switching Redis. Any residual blacklisted tokens from Railway will expire within 24 hours of migration. The security impact is bounded and acceptable.

2. **Rate limit counters** — These are ephemeral, fixed-window counters. Starting fresh means rate limit windows reset. An attacker who was at limit 19/20 gets a fresh window. This is a brief, bounded window of reduced protection — not a security incident.

3. **No persistent application state** in Redis — NAPLANPrep's primary data store is PostgreSQL. Redis holds only transient security state. A clean init is safe.

4. **Migration complexity** — Redis `DUMP`/`RESTORE` across different versions and different TLS configurations is error-prone. The data is too ephemeral to justify the risk.

This decision is documented here as an explicit architectural choice, not an oversight.

---

## 2. Azure Managed Redis vs Azure Cache for Redis

**Use Azure Managed Redis (NOT Azure Cache for Redis).**

Azure Cache for Redis is on the Azure retirement path. New deployments should use Azure Managed Redis (the successor service). This aligns with the infrastructure mandate in the Azure migration specification.

### Service: Azure Managed Redis (Preview / GA)

Azure Managed Redis uses a different resource type: `Microsoft.Cache/redisEnterprise` with a `databases` child resource.

| Parameter | Value |
|---|---|
| Resource type | `Microsoft.Cache/redisEnterprise` |
| SKU | Balanced B1 (2 GB, 2 vCores) — adequate for NAPLANPrep's ephemeral use |
| Region | Australia East |
| Zone redundancy | Enabled (zones 1 and 2) |
| TLS version | 1.2 minimum |
| Port | 10000 (Azure Managed Redis default) |
| Access | Private endpoint only |

> If Azure Managed Redis is not yet available in Australia East at time of provisioning, fall back to Azure Cache for Redis (Enterprise tier) in the same region. Document the decision in the change record.

---

## 3. Network Configuration

```
Azure Virtual Network: npp-prod-vnet (10.0.0.0/16)
  Subnet: npp-prod-snet-pe (10.0.2.0/24)
    Private Endpoint: npp-prod-pe-redis
      → npp-prod-redis.australiaeast.redis.azure.com (private IP: 10.0.2.5)

Private DNS Zone: privatelink.redis.cache.windows.net
  A record: npp-prod-redis → 10.0.2.5
```

All Container App → Redis communication stays within the VNet. No public endpoint is exposed.

---

## 4. Spring Boot Configuration (application-prod.yml)

```yaml
spring:
  data:
    redis:
      host: ${REDIS_HOST}
      port: ${REDIS_PORT:10000}
      password: ${REDIS_PASSWORD}
      ssl:
        enabled: true
      timeout: 2000ms
      connect-timeout: 3000ms
      lettuce:
        pool:
          max-active: 8
          max-idle: 8
          min-idle: 2
          max-wait: -1ms
```

### Container App Environment Variables

| Variable | Source | Value |
|---|---|---|
| `REDIS_HOST` | Key Vault secret ref | `npp-prod-redis.australiaeast.redis.azure.com` |
| `REDIS_PORT` | Key Vault secret ref | `10000` |
| `REDIS_PASSWORD` | Key Vault secret ref | (from Key Vault secret `redis-password`) |

---

## 5. Pre-Migration Steps

### 5.1 Provision Azure Managed Redis

This is provisioned via Terraform (see `infra/terraform/modules/redis/main.tf`). Verify it exists:

```bash
# READ-ONLY — verify Redis instance state
az redis enterprise show \
  --resource-group npp-prod-rg-app \
  --cluster-name npp-prod-redis \
  --query "{state:provisioningState,hostname:hostName}" \
  --output table
# Expected: state=Succeeded
```

### 5.2 Store Redis Credentials in Key Vault

```bash
# SAFE — get Redis access key from Azure
REDIS_KEY=$(az redis enterprise database list-keys \
  --resource-group npp-prod-rg-app \
  --cluster-name npp-prod-redis \
  --database-name default \
  --query "primaryKey" \
  --output tsv)

# SAFE — store in Key Vault
az keyvault secret set \
  --vault-name npp-prod-kv \
  --name redis-host \
  --value "npp-prod-redis.australiaeast.redis.azure.com"

az keyvault secret set \
  --vault-name npp-prod-kv \
  --name redis-port \
  --value "10000"

az keyvault secret set \
  --vault-name npp-prod-kv \
  --name redis-password \
  --value "$REDIS_KEY"
```

### 5.3 Verify Private Endpoint Connectivity

From within the Azure VNet (jump box or test container):

```bash
# READ-ONLY — from within VNet
redis-cli \
  -h npp-prod-redis.australiaeast.redis.azure.com \
  -p 10000 \
  -a "$REDIS_KEY" \
  --tls \
  PING
# Expected: PONG
```

### 5.4 Verify TLS Connectivity from Spring Boot

Deploy a test revision of the Container App pointed at Azure Redis and confirm the health check passes:

```bash
# SAFE — create canary revision (0% traffic) for Redis connectivity test
az containerapp revision copy \
  --name npp-prod-api \
  --resource-group npp-prod-rg-app \
  --set-env-vars \
    "REDIS_HOST=secretref:redis-host" \
    "REDIS_PORT=secretref:redis-port" \
    "REDIS_PASSWORD=secretref:redis-password"

# Tail logs for Redis connection
az containerapp logs show \
  --name npp-prod-api \
  --resource-group npp-prod-rg-app \
  --tail 50
# Expected: Lettuce connection established, no TLS errors
```

---

## 6. Migration Execution

### 6.1 Migration Is Non-Disruptive

Because we are performing a clean init (section 1), the Redis migration itself is non-disruptive:

1. Azure Managed Redis is provisioned and tested (above)
2. Container App environment variables are updated to point to Azure Redis
3. A new Container App revision is deployed
4. Traffic is gradually shifted to the new revision

There is no "Redis migration window" per se — the switch happens when Container App traffic is shifted to the new revision.

### 6.2 Update Container App to Use Azure Redis

```bash
# SAFE — update Container App env vars (creates new revision at 0% traffic)
az containerapp update \
  --name npp-prod-api \
  --resource-group npp-prod-rg-app \
  --set-env-vars \
    "REDIS_HOST=secretref:redis-host" \
    "REDIS_PORT=secretref:redis-port" \
    "REDIS_PASSWORD=secretref:redis-password" \
    "SPRING_PROFILES_ACTIVE=prod"
```

### 6.3 Verify New Revision Health

```bash
# READ-ONLY — get URL for new revision
NEW_REV=$(az containerapp revision list \
  --name npp-prod-api \
  --resource-group npp-prod-rg-app \
  --query "[-1].name" \
  --output tsv)

echo "New revision: $NEW_REV"

# Check logs for successful Redis + DB connection
az containerapp logs show \
  --name npp-prod-api \
  --resource-group npp-prod-rg-app \
  --revision "$NEW_REV" \
  --tail 100
# Expected: "Started NaplanprepApplication"
# NO errors: "Redis connection refused", "Unable to connect to Redis"
```

### 6.4 Blue/Green Traffic Shift

```bash
# SAFE — shift 10% traffic to new revision to smoke test
az containerapp ingress traffic set \
  --name npp-prod-api \
  --resource-group npp-prod-rg-app \
  --revision-weight \
    npp-prod-api--<old-revision>=90 \
    "$NEW_REV"=10

# Monitor for 5 minutes, then shift fully
az containerapp ingress traffic set \
  --name npp-prod-api \
  --resource-group npp-prod-rg-app \
  --revision-weight \
    "$NEW_REV"=100

echo "Traffic fully shifted to Azure Redis revision"
```

---

## 7. Post-Migration Verification

### 7.1 Rate Limiting Functional Test

```bash
# SAFE — trigger rate limit on auth endpoint (uses test credentials only)
for i in {1..25}; do
  STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
    -X POST https://api.naplanprep.com.au/v1/auth/login \
    -H "Content-Type: application/json" \
    -d '{"email":"ratelimit-test@test.com","password":"wrong"}')
  echo "Request $i: HTTP $STATUS"
done
# Expected: requests 21+ return HTTP 429
# This confirms Azure Redis rate limiting is active
```

### 7.2 JWT Blacklist Test

```bash
# SAFE — login, blacklist token via logout, verify token rejected
TOKEN=$(curl -s -X POST https://api.naplanprep.com.au/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"smoke-test@naplanprep.com.au","password":"<smoke-password>"}' \
  | python3 -c "import sys,json; print(json.load(sys.stdin)['accessToken'])")

# Logout (adds token to Redis blacklist)
curl -s -X POST https://api.naplanprep.com.au/v1/auth/logout \
  -H "Authorization: Bearer $TOKEN"

# Attempt to use blacklisted token
STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
  https://api.naplanprep.com.au/v1/exams \
  -H "Authorization: Bearer $TOKEN")

echo "HTTP $STATUS"
# Expected: 401 (token blacklisted in Azure Redis)
```

### 7.3 Verify Redis Keys in Azure

From within the VNet:

```bash
# READ-ONLY — inspect active keys in Azure Redis
redis-cli \
  -h npp-prod-redis.australiaeast.redis.azure.com \
  -p 10000 \
  -a "$REDIS_KEY" \
  --tls \
  KEYS "*"
# Expected: rate limit keys and/or blacklist keys visible after activity above
```

### 7.4 Health Endpoint

```bash
curl -s https://api.naplanprep.com.au/actuator/health | python3 -m json.tool
# Expected:
# {
#   "status": "UP",
#   "components": {
#     "redis": { "status": "UP" },
#     "db": { "status": "UP" }
#   }
# }
```

---

## 8. Rollback Procedure

If any verification step fails:

```bash
# DANGER — PRODUCTION — roll back to Railway Redis
az keyvault secret set \
  --vault-name npp-prod-kv \
  --name redis-host \
  --value "<railway-redis-host>"

az keyvault secret set \
  --vault-name npp-prod-kv \
  --name redis-port \
  --value "<railway-redis-port>"

az keyvault secret set \
  --vault-name npp-prod-kv \
  --name redis-password \
  --value "<railway-redis-password>"

# Force new revision
az containerapp update \
  --name npp-prod-api \
  --resource-group npp-prod-rg-app \
  --set-env-vars "SPRING_PROFILES_ACTIVE=uat"

# Shift traffic to rollback revision
az containerapp ingress traffic set \
  --name npp-prod-api \
  --resource-group npp-prod-rg-app \
  --revision-weight npp-prod-api--<rollback-revision>=100
```

**Rollback consequence:** Users who logged out after the Azure Redis switch but before rollback will have their logout not honoured on Railway Redis (token not blacklisted there). These tokens will expire naturally within 24 hours. Document in incident record.

---

## 9. Security Controls

| Control | Implementation |
|---|---|
| Encryption in transit | TLS 1.2+ mandatory (`ssl.enabled: true`) |
| Encryption at rest | Azure-managed keys (default) |
| Network access | Private endpoint only |
| Authentication | Access key (stored in Key Vault) |
| Key rotation | Manual via Azure Portal → regenerate key → update Key Vault secret |
| Audit logging | Azure Monitor metrics for Azure Managed Redis |

### Redis Key Rotation Procedure

```bash
# SAFE — regenerate Redis access key (causes brief connection drop)
az redis enterprise database regenerate-key \
  --resource-group npp-prod-rg-app \
  --cluster-name npp-prod-redis \
  --database-name default \
  --key-type Primary

# Immediately update Key Vault with new key
NEW_KEY=$(az redis enterprise database list-keys \
  --resource-group npp-prod-rg-app \
  --cluster-name npp-prod-redis \
  --database-name default \
  --query "primaryKey" \
  --output tsv)

az keyvault secret set \
  --vault-name npp-prod-kv \
  --name redis-password \
  --value "$NEW_KEY"

# Force Container App to pick up new secret by deploying new revision
az containerapp update \
  --name npp-prod-api \
  --resource-group npp-prod-rg-app \
  --revision-suffix "key-rotation-$(date +%Y%m%d)"
```

---

## 10. Monitoring and Alerting

### Azure Monitor Alerts for Redis

| Metric | Threshold | Severity | Action |
|---|---|---|---|
| `connected_clients` | < 1 sustained 5 min | P1 | Check Container App → Redis connectivity |
| `used_memory_percentage` | > 80% | P2 | Upgrade SKU or review key patterns |
| `cache_misses` | Spike > 500% baseline | P2 | Investigate unexpected access patterns |
| `errors` | > 10/min | P2 | Check logs for connection errors |
| `server_load` | > 80% | P2 | Scale up SKU |

### Key Expiry Monitoring

Rate limit keys should expire automatically (TTL = window + 1 second). If `used_memory_percentage` grows unexpectedly, check for keys without TTL:

```bash
# READ-ONLY — check for keys without expiry (should be none in production)
redis-cli \
  -h npp-prod-redis.australiaeast.redis.azure.com \
  -p 10000 \
  -a "$REDIS_KEY" \
  --tls \
  --scan --pattern "ratelimit:*" \
  | while read key; do
      ttl=$(redis-cli -h npp-prod-redis.australiaeast.redis.azure.com -p 10000 -a "$REDIS_KEY" --tls TTL "$key")
      if [ "$ttl" = "-1" ]; then
        echo "WARNING: Key without TTL: $key"
      fi
    done
```

---

## 11. Sign-Off Record

| Step | Status | Engineer | Time (AEST) |
|---|---|---|---|
| Azure Managed Redis provisioned | | | |
| Private endpoint verified | | | |
| Key Vault secrets set | | | |
| Canary revision health: PASS | | | |
| Traffic shifted to new revision | | | |
| Rate limiting functional: PASS | | | |
| JWT blacklist functional: PASS | | | |
| Health endpoint: UP | | | |
| 30-min monitoring complete | | | |

---

*Redis migration is a clean init by design. See section 1 for the documented rationale. This is not an oversight — it is a deliberate architectural choice consistent with the ephemeral nature of the data stored in Redis.*
