# ─── Key Vault ────────────────────────────────────────────────────────────────
# Holds all production secrets injected into the Container App at runtime:
#   • JWT_PRIVATE_KEY / JWT_PUBLIC_KEY (RSA-256 PEM strings)
#   • DB_PASSWORD
#   • STRIPE_SECRET_KEY / STRIPE_WEBHOOK_SECRET
#   • REDIS_PASSWORD (primary access key)
#   • Spring app-specific secrets passed as env vars via secretRef
#
# prevent_destroy prevents accidental deletion of production secrets.

resource "azurerm_key_vault" "main" {
  name                        = local.kv_name
  resource_group_name         = azurerm_resource_group.security.name
  location                    = var.location
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  soft_delete_retention_days  = 90
  purge_protection_enabled    = true
  enable_rbac_authorization   = true
  public_network_access_enabled = false

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
    ip_rules       = []
  }

  tags = local.tags

  lifecycle {
    prevent_destroy = true
  }
}

# ─── RBAC Assignments ─────────────────────────────────────────────────────────

# Container App managed identity — read secrets at runtime.
resource "azurerm_role_assignment" "ca_kv_secrets_user" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.app.principal_id
}

# GitHub Actions identity — write secrets during CI/CD (image tag update, rotate secrets).
resource "azurerm_role_assignment" "github_kv_secrets_officer" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = azurerm_user_assigned_identity.github.principal_id
}

# Terraform operator (current CI caller) — needed during initial secret population.
# After bootstrapping, this assignment can be removed by setting a flag in tfvars.
resource "azurerm_role_assignment" "terraform_kv_secrets_officer" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

# ─── Secret Placeholders ──────────────────────────────────────────────────────
# These resources declare the secret names in state so dependent resources can
# reference them. Actual secret VALUES are populated by the initial-secrets.sh
# runbook (not Terraform), preventing plaintext values from appearing in state.

resource "azurerm_key_vault_secret" "db_password" {
  name         = "db-password"
  value        = "PLACEHOLDER-REPLACE-VIA-RUNBOOK"
  key_vault_id = azurerm_key_vault.main.id
  tags         = local.tags

  lifecycle {
    ignore_changes = [value]
  }

  depends_on = [azurerm_role_assignment.terraform_kv_secrets_officer]
}

resource "azurerm_key_vault_secret" "stripe_secret_key" {
  name         = "stripe-secret-key"
  value        = "PLACEHOLDER-REPLACE-VIA-RUNBOOK"
  key_vault_id = azurerm_key_vault.main.id
  tags         = local.tags

  lifecycle {
    ignore_changes = [value]
  }

  depends_on = [azurerm_role_assignment.terraform_kv_secrets_officer]
}

resource "azurerm_key_vault_secret" "stripe_webhook_secret" {
  name         = "stripe-webhook-secret"
  value        = "PLACEHOLDER-REPLACE-VIA-RUNBOOK"
  key_vault_id = azurerm_key_vault.main.id
  tags         = local.tags

  lifecycle {
    ignore_changes = [value]
  }

  depends_on = [azurerm_role_assignment.terraform_kv_secrets_officer]
}

resource "azurerm_key_vault_secret" "jwt_private_key" {
  name         = "jwt-private-key"
  value        = "PLACEHOLDER-REPLACE-VIA-RUNBOOK"
  key_vault_id = azurerm_key_vault.main.id
  tags         = local.tags

  lifecycle {
    ignore_changes = [value]
  }

  depends_on = [azurerm_role_assignment.terraform_kv_secrets_officer]
}

resource "azurerm_key_vault_secret" "jwt_public_key" {
  name         = "jwt-public-key"
  value        = "PLACEHOLDER-REPLACE-VIA-RUNBOOK"
  key_vault_id = azurerm_key_vault.main.id
  tags         = local.tags

  lifecycle {
    ignore_changes = [value]
  }

  depends_on = [azurerm_role_assignment.terraform_kv_secrets_officer]
}

resource "azurerm_key_vault_secret" "redis_password" {
  name         = "redis-password"
  value        = azurerm_redis_cache.main.primary_access_key
  key_vault_id = azurerm_key_vault.main.id
  tags         = local.tags

  lifecycle {
    ignore_changes = [value]
  }

  depends_on = [azurerm_role_assignment.terraform_kv_secrets_officer]
}
