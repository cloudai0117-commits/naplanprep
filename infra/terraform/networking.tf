# ─── Virtual Network ──────────────────────────────────────────────────────────

resource "azurerm_virtual_network" "main" {
  name                = local.vnet_name
  resource_group_name = azurerm_resource_group.network.name
  location            = var.location
  address_space       = ["10.0.0.0/16"]
  tags                = local.tags
}

# ─── NSGs ─────────────────────────────────────────────────────────────────────

resource "azurerm_network_security_group" "apps" {
  name                = local.nsg_apps_name
  resource_group_name = azurerm_resource_group.network.name
  location            = var.location
  tags                = local.tags

  # Container Apps Environment manages its own internal routing; restrict external ingress.
  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "AzureFrontDoor.Backend"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowAzureMonitor"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "AzureMonitor"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowContainerAppsInfra"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_ranges    = ["5554", "30000-32767"]
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "pe" {
  name                = local.nsg_pe_name
  resource_group_name = azurerm_resource_group.network.name
  location            = var.location
  tags                = local.tags

  # Private endpoints subnet — only allow traffic from the apps subnet.
  security_rule {
    name                       = "AllowFromAppsSubnet"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.0.1.0/24"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# ─── Subnets ──────────────────────────────────────────────────────────────────

# Container Apps subnet — must be /23 or larger for workload profiles;
# /24 is adequate for Consumption plan (which we use initially).
# Delegation to Microsoft.App/environments is REQUIRED for VNet integration.
resource "azurerm_subnet" "apps" {
  name                 = local.snet_apps_name
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]

  delegation {
    name = "container-apps-delegation"
    service_delegation {
      name    = "Microsoft.App/environments"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

# Private endpoints subnet — private endpoint NICs live here.
# NSG on this subnet allows only traffic from the apps subnet.
resource "azurerm_subnet" "pe" {
  name                 = local.snet_pe_name
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]

  # Private endpoint network policies must be disabled for PE subnet.
  private_endpoint_network_policies_enabled = false
}

# ─── NSG Associations ─────────────────────────────────────────────────────────

resource "azurerm_subnet_network_security_group_association" "apps" {
  subnet_id                 = azurerm_subnet.apps.id
  network_security_group_id = azurerm_network_security_group.apps.id
}

resource "azurerm_subnet_network_security_group_association" "pe" {
  subnet_id                 = azurerm_subnet.pe.id
  network_security_group_id = azurerm_network_security_group.pe.id
}
