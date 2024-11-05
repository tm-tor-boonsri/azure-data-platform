locals {
  transit_workspace_prefix = "fe-vm"
}

resource "azurerm_subnet" "transit_vm_subnet" {
  name                 = "${var.resource_prefix}-${local.transit_workspace_prefix}-subnet"
  resource_group_name  = var.rg_transit_name
  virtual_network_name = var.transit_vnet_name
  address_prefixes     = [var.testvm_subnet]
}

resource "azurerm_public_ip" "transit_vm_pub_ip" {
  name                = "${var.resource_prefix}-${local.transit_workspace_prefix}-pubip"
  location            = var.rg_resources_location
  resource_group_name = var.rg_transit_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "transit_vm_nic" {
  name                = "${var.resource_prefix}-${local.transit_workspace_prefix}-nic"
  location            = var.rg_resources_location
  resource_group_name = var.rg_transit_name

  ip_configuration {
    name                          = "${var.resource_prefix}-${local.transit_workspace_prefix}-ipconfig"
    subnet_id                     = azurerm_subnet.transit_vm_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.transit_vm_pub_ip.id
  }
}

resource "azurerm_network_security_group" "transit_vm_nsg" {
  name                = "${var.resource_prefix}-${local.transit_workspace_prefix}-sg"
  location            = var.rg_resources_location
  resource_group_name = var.rg_transit_name
  tags                = var.tags
}

resource "azurerm_network_interface_security_group_association" "testvmnsgassoc" {
  network_interface_id      = azurerm_network_interface.transit_vm_nic.id
  network_security_group_id = azurerm_network_security_group.transit_vm_nsg.id
}

resource "azurerm_network_security_rule" "transit_vm_nsgr1" {
  name                        = "RDP"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefixes     = ["*"] # your IP
  destination_address_prefix  = "VirtualNetwork"
  network_security_group_name = azurerm_network_security_group.transit_vm_nsg.name
  resource_group_name         = var.rg_transit_name
}

resource "azurerm_windows_virtual_machine" "transit_vm" {
  name                = "${var.resource_prefix}-vm"
  resource_group_name = var.rg_transit_name
  location            = var.rg_resources_location
  size                = "Standard_D2_v4"
  admin_username      = var.testvm_user
  admin_password      = var.testvm_pwd

  network_interface_ids = [
    azurerm_network_interface.transit_vm_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "windows-10"
    sku       = "19h2-pro-g2"
    version   = "latest"
  }
}