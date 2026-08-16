# ─── Azure Container Registry ─────────────────────────────────────────────────
# Premium tier is required for:
#   • Private endpoint support (network_rule_set with default_action = Deny)
#   • Geo-replication to the DR region
#   • Retention policies
#
# ACR name must be globally unique, alphanumeric only (no hyphens), 5-50 chars.
# Naming convention: {project}{env}acr → e.g. "npprodacr"

resource "azurerm_container_registry" "main" {
  name                          = local.acr_name
  resource_group_name           = azurerm_resource_group.app.name
  location                      = var.location
  sku                           = "Premium"
  admin_enabled                 = false
  public_network_access_enabled = false
  zone_redundancy_enabled       = true

  network_rule_set {
    default_action = "Deny"
  }

  retention_policy {
    days    = 30
    enabled = true
  }

  trust_policy {
    enabled = false  # Content trust / DCT — not required for this workload
  }

  georeplications {
    location                  = var.dr_location
    zone_redundancy_enabled   = false  # Australia Southeast doesn't support zone redundancy
    regional_endpoint_enabled = false
    tags                      = local.tags
  }

  tags = local.tags
}

# ─── RBAC for ACR ─────────────────────────────────────────────────────────────

# Container App managed identity — pull images at runtime.
resource "azurerm_role_assignment" "ca_acr_pull" {
  scope                = azurerm_container_registry.main.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.app.principal_id
}

# GitHub Actions — push images during CI/CD.
resource "azurerm_role_assignment" "github_acr_push" {
  scope                = azurerm_container_registry.main.id
  role_definition_name = "AcrPush"
  principal_id         = azurerm_user_assigned_identity.github.principal_id
}
