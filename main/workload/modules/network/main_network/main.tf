locals {
  backend = "be"
}

resource "azurerm_virtual_network" "main_vnet" {
  name                = "${var.resource_prefix}-be-vnet"
  location            = var.rg_resources_location
  resource_group_name = var.rg_resources_name
  address_space       = [var.be_vnet]
  tags                = var.tags
  
  lifecycle { ignore_changes = [tags] }
}

resource "azurerm_network_security_group" "main_sg" {
  name                = "${var.resource_prefix}-${local.backend}-sg"
  location            = var.rg_resources_location
  resource_group_name = var.rg_resources_name
}

resource "azurerm_network_security_rule" "main_nsg_aad" {
  name                        = "${var.resource_prefix}-${local.backend}-nsgr-ad"
  priority                    = 200
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "AzureActiveDirectory"
  resource_group_name         = var.rg_resources_name
  network_security_group_name = azurerm_network_security_group.main_sg.name
}

resource "azurerm_network_security_rule" "main_nsgr_fd" {
  name                        = "${var.resource_prefix}-${local.backend}-nsgr-fd"
  priority                    = 201
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "AzureFrontDoor.Frontend"
  resource_group_name         = var.rg_resources_name
  network_security_group_name = azurerm_network_security_group.main_sg.name
}

resource "azurerm_subnet" "main_public" {
  name                 = "${var.resource_prefix}-${local.backend}-public-zone"
  resource_group_name  = var.rg_resources_name
  virtual_network_name = azurerm_virtual_network.main_vnet.name
  address_prefixes     = [var.be_public_subnet]
  service_endpoints    = ["Microsoft.Storage"]

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

resource "azurerm_subnet_network_security_group_association" "main_public" {
  subnet_id                 = azurerm_subnet.main_public.id
  network_security_group_id = azurerm_network_security_group.main_sg.id
}

resource "azurerm_subnet" "main_private" {
  name                 = "${var.resource_prefix}-${local.backend}-private-zone"
  resource_group_name  = var.rg_resources_name
  virtual_network_name = azurerm_virtual_network.main_vnet.name
  address_prefixes     = [var.be_private_subnet]
  service_endpoints    = ["Microsoft.Storage"]

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

resource "azurerm_subnet_network_security_group_association" "main_private" {
  subnet_id                 = azurerm_subnet.main_private.id
  network_security_group_id = azurerm_network_security_group.main_sg.id
}

resource "azurerm_subnet" "main_private_link" {
  name                              = "${var.resource_prefix}-${local.backend}-service-zone"
  resource_group_name               = var.rg_resources_name
  virtual_network_name              = azurerm_virtual_network.main_vnet.name
  address_prefixes                  = [var.be_service_subnet]
  private_endpoint_network_policies = "Enabled"
}