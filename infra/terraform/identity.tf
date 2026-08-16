# ─── User-Assigned Managed Identities ────────────────────────────────────────
# Two identities — one for the running application, one for GitHub Actions.
# Using user-assigned (not system-assigned) identities allows the Container App
# to be replaced during a revision promotion without losing RBAC assignments.

# App identity — used by the Container App to pull ACR images and read KV secrets.
resource "azurerm_user_assigned_identity" "app" {
  name                = "${var.project}-${var.environment}-id-app"
  resource_group_name = azurerm_resource_group.security.name
  location            = var.location
  tags                = local.tags
}

# GitHub identity — used by GitHub Actions OIDC for deployments.
resource "azurerm_user_assigned_identity" "github" {
  name                = local.id_github_name
  resource_group_name = azurerm_resource_group.security.name
  location            = var.location
  tags                = local.tags
}

# ─── GitHub Actions OIDC Federated Credential ─────────────────────────────────
# No long-lived client secrets. GitHub Actions exchanges an OIDC token for a
# short-lived Azure access token scoped to the production environment.
# Subject format: repo:{org}/{repo}:environment:{env}

resource "azurerm_federated_identity_credential" "github_production" {
  name                = "github-actions-production"
  resource_group_name = azurerm_resource_group.security.name
  parent_id           = azurerm_user_assigned_identity.github.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = "https://token.actions.githubusercontent.com"
  subject             = "repo:${var.github_repo}:environment:${var.github_actions_environment}"
}

# ─── Container Apps Environment-level RBAC ────────────────────────────────────

# GitHub identity needs Contributor on the Container App to deploy new revisions.
resource "azurerm_role_assignment" "github_ca_contributor" {
  scope                = azurerm_container_app.api.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.github.principal_id
}

# GitHub identity needs Contributor on Static Web Apps for frontend deployments.
resource "azurerm_role_assignment" "github_swa_frontend_contributor" {
  scope                = azurerm_static_site.frontend.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.github.principal_id
}

resource "azurerm_role_assignment" "github_swa_admin_contributor" {
  scope                = azurerm_static_site.admin.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.github.principal_id
}
