# ─── Azure Cache for Redis ────────────────────────────────────────────────────
# Standard C1 (1 GiB, replication included) — matches the Platform_Standard tier
# used on Railway. Redis is used for:
#   • JWT blacklist (logout / refresh revocation)  — key: blacklist:{token}
#   • Rate limiting fixed-window counters           — key: ratelimit:{group}:{ip}:{window}
#   • Spring Cache (@Cacheable)                     — per-annotation prefix
#
# Standard tier provides automatic replication + failover within the same region.
# A Redis Cluster (Premium) is not required at this traffic level.

resource "azurerm_redis_cache" "main" {
  name                          = local.redis_name
  resource_group_name           = azurerm_resource_group.data.name
  location                      = var.location
  capacity                      = 1
  family                        = "C"
  sku_name                      = "Standard"
  enable_non_ssl_port           = false
  minimum_tls_version           = "1.2"
  public_network_access_enabled = false

  redis_configuration {
    maxmemory_policy          = "allkeys-lru"
    maxmemory_reserved        = 50
    maxfragmentationmemory_reserved = 50
    # Disable AUTH password — access is restricted to VNet-only via private endpoint.
    # The primary access key is still available and used by the Spring Boot app.
    enable_authentication     = true
    aof_backup_enabled        = false
    rdb_backup_enabled        = true
    rdb_backup_frequency      = 60   # RDB snapshot every 60 minutes
    rdb_backup_max_snapshot_count = 1
  }

  patch_schedule {
    day_of_week    = "Sunday"
    start_hour_utc = 2
  }

  tags = local.tags

  lifecycle {
    ignore_changes = [redis_configuration[0].rdb_storage_connection_string]
  }
}
