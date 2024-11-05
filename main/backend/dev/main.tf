provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "backend" {
  name = var.rg_backend_name
}

data "azurerm_storage_account" "backend" {
  name = var.backend_storage_account
  resource_group_name = var.rg_backend_name
}

locals {
  resource_prefix             = "${var.department}${var.country_code}${var.env}-${var.project_name}"
}

module "network" {
  source = "../modules/network"
  rg_backend_name               = var.rg_backend_name
  rg_backend_loc                = var.rg_backend_loc
  resource_prefix               = local.resource_prefix
  vnet_main_address_space       = var.vnet_main_address_space
  snet_devops_address_prefix    = var.snet_devops_adddress
}

module "storage" {
  source = "../modules/storage"
  user_ip_address               = var.user_ip_address
  backend_devops_subnet_id      = module.network.backend_devops_subnet_id
  backend_storage_account_id    = data.azurerm_storage_account.backend.id

  depends_on = [ module.network ]
}

module "devops_runner" {
  source = "../modules/devops_runner"
  rg_backend_name                   = var.rg_backend_name
  rg_backend_loc                    = var.rg_backend_loc
  resource_prefix                   = local.resource_prefix
  devops_pat                        = var.devops_pat
  devops_org_url                    = var.devops_org_url
  devops_sh_pool                    = var.devops_sh_pool
  vm_admin_username                 = var.vm_admin_username
  vm_admin_password                 = var.vm_admin_password
  vm_devops_size                    = var.vm_devops_size
  vm_devops_ip                      = var.vm_devops_ip
  backend_devops_subnet_id          = module.network.backend_devops_subnet_id
  backend_storage_account_id        = data.azurerm_storage_account.backend.id

  depends_on = [ module.network, module.storage ]
}