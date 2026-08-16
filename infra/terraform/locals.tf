# Centralised naming convention — all resource names derive from project + environment.
# Pattern: {project}-{env}-{type}-{descriptor}
# ACR name is globally unique and cannot contain hyphens.

locals {
  # Resource group names
  rg_network    = "${var.project}-${var.environment}-rg-network"
  rg_app        = "${var.project}-${var.environment}-rg-app"
  rg_data       = "${var.project}-${var.environment}-rg-data"
  rg_security   = "${var.project}-${var.environment}-rg-security"
  rg_monitoring = "${var.project}-${var.environment}-rg-monitoring"

  # Networking
  vnet_name        = "${var.project}-${var.environment}-vnet"
  snet_apps_name   = "${var.project}-${var.environment}-snet-apps"
  snet_pe_name     = "${var.project}-${var.environment}-snet-pe"
  nsg_apps_name    = "${var.project}-${var.environment}-nsg-apps"
  nsg_pe_name      = "${var.project}-${var.environment}-nsg-pe"

  # Data
  pg_name          = "${var.project}-${var.environment}-pg"
  redis_name       = "${var.project}-${var.environment}-redis"
  pg_db_name       = "naplanprep_${var.environment}"

  # Security
  kv_name          = "${var.project}-${var.environment}-kv"

  # Container / registry
  acr_name         = "${var.project}${var.environment}acr"  # no hyphens, globally unique
  ca_env_name      = "${var.project}-${var.environment}-ca-env"
  ca_api_name      = "${var.project}-${var.environment}-ca-api"

  # Storage
  storage_name     = "${var.project}${var.environment}sa"  # no hyphens, globally unique

  # Frontend
  swa_frontend_name = "${var.project}-${var.environment}-swa-frontend"
  swa_admin_name    = "${var.project}-${var.environment}-swa-admin"

  # Front Door
  afd_name          = "${var.project}-${var.environment}-afd"

  # Monitoring
  law_name          = "${var.project}-${var.environment}-law"
  ai_name           = "${var.project}-${var.environment}-ai"

  # Identity
  id_github_name    = "${var.project}-${var.environment}-id-github"

  # Common tags applied to all resources
  tags = {
    Project     = "naplanprep"
    Environment = var.environment
    ManagedBy   = "terraform"
    Repository  = "github.com/${var.github_repo}"
  }

  # Private DNS zone names (Azure canonical)
  dns_zone_postgres = "privatelink.postgres.database.azure.com"
  dns_zone_redis    = "privatelink.redis.cache.windows.net"
  dns_zone_keyvault = "privatelink.vaultcore.azure.net"
  dns_zone_acr      = "privatelink.azurecr.io"
}
