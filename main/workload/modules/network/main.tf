module "main_vnet" {
    source = "./main_network"
    rg_resources_name                         = var.rg_resources_name
    rg_resources_location                     = var.rg_resources_location
    resource_prefix                           = var.resource_prefix
    be_vnet                                   = var.be_vnet
    be_service_subnet                         = var.be_service_subnet
    be_public_subnet                          = var.be_public_subnet        
    be_private_subnet                         = var.be_private_subnet
    tags                                      = var.tags
}

module "transit_vnet" {
    source = "./transit_network"
    rg_resources_name                         = var.rg_resources_name
    rg_transit_name                           = var.rg_transit_name
    rg_resources_location                     = var.rg_resources_location
    resource_prefix                           = var.resource_prefix
    fe_vnet                                   = var.fe_vnet
    fe_service_subnet                         = var.fe_service_subnet
    fe_public_subnet                          = var.fe_public_subnet        
    fe_private_subnet                         = var.fe_private_subnet
    tags                                      = var.tags
}
