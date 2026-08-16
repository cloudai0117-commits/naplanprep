# NAPLANPrep — Azure Low Level Design (Core Infrastructure)

**Version:** 1.0  
**Date:** 2026-08-16  
**Status:** APPROVED FOR MIGRATION  
**Classification:** Internal — Architecture  
**Parent:** `docs/architecture/HLD_AZURE.md`

---

## 1. Scope

This document provides component-level specifications for Azure core infrastructure:
- Azure Container Apps (backend API runtime)
- Azure Container Registry (ACR)
- Azure Key Vault integration (secret injection model)
- Azure Front Door Premium + WAF (ingress)
- Azure Managed Redis (JWT blacklist, rate limiting, Spring cache)
- Azure Virtual Network (subnets, NSGs, private endpoints)
- Managed Identity (system and user-assigned)

Related documents:
- `LLD_AZURE_NETWORK.md` — VNet CIDR allocations, NSG rules, Private DNS details
- `LLD_AZURE_SECURITY.md` — WAF rules, TLS policy, Key Vault access policies
- `LLD_AZURE_DATABASE.md` — PostgreSQL Flexible Server configuration, connection pooling
- `LLD_AZURE_CICD.md` — GitHub Actions workflow YAML, OIDC federation setup
- `LLD_STRIPE_AZURE.md` — Stripe webhook origin configuration for Front Door

---

## 2. Resource Naming Convention

Pattern: `npp-{env}-{tier}-{resource}`

| Segment | Values |
|---|---|
| `npp` | Fixed prefix for NAPLANPrep |
| `{env}` | `prod`, `uat`, `dev` |
| `{tier}` | Resource group scope: `rg-app`, `rg-data`, `rg-network`, `rg-shared` |
| `{resource}` | Resource type and optional purpose suffix |

### 2.1 Resource Inventory

| Resource | Name | Resource Group |
|---|---|---|
| VNet | npp-prod-vnet | npp-prod-rg-network |
| Container Apps Environment | npp-prod-ca-env | npp-prod-rg-app |
| Container App (backend) | npp-prod-ca-api | npp-prod-rg-app |
| Azure Container Registry | npprodacr | npp-prod-rg-shared |
| PostgreSQL Flexible Server | npp-prod-pg | npp-prod-rg-data |
| Azure Managed Redis | npp-prod-redis | npp-prod-rg-data |
| Key Vault | npp-prod-kv | npp-prod-rg-data |
| Storage Account | npprodsa | npp-prod-rg-data |
| Static Web App (frontend) | npp-prod-swa-app | npp-prod-rg-app |
| Static Web App (admin) | npp-prod-swa-admin | npp-prod-rg-app |
| Front Door Profile | npp-prod-afd | npp-prod-rg-network |
| Log Analytics Workspace | npp-prod-law | npp-prod-rg-shared |
| Application Insights | npp-prod-appinsights | npp-prod-rg-shared |
| User-Assigned MI (deploy) | npp-prod-mi-deploy | npp-prod-rg-shared |
| NSG (Container Apps subnet) | npp-prod-nsg-ca | npp-prod-rg-network |
| NSG (Private Endpoints subnet) | npp-prod-nsg-pe | npp-prod-rg-network |
| Private DNS (PostgreSQL) | privatelink.postgres.database.azure.com | npp-prod-rg-network |
| Private DNS (Redis) | privatelink.redis.azure.com | npp-prod-rg-network |
| Private DNS (Key Vault) | privatelink.vaultcore.azure.net | npp-prod-rg-network |
| Private Endpoint (PostgreSQL) | npp-prod-pe-pg | npp-prod-rg-network |
| Private Endpoint (Redis) | npp-prod-pe-redis | npp-prod-rg-network |
| Private Endpoint (Key Vault) | npp-prod-pe-kv | npp-prod-rg-network |

---

## 3. Azure Container Apps

### 3.1 Environment Configuration

```yaml
# Container Apps Environment
name: npp-prod-ca-env
location: australiaeast
resourceGroup: npp-prod-rg-app

properties:
  infrastructureSubnetId: /subscriptions/{sub}/resourceGroups/npp-prod-rg-network/providers/Microsoft.Network/virtualNetworks/npp-prod-vnet/subnets/containerapps-subnet
  internal: false          # External ingress via Front Door
  workloadProfiles:
    - name: Consumption
      workloadProfileType: Consumption
    - name: D4
      workloadProfileType: D4
      minimumCount: 2
      maximumCount: 10
  appLogsConfiguration:
    destination: log-analytics
    logAnalyticsConfiguration:
      customerId: /subscriptions/{sub}/resourceGroups/npp-prod-rg-shared/providers/Microsoft.OperationalInsights/workspaces/npp-prod-law
  daprAIInstrumentationKey: (not used — using App Insights SDK directly)
  zoneRedundant: true      # Distribute replicas across AZs
```

### 3.2 Container App — Backend API

