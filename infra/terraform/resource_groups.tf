# ─── Resource Groups ──────────────────────────────────────────────────────────
# Five resource groups separate lifecycle concerns and enable scoped RBAC.
# Network and security RGs rarely change; app and data RGs rotate with deployments.

resource "azurerm_resource_group" "network" {
  name     = local.rg_network
  location = var.location
  tags     = local.tags
}

resource "azurerm_resource_group" "app" {
  name     = local.rg_app
  location = var.location
  tags     = local.tags
}

resource "azurerm_resource_group" "data" {
  name     = local.rg_data
  location = var.location
  tags     = local.tags
}

resource "azurerm_resource_group" "security" {
  name     = local.rg_security
  location = var.location
  tags     = local.tags
}

resource "azurerm_resource_group" "monitoring" {
  name     = local.rg_monitoring
  location = var.location
  tags     = local.tags
}
