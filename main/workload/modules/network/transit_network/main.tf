locals {
  frontend = "fe"
}

resource "azurerm_virtual_network" "transit_vnet" {
  name                = "${var.resource_prefix}-fe-vnet"
  location            = var.rg_resources_location
  resource_group_name = var.rg_transit_name
  address_space       = [var.fe_vnet]
  tags                = var.tags
  
  lifecycle { ignore_changes = [tags] }
}

resource "azurerm_network_security_group" "transit_sg" {
  name                = "${var.resource_prefix}-${local.frontend}-sg"
  location            = var.rg_resources_location
  resource_group_name = var.rg_transit_name
}

resource "azurerm_network_security_rule" "transit_nsgr_aad" {
  name                        = "${var.resource_prefix}-${local.frontend}-nsgr-aad"
  priority                    = 200
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "AzureActiveDirectory"
  resource_group_name         = var.rg_transit_name
  network_security_group_name = azurerm_network_security_group.transit_sg.name
}

resource "azurerm_network_security_rule" "transit_nsgr_fd" {
  name                        = "${var.resource_prefix}-${local.frontend}-nsgr-fd"
  priority                    = 201
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "AzureFrontDoor.Frontend"
  resource_group_name         = var.rg_transit_name
  network_security_group_name = azurerm_network_security_group.transit_sg.name
}
resource "azurerm_subnet" "transit_public" {
  name                 = "${var.resource_prefix}-${local.frontend}-public-zone"
  resource_group_name  = var.rg_transit_name
  virtual_network_name = azurerm_virtual_network.transit_vnet.name
  address_prefixes     = [var.fe_public_subnet]

  delegation {
    name = "databricks"
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"]
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "transit_public" {
  subnet_id                 = azurerm_subnet.transit_public.id
  network_security_group_id = azurerm_network_security_group.transit_sg.id
}

resource "azurerm_subnet" "transit_private" {
  name                 = "${var.resource_prefix}-${local.frontend}-private-zone"
  resource_group_name  = var.rg_transit_name
  virtual_network_name = azurerm_virtual_network.transit_vnet.name
  address_prefixes     = [var.fe_private_subnet]

  private_endpoint_network_policies = "Enabled"

  delegation {
    name = "databricks"
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"]
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "transit_private" {
  subnet_id                 = azurerm_subnet.transit_private.id
  network_security_group_id = azurerm_network_security_group.transit_sg.id
}

resource "azurerm_subnet" "transit_plsubnet" {
  name                              = "${var.resource_prefix}-${local.frontend}-service-zone"
  resource_group_name               = var.rg_transit_name
  virtual_network_name              = azurerm_virtual_network.transit_vnet.name
  address_prefixes                  = [var.fe_service_subnet]
  private_endpoint_network_policies = "Enabled"
}