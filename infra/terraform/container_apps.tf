# ─── Container Apps Environment ───────────────────────────────────────────────
# VNet-integrated Consumption environment. All Container Apps in this environment
# share the apps subnet and can reach private endpoints in the pe subnet.

resource "azurerm_container_app_environment" "main" {
  name                       = local.ca_env_name
  resource_group_name        = azurerm_resource_group.app.name
  location                   = var.location
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  infrastructure_subnet_id   = azurerm_subnet.apps.id

  # Internal-only environment — Front Door is the public ingress point.
  internal_load_balancer_enabled = true

  tags = local.tags

  depends_on = [azurerm_subnet_network_security_group_association.apps]
}

# ─── Backend API Container App ─────────────────────────────────────────────────
# Spring Boot 3.2.3 / Java 21 backend. Image is pushed to ACR by CI and the tag
# is supplied via var.container_app_image on each deployment.
#
# Secrets are sourced from Key Vault via secretRef — the managed identity must have
# the Key Vault Secrets User role (granted in keyvault.tf and identity.tf).

resource "azurerm_container_app" "api" {
  name                         = local.ca_api_name
  resource_group_name          = azurerm_resource_group.app.name
  container_app_environment_id = azurerm_container_app_environment.main.id
  revision_mode                = "Single"
  tags                         = local.tags

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.app.id]
  }

  registry {
    server   = azurerm_container_registry.main.login_server
    identity = azurerm_user_assigned_identity.app.id
  }

  # Secrets referencing Key Vault — values resolved at runtime by the managed identity.
  secret {
    name                = "db-password"
    key_vault_secret_id = azurerm_key_vault_secret.db_password.id
    identity            = azurerm_user_assigned_identity.app.id
  }

  secret {
    name                = "stripe-secret-key"
    key_vault_secret_id = azurerm_key_vault_secret.stripe_secret_key.id
    identity            = azurerm_user_assigned_identity.app.id
  }

  secret {
    name                = "stripe-webhook-secret"
    key_vault_secret_id = azurerm_key_vault_secret.stripe_webhook_secret.id
    identity            = azurerm_user_assigned_identity.app.id
  }

  secret {
    name                = "jwt-private-key"
    key_vault_secret_id = azurerm_key_vault_secret.jwt_private_key.id
    identity            = azurerm_user_assigned_identity.app.id
  }

  secret {
    name                = "jwt-public-key"
    key_vault_secret_id = azurerm_key_vault_secret.jwt_public_key.id
    identity            = azurerm_user_assigned_identity.app.id
  }

  secret {
    name                = "redis-password"
    key_vault_secret_id = azurerm_key_vault_secret.redis_password.id
    identity            = azurerm_user_assigned_identity.app.id
  }

  template {
    min_replicas = 1
    max_replicas = 5

    container {
      name   = "api"
      image  = var.container_app_image
      cpu    = 1.0
      memory = "2Gi"

      # ─── Environment variables ─────────────────────────────────────────────
      # Non-secret configuration — supplied as plain env vars.
      env {
        name  = "SPRING_PROFILES_ACTIVE"
        value = "prod"
      }

      env {
        name  = "SERVER_PORT"
        value = "8080"
      }

      env {
        name  = "DB_HOST"
        value = azurerm_postgresql_flexible_server.main.fqdn
      }

      env {
        name  = "DB_PORT"
        value = "5432"
      }

      env {
        name  = "DB_NAME"
        value = local.pg_db_name
      }

      env {
        name  = "DB_USERNAME"
        value = var.postgresql_admin_username
      }

      env {
        name        = "DB_PASSWORD"
        secret_name = "db-password"
      }

      env {
        name  = "REDIS_HOST"
        value = azurerm_redis_cache.main.hostname
      }

      env {
        name  = "REDIS_PORT"
        value = "6380"
      }

      env {
        name  = "REDIS_SSL"
        value = "true"
      }

      env {
        name        = "REDIS_PASSWORD"
        secret_name = "redis-password"
      }

      env {
        name        = "STRIPE_SECRET_KEY"
        secret_name = "stripe-secret-key"
      }

      env {
        name        = "STRIPE_WEBHOOK_SECRET"
        secret_name = "stripe-webhook-secret"
      }

      env {
        name        = "JWT_PRIVATE_KEY"
        secret_name = "jwt-private-key"
      }

      env {
        name        = "JWT_PUBLIC_KEY"
        secret_name = "jwt-public-key"
      }

      env {
        name  = "STRIPE_PUBLISHABLE_KEY"
        value = var.stripe_publishable_key
      }

      env {
        name  = "APPLICATIONINSIGHTS_CONNECTION_STRING"
        value = azurerm_application_insights.main.connection_string
      }

      env {
        name  = "JAVA_OPTS"
        value = "-XX:MaxRAMPercentage=75.0 -XX:+UseG1GC"
      }

      # ─── Health probes ────────────────────────────────────────────────────
      liveness_probe {
        path             = "/actuator/health/liveness"
        port             = 8080
        transport        = "HTTP"
        initial_delay    = 30
        interval_seconds = 10
        failure_count_threshold = 3
      }

      readiness_probe {
        path             = "/actuator/health/readiness"
        port             = 8080
        transport        = "HTTP"
        initial_delay    = 20
        interval_seconds = 10
        failure_count_threshold = 3
      }

      startup_probe {
        path             = "/actuator/health"
        port             = 8080
        transport        = "HTTP"
        initial_delay    = 15
        interval_seconds = 5
        failure_count_threshold = 12
      }
    }

    http_scale_rule {
      name                = "http-scale"
      concurrent_requests = "50"
    }
  }

  ingress {
    external_enabled = false  # Front Door is the external entry point
    target_port      = 8080
    transport        = "http"

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  depends_on = [
    azurerm_private_endpoint.postgres,
    azurerm_private_endpoint.redis,
    azurerm_private_endpoint.keyvault,
    azurerm_private_endpoint.acr,
    azurerm_role_assignment.ca_acr_pull,
    azurerm_role_assignment.ca_kv_secrets_user,
  ]
}
