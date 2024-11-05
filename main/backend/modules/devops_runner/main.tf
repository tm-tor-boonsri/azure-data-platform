locals {
  data_inputs = {
    devops_pat        = var.devops_pat
    devops_org_url    = var.devops_org_url
    devops_pool_name  = var.devops_sh_pool
    devops_agent_name = "${var.resource_prefix}-devops-vm-agent"
  }
}

resource "azurerm_linux_virtual_machine" "devops" {
  name                  = "${var.resource_prefix}-devops-vm"
  location              = var.rg_backend_loc
  resource_group_name   = var.rg_backend_name
  size                  = var.vm_devops_size
  admin_username        = var.vm_admin_username
  admin_password        = var.vm_admin_password
  
  network_interface_ids = [
    azurerm_network_interface.devops.id
  ]

  disable_password_authentication = false
  encryption_at_host_enabled      = true

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {  
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }

  user_data = base64encode(templatefile("${path.module}/configure_agent.tftpl", local.data_inputs))
}

resource "azurerm_network_interface" "devops" {
  name = "${var.resource_prefix}-devops-vm-nic"
  location              = var.rg_backend_loc
  resource_group_name   = var.rg_backend_name

  ip_configuration {
    name                          = "${var.resource_prefix}-devops-vm-ip"
    subnet_id                     = var.backend_devops_subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.vm_devops_ip
  }
}

resource "azurerm_role_assignment" "devops_storage_blob_data_contrib" {
  scope                = var.backend_storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_linux_virtual_machine.devops.identity[0].principal_id
}
