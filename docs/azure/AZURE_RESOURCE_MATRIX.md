# NAPLANPrep — Azure Resource Matrix

All Azure resources provisioned by `infra/terraform/`. Names follow the convention `{project}-{env}-{type}-{descriptor}` with `project=npp` and `env=prod`.

## Resource Groups

| Resource Group | Terraform Resource | Purpose |
|---|---|---|
| `npp-prod-rg-network` | `azurerm_resource_group.network` | VNet, subnets, NSGs, private endpoints, DNS zones |
| `npp-prod-rg-app` | `azurerm_resource_group.app` | Container Apps, Static Web Apps, ACR, Front Door |
| `npp-prod-rg-data` | `azurerm_resource_group.data` | PostgreSQL Flexible Server, Azure Cache for Redis |
| `npp-prod-rg-security` | `azurerm_resource_group.security` | Key Vault, managed identities |
| `npp-prod-rg-monitoring` | `azurerm_resource_group.monitoring` | Log Analytics, Application Insights, alert rules |
| `npp-prod-rg-tfstate` | (pre-created manually) | Terraform state storage account |

---

## Networking

| Resource | Name | SKU / Config | RG | Terraform |
|---|---|---|---|---|
| Virtual Network | `npp-prod-vnet` | 10.0.0.0/16 | network | `azurerm_virtual_network.main` |
| Subnet (apps) | `npp-prod-snet-apps` | 10.0.1.0/24, Container Apps delegation | network | `azurerm_subnet.apps` |
| Subnet (PE) | `npp-prod-snet-pe` | 10.0.2.0/24, PE policies disabled | network | `azurerm_subnet.pe` |
| NSG (apps) | `npp-prod-nsg-apps` | Allow AFD + AzureMonitor + VNet infra; Deny all | network | `azurerm_network_security_group.apps` |
| NSG (PE) | `npp-prod-nsg-pe` | Allow from apps subnet only; Deny all | network | `azurerm_network_security_group.pe` |

---

## Private Endpoints & DNS Zones

| DNS Zone | VNet Link | Service |
|---|---|---|
| `privatelink.postgres.database.azure.com` | link-postgres | PostgreSQL Flexible Server |
| `privatelink.redis.cache.windows.net` | link-redis | Azure Cache for Redis |
| `privatelink.vaultcore.azure.net` | link-keyvault | Key Vault |
| `privatelink.azurecr.io` | link-acr | Azure Container Registry |

| Private Endpoint | Subnet | Sub-resource | Target |
|---|---|---|---|
| `npp-prod-pg-pe` | pe | `postgresqlServer` | `npp-prod-pg` |
| `npp-prod-redis-pe` | pe | `redisCache` | `npp-prod-redis` |
| `npp-prod-kv-pe` | pe | `vault` | `npp-prod-kv` |
| `npprodacr-pe` | pe | `registry` | `npprodacr` |

---

## Compute

| Resource | Name | SKU / Config | RG | Terraform |
|---|---|---|---|---|
| Container Apps Environment | `npp-prod-ca-env` | Consumption, VNet-integrated, internal LB | app | `azurerm_container_app_environment.main` |
| Container App (API) | `npp-prod-ca-api` | 1 vCPU / 2 GiB, 1–5 replicas, HTTP scale 50 req | app | `azurerm_container_app.api` |
| Static Web App (frontend) | `npp-prod-swa-frontend` | Standard, East Asia | app | `azurerm_static_site.frontend` |
| Static Web App (admin) | `npp-prod-swa-admin` | Standard, East Asia | app | `azurerm_static_site.admin` |

---

## Registry

| Resource | Name | SKU | RG | Terraform |
|---|---|---|---|---|
| Container Registry | `npprodacr` | Premium | app | `azurerm_container_registry.main` |
| Geo-replication | Australia Southeast | — | — | `azurerm_container_registry.main.georeplications` |

Image naming: `npprodacr.azurecr.io/naplanprep-backend:{env}-{git-sha}`

---

## Data