```yaml
# Container App Resource
name: npp-prod-ca-api
location: australiaeast
resourceGroup: npp-prod-rg-app

identity:
  type: SystemAssigned   # For Key Vault and ACR access

properties:
  managedEnvironmentId: /subscriptions/{sub}/resourceGroups/npp-prod-rg-app/providers/Microsoft.App/managedEnvironments/npp-prod-ca-env
  workloadProfileName: D4

  configuration:
    activeRevisionsMode: Single    # Use Multiple during canary deploys

    ingress:
      external: true
      targetPort: 8080
      transport: http
      allowInsecure: false
      traffic:
        - latestRevision: true
          weight: 100
      customDomains: []   # Routed via Front Door only
      corsPolicy:
        allowedOrigins:
          - https://app.naplanprep.com.au
          - https://admin.naplanprep.com.au
        allowedHeaders: ["*"]
        allowedMethods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
        allowCredentials: true
        maxAge: 3600

    registries:
      - server: npprodacr.azurecr.io
        identity: system

    secrets:
      - name: db-password
        keyVaultUrl: https://npp-prod-kv.vault.azure.net/secrets/DATABASE-PASSWORD
        identity: system
      - name: redis-password
        keyVaultUrl: https://npp-prod-kv.vault.azure.net/secrets/REDIS-PASSWORD
        identity: system
      - name: stripe-secret-key
        keyVaultUrl: https://npp-prod-kv.vault.azure.net/secrets/STRIPE-SECRET-KEY
        identity: system
      - name: stripe-webhook-secret
        keyVaultUrl: https://npp-prod-kv.vault.azure.net/secrets/STRIPE-WEBHOOK-SECRET
        identity: system
      - name: jwt-private-key
        keyVaultUrl: https://npp-prod-kv.vault.azure.net/secrets/JWT-PRIVATE-KEY
        identity: system
      - name: jwt-public-key
        keyVaultUrl: https://npp-prod-kv.vault.azure.net/secrets/JWT-PUBLIC-KEY
        identity: system

  template:
    revisionSuffix: ""   # Auto-generated

    containers:
      - name: naplanprep-backend
        image: npprodacr.azurecr.io/naplanprep-backend:prod-{sha}
        resources:
          cpu: 2.0
          memory: 4Gi

        env:
          # Application profile
          - name: SPRING_PROFILES_ACTIVE
            value: prod

          # Database
          - name: DATABASE_URL
            value: jdbc:postgresql://npp-prod-pg.postgres.database.azure.com:5432/naplanprep?sslmode=require
          - name: DATABASE_USERNAME
            value: naplanprep_app
          - name: DATABASE_PASSWORD
            secretRef: db-password

          # Redis
          - name: SPRING_DATA_REDIS_HOST
            value: npp-prod-redis.redis.azure.com
          - name: SPRING_DATA_REDIS_PORT
            value: "6380"
          - name: SPRING_DATA_REDIS_SSL_ENABLED
            value: "true"
          - name: SPRING_DATA_REDIS_PASSWORD
            secretRef: redis-password

          # Stripe
          - name: STRIPE_SECRET_KEY
            secretRef: stripe-secret-key
          - name: STRIPE_WEBHOOK_SECRET
            secretRef: stripe-webhook-secret
          - name: STRIPE_ADVANCED_PRICE_ID
            value: "price_XXXX"  # Non-secret: price ID visible in Stripe Dashboard
          - name: STRIPE_PRO_PRICE_ID
            value: "price_YYYY"

          # JWT keys (materialised by entrypoint.sh from these env vars)
          - name: JWT_PRIVATE_KEY
            secretRef: jwt-private-key
          - name: JWT_PUBLIC_KEY
            secretRef: jwt-public-key
          - name: JWT_PRIVATE_KEY_PATH
            value: /tmp/jwt/private.pem
          - name: JWT_PUBLIC_KEY_PATH
            value: /tmp/jwt/public.pem

          # Application Insights
          - name: APPLICATIONINSIGHTS_CONNECTION_STRING
            value: InstrumentationKey=xxxxx;IngestionEndpoint=https://australiaeast-0.in.applicationinsights.azure.com/

          # App settings
          - name: APP_FRONTEND_URL
            value: https://app.naplanprep.com.au
          - name: SERVER_PORT
            value: "8080"

        probes:
          startup:
            httpGet:
              path: /actuator/health
              port: 8080
            initialDelaySeconds: 30
            periodSeconds: 10
            failureThreshold: 20    # 200s for JVM + Flyway migrations

          liveness:
            httpGet:
              path: /actuator/health/liveness
              port: 8080
            periodSeconds: 30
            failureThreshold: 3

          readiness:
            httpGet:
              path: /actuator/health/readiness
              port: 8080
            periodSeconds: 10
            failureThreshold: 3

    scale:
      minReplicas: 2
      maxReplicas: 10
      rules:
        - name: http-requests
          http:
            metadata:
              concurrentRequests: "100"
        - name: cpu-utilisation
          custom:
            type: cpu
            metadata:
              type: Utilization
              value: "70"

    volumes: []   # No persistent volumes; entrypoint.sh writes to /tmp/jwt/ (ephemeral)
```

### 3.3 Spring Boot Profile: prod

The `prod` Spring profile is activated via `SPRING_PROFILES_ACTIVE=prod`. It inherits `application.yml` (base) with these overrides needed in `application-prod.yml`:

