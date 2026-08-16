# ─── PostgreSQL Flexible Server ───────────────────────────────────────────────
# Version 16 matches the Railway PostgreSQL version and the Flyway baseline.
# prevent_destroy guards against accidental terraform destroy of production data.

resource "azurerm_postgresql_flexible_server" "main" {
  name                          = local.pg_name
  resource_group_name           = azurerm_resource_group.data.name
  location                      = var.location
  version                       = var.postgresql_version
  administrator_login           = var.postgresql_admin_username
  administrator_password        = var.postgresql_admin_password
  sku_name                      = var.postgresql_sku_name
  storage_mb                    = 131072  # 128 GiB initial, can be scaled up online
  backup_retention_days         = 35
  geo_redundant_backup_enabled  = true
  zone                          = "1"

  # VNet integration via private endpoint (not delegated subnet injection).
  # public_network_access_enabled = false is set after the private endpoint is provisioned.
  public_network_access_enabled = false

  # High availability — zone-redundant standby in AZ 2.
  high_availability {
    mode                      = "ZoneRedundant"
    standby_availability_zone = "2"
  }

  maintenance_window {
    day_of_week  = 0  # Sunday
    start_hour   = 2
    start_minute = 0
  }

  authentication {
    active_directory_auth_enabled = false
    password_auth_enabled         = true
  }

  tags = local.tags

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [zone, high_availability[0].standby_availability_zone]
  }
}

# ─── Database ─────────────────────────────────────────────────────────────────

resource "azurerm_postgresql_flexible_server_database" "main" {
  name      = local.pg_db_name
  server_id = azurerm_postgresql_flexible_server.main.id
  charset   = "UTF8"
  collation = "en_US.utf8"

  lifecycle {
    prevent_destroy = true
  }
}

# ─── Server Parameters ────────────────────────────────────────────────────────
# Tuned for a Spring Boot / JDBC workload on GP_Standard_D4s_v3 (4 vCPU, 16 GiB).

resource "azurerm_postgresql_flexible_server_configuration" "shared_buffers" {
  name      = "shared_buffers"
  server_id = azurerm_postgresql_flexible_server.main.id
  value     = "4096"  # 4 GiB = 25 % of 16 GiB RAM
}

resource "azurerm_postgresql_flexible_server_configuration" "max_connections" {
  name      = "max_connections"
  server_id = azurerm_postgresql_flexible_server.main.id
  value     = "200"
}

resource "azurerm_postgresql_flexible_server_configuration" "work_mem" {
  name      = "work_mem"
  server_id = azurerm_postgresql_flexible_server.main.id
  value     = "16384"  # 16 MiB per sort/hash, shared across parallel workers
}

resource "azurerm_postgresql_flexible_server_configuration" "maintenance_work_mem" {
  name      = "maintenance_work_mem"
  server_id = azurerm_postgresql_flexible_server.main.id
  value     = "524288"  # 512 MiB for VACUUM / CREATE INDEX
}

resource "azurerm_postgresql_flexible_server_configuration" "log_min_duration_statement" {
  name      = "log_min_duration_statement"
  server_id = azurerm_postgresql_flexible_server.main.id
  value     = "1000"  # log queries taking more than 1 second
}

# ─── Firewall Rules ───────────────────────────────────────────────────────────
# No public firewall rules — access is exclusively via private endpoint.
# Azure Container Apps connect through the private endpoint NIC in the pe subnet.
# The high_availability block above keeps the standby in the same VNet.