| Resource | Name | SKU / Config | RG | Terraform |
|---|---|---|---|---|
| PostgreSQL Flexible Server | `npp-prod-pg` | GP_Standard_D4s_v3, v16, ZR-HA, 128 GiB, 35-day GRS backup | data | `azurerm_postgresql_flexible_server.main` |
| PostgreSQL Database | `naplanprep_prod` | UTF8, en_US.utf8 | data | `azurerm_postgresql_flexible_server_database.main` |
| Azure Cache for Redis | `npp-prod-redis` | Standard C1 (1 GiB), TLS-only, private endpoint | data | `azurerm_redis_cache.main` |

---

## Security

| Resource | Name | SKU / Config | RG | Terraform |
|---|---|---|---|---|
| Key Vault | `npp-prod-kv` | Standard, purge-protected, RBAC auth, private endpoint | security | `azurerm_key_vault.main` |
| Managed Identity (app) | `npp-prod-id-app` | User-assigned | security | `azurerm_user_assigned_identity.app` |
| Managed Identity (GitHub) | `npp-prod-id-github` | User-assigned, OIDC federated | security | `azurerm_user_assigned_identity.github` |

Key Vault secrets:

| Secret Name | Description |
|---|---|
| `db-password` | PostgreSQL admin password |
| `stripe-secret-key` | Stripe live secret key (sk_live_...) |
| `stripe-webhook-secret` | Stripe webhook signing secret (whsec_...) |
| `jwt-private-key` | RSA-256 private key (PKCS#8 PEM) |
| `jwt-public-key` | RSA-256 public key (X.509 PEM) |
| `redis-password` | Redis primary access key |

---

## Ingress

| Resource | Name | SKU | RG | Terraform |
|---|---|---|---|---|
| Front Door Profile | `npp-prod-afd` | Premium_AzureFrontDoor | app | `azurerm_cdn_frontdoor_profile.main` |
| Front Door Endpoint | `npp-prod-ep` | — | app | `azurerm_cdn_frontdoor_endpoint.main` |
| WAF Policy | `npprodwaf` | Premium, Prevention mode, OWASP 2.1 + BotManager 1.1 | app | `azurerm_cdn_frontdoor_firewall_policy.main` |
| Origin Group (API) | `og-api` | — | app | `azurerm_cdn_frontdoor_origin_group.api` |
| Origin Group (frontend) | `og-frontend` | — | app | `azurerm_cdn_frontdoor_origin_group.frontend` |

Route table:

| Pattern | Origin Group | Notes |
|---|---|---|
| `/v1/*`, `/api/*`, `/actuator/health` | API (Container App) | Private Link origin |
| `/*` | Frontend (Static Web App) | SWA default hostname |

---

## Monitoring

| Resource | Name | Config | RG | Terraform |
|---|---|---|---|---|
| Log Analytics Workspace | `npp-prod-law` | PerGB2018, 90-day retention | monitoring | `azurerm_log_analytics_workspace.main` |
| Application Insights | `npp-prod-ai` | Java, workspace-based | monitoring | `azurerm_application_insights.main` |
| Action Group | `npp-prod-ag-ops` | Email to `alert_email` | monitoring | `azurerm_monitor_action_group.ops` |

Metric alerts:

| Alert | Threshold | Severity |
|---|---|---|
| Redis memory > 80% | 15-min window | 2 |
| PostgreSQL CPU > 80% | 15-min window | 2 |
| PostgreSQL connections > 150 | 15-min window | 2 |
| Container App 5xx count > 5 per min | 5-min window | 1 |

---

## RBAC Summary

| Principal | Role | Scope |
|---|---|---|
| `npp-prod-id-app` | AcrPull | ACR |
| `npp-prod-id-app` | Key Vault Secrets User | Key Vault |
| `npp-prod-id-github` | AcrPush | ACR |
| `npp-prod-id-github` | Key Vault Secrets Officer | Key Vault |
| `npp-prod-id-github` | Contributor | Container App |
| `npp-prod-id-github` | Contributor | SWA frontend |
| `npp-prod-id-github` | Contributor | SWA admin |
| Terraform caller | Key Vault Secrets Officer | Key Vault (bootstrap only) |
