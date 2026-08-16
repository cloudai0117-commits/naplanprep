# ─── Log Analytics Workspace ──────────────────────────────────────────────────

resource "azurerm_log_analytics_workspace" "main" {
  name                = local.law_name
  resource_group_name = azurerm_resource_group.monitoring.name
  location            = var.location
  sku                 = "PerGB2018"
  retention_in_days   = 90
  tags                = local.tags
}

# ─── Application Insights ─────────────────────────────────────────────────────

resource "azurerm_application_insights" "main" {
  name                = local.ai_name
  resource_group_name = azurerm_resource_group.monitoring.name
  location            = var.location
  workspace_id        = azurerm_log_analytics_workspace.main.id
  application_type    = "java"
  tags                = local.tags
}

# ─── Diagnostic Settings ──────────────────────────────────────────────────────
# Route all resource logs to the Log Analytics workspace.

resource "azurerm_monitor_diagnostic_setting" "postgres" {
  name                       = "diag-postgres"
  target_resource_id         = azurerm_postgresql_flexible_server.main.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  enabled_log {
    category = "PostgreSQLLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

resource "azurerm_monitor_diagnostic_setting" "redis" {
  name                       = "diag-redis"
  target_resource_id         = azurerm_redis_cache.main.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

resource "azurerm_monitor_diagnostic_setting" "acr" {
  name                       = "diag-acr"
  target_resource_id         = azurerm_container_registry.main.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  enabled_log {
    category = "ContainerRegistryLoginEvents"
  }
  enabled_log {
    category = "ContainerRegistryRepositoryEvents"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

resource "azurerm_monitor_diagnostic_setting" "keyvault" {
  name                       = "diag-keyvault"
  target_resource_id         = azurerm_key_vault.main.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  enabled_log {
    category = "AuditEvent"
  }
  enabled_log {
    category = "AzurePolicyEvaluationDetails"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

# ─── Action Group ─────────────────────────────────────────────────────────────

resource "azurerm_monitor_action_group" "ops" {
  name                = "${var.project}-${var.environment}-ag-ops"
  resource_group_name = azurerm_resource_group.monitoring.name
  short_name          = "npp-ops"
  tags                = local.tags

  email_receiver {
    name                    = "ops-email"
    email_address           = var.alert_email
    use_common_alert_schema = true
  }
}

# ─── Metric Alerts ────────────────────────────────────────────────────────────

resource "azurerm_monitor_metric_alert" "redis_memory" {
  name                = "${var.project}-${var.environment}-alert-redis-memory"
  resource_group_name = azurerm_resource_group.monitoring.name
  scopes              = [azurerm_redis_cache.main.id]
  description         = "Redis used memory exceeds 80% of capacity"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT15M"
  tags                = local.tags

  criteria {
    metric_namespace = "Microsoft.Cache/Redis"
    metric_name      = "usedmemorypercentage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.ops.id
  }
}

resource "azurerm_monitor_metric_alert" "pg_cpu" {
  name                = "${var.project}-${var.environment}-alert-pg-cpu"
  resource_group_name = azurerm_resource_group.monitoring.name
  scopes              = [azurerm_postgresql_flexible_server.main.id]
  description         = "PostgreSQL CPU exceeds 80% for 15 minutes"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT15M"
  tags                = local.tags

  criteria {
    metric_namespace = "Microsoft.DBforPostgreSQL/flexibleServers"
    metric_name      = "cpu_percent"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.ops.id
  }
}

resource "azurerm_monitor_metric_alert" "pg_connections" {
  name                = "${var.project}-${var.environment}-alert-pg-connections"
  resource_group_name = azurerm_resource_group.monitoring.name
  scopes              = [azurerm_postgresql_flexible_server.main.id]
  description         = "PostgreSQL active connections exceed 150 (75% of max_connections=200)"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT15M"
  tags                = local.tags

  criteria {
    metric_namespace = "Microsoft.DBforPostgreSQL/flexibleServers"
    metric_name      = "active_connections"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 150
  }

  action {
    action_group_id = azurerm_monitor_action_group.ops.id
  }
}

# ─── Log Alerts ───────────────────────────────────────────────────────────────

# Alert on 5xx error rate spike in Container Apps (requires structured logs).
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "ca_5xx" {
  name                = "${var.project}-${var.environment}-alert-ca-5xx"
  resource_group_name = azurerm_resource_group.monitoring.name
  location            = var.location
  description         = "Backend Container App HTTP 5xx rate exceeds 1% over 5 minutes"
  severity            = 1
  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"
  scopes               = [azurerm_log_analytics_workspace.main.id]
  tags                 = local.tags

  criteria {
    query = <<-EOT
      ContainerAppConsoleLogs_CL
      | where ContainerAppName_s == "${local.ca_api_name}"
      | where Log_s contains "HTTP Status 5"
      | summarize count() by bin(TimeGenerated, 1m)
    EOT

    time_aggregation_method = "Count"
    threshold               = 5
    operator                = "GreaterThan"
  }

  action {
    action_groups = [azurerm_monitor_action_group.ops.id]
  }
}
