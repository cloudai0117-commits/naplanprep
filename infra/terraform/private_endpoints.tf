# ─── Private DNS Zones ────────────────────────────────────────────────────────
# Each private endpoint service requires its own DNS zone registered in the VNet.
# Without these zones, the application would resolve service FQDNs to public IPs.

resource "azurerm_private_dns_zone" "postgres" {
  name                = local.dns_zone_postgres
  resource_group_name = azurerm_resource_group.network.name
  tags                = local.tags
}

resource "azurerm_private_dns_zone" "redis" {
  name                = local.dns_zone_redis
  resource_group_name = azurerm_resource_group.network.name
  tags                = local.tags
}

resource "azurerm_private_dns_zone" "keyvault" {
  name                = local.dns_zone_keyvault
  resource_group_name = azurerm_resource_group.network.name
  tags                = local.tags
}

resource "azurerm_private_dns_zone" "acr" {
  name                = local.dns_zone_acr
  resource_group_name = azurerm_resource_group.network.name
  tags                = local.tags
}

# ─── DNS Zone VNet Links ──────────────────────────────────────────────────────
# Link each private DNS zone to the VNet so that DNS resolution within the VNet
# resolves private endpoint A records instead of public endpoints.

resource "azurerm_private_dns_zone_virtual_network_link" "postgres" {
  name                  = "link-postgres"
  resource_group_name   = azurerm_resource_group.network.name
  private_dns_zone_name = azurerm_private_dns_zone.postgres.name
  virtual_network_id    = azurerm_virtual_network.main.id
  registration_enabled  = false
  tags                  = local.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "redis" {
  name                  = "link-redis"
  resource_group_name   = azurerm_resource_group.network.name
  private_dns_zone_name = azurerm_private_dns_zone.redis.name
  virtual_network_id    = azurerm_virtual_network.main.id
  registration_enabled  = false
  tags                  = local.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "keyvault" {
  name                  = "link-keyvault"
  resource_group_name   = azurerm_resource_group.network.name
  private_dns_zone_name = azurerm_private_dns_zone.keyvault.name
  virtual_network_id    = azurerm_virtual_network.main.id
  registration_enabled  = false
  tags                  = local.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "acr" {
  name                  = "link-acr"
  resource_group_name   = azurerm_resource_group.network.name
  private_dns_zone_name = azurerm_private_dns_zone.acr.name
  virtual_network_id    = azurerm_virtual_network.main.id
  registration_enabled  = false
  tags                  = local.tags
}

# ─── Private Endpoints ────────────────────────────────────────────────────────

# PostgreSQL private endpoint
resource "azurerm_private_endpoint" "postgres" {
  name                = "${local.pg_name}-pe"
  resource_group_name = azurerm_resource_group.network.name
  location            = var.location
  subnet_id           = azurerm_subnet.pe.id
  tags                = local.tags

  private_service_connection {
    name                           = "${local.pg_name}-psc"
    private_connection_resource_id = azurerm_postgresql_flexible_server.main.id
    subresource_names              = ["postgresqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "postgres-dns-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.postgres.id]
  }

  depends_on = [
    azurerm_postgresql_flexible_server.main,
    azurerm_private_dns_zone_virtual_network_link.postgres,
  ]
}

# Redis private endpoint
resource "azurerm_private_endpoint" "redis" {
  name                = "${local.redis_name}-pe"
  resource_group_name = azurerm_resource_group.network.name
  location            = var.location
  subnet_id           = azurerm_subnet.pe.id
  tags                = local.tags

  private_service_connection {
    name                           = "${local.redis_name}-psc"
    private_connection_resource_id = azurerm_redis_cache.main.id
    subresource_names              = ["redisCache"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "redis-dns-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.redis.id]
  }

  depends_on = [
    azurerm_redis_cache.main,
    azurerm_private_dns_zone_virtual_network_link.redis,
  ]
}

# Key Vault private endpoint
resource "azurerm_private_endpoint" "keyvault" {
  name                = "${local.kv_name}-pe"
  resource_group_name = azurerm_resource_group.network.name
  location            = var.location
  subnet_id           = azurerm_subnet.pe.id
  tags                = local.tags

  private_service_connection {
    name                           = "${local.kv_name}-psc"
    private_connection_resource_id = azurerm_key_vault.main.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "keyvault-dns-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.keyvault.id]
  }

  depends_on = [
    azurerm_key_vault.main,
    azurerm_private_dns_zone_virtual_network_link.keyvault,
  ]
}

# ACR private endpoint — enables Container App to pull images without leaving the VNet.
resource "azurerm_private_endpoint" "acr" {
  name                = "${local.acr_name}-pe"
  resource_group_name = azurerm_resource_group.network.name
  location            = var.location
  subnet_id           = azurerm_subnet.pe.id
  tags                = local.tags

  private_service_connection {
    name                           = "${local.acr_name}-psc"
    private_connection_resource_id = azurerm_container_registry.main.id
    subresource_names              = ["registry"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "acr-dns-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.acr.id]
  }

  depends_on = [
    azurerm_container_registry.main,
    azurerm_private_dns_zone_virtual_network_link.acr,
  ]
}
