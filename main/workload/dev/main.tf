provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "backend" {
  name = var.rg_resources_name
}

locals {
  resource_prefix           = "${var.department}${var.country_code}${var.env}-${var.project_name}"
  resource_prefix_wo_hyphen = "${var.department}${var.country_code}${var.env}${var.project_name}"

  devops_vnet               = "devops-vnet"
  devops_subnet             = "devops-subnet"

  tags = {
    project_name            = "${var.project_name}"
    project_full_name       = "${local.resource_prefix}"
    env                     = "${var.env}"
    created_at              = formatdate("YYYY-MM-DD", timestamp())
    created_by              = "Terraform"
  }
}

data "azurerm_subnet" "devops_subnet" {
  name                 = "${local.devops_subnet}"
  virtual_network_name = "${local.devops_vnet}"
  resource_group_name  = var.rg_backend_name
}

module "storage" {
  source                                    = "../modules/storage"
  rg_resources_name                         = var.rg_resources_name
  rg_resources_loc                          = var.rg_resources_location
  resource_prefix                           = local.resource_prefix
  resource_prefix_wo_hyphen                 = local.resource_prefix_wo_hyphen
  backend_devops_subnet_id                  = data.azurerm_subnet.devops_subnet.id 
  
  tags                                      = local.tags
}

module "keyvault" {
  source                                    = "../modules/keyvault"
  rg_resources_name                         = var.rg_resources_name
  rg_resources_loc                          = var.rg_resources_location
  resource_prefix                           = local.resource_prefix
  tags                                      = local.tags
}

module "data_factory" {
  source = "../modules/data_factory"
  rg_resources_name                         = var.rg_resources_name
  rg_resources_loc                          = var.rg_resources_location
  resource_prefix                           = local.resource_prefix
  storage_account_name                      = module.storage.storage_account_name
  keyvault_id                               = module.keyvault.azurerm_key_vault_id

  tags                                      = local.tags

  depends_on = [ module.storage, module.keyvault ]
}

module "network" {
  source = "../modules/network"
  rg_resources_name                         = var.rg_resources_name
  rg_resources_location                     = var.rg_resources_location
  resource_prefix                           = local.resource_prefix
  be_vnet                                   = var.be_vnet
  be_service_subnet                         = var.be_service_subnet
  be_public_subnet                          = var.be_public_subnet        
  be_private_subnet                         = var.be_private_subnet
  fe_vnet                                   = var.fe_vnet
  fe_service_subnet                         = var.fe_service_subnet
  fe_public_subnet                          = var.fe_public_subnet        
  fe_private_subnet                         = var.fe_private_subnet
  tags                                      = local.tags
  rg_transit_name                           = var.rg_transit_name

}

module "databricks" {
  source                    = "../modules/databricks"
  rg_resources_name                         = var.rg_resources_name
  rg_resources_location                     = var.rg_resources_location
  resource_prefix                           = local.resource_prefix
  resource_prefix_wo_hyphen                 = local.resource_prefix_wo_hyphen
  rg_transit_name                           = var.rg_transit_name
  
  main_vnet_id                              = module.network.main_vnet_id
  main_service_subnet                       = module.network.main_service_subnet_name
  main_public_subnet                        = module.network.main_public_subnet_name
  main_private_subnet                       = module.network.main_privte_subnet_name
  main_public_subnet_id                     = module.network.main_public_subnet_id
  main_private_subnet_id                    = module.network.main_privte_subnet_id
  main_public_subnet_nsg_aid                = module.network.main_public_subnet_nsg_aid
  main_private_subnet_nsg_aid               = module.network.main_private_subnet_nsg_aid

  transit_vnet_id                           = module.network.transit_vnet_id
  transit_service_subnet                    = module.network.transit_service_subnet_name
  transit_public_subnet                     = module.network.transit_public_subnet_name
  transit_private_subnet                    = module.network.transit_private_subnet_name
  transit_public_subnet_nsg_aid             = module.network.transit_public_subnet_nsg_aid
  transit_private_subnet_nsg_aid            = module.network.transit_private_subnet_nsg_aid

  main_storage_account_id                   = module.storage.storage_account_id

  tags                                      = local.tags
  depends_on = [ module.network ]  
}

module "private_dns" {
  source                    = "../modules/private_dns"
  rg_resources_name                         = var.rg_resources_name
  rg_resources_location                     = var.rg_resources_location
  resource_prefix                           = local.resource_prefix
  rg_transit_name                           = var.rg_transit_name

  main_vnet_id                              = module.network.main_vnet_id
  transit_vnet_id                           = module.network.transit_vnet_id
  
  tags                                      = local.tags
  depends_on = [ module.network, module.databricks] 
}


module "private_endpoint" {
  source                    = "../modules/private_endpoint"
  rg_resources_name                         = var.rg_resources_name
  rg_resources_location                     = var.rg_resources_location
  resource_prefix                           = local.resource_prefix
  rg_transit_name                           = var.rg_transit_name

  main_service_subnet_id                    = module.network.main_service_subnet_id
  transit_service_subnet_id                 = module.network.transit_service_subnet_id

  main_databricks_workspace_id              = module.databricks.main_databricks_workspace_id
  transit_databricks_workspace_id           = module.databricks.transit_databricks_workspace_id

  main_dns_id                               = module.private_dns.main_dns_id
  transit_auth_dns_id                       = module.private_dns.transit_dns_id

  tags                                      = local.tags
  depends_on = [ module.network, module.databricks, module.private_dns] 
}

# module "vm" {
#   source                                    = "../modules/vm"
#   rg_resources_name                         = var.rg_resources_name
#   rg_resources_location                     = var.rg_resources_location
#   resource_prefix                           = local.resource_prefix
#   rg_transit_name                           = var.rg_transit_name

#   transit_vnet_name                         = module.network.transit_vnet_name
#   testvm_subnet                             = var.fe_vm_subnet

#   testvm_user                               = var.testvm_user
#   testvm_pwd                                = var.testvm_pwd
#   tags                                      = local.tags 
# }