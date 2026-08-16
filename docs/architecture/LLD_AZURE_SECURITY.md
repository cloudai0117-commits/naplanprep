# LLD — Azure Security Architecture
## NAPLANPrep Production

**Version:** 1.0  
**Date:** 2026-08-16  
**Compliance:** Australian Privacy Act 1988, Australian Cyber Security Centre (ACSC) Essential Eight

---

## 1. Identity and Access Management

### 1.1 Microsoft Entra ID Tenancy

All Azure resources reside in a single Entra ID tenant. No guest accounts with production access.

### 1.2 Resource Group RBAC (Least Privilege)

| Principal | Scope | Role | Purpose |
|---|---|---|---|
| GitHub Actions MI | npp-prod-rg-app | AcrPush | Push container images |
| GitHub Actions MI | npp-prod-rg-app | Contributor (CA only) | Deploy Container App revisions |
| GitHub Actions MI | npp-prod-rg-app | StaticWebsiteContributor | Deploy Static Web Apps |
| Container App MI | npp-prod-rg-security | Key Vault Secrets User | Read secrets at runtime |
| Container App MI | npp-prod-rg-app | AcrPull | Pull images (system identity) |
| DevOps Team | All prod RGs | Reader | Read-only monitoring |
| On-call Engineer | npp-prod-rg-app | Contributor (scoped) | Incident response, time-limited |
| Platform Admin | Subscription | Owner | Provisioning only — no standing access |

> **No standing Owner/Contributor** for humans in production. Elevated access via Azure PIM (Privileged Identity Management) with just-in-time approval and 4-hour maximum.

### 1.3 Managed Identity Configuration

**Container App — System-Assigned Managed Identity:**
```
Resource: npp-prod-ca-api
Identity Type: SystemAssigned
Client ID: <assigned by Azure at creation>
Principal ID: <used for RBAC assignments>
```

Key Vault RBAC assignment:
```bash
# Grant Container App MI read access to Key Vault secrets
PRINCIPAL_ID=$(az containerapp show \
  --name npp-prod-ca-api \
  --resource-group npp-prod-rg-app \
  --query "identity.principalId" -o tsv)

az role assignment create \
  --role "Key Vault Secrets User" \
  --assignee $PRINCIPAL_ID \
  --scope /subscriptions/<id>/resourceGroups/npp-prod-rg-security/providers/Microsoft.KeyVault/vaults/npp-prod-kv
```

ACR pull assignment:
```bash
az role assignment create \
  --role "AcrPull" \
  --assignee $PRINCIPAL_ID \
  --scope /subscriptions/<id>/resourceGroups/npp-prod-rg-app/providers/Microsoft.ContainerRegistry/registries/npprodacr
```

---

## 2. GitHub Actions OIDC Federated Credential

GitHub Actions uses OIDC (no long-lived client secrets). The token exchange is:
```
GitHub Actions runner → GitHub OIDC Provider (https://token.actions.githubusercontent.com)
                      → Microsoft Entra ID (federated credential trust)
                      → Azure access token (15-minute lifetime)
```

### 2.1 Setup Procedure

**Step 1 — Create User-Assigned Managed Identity for GitHub:**
```bash
az identity create \
  --name npp-github-actions-mi \
  --resource-group npp-prod-rg-security \
  --location australiaeast
```

**Step 2 — Add Federated Credential:**
```bash
az identity federated-credential create \
  --name github-naplanprep-deploy \
  --identity-name npp-github-actions-mi \
  --resource-group npp-prod-rg-security \
  --issuer https://token.actions.githubusercontent.com \
  --subject "repo:cloudai0117-commits/naplanprep:ref:refs/heads/main" \
  --audiences api://AzureADTokenExchange
```

Add a second credential for develop branch (UAT deployments):
```bash
az identity federated-credential create \
  --name github-naplanprep-uat \
  --identity-name npp-github-actions-mi \
  --resource-group npp-prod-rg-security \
  --issuer https://token.actions.githubusercontent.com \
  --subject "repo:cloudai0117-commits/naplanprep:ref:refs/heads/develop" \
  --audiences api://AzureADTokenExchange
```

**Step 3 — GitHub Actions workflow snippet:**
```yaml
permissions:
  id-token: write
  contents: read

- name: Azure Login (OIDC)
  uses: azure/login@v2
  with:
    client-id: ${{ secrets.AZURE_CLIENT_ID }}          # npp-github-actions-mi client ID
    tenant-id: ${{ secrets.AZURE_TENANT_ID }}
    subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
```

GitHub Secrets required (not secrets, just identifiers — safe to store as GitHub variables):
- `AZURE_CLIENT_ID` — client ID of `npp-github-actions-mi`
- `AZURE_TENANT_ID` — Entra ID tenant ID
- `AZURE_SUBSCRIPTION_ID` — Azure subscription ID

---

## 3. Key Vault Configuration

### 3.1 Key Vault RBAC (not legacy Access Policies)

Key Vault is configured with `--enable-rbac-authorization true`. Legacy access policies are disabled.

```bash
az keyvault create \
  --name npp-prod-kv \
  --resource-group npp-prod-rg-security \
  --location australiaeast \
  --enable-rbac-authorization true \
  --public-network-access Disabled \
  --sku standard
```

`--public-network-access Disabled` blocks all internet access; secrets accessible only via private endpoint from the VNet.

### 3.2 Secrets Stored

| Secret Name | Value | Rotation Trigger |
|---|---|---|
| STRIPE-SECRET-KEY | Stripe live secret key | Stripe key compromise or 90-day policy |
| STRIPE-WEBHOOK-SECRET | Stripe webhook signing secret | Stripe secret rotation or compromise |
| STRIPE-ADVANCED-PRICE-ID | Stripe Price ID for Advanced plan | New Stripe product creation |
| STRIPE-PRO-PRICE-ID | Stripe Price ID for Pro/Premium plan | New Stripe product creation |
| JWT-PRIVATE-KEY | RSA-2048 private key (PKCS#8 PEM) | Compromise; annual review |
| JWT-PUBLIC-KEY | RSA-2048 public key (X.509 PEM) | Paired with private key rotation |
| DB-PASSWORD | PostgreSQL admin password | 90-day policy or compromise |
| REDIS-ACCESS-KEY | Azure Managed Redis access key | 90-day policy or compromise |
| CI-SERVICE-EMAIL | CI bootstrap account email | Service account credential review |
| CI-SERVICE-PASSWORD | CI bootstrap account password | 90-day policy |

### 3.3 Secret Reference in Container App

Container Apps reference Key Vault secrets via managed identity at runtime:
```yaml
# In Container App environment variables
env:
  - name: STRIPE_SECRET_KEY
    secretRef: stripe-secret-key
secrets:
  - name: stripe-secret-key
    keyVaultUrl: https://npp-prod-kv.vault.azure.net/secrets/STRIPE-SECRET-KEY
    identity: system
```

---

## 4. JWT Key Rotation Strategy

### Current State
RSA-2048 keys materialized from environment variables to `/tmp/jwt/` by `entrypoint.sh`. Keys are persistent (not ephemeral in UAT/prod).

### Rotation Procedure (Rolling — Zero Downtime)

```
Phase 1: Generate new key pair (offline, secure workstation)
  openssl genrsa -out new-private.pem 2048
  openssl rsa -in new-private.pem -pubout -out new-public.pem
  openssl pkcs8 -topk8 -inform PEM -outform PEM -nocrypt -in new-private.pem -out new-private-pkcs8.pem

Phase 2: Store new keys in Key Vault (do NOT overwrite old keys yet)
  Store as: JWT-PRIVATE-KEY-NEW, JWT-PUBLIC-KEY-NEW

Phase 3: Deploy backend revision accepting BOTH old and new public keys
  (Requires code change to JwtTokenProvider to support multiple public keys
   OR accept brief re-login requirement for all users)

Phase 4: Update Key Vault secrets (replace JWT-PRIVATE-KEY, JWT-PUBLIC-KEY)
  DANGER: Triggers Container App secret reload — users with old tokens
          must re-authenticate after old tokens expire (max 15 minutes).

Phase 5: Deploy new Container App revision pulling updated secrets

Phase 6: Verify new tokens are issued successfully

Phase 7: Delete JWT-PRIVATE-KEY-NEW, JWT-PUBLIC-KEY-NEW from Key Vault
```

> **Current token lifetime:** Access token = 900s (15 min). Rolling update within one token TTL is acceptable: users with tokens issued under the old key will naturally re-authenticate within 15 minutes. No session disruption beyond that window.

### Rotation Trigger Conditions
- **Immediate:** Any indication private key was exposed (logs, git history, support ticket)
- **Scheduled:** Annual review, or if the key was generated before the current security baseline
- **Post-incident:** After any infrastructure breach investigation

---

## 5. TLS Configuration

| Layer | Minimum TLS | Certificate | Notes |
|---|---|---|---|
| Azure Front Door | TLS 1.2 | Front Door managed (auto-renewed) | Custom domain verification required |
| Container App → PostgreSQL | TLS 1.2 | Azure-managed server cert | `sslmode=require` in JDBC URL |
| Container App → Redis | TLS 1.2 (port 6380) | Azure-managed | Never use port 6379 (plaintext) |
| Container App → Key Vault | TLS 1.2 | Azure-managed | HTTPS only, private endpoint |
| Container App ingress | TLS 1.2 | Managed by Container Apps | Terminated at Container App ingress |

**HSTS:** Configured at Front Door level — `Strict-Transport-Security: max-age=31536000; includeSubDomains`.

---

## 6. WAF Policy

### Policy: npp-prod-waf

```
Mode: Prevention (not Detection — prevention blocks rather than logs)
Rule Set: Microsoft_DefaultRuleSet 2.1
Custom Rules:
  - Rate limit: 1000 req/min per IP (applies to API origin)
  - Block requests with suspicious User-Agent (scanners)
  - Geo-filter: Log (not block) requests from high-risk countries initially;
                upgrade to block after baseline established
```

WAF does NOT replace application-level authorization. Assume WAF can be bypassed — defense in depth.

### WAF Exclusions
Spring Boot Actuator `/actuator/health` must not be rate-limited (Railway/Azure health probes). Add exclusion if false positives occur.

---

## 7. Container Security

### Dockerfile Security Properties
- Non-root user: `USER naplanprep` (from existing Dockerfile)
- Group: `naplanprep` (non-privileged)
- Base image: `eclipse-temurin:21-jre-alpine` — minimal JRE, no build tools
- No secrets baked into image layers
- JWT keys NOT in image — materialized at runtime from Key Vault via env vars

### Container Registry Scanning
```bash
# Enable Microsoft Defender for Containers on ACR
az security pricing create \
  --name Containers \
  --tier Standard

# Vulnerability assessment runs on push and weekly
# Results visible in Microsoft Defender for Cloud
```

---

## 8. Secret Scanning — What Must NOT Be Logged

The following must NEVER appear in application logs, Container App log streams, or Log Analytics:

| Category | Value |
|---|---|
| JWT token value | `Authorization: Bearer <token>` header value |
| Private RSA key | Any PEM content beginning with `-----BEGIN PRIVATE KEY-----` |
| DB password | PostgreSQL connection string with password |
| Stripe secret key | Values beginning with `sk_live_` |
| Stripe webhook secret | Values beginning with `whsec_` |
| Redis access key | Redis password/access key value |
| Card numbers | PAN, CVV, expiry (Stripe handles; app never sees these) |

Application code already masks JWT values in CI (`::add-mask::`). Spring Boot error messages are set to `never` in base config.

---

## 9. Audit Logging

| Event | Source | Destination | Retention |
|---|---|---|---|
| Azure resource changes | Azure Activity Log | Log Analytics | 90 days |
| Key Vault secret access | KV Diagnostic Logs | Log Analytics | 90 days |
| Container App console | App Insights | Log Analytics | 30 days |
| PostgreSQL audit logs | PG Flexible Server logs | Log Analytics | 30 days |
| Front Door access logs | AFD Diagnostic Settings | Log Analytics | 30 days |
| GitHub Actions runs | GitHub | GitHub (30 days) | Per GitHub plan |
| Application auth events | Spring Boot (INFO) | Log Analytics via App Insights | 30 days |

---

## 10. Security Monitoring Alerts

| Alert | Threshold | Severity | Action |
|---|---|---|---|
| 401 spike | >100/min sustained 5 min | High | PagerDuty → on-call |
| 5xx spike | >10/min sustained 2 min | High | PagerDuty → on-call |
| Failed login spike | >50/min (auth endpoint) | High | Review, possible brute force |
| Container restart | >3 restarts/hour | Medium | Investigate OOM or crash |
| Key Vault access denied | Any unauthorized access attempt | Critical | Immediate investigation |
| Redis unavailable | >2 min consecutive | Medium | Check Redis service health |
| PostgreSQL connection errors | >10/min | High | Check DB, connection pool |
| Deployment failure | Any failed Container App revision | Medium | Review deployment logs |

---

## 11. Compliance Notes

### Australian Privacy Act 1988
- All student PII (name, email, exam results) stored in Azure Australia East — data residency satisfied.
- Breach notification: must notify OAIC within 30 days of becoming aware of an eligible data breach.
- Data minimisation: exam engine stores only required student data; no payment card data stored (Stripe handles PCI scope).

### ACSC Essential Eight
| Control | Status |
|---|---|
| Application control | Container-based deployment; immutable images |
| Patch applications | Eclipse Temurin JRE patched via image rebuild; Dependabot alerts |
| Configure MS Office macros | Not applicable (no Office deployment) |
| User application hardening | WAF + CSP headers |
| Restrict admin privileges | Azure PIM for elevated access |
| Patch OS | Alpine Linux in container; patched via image rebuild |
| MFA | Entra ID MFA required for all admin accounts |
| Regular backups | PostgreSQL PITR + automated backups — see DR plan |
