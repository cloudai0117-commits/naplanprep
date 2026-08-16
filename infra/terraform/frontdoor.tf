# ─── Azure Front Door Premium ─────────────────────────────────────────────────
# Front Door Premium is required for:
#   • Private Link origins (backend Container App internal endpoint)
#   • WAF managed rule sets (OWASP + BotProtection)
#   • DDoS protection at the edge
#
# Front Door is the single public entry point for all traffic:
#   /api/*  → Container App (backend)
#   /*      → Static Web App (frontend)

resource "azurerm_cdn_frontdoor_profile" "main" {
  name                     = local.afd_name
  resource_group_name      = azurerm_resource_group.app.name
  sku_name                 = "Premium_AzureFrontDoor"
  response_timeout_seconds = 60
  tags                     = local.tags
}

# ─── Endpoint ─────────────────────────────────────────────────────────────────

resource "azurerm_cdn_frontdoor_endpoint" "main" {
  name                     = "${var.project}-${var.environment}-ep"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id
  tags                     = local.tags
}

# ─── Origin Groups ────────────────────────────────────────────────────────────

resource "azurerm_cdn_frontdoor_origin_group" "api" {
  name                     = "og-api"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id
  session_affinity_enabled = false

  health_probe {
    interval_in_seconds = 30
    path                = "/actuator/health"
    protocol            = "Https"
    request_type        = "GET"
  }

  load_balancing {
    additional_latency_in_milliseconds = 50
    sample_size                        = 4
    successful_samples_required        = 3
  }
}

resource "azurerm_cdn_frontdoor_origin_group" "frontend" {
  name                     = "og-frontend"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id
  session_affinity_enabled = false

  health_probe {
    interval_in_seconds = 60
    path                = "/"
    protocol            = "Https"
    request_type        = "HEAD"
  }

  load_balancing {
    additional_latency_in_milliseconds = 50
    sample_size                        = 4
    successful_samples_required        = 3
  }
}

# ─── Origins ──────────────────────────────────────────────────────────────────

# API origin — Private Link to Container App internal load balancer.
resource "azurerm_cdn_frontdoor_origin" "api" {
  name                          = "origin-api"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.api.id
  enabled                       = true
  host_name                     = azurerm_container_app.api.ingress[0].fqdn
  origin_host_header            = azurerm_container_app.api.ingress[0].fqdn
  https_port                    = 443
  http_port                     = 80
  priority                      = 1
  weight                        = 1000
  certificate_name_check_enabled = true

  private_link {
    request_message        = "FrontDoor private link to Container App API"
    target_type            = "sites"
    location               = var.location
    private_link_target_id = azurerm_container_app.api.id
  }
}

# Frontend origin — Static Web App.
resource "azurerm_cdn_frontdoor_origin" "frontend" {
  name                          = "origin-frontend"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.frontend.id
  enabled                       = true
  host_name                     = azurerm_static_site.frontend.default_host_name
  origin_host_header            = azurerm_static_site.frontend.default_host_name
  https_port                    = 443
  http_port                     = 80
  priority                      = 1
  weight                        = 1000
  certificate_name_check_enabled = true
}

# ─── WAF Policy ───────────────────────────────────────────────────────────────

resource "azurerm_cdn_frontdoor_firewall_policy" "main" {
  name                              = "${var.project}${var.environment}waf"
  resource_group_name               = azurerm_resource_group.app.name
  sku_name                          = azurerm_cdn_frontdoor_profile.main.sku_name
  enabled                           = true
  mode                              = "Prevention"
  redirect_url                      = null
  custom_block_response_status_code = 403
  tags                              = local.tags

  managed_rule {
    type    = "Microsoft_DefaultRuleSet"
    version = "2.1"
    action  = "Block"
  }

  managed_rule {
    type    = "Microsoft_BotManagerRuleSet"
    version = "1.1"
    action  = "Block"
  }
}

resource "azurerm_cdn_frontdoor_security_policy" "main" {
  name                     = "${var.project}-${var.environment}-sec-policy"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id

  security_policies {
    firewall {
      cdn_frontdoor_firewall_policy_id = azurerm_cdn_frontdoor_firewall_policy.main.id

      association {
        domain {
          cdn_frontdoor_domain_id = azurerm_cdn_frontdoor_endpoint.main.id
        }
        patterns_to_match = ["/*"]
      }
    }
  }
}

# ─── Routes ───────────────────────────────────────────────────────────────────

resource "azurerm_cdn_frontdoor_route" "api" {
  name                          = "route-api"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.main.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.api.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.api.id]
  enabled                       = true
  forwarding_protocol           = "HttpsOnly"
  https_redirect_enabled        = true
  patterns_to_match             = ["/v1/*", "/api/*", "/actuator/health"]
  supported_protocols           = ["Http", "Https"]
  link_to_default_domain        = true
}

resource "azurerm_cdn_frontdoor_route" "frontend" {
  name                          = "route-frontend"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.main.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.frontend.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.frontend.id]
  enabled                       = true
  forwarding_protocol           = "HttpsOnly"
  https_redirect_enabled        = true
  patterns_to_match             = ["/*"]
  supported_protocols           = ["Http", "Https"]
  link_to_default_domain        = true
}
