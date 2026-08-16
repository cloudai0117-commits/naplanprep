# Azure Security Plan — NAPLANPrep Production
**Version:** 1.0 | **Date:** 2026-08-16

---

## 1. Resource Group

| Field | Value |
|---|---|
| Resource Group | npp-prod-rg-security |
| Region | australiaeast |
| Owner | Platform Security Lead |
| Contents | Key Vault, Managed Identities, Defender policies |

---

## 2. Key Vault Setup Checklist

- [ ] Create Key Vault with RBAC authorization (not legacy access policies)
  ```bash
  az keyvault create \
    --name npp-prod-kv \
    --resource-group npp-prod-rg-security \
    --location australiaeast \
    --enable-rbac-authorization true \
    --public-network-access Disabled \
    --sku standard \
    --retention-days 90
  ```
- [ ] Enable diagnostic settings → Log Analytics workspace
  ```bash
  az monitor diagnostic-settings create \
    --name kv-diag \
    --resource /subscriptions/<id>/resourceGroups/npp-prod-rg-security/providers/Microsoft.KeyVault/vaults/npp-prod-kv \
    --workspace /subscriptions/<id>/resourceGroups/npp-prod-rg-monitoring/providers/Microsoft.OperationalInsights/workspaces/npp-prod-law \
    --logs '[{"category":"AuditEvent","enabled":true,"retentionPolicy":{"days":90,"enabled":true}}]'
  ```
- [ ] Enable soft-delete (90 days) — enforced by Azure for new vaults
- [ ] Enable purge protection — prevents permanent deletion during retention period
  ```bash
  az keyvault update --name npp-prod-kv --enable-purge-protection true
  ```
- [ ] Create private endpoint for Key Vault in `npp-prod-snet-pe`
- [ ] Verify public network access is Disabled after private endpoint is active
- [ ] Assign RBAC roles for Container App MI (`Key Vault Secrets User`)
- [ ] Assign RBAC roles for GitHub Actions MI (`Key Vault Secrets Officer` — for setting secrets in CI/CD)
- [ ] Assign RBAC roles for Platform Admin (`Key Vault Administrator` — time-limited via PIM)
- [ ] Load all production secrets (see onboarding procedure below)
- [ ] Test secret retrieval from Container App before cutover

---

## 3. Secret Onboarding Procedure

Only the Platform Security Lead and designated deputies may add production secrets. All additions are audited.

### Adding a Secret

```bash
# Who can run this: Platform Security Lead (Key Vault Administrator role via PIM)
# Log your change in the change log BEFORE running

# Example: Add Stripe secret key
az keyvault secret set \
  --vault-name npp-prod-kv \
  --name STRIPE-SECRET-KEY \
  --value "sk_live_..." \
  --content-type "text/plain"

# NEVER include the actual value in:
# - Git commits
# - Slack messages
# - Email
# - GitHub Actions YAML
# - Application logs
```

### Audit Trail
All secret access is captured in Key Vault audit logs → Log Analytics. Query:
```kusto
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.KEYVAULT"
| where OperationName in ("SecretGet", "SecretSet", "SecretDelete")
| project TimeGenerated, identity_claim_oid_g, requestUri_s, resultSignature_s
| order by TimeGenerated desc
```

---

## 4. GitHub OIDC Setup Steps

### Step 1 — Create User-Assigned Managed Identity
```bash
az identity create \
  --name npp-github-actions-mi \
  --resource-group npp-prod-rg-security \
  --location australiaeast
```
Record the `clientId` and `principalId` outputs.

### Step 2 — Add Federated Credentials
```bash
# Production deployments (main branch)
az identity federated-credential create \
  --name gh-naplanprep-main \
  --identity-name npp-github-actions-mi \
  --resource-group npp-prod-rg-security \
  --issuer https://token.actions.githubusercontent.com \
  --subject "repo:cloudai0117-commits/naplanprep:ref:refs/heads/main" \
  --audiences api://AzureADTokenExchange

# UAT deployments (develop branch)
az identity federated-credential create \
  --name gh-naplanprep-develop \
  --identity-name npp-github-actions-mi \
  --resource-group npp-prod-rg-security \
  --issuer https://token.actions.githubusercontent.com \
  --subject "repo:cloudai0117-commits/naplanprep:ref:refs/heads/develop" \
  --audiences api://AzureADTokenExchange
```

### Step 3 — Assign RBAC to GitHub Actions MI
```bash
GITHUB_MI_PRINCIPAL=$(az identity show \
  --name npp-github-actions-mi \
  --resource-group npp-prod-rg-security \
  --query principalId -o tsv)

# ACR Push
az role assignment create \
  --role AcrPush \
  --assignee $GITHUB_MI_PRINCIPAL \
  --scope /subscriptions/<id>/resourceGroups/npp-prod-rg-app/providers/Microsoft.ContainerRegistry/registries/npprodacr

# Container Apps Contributor (for revision deployment)
az role assignment create \
  --role Contributor \
  --assignee $GITHUB_MI_PRINCIPAL \
  --scope /subscriptions/<id>/resourceGroups/npp-prod-rg-app/providers/Microsoft.App/containerApps/npp-prod-ca-api

# Static Web Apps Contributor
az role assignment create \
  --role "Website Contributor" \
  --assignee $GITHUB_MI_PRINCIPAL \
  --scope /subscriptions/<id>/resourceGroups/npp-prod-rg-app/providers/Microsoft.Web/staticSites/npp-prod-swa-student
```

