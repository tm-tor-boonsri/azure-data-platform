resource "azurerm_virtual_network" "backend" {
  name                = "${var.resource_prefix}-be-vnet"
  location            = var.rg_backend_loc
  resource_group_name = var.rg_backend_name
  address_space       = [var.vnet_main_address_space]
}

resource "azurerm_subnet" "devops" {
  name                 = "${var.resource_prefix}-devops-subnet"
  resource_group_name  = var.rg_backend_name
  virtual_network_name = azurerm_virtual_network.backend.name
  address_prefixes     = [var.snet_devops_address_prefix]
  service_endpoints    = ["Microsoft.Storage"]
}

resource "azurerm_network_security_group" "devops" {
  name                = "${var.resource_prefix}-devops-nsg"
  location            = var.rg_backend_loc
  resource_group_name = var.rg_backend_name

  security_rule {
    name                       = "${var.resource_prefix}-devops-nsgsr-1"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "devops_nsg_assoc" {
  subnet_id                 = azurerm_subnet.devops.id
  network_security_group_id = azurerm_network_security_group.devops.id
}
