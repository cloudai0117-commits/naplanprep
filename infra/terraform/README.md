# NAPLANPrep — Terraform IaC (Azure Production)

Terraform configuration for the NAPLANPrep production environment on Azure.

## Architecture

| Layer | Resource | SKU |
|---|---|---|
| Ingress | Azure Front Door Premium + WAF | Premium |
| Frontend | Azure Static Web Apps ×2 | Standard |
| Compute | Azure Container Apps (Consumption) | — |
| Registry | Azure Container Registry | Premium |
| Database | Azure PostgreSQL Flexible Server v16 | GP_Standard_D4s_v3 |
| Cache | Azure Cache for Redis | Standard C1 |
| Secrets | Azure Key Vault | Standard |
| Networking | VNet 10.0.0.0/16, private endpoints for all PaaS | — |
| Monitoring | Log Analytics + Application Insights + metric alerts | PerGB2018 |

## File Layout

```
infra/terraform/
├── main.tf                    # Provider config, backend state
├── variables.tf               # All input variables
├── locals.tf                  # Naming convention, tags
├── resource_groups.tf         # 5 resource groups
├── networking.tf              # VNet, subnets, NSGs
├── private_endpoints.tf       # Private DNS zones, VNet links, private endpoints
├── identity.tf                # Managed identities, OIDC federated credential
├── acr.tf                     # Azure Container Registry (Premium)
├── postgresql.tf              # PostgreSQL Flexible Server v16
├── redis.tf                   # Azure Cache for Redis (Standard C1)
├── keyvault.tf                # Key Vault + secret placeholders
├── container_apps.tf          # Container Apps Environment + API app
├── static_web_apps.tf         # Frontend + admin Static Web Apps
├── frontdoor.tf               # Front Door Premium + WAF + routes
├── monitoring.tf              # Log Analytics, App Insights, metric alerts
├── outputs.tf                 # All exported values
├── terraform.tfvars.example   # Variable template (copy → terraform.tfvars)
└── README.md                  # This file
```

## Prerequisites

1. **Terraform 1.7+** — `terraform version`
2. **Azure CLI** logged in — `az login`
3. **Remote state storage** pre-created (one-time bootstrap):
   ```bash
   az group create -n npp-prod-rg-tfstate -l australiaeast
   az storage account create -n npprodtfstate -g npp-prod-rg-tfstate \
     -l australiaeast --sku Standard_GRS --kind StorageV2
   az storage container create -n tfstate \
     --account-name npprodtfstate
   ```
4. **Service principal or managed identity** with Owner role on the target subscription (needed to create RBAC assignments).

## Initial Deployment

```bash
cd infra/terraform

# 1. Copy and fill in variables
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars — fill in passwords, Stripe key, GitHub repo, alert email

# 2. Initialise
terraform init

# 3. Plan
terraform plan -out=tfplan

# 4. Apply
terraform apply tfplan
```

## Secret Population

After `terraform apply`, Key Vault secret values are placeholders. Run the initial secrets runbook:

```bash
# Set the real secret values (replace with actual values)
KV=$(terraform output -raw key_vault_uri | sed 's|https://||' | sed 's|/||')

az keyvault secret set --vault-name "$KV" --name "db-password" --value "ACTUAL_DB_PASSWORD"
az keyvault secret set --vault-name "$KV" --name "stripe-secret-key" --value "sk_live_..."
az keyvault secret set --vault-name "$KV" --name "stripe-webhook-secret" --value "whsec_..."
az keyvault secret set --vault-name "$KV" --name "jwt-private-key" --value "$(cat /path/to/private.pem)"
az keyvault secret set --vault-name "$KV" --name "jwt-public-key" --value "$(cat /path/to/public.pem)"
# redis-password is auto-populated from Terraform (azurerm_redis_cache primary_access_key)
```

## CI/CD Integration

GitHub Actions uses OIDC federation — no long-lived client secrets.

Required GitHub Actions secrets:

| Secret | Value |
|---|---|
| `AZURE_CLIENT_ID` | `terraform output -raw github_managed_identity_client_id` |
| `AZURE_TENANT_ID` | Azure AD tenant ID |
| `AZURE_SUBSCRIPTION_ID` | Azure subscription ID |
| `ACR_LOGIN_SERVER` | `terraform output -raw acr_login_server` |
| `CONTAINER_APP_NAME` | `terraform output -raw container_app_name` |
| `CONTAINER_APP_RG` | `terraform output -raw container_app_resource_group` |
| `SWA_FRONTEND_DEPLOYMENT_TOKEN` | From SWA resource → Manage deployment token |
| `SWA_ADMIN_DEPLOYMENT_TOKEN` | From admin SWA resource → Manage deployment token |

## Upgrading

- **Container App image**: No Terraform change needed. CI/CD calls `az containerapp update --image`.
- **PostgreSQL version**: Not a zero-downtime operation. Coordinate with a maintenance window.
- **ACR SKU / Redis size**: Can be upgraded online; `terraform apply` after changing the variable.

## Destroying

`terraform destroy` is blocked for PostgreSQL and Key Vault (`lifecycle { prevent_destroy = true }`). To destroy production:

1. Remove the `prevent_destroy` lifecycle blocks.
2. Run `terraform apply` to update state.
3. Run `terraform destroy`.

This two-step requirement is intentional — it prevents accidents.