### Step 4 — Add GitHub Repository Variables (not secrets)
In GitHub repository settings → Variables → Actions:
```
AZURE_CLIENT_ID     = <npp-github-actions-mi clientId>
AZURE_TENANT_ID     = <Entra ID tenant ID>
AZURE_SUBSCRIPTION_ID = <Azure subscription ID>
```

---

## 5. WAF Policy Configuration

```bash
# Create WAF policy in Prevention mode
az network front-door waf-policy create \
  --name nppProdWaf \
  --resource-group npp-prod-rg-app \
  --sku Premium_AzureFrontDoor \
  --mode Prevention

# Attach DRS 2.1 managed ruleset
az network front-door waf-policy managed-rules add \
  --policy-name nppProdWaf \
  --resource-group npp-prod-rg-app \
  --type Microsoft_DefaultRuleSet \
  --version 2.1 \
  --action Block

# Add rate limit custom rule (1000 req/5min per IP)
az network front-door waf-policy rule create \
  --policy-name nppProdWaf \
  --resource-group npp-prod-rg-app \
  --name RateLimitPerIP \
  --priority 100 \
  --rule-type RateLimitRule \
  --rate-limit-duration FiveMins \
  --rate-limit-threshold 1000 \
  --action Block \
  --match-conditions '[]'
```

### WAF Exclusions (apply as needed after baseline)
```bash
# Exclude Stripe-Signature header from injection checks
# (header contains binary HMAC content that may trigger SQL injection rules)
az network front-door waf-policy rule exclusion add \
  --policy-name nppProdWaf \
  --resource-group npp-prod-rg-app \
  --rule-set-type Microsoft_DefaultRuleSet \
  --rule-set-version 2.1 \
  --exclusion "RequestHeaderNames:Contains:Stripe-Signature"
```

---

## 6. Security Baseline Checklist

### Microsoft Defender for Cloud
- [ ] Enable Microsoft Defender for Containers (scans ACR images)
  ```bash
  az security pricing create --name Containers --tier Standard
  ```
- [ ] Enable Microsoft Defender for Azure Database for PostgreSQL
  ```bash
  az security pricing create --name OpenSourceRelationalDatabases --tier Standard
  ```
- [ ] Enable Microsoft Defender for Key Vault
  ```bash
  az security pricing create --name KeyVaults --tier Standard
  ```
- [ ] Review Defender for Cloud secure score — target >70%
- [ ] Enable continuous export of security alerts to Log Analytics
- [ ] Configure email notification for High and Critical alerts

### Network Security Baseline
- [ ] Verify PostgreSQL has no public endpoint (`--public-network-access Disabled`)
- [ ] Verify Redis has no public endpoint (private link only)
- [ ] Verify Key Vault public access is Disabled
- [ ] Verify Container App ingress IP restriction allows only Front Door service tag
- [ ] Confirm NSG flow logs enabled on both NSGs
- [ ] Confirm Network Watcher enabled in Australia East

### Identity Baseline
- [ ] MFA enforced for all Entra ID accounts with Azure access
- [ ] No service principals with permanent client secrets for deployment
- [ ] PIM configured for Owner/Contributor roles
- [ ] Access review scheduled (quarterly)
- [ ] No users with global admin except break-glass accounts

---

## 7. Penetration Testing Plan

### Scope
- API endpoints: `https://api.naplanprep.com.au/v1/**`
- Authentication flows: login, register, refresh, logout
- Payment webhook endpoint
- Admin panel API: `https://admin.naplanprep.com.au`
- Exclusions: Stripe infrastructure (out of scope), Azure infrastructure itself (requires Microsoft permission)

### Schedule
- Pre-launch: External pentest before first public traffic
- Annual: Annual penetration test by accredited party
- Post-incident: Ad-hoc after any security incident

### Acceptance Criteria
- No Critical or High findings unmitigated before launch
- Medium findings documented with remediation plan (30-day SLA)
- Low findings documented with risk acceptance or timeline

### Authorization
Microsoft Azure requires advance notification for penetration testing. Submit notification at: https://portal.msrc.microsoft.com/en-us/engage/pentest

---

## 8. Secret Rotation Runbook

### 8.1 JWT Keys (Annual or Immediate on Compromise)

```
1. SAFE: Generate new RSA-2048 key pair on secure offline workstation
   openssl genrsa -out new-private.pem 2048
   openssl rsa -in new-private.pem -pubout -out new-public.pem
   openssl pkcs8 -topk8 -inform PEM -outform PEM -nocrypt \
     -in new-private.pem -out new-private-pkcs8.pem

2. SAFE: Store new keys in Key Vault with temporary names
   az keyvault secret set --vault-name npp-prod-kv \
     --name JWT-PRIVATE-KEY-NEW --value "$(cat new-private-pkcs8.pem)"
   az keyvault secret set --vault-name npp-prod-kv \
     --name JWT-PUBLIC-KEY-NEW --value "$(cat new-public.pem)"

3. SAFE: Update active secrets (triggers Container App reload)
   az keyvault secret set --vault-name npp-prod-kv \
     --name JWT-PRIVATE-KEY --value "$(cat new-private-pkcs8.pem)"
   az keyvault secret set --vault-name npp-prod-kv \
     --name JWT-PUBLIC-KEY --value "$(cat new-public.pem)"
   
   NOTE: Tokens issued with old key will be invalid within 15 minutes
   (access token TTL). Users must re-login. Coordinate with support team.

4. SAFE: Trigger Container App restart to pick up new keys
   az containerapp update --name npp-prod-ca-api \
     --resource-group npp-prod-rg-app \
     --revision-suffix $(date +%Y%m%d)-jwt-rotation

5. DANGER: Delete old keys from Key Vault (only after verification)
   az keyvault secret delete --vault-name npp-prod-kv --name JWT-PRIVATE-KEY-NEW
   az keyvault secret delete --vault-name npp-prod-kv --name JWT-PUBLIC-KEY-NEW

6. SAFE: Verify new token issuance works (login, check JWT header)

7. SAFE: Securely delete local key files
   shred -u new-private.pem new-private-pkcs8.pem new-public.pem
```

### 8.2 Stripe Keys (On Compromise or Stripe Request)

```
1. Log into Stripe Dashboard
2. Create new restricted API key (live mode)
3. Store in Key Vault: az keyvault secret set --vault-name npp-prod-kv --name STRIPE-SECRET-KEY --value "sk_live_..."
4. Update Container App environment variable reference (secrets are auto-refreshed)
5. Rotate webhook secret: Dashboard → Webhooks → Roll signing secret
6. Update Key Vault: az keyvault secret set --vault-name npp-prod-kv --name STRIPE-WEBHOOK-SECRET --value "whsec_..."
7. Verify a test event delivery succeeds
8. DANGER: Revoke old Stripe key in Dashboard (payments stop if new key not active)
```

### 8.3 Database Password (90 Days or Compromise)

```
1. Generate new password (min 20 chars, upper+lower+digit+special)
2. DANGER: Change password in Azure PostgreSQL Flexible Server
   az postgres flexible-server update \
     --resource-group npp-prod-rg-data \
     --name npp-prod-pg \
     --admin-password "<new-password>"
3. Update Key Vault:
   az keyvault secret set --vault-name npp-prod-kv \
     --name DB-PASSWORD --value "<new-password>"
4. Update Container App env vars (DB connection string)
5. Restart Container App to pick up new password
6. Verify health: GET /actuator/health → status=UP
```

---

## 9. Access Review Schedule

| Review | Frequency | Owner | Process |
|---|---|---|---|
| Entra ID users with Azure access | Quarterly | Security Lead | Azure AD Access Reviews |
| Key Vault access audit | Monthly | Security Lead | Review KV audit logs in Log Analytics |
| GitHub repository access | Quarterly | Engineering Lead | Review team membership |
| Service account credentials | 90 days | Security Lead | Rotate CI_SERVICE_PASSWORD |
| PIM eligible role assignments | Quarterly | Security Lead | Remove stale PIM eligibility |
| WAF exclusions | 6 months | Security Lead | Review and justify each exclusion |

---

## 10. Incident Response

### Severity Classification
| Sev | Description | Response Time |
|---|---|---|
| P0 | Private key exposed, production data breach, payment system compromised | Immediate (24/7) |
| P1 | Authentication bypass, unauthorized data access, service down | 1 hour (business hours); 4 hours (off-hours) |
| P2 | High error rate, suspicious traffic pattern, non-critical security alert | 4 hours |
| P3 | WAF alert (no confirmed exploit), low-severity Defender finding | Next business day |

### Response Contacts
```
Primary On-Call:    [Platform lead — populate before cutover]
Security Escalation: [Security lead — populate before cutover]
Stripe Fraud:        fraud@stripe.com, Stripe Dashboard
Microsoft Security:  MSRC at https://msrc.microsoft.com
OAIC (data breach):  https://www.oaic.gov.au
```

### Immediate Actions on P0
1. Revoke compromised credentials immediately (Key Vault, Stripe, Azure)
2. Isolate: scale Container App to 0 replicas if exploit is active
3. Preserve: enable verbose logging and take snapshot before cleanup
4. Notify: OAIC within 72 hours if personal data involved
5. Investigate: pull Key Vault audit logs, Container App logs, AFD logs
6. Remediate and redeploy
7. Post-incident review within 48 hours
