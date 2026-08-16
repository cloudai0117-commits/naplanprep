# ─── Azure Static Web Apps ────────────────────────────────────────────────────
# Two Static Web Apps — one for the student-facing frontend, one for the admin
# panel. Both are Standard tier (required for custom domains and private link).
#
# SWA deployment is managed by GitHub Actions using the SWA deployment token
# stored in GitHub Actions secrets (not in Terraform state).

resource "azurerm_static_site" "frontend" {
  name                = local.swa_frontend_name
  resource_group_name = azurerm_resource_group.app.name
  location            = "eastasia"  # SWA doesn't support australiaeast; eastasia is the closest
  sku_tier            = "Standard"
  sku_size            = "Standard"
  tags                = local.tags
}

resource "azurerm_static_site" "admin" {
  name                = local.swa_admin_name
  resource_group_name = azurerm_resource_group.app.name
  location            = "eastasia"
  sku_tier            = "Standard"
  sku_size            = "Standard"
  tags                = local.tags
}

# ─── Custom Domains ───────────────────────────────────────────────────────────
# DNS validation is done via TXT record (manual step).
# These resources are commented out until DNS is configured at the registrar.
#
# resource "azurerm_static_site_custom_domain" "frontend" {
#   static_site_id  = azurerm_static_site.frontend.id
#   domain_name     = "www.naplanprep.com.au"
#   validation_type = "dns-txt-token"
# }
#
# resource "azurerm_static_site_custom_domain" "admin" {
#   static_site_id  = azurerm_static_site.admin.id
#   domain_name     = "admin.naplanprep.com.au"
#   validation_type = "dns-txt-token"
# }
