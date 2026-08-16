# ─── Outputs ──────────────────────────────────────────────────────────────────
# Referenced by CI/CD pipelines (GitHub Actions) and runbooks.
# Sensitive outputs (passwords, access keys) are marked sensitive=true so they
# are redacted from plan/apply logs but remain accessible via `terraform output -raw`.

output "container_app_fqdn" {
  description = "Internal FQDN of the backend Container App."
  value       = azurerm_container_app.api.ingress[0].fqdn
}

output "frontdoor_endpoint_hostname" {
  description = "Public Front Door endpoint hostname (default *.z01.azurefd.net domain)."
  value       = azurerm_cdn_frontdoor_endpoint.main.host_name
}

output "static_web_app_frontend_hostname" {
  description = "Default hostname of the frontend Static Web App."
  value       = azurerm_static_site.frontend.default_host_name
}

output "static_web_app_admin_hostname" {
  description = "Default hostname of the admin Static Web App."
  value       = azurerm_static_site.admin.default_host_name
}

output "acr_login_server" {
  description = "ACR login server — used in GitHub Actions docker push commands."
  value       = azurerm_container_registry.main.login_server
}

output "container_app_name" {
  description = "Name of the backend Container App — used by GitHub Actions az containerapp update."
  value       = azurerm_container_app.api.name
}

output "container_app_resource_group" {
  description = "Resource group containing the Container App."
  value       = azurerm_resource_group.app.name
}

output "postgresql_fqdn" {
  description = "Private FQDN of the PostgreSQL Flexible Server."
  value       = azurerm_postgresql_flexible_server.main.fqdn
}

output "postgresql_database_name" {
  description = "Name of the application database on the PostgreSQL server."
  value       = local.pg_db_name
}

output "redis_hostname" {
  description = "Private hostname of the Azure Cache for Redis instance."
  value       = azurerm_redis_cache.main.hostname
}

output "redis_port" {
  description = "SSL port for the Azure Cache for Redis instance."
  value       = azurerm_redis_cache.main.ssl_port
}

output "redis_primary_access_key" {
  description = "Primary access key for Redis — populated in Key Vault as redis-password."
  value       = azurerm_redis_cache.main.primary_access_key
  sensitive   = true
}

output "key_vault_uri" {
  description = "URI of the Key Vault — used to construct secret references in Container App."
  value       = azurerm_key_vault.main.vault_uri
}

output "log_analytics_workspace_id" {
  description = "Log Analytics workspace resource ID — used for diagnostic setting references."
  value       = azurerm_log_analytics_workspace.main.id
}

output "application_insights_connection_string" {
  description = "App Insights connection string — passed as APPLICATIONINSIGHTS_CONNECTION_STRING env var."
  value       = azurerm_application_insights.main.connection_string
  sensitive   = true
}

output "app_managed_identity_client_id" {
  description = "Client ID of the app user-assigned managed identity — used for workload identity auth."
  value       = azurerm_user_assigned_identity.app.client_id
}

output "github_managed_identity_client_id" {
  description = "Client ID of the GitHub Actions user-assigned managed identity — used in OIDC workflow."
  value       = azurerm_user_assigned_identity.github.client_id
}

output "resource_group_app" {
  description = "Name of the app resource group."
  value       = azurerm_resource_group.app.name
}

output "resource_group_data" {
  description = "Name of the data resource group."
  value       = azurerm_resource_group.data.name
}