```yaml
# backend/src/main/resources/application-prod.yml
spring:
  flyway:
    out-of-order: false
    validate-on-migrate: true
    # repair-on-migrate NOT present (base config default is false)

  datasource:
    hikari:
      maximum-pool-size: 20
      minimum-idle: 5
      connection-timeout: 30000
      idle-timeout: 600000
      max-lifetime: 1800000

  data:
    redis:
      timeout: 2000ms
      lettuce:
        pool:
          max-active: 8
          max-idle: 8
          min-idle: 2

server:
  forward-headers-strategy: NATIVE   # Tomcat RemoteIpValve for correct IP from Front Door
  error:
    include-message: never
    include-binding-errors: never
    include-stacktrace: never

management:
  endpoint:
    health:
      show-details: when-authorized
      show-components: when-authorized
  endpoints:
    web:
      exposure:
        include: health,info,metrics

logging:
  pattern:
    console: '{"timestamp":"%d{yyyy-MM-dd HH:mm:ss.SSS}","level":"%level","logger":"%logger{36}","message":"%msg","thread":"%thread"}%n'
  level:
    root: INFO
    au.com.naplanprep: INFO
    org.springframework.security: WARN
    org.flywaydb: INFO
```

**Note:** `application-prod.yml` does NOT exist yet in the repository. It must be created as part of the Azure migration.

### 3.4 Liveness vs Readiness Probes

| Probe | Path | Purpose |
|---|---|---|
| Startup | `/actuator/health` | Waits for full startup (Flyway, connection pools) — 200s budget |
| Liveness | `/actuator/health/liveness` | Container alive but stuck → restart |
| Readiness | `/actuator/health/readiness` | Database + Redis reachable → serve traffic |

Spring Boot Actuator health groups must be configured to map liveness and readiness:

```yaml
# In application-prod.yml
management:
  health:
    livenessState:
      enabled: true
    readinessState:
      enabled: true
  endpoint:
    health:
      probes:
        enabled: true
      group:
        readiness:
          include: db,redis   # Adds PostgreSQL and Redis checks to readiness
```

---

## 4. Azure Container Registry

### 4.1 Registry Configuration

```
Name:         npprodacr
SKU:          Premium           # Required: private endpoint, geo-replication option, retention policies
Location:     australiaeast
Admin user:   DISABLED          # Use Managed Identity only
Anonymous:    DISABLED

Policies:
  quarantine:    disabled       # Enable in future with Defender for Containers
  retention:
    enabled: true
    days: 30                    # Remove untagged/old manifests after 30 days
  softDelete:
    enabled: true
    retentionDays: 7
```

### 4.2 Repository Structure

| Repository | Tag Pattern | Notes |
|---|---|---|
| `naplanprep-backend` | `prod-<sha>`, `uat-<sha>` | Immutable SHA tags only; no `latest` |
| `naplanprep-frontend` | `prod-<sha>`, `uat-<sha>` | Static Web Apps build handled differently |
| `naplanprep-admin` | `prod-<sha>`, `uat-<sha>` | Static Web Apps build handled differently |

**No `latest` tags.** Every deployment uses an immutable `{env}-{sha}` tag. This ensures exact version traceability and rollback ability.

### 4.3 ACR Access

| Identity | Role | Scope |
|---|---|---|
| Container App system-assigned MI | AcrPull | npprodacr |
| GitHub OIDC user-assigned MI | AcrPush | npprodacr |
| Container Apps UAT system-assigned MI | AcrPull | npprodacr |

Private endpoint on `npp-prod-rg-network` ensures ACR is not exposed publicly once private networking is active. GitHub Actions runner (hosted runner on public internet) pushes to ACR via the public ACR endpoint — this is acceptable because OIDC identity controls are strict.

---

## 5. Azure Key Vault

### 5.1 Key Vault Configuration

```
Name:            npp-prod-kv
SKU:             Standard
Location:        australiaeast
Soft delete:     enabled (90 days)
Purge protection: enabled
RBAC auth:       enabled (not legacy access policies)
Public access:   DISABLED — private endpoint only
Firewall:        deny all public IPs

Private endpoint: npp-prod-pe-kv
  VNet: npp-prod-vnet
  Subnet: private-endpoints-subnet (10.0.2.0/24)
  Private DNS: privatelink.vaultcore.azure.net → 10.0.2.x
```

### 5.2 Secret Inventory

| Secret Name (Key Vault) | Maps To | Notes |
|---|---|---|
| `DATABASE-PASSWORD` | `DATABASE_PASSWORD` env var | PostgreSQL naplanprep_app password |
| `REDIS-PASSWORD` | `SPRING_DATA_REDIS_PASSWORD` env var | Azure Managed Redis access key |
| `STRIPE-SECRET-KEY` | `STRIPE_SECRET_KEY` env var | Stripe live secret key |
| `STRIPE-WEBHOOK-SECRET` | `STRIPE_WEBHOOK_SECRET` env var | Stripe live webhook endpoint secret |
| `JWT-PRIVATE-KEY` | `JWT_PRIVATE_KEY` env var | PKCS#8 PEM, RSA-2048 private key (full PEM block) |
| `JWT-PUBLIC-KEY` | `JWT_PUBLIC_KEY` env var | X.509 PEM, RSA-2048 public key |

**DO NOT ADD:** Stripe price IDs are not secrets (visible in Stripe Dashboard). Do not add `STRIPE_ADVANCED_PRICE_ID` or `STRIPE_PRO_PRICE_ID` to Key Vault.

### 5.3 RBAC Assignments

| Principal | Role | Scope |
|---|---|---|
| Container App system-assigned MI | Key Vault Secrets User | npp-prod-kv |
| UAT Container App system-assigned MI | Key Vault Secrets User | npp-uat-kv (separate vault) |
| Platform Admin (Azure AD user) | Key Vault Secrets Officer | npp-prod-kv |
| CI/CD OIDC MI | — | No KV access needed from CI/CD |

**Container App Key Vault secret injection:** Container Apps supports `secretRef` that resolves from Key Vault directly using the Container App's Managed Identity. This avoids needing to pass secrets through GitHub Actions at all.

```yaml
# Container App secret definition (ARM/Bicep/Terraform)
secrets:
  - name: db-password                           # local alias
    keyVaultUrl: https://npp-prod-kv.vault.azure.net/secrets/DATABASE-PASSWORD
    identity: system                            # Uses Container App system-assigned MI
```

### 5.4 JWT Key Handling

The existing `entrypoint.sh` materialises PEM content from environment variables to `/tmp/jwt/`:

```bash
# From existing entrypoint.sh
mkdir -p /tmp/jwt
echo "$JWT_PRIVATE_KEY" > /tmp/jwt/private.pem
chmod 600 /tmp/jwt/private.pem
echo "$JWT_PUBLIC_KEY" > /tmp/jwt/public.pem
chmod 644 /tmp/jwt/public.pem
exec java -XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0 ... -jar /app/app.jar
```

In Azure Container Apps:
- `JWT_PRIVATE_KEY` and `JWT_PUBLIC_KEY` are injected as container env vars via `secretRef` pointing to Key Vault
- `/tmp/jwt/` is ephemeral (container's writable layer) — never persisted
- `JwtTokenProvider` reads keys from the paths configured in `JWT_PRIVATE_KEY_PATH` / `JWT_PUBLIC_KEY_PATH`

**Security invariant:** PEM private key content is never in Git, never in Docker image, never in CI/CD logs.

---

## 6. Azure Managed Redis

### 6.1 Redis Configuration

```
Name:            npp-prod-redis
Location:        australiaeast
SKU:             Balanced B1 (6 GiB memory, 2 vCores)
TLS:             Required (port 6380 only; port 6379 disabled)
Zone redundancy: Enabled (AZ1 + AZ2 in Australia East)
Persistence:     RDB (30-minute snapshot interval)
Access keys:     Enabled (primary key used as password)
Entra auth:      Optional (can configure Managed Identity access later)

Private endpoint: npp-prod-pe-redis
  VNet: npp-prod-vnet
  Subnet: private-endpoints-subnet (10.0.2.0/24)
  Private DNS: privatelink.redis.azure.com → 10.0.2.x
```

**Note:** Azure Managed Redis (formerly Azure Cache for Redis Enterprise) supports Balanced tier with private endpoints and TLS. The Balanced B1 tier provides sufficient capacity for the NAPLANPrep Redis usage pattern (JWT blacklist + rate limiting + Spring cache).

### 6.2 Redis Data Flows

| Flow | Key | Operation | TTL | Volume |
|---|---|---|---|---|
| JWT blacklist write | `blacklist:{token}` | SET EX {remaining_ttl} | Token TTL | On logout/refresh |
| JWT blacklist read | `blacklist:{token}` | EXISTS (hasKey) | — | Every authenticated request |
| Rate limit counter | `ratelimit:{GROUP}:{IP}:{window}` | INCR + EXPIRE | Window duration + 1s | Every rate-limited request |
| Spring Cache: user | `userDetails::{userId}` | GET/SET | 5 min | Auth on each login |
| Spring Cache: questions | `questions::{key}` | GET/SET | 30 min | Content reads |
| Spring Cache: catalog | `examCatalog::{key}` | GET/SET | 2 min | Catalog reads |

### 6.3 Spring Data Redis Configuration

```yaml
# In application-prod.yml
spring:
  data:
    redis:
      host: npp-prod-redis.redis.azure.com
      port: 6380
      ssl:
        enabled: true
      password: ${SPRING_DATA_REDIS_PASSWORD}
      timeout: 2000ms
      lettuce:
        pool:
          max-active: 8
          max-idle: 8
          min-idle: 2
          max-wait: 1000ms
        shutdown-timeout: 100ms
```

**TLS note:** Azure Managed Redis uses self-signed TLS certificates from `*.redis.azure.com`. The Lettuce client (Spring Data Redis default) trusts Azure CA. If `ssl.enabled=true` causes `SSLHandshakeException`, add the Azure Redis CA certificate to the JVM truststore or use `ssl.verify-mode: none` (less secure, acceptable for managed service with private endpoint).

### 6.4 Redis Failure Handling

Already implemented in the codebase (P2-006):

```java
// JwtAuthenticationFilter.java
try {
    String blacklistKey = "blacklist:" + token;
    if (Boolean.TRUE.equals(redisTemplate.hasKey(blacklistKey))) {
        filterChain.doFilter(request, response); return;
    }
} catch (Exception redisEx) {
    log.error("JWT_BLACKLIST_REDIS_ERROR — Redis unavailable; proceeding without blacklist check: {}",
        redisEx.getMessage());
}
```

```java
// RateLimitInterceptor.java
try {
    Long count = stringRedisTemplate.opsForValue().increment(key);
    ...
} catch (Exception e) {
    log.error("RATE_LIMIT_REDIS_ERROR — Redis unavailable; allowing request: {}", e.getMessage());
    return true;  // allow
}
```

---

## 7. Azure Front Door Premium

### 7.1 Front Door Profile

```
Name:                npp-prod-afd
SKU:                 Premium     # Required: Private Link origins, WAF Advanced rules
Location:            Global
Custom domains:
  - app.naplanprep.com.au        → student frontend
  - admin.naplanprep.com.au      → admin frontend
  - api.naplanprep.com.au        → backend API
  - naplanprep.com.au            → redirect to app.naplanprep.com.au
Managed TLS:         Enabled (Azure-managed certificates, auto-renewal)
HTTP → HTTPS:        Redirect (301)
Minimum TLS:         TLS 1.2
HTTPS port:          443
```

### 7.2 Origin Groups

**Origin Group: og-api**
```
Name:                og-api
Session affinity:    Disabled (stateless API)
Health probe:
  path:              /actuator/health
  protocol:          HTTP
  interval:          30 seconds
  method:            HEAD
Load balancing:
  latency-sensitivity: 50ms
  sample-size:       4
  required-samples:  3

Origins:
  - name: ca-api-origin
    hostName: npp-prod-ca-api.{env}.azurecontainerapps.io
    httpPort: 80
    httpsPort: 443
    priority: 1
    weight: 1000
    privateLink:
      enabled: true
      privateLinkLocation: australiaeast
      linkId: /subscriptions/{sub}/resourceGroups/npp-prod-rg-app/providers/Microsoft.App/containerApps/npp-prod-ca-api
      groupId: managedEnvironments   # Container Apps private origin
```

**Origin Group: og-frontend**
```
Name:                og-frontend
Session affinity:    Disabled
Health probe:
  path:              /
  protocol:          HTTPS
  interval:          60 seconds

Origins:
  - name: swa-app-origin
    hostName: {random}.azurestaticapps.net   # Static Web App default domain
    httpsPort: 443
    priority: 1
    weight: 1000
```

**Origin Group: og-admin**
```
Origins:
  - name: swa-admin-origin
    hostName: {random2}.azurestaticapps.net
    httpsPort: 443
    priority: 1
    weight: 1000
```

### 7.3 Routing Rules

| Rule | Match Condition | Route Action |
|---|---|---|
| naplanprep.com.au/* | host = naplanprep.com.au | Redirect → https://app.naplanprep.com.au/$1 (301) |
| app.naplanprep.com.au/* | host = app.naplanprep.com.au | Forward to og-frontend |
| admin.naplanprep.com.au/* | host = admin.naplanprep.com.au | Forward to og-admin |
| api.naplanprep.com.au/* | host = api.naplanprep.com.au | Forward to og-api; WAF policy applied |
| api.naplanprep.com.au/v1/subscriptions/webhooks/* | Matched by above + WAF | Forward to og-api (Stripe webhook MUST reach backend) |

**Security header insertion (Front Door CDN rules):**

| Header | Value |
|---|---|
| Strict-Transport-Security | max-age=31536000; includeSubDomains; preload |
| X-Content-Type-Options | nosniff |
| X-Frame-Options | DENY |
| Referrer-Policy | strict-origin-when-cross-origin |
| Permissions-Policy | camera=(), microphone=(), geolocation=() |

**Note:** Do NOT set Content-Security-Policy via Front Door — SPA CSP policies are served from the Static Web App `staticwebapp.config.json`.

### 7.4 WAF Policy

```
Name:       npp-prod-waf
Mode:       Prevention   # Block matching requests (not just log)
SKU:        Premium      # Required for Front Door Premium integration

Managed rule sets:
  - Microsoft_DefaultRuleSet 2.1 (OWASP 3.2 equivalent)
  - Microsoft_BotManagerRuleSet 1.0

Custom rules:
  - Priority 100: Block requests with Host header containing localhost, 127.0.0.1, ::1
  - Priority 200: Block if X-Api-Version header > 64 chars (potential header injection)
  - Priority 300: Rate limit rule — 1000 requests per 1 minute per IP (Front Door WAF rate limit)
    applies to: api.naplanprep.com.au only
    action: Block (429)

Exclusions (for Stripe webhook):
  - POST /v1/subscriptions/webhooks/stripe:
    exclude RequestBodyRaw from RuleGroup SQLI
    (Stripe JSON payload may trigger SQLi false positives)
```

**IMPORTANT — Stripe Webhook WAF note:** The Microsoft_DefaultRuleSet can trigger false positive SQLi or XSS detections on Stripe webhook payloads. The exclusion above must be validated during UAT by sending a real Stripe webhook test event and verifying it reaches the backend without WAF block.

---

## 8. Azure Static Web Apps

### 8.1 Student Frontend App

```
Name:            npp-prod-swa-app
SKU:             Standard
Location:        australiaeast
Custom domain:   app.naplanprep.com.au (via Front Door)
Build:           Not used (CI/CD deploys via SWA CLI/Azure Static Web Apps GitHub Action)
Framework:       React (Vite)
API location:    (none — API handled separately by Container App)
```

Build environment variables (set in GitHub Actions build step, not stored in Static Web Apps):
```
VITE_API_URL=https://api.naplanprep.com.au
VITE_STRIPE_KEY=pk_live_xxx
```

**Security note:** `VITE_STRIPE_KEY` is the Stripe **publishable** key — it is safe to embed in frontend bundles. `STRIPE_SECRET_KEY` must NEVER be in frontend code.

### 8.2 staticwebapp.config.json

```json
{
  "routes": [
    {
      "route": "/api/*",
      "redirect": "https://api.naplanprep.com.au/v1/*",
      "statusCode": 301
    },
    {
      "route": "/*",
      "serve": "/index.html",
      "statusCode": 200
    }
  ],
  "navigationFallback": {
    "rewrite": "/index.html",
    "exclude": ["/static/*", "/assets/*", "*.{css,js,png,jpg,svg,ico,woff2}"]
  },
  "responseOverrides": {
    "404": {
      "rewrite": "/index.html",
      "statusCode": 200
    }
  },
  "globalHeaders": {
    "Content-Security-Policy": "default-src 'self'; script-src 'self' 'unsafe-inline' https://js.stripe.com; frame-src https://js.stripe.com; connect-src 'self' https://api.naplanprep.com.au https://api.stripe.com; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:",
    "X-Content-Type-Options": "nosniff",
    "X-Frame-Options": "DENY",
    "Referrer-Policy": "strict-origin-when-cross-origin"
  },
  "platform": {
    "apiRuntime": "node:18"
  }
}
```

### 8.3 Admin Frontend App

Same configuration as student frontend with:
- Custom domain: `admin.naplanprep.com.au`
- Build environment: `VITE_API_URL=https://api.naplanprep.com.au`
- Stricter CSP (no Stripe JS required in admin panel unless admin payment management is implemented)

---

## 9. Managed Identity Design

### 9.1 System-Assigned: Container App

Created automatically with the Container App. Used for:
- ACR image pull (AcrPull role assigned to principal ID)
- Key Vault secret access (Key Vault Secrets User role on npp-prod-kv)

Principal ID known after Container App creation. Role assignments use this principal.

```bash
# After Container App creation:
PRINCIPAL_ID=$(az containerapp show \
  --name npp-prod-ca-api \
  --resource-group npp-prod-rg-app \
  --query identity.principalId -o tsv)

# Grant Key Vault Secrets User
az role assignment create \
  --assignee $PRINCIPAL_ID \
  --role "Key Vault Secrets User" \
  --scope /subscriptions/{sub}/resourceGroups/npp-prod-rg-data/providers/Microsoft.KeyVault/vaults/npp-prod-kv

# Grant ACR Pull
az role assignment create \
  --assignee $PRINCIPAL_ID \
  --role "AcrPull" \
  --scope /subscriptions/{sub}/resourceGroups/npp-prod-rg-shared/providers/Microsoft.ContainerRegistry/registries/npprodacr
```

### 9.2 User-Assigned: GitHub CI/CD Deploy Identity

```bash
# Created once, reused across deployments
az identity create \
  --name npp-prod-mi-deploy \
  --resource-group npp-prod-rg-shared \
  --location australiaeast

# Get details
CLIENT_ID=$(az identity show --name npp-prod-mi-deploy --resource-group npp-prod-rg-shared --query clientId -o tsv)
OBJECT_ID=$(az identity show --name npp-prod-mi-deploy --resource-group npp-prod-rg-shared --query principalId -o tsv)

# Roles
az role assignment create --assignee $OBJECT_ID --role "AcrPush" \
  --scope /subscriptions/{sub}/resourceGroups/npp-prod-rg-shared/providers/Microsoft.ContainerRegistry/registries/npprodacr

az role assignment create --assignee $OBJECT_ID --role "Contributor" \
  --scope /subscriptions/{sub}/resourceGroups/npp-prod-rg-app

# OIDC Federated Credential
az identity federated-credential create \
  --name github-oidc-prod \
  --identity-name npp-prod-mi-deploy \
  --resource-group npp-prod-rg-shared \
  --issuer https://token.actions.githubusercontent.com \
  --subject repo:{org}/naplanprep:environment:production \
  --audiences api://AzureADTokenExchange
```

GitHub repository variables (not secrets — no secret value stored):
```
AZURE_CLIENT_ID = {client_id from above}
AZURE_TENANT_ID = {tenant_id}
AZURE_SUBSCRIPTION_ID = {subscription_id}
```

---

## 10. Spring Boot Production Configuration

### 10.1 JVM Startup Command

The existing `entrypoint.sh` is used unchanged:

```bash
#!/bin/sh
set -e
mkdir -p /tmp/jwt

if [ -z "$JWT_PRIVATE_KEY" ] || [ -z "$JWT_PUBLIC_KEY" ]; then
  echo "ERROR: JWT_PRIVATE_KEY or JWT_PUBLIC_KEY not set" >&2
  exit 1
fi

echo "$JWT_PRIVATE_KEY" > /tmp/jwt/private.pem
chmod 600 /tmp/jwt/private.pem
echo "$JWT_PUBLIC_KEY" > /tmp/jwt/public.pem
chmod 644 /tmp/jwt/public.pem

exec java \
  -XX:+UseContainerSupport \
  -XX:MaxRAMPercentage=75.0 \
  -Djava.security.egd=file:/dev/./urandom \
  -jar /app/app.jar
```

**Azure Container Apps compatibility:** The `-XX:+UseContainerSupport` flag correctly detects container CPU/memory limits. With 2 CPU / 4 GiB container resource, `-XX:MaxRAMPercentage=75.0` allocates ~3 GiB to JVM heap.

### 10.2 Hikari Connection Pool Sizing

```yaml
# Total replicas × connections per replica ≤ PostgreSQL max_connections
# PostgreSQL D4s default max_connections = 250
# Target: 2 replicas × 20 connections = 40 connections (comfortable headroom)
spring:
  datasource:
    hikari:
      maximum-pool-size: 20
      minimum-idle: 5
      connection-timeout: 30000        # 30s — fail fast if pool full
      idle-timeout: 600000             # 10 min idle before closing
      max-lifetime: 1800000            # 30 min max connection age
      keepalive-time: 60000            # 1 min — prevent PostgreSQL idle timeout
      connection-test-query: SELECT 1  # Validate connection before use
```

### 10.3 Actuator Security

```yaml
# In application-prod.yml
management:
  endpoints:
    web:
      base-path: /actuator
      exposure:
        include: health,info,metrics   # NOT: env, beans, mappings, threaddump, heapdump
  endpoint:
    health:
      show-details: when-authorized   # Requires ACTUATOR role (SecurityConfig)
      show-components: when-authorized
      probes:
        enabled: true
      group:
        liveness:
          include: livenessState
        readiness:
          include: readinessState,db,redis
```

The `dbIntegrity` endpoint is registered as a custom health indicator:
```java
// DbIntegrityHealthIndicator.java (existing)
// Accessible at /actuator/health/dbIntegrity
// Requires authentication (SecurityConfig — not permitAll)
```

CI health gate authenticates using CI service account credentials (CI_SERVICE_EMAIL / CI_SERVICE_PASSWORD from GitHub Secrets) to access the `dbIntegrity` indicator.

---

## 11. Docker Image Specification

### 11.1 Current Dockerfile (unchanged)

```dockerfile
# Stage 1: Build
FROM eclipse-temurin:21-jdk-alpine AS builder
WORKDIR /build
COPY pom.xml .
COPY src ./src
RUN mvn -B -q clean package -DskipTests

# Stage 2: Runtime
FROM eclipse-temurin:21-jre-alpine AS runtime
WORKDIR /app
RUN addgroup -S naplanprep && adduser -S naplanprep -G naplanprep
COPY --from=builder /build/target/*.jar app.jar
COPY entrypoint.sh entrypoint.sh
RUN chmod +x entrypoint.sh && chown -R naplanprep:naplanprep /app
USER naplanprep
EXPOSE 8080
ENTRYPOINT ["./entrypoint.sh"]
```

**No changes required** to the Dockerfile for Azure migration. The image is environment-agnostic; all Azure-specific configuration is provided via environment variables at runtime.

### 11.2 Image Tagging Strategy

```bash
# In GitHub Actions
SHA=$(git rev-parse --short HEAD)
IMAGE_TAG="prod-${SHA}"       # e.g., prod-a1b2c3d
IMAGE_FULL="npprodacr.azurecr.io/naplanprep-backend:${IMAGE_TAG}"

docker build -t $IMAGE_FULL backend/
docker push $IMAGE_FULL

# Container App update
az containerapp update \
  --name npp-prod-ca-api \
  --resource-group npp-prod-rg-app \
  --image $IMAGE_FULL
```

---

## 12. Database (Summary — Full Detail in LLD_AZURE_DATABASE.md)

### 12.1 Connection Specification

| Parameter | Value |
|---|---|
| Server name | npp-prod-pg.postgres.database.azure.com |
| Port | 5432 |
| Database | naplanprep |
| Application user | naplanprep_app (limited privileges) |
| SSL mode | require |
| JDBC URL | `jdbc:postgresql://npp-prod-pg.postgres.database.azure.com:5432/naplanprep?sslmode=require` |

### 12.2 Flyway Migration Execution

Flyway runs at application startup (`spring.flyway.enabled=true`). On Azure Container Apps:
- PostgreSQL must be reachable (private endpoint up) before the Container App starts
- If Flyway fails (schema mismatch, locked migration), the app fails to start → startup probe detects and does NOT route traffic
- This prevents partially-migrated state from serving requests

The startup probe's 200-second budget (20 failures × 10s interval) accommodates Flyway running all migrations on first deploy to an empty database (V1–V379: ~30s typical).

---

## 13. Observability (Summary — Full Detail in LLD_AZURE_CICD.md)

### 13.1 Application Insights SDK Integration

Add to `pom.xml` (if not already present):

```xml
<dependency>
  <groupId>com.microsoft.azure</groupId>
  <artifactId>applicationinsights-spring-boot-starter</artifactId>
  <version>3.5.4</version>
</dependency>
```

Configure via environment variable (no file required):
```
APPLICATIONINSIGHTS_CONNECTION_STRING=InstrumentationKey=xxx;IngestionEndpoint=https://australiaeast-0.in.applicationinsights.azure.com/
```

This single env var enables:
- Automatic HTTP request tracing (latency, status codes, URL, method)
- Automatic JDBC query tracing (operation name, duration)
- Automatic Redis command tracing
- Exception tracking with stack traces
- JVM metrics (heap, GC, threads)

### 13.2 Structured Log Format

The `logback` configuration for prod emits JSON logs that Azure Log Analytics parses automatically:

```json
{
  "timestamp": "2026-08-15T12:34:56.789",
  "level": "INFO",
  "logger": "au.com.naplanprep.exam.ExamController",
  "message": "Exam session started",
  "thread": "http-nio-8080-exec-1",
  "traceId": "abc123",
  "spanId": "def456",
  "userId": "12345"
}
```

**Security logging requirement:** The following events MUST be logged at INFO or higher and are queryable in Log Analytics:
- `AUTH_LOGIN_SUCCESS` — userId, IP
- `AUTH_LOGIN_FAILURE` — email (masked), IP
- `AUTH_LOCKOUT` — email (masked), IP
- `PAYMENT_COMPLETED` — userId, amount, currency (no card data)
- `WEBHOOK_RECEIVED` — event type, Stripe event ID
- `WEBHOOK_DUPLICATE_IGNORED` — paymentIntentId
- `JWT_BLACKLIST_REDIS_ERROR` — error summary only
- `RATE_LIMIT_EXCEEDED` — group, IP (no PII)
- `ADMIN_CONTENT_MODIFIED` — userId, action, entityId

---

## 14. Deployment Sequence

The detailed deployment sequence is in `AZURE_MIGRATION_MASTER_PLAN.md`. Here is the infrastructure dependency order for Container App deployment:

```
1. Resource groups (npp-prod-rg-*)
2. Log Analytics Workspace (npp-prod-law)
3. Application Insights (npp-prod-appinsights)
4. VNet (npp-prod-vnet) + subnets + NSGs
5. Key Vault (npp-prod-kv)
   └── Private endpoint (npp-prod-pe-kv)
   └── Private DNS zone (privatelink.vaultcore.azure.net)
6. Azure Managed Redis (npp-prod-redis)
   └── Private endpoint (npp-prod-pe-redis)
   └── Private DNS zone (privatelink.redis.azure.com)
7. PostgreSQL Flexible Server (npp-prod-pg)
   └── Private endpoint (npp-prod-pe-pg)
   └── Private DNS zone (privatelink.postgres.database.azure.com)
8. Azure Container Registry (npprodacr)
9. Managed Identity (npp-prod-mi-deploy)
10. Key Vault secrets (load via az keyvault secret set)
11. Container Apps Environment (npp-prod-ca-env)
12. Container App (npp-prod-ca-api)
    └── System-assigned MI enabled
    └── Role assignments (ACR pull, KV secrets user)
13. Static Web Apps (npp-prod-swa-app, npp-prod-swa-admin)
14. Front Door Premium (npp-prod-afd)
    └── WAF policy
    └── Origin groups
    └── Routes
    └── Custom domains + managed TLS
15. DNS CNAME updates (cutover event)
```

---

## 15. Validation Checklist

### 15.1 Pre-Cutover (Azure UAT)

| Check | Method | Expected |
|---|---|---|
| Container App starts cleanly | Check revision logs | No ERROR in startup, Flyway completed |
| JWT materialisation | entrypoint.sh log | `/tmp/jwt/private.pem` created |
| Redis TLS connection | App log on startup | Spring Data Redis connected to :6380 |
| PostgreSQL connection | Spring log | HikariPool-1 started, Flyway validated |
| Key Vault secret injection | Container App revision log | All secretRefs resolved |
| Liveness probe | `GET /actuator/health/liveness` | 200 {"status":"UP"} |
| Readiness probe | `GET /actuator/health/readiness` | 200 {"status":"UP"} with db, redis |
| DB integrity gate | Authenticated CI account GET `/actuator/health/dbIntegrity` | 200 examCount=320, all year groups |
| WAF blocking | Send SQLi test request to API | 403 blocked by WAF |
| WAF Stripe pass-through | Send Stripe test webhook | 200 processed (not WAF blocked) |
| Rate limiting | 25 rapid AUTH requests | First 20 pass, then 429 |
| Exam flow | Full exam session E2E | Session created, questions returned (no answer keys), submit, results |
| Payment flow | Stripe Checkout test mode | Checkout session created, redirect works |
| Webhook signature | Send test event from Stripe Dashboard | 200 processed |
| Student cannot get answers | GET /v1/content/questions with STUDENT JWT | 403 Forbidden |
| CSP headers | Browser dev tools | Content-Security-Policy present on SPA |
| HSTS | curl -I https://app.naplanprep.com.au | Strict-Transport-Security present |
| TLS | SSL Labs test | A+ rating |

---

## 16. Known Limitations and Deferred Items

| Item | Status | Notes |
|---|---|---|
| Audio exam content | DEFERRED | V379 converted all audio to text-only (SHORT_ANSWER) |
| Token storage (P3-004) | DEFERRED | localStorage → HttpOnly cookies plan in security audit |
| PgBouncer connection pooler | Optional | Only needed if replica count exceeds ~12 |
| ACR geo-replication | Optional | Only needed if multi-region deployment |
| Azure Defender for Containers | Future | Container image vulnerability scanning |
| OWASP ZAP scan | Pre-production gate | Automated DAST scan against UAT API |
| Load test | Pre-capacity-claim gate | 10,000 concurrent students unverified |
| Redis Entra authentication | Future | Currently password-based; Managed Identity auth available in Azure Managed Redis |
| Front Door Private Link approval | Manual step | Container Apps Private Link origin requires manual approval in Azure Portal |
| Static Web App API integration | Not used | API is standalone Container App, not SWA built-in API |
