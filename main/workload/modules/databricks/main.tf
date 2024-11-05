resource "azurerm_databricks_workspace" "main_workspace" {
  name                                  = "${var.resource_prefix}-dbx-main-workspace"
  resource_group_name                   = var.rg_resources_name
  location                              = var.rg_resources_location
  managed_resource_group_name           = "${var.rg_resources_name}-dbx-main-mgmt"
  sku                                   = "premium"
  network_security_group_rules_required = "NoAzureDatabricksRules"
  public_network_access_enabled         = false
  infrastructure_encryption_enabled     = true
  tags                                  = var.tags
 
  custom_parameters {
    no_public_ip                                         = true
    virtual_network_id                                   = var.main_vnet_id
    private_subnet_name                                  = var.main_private_subnet
    public_subnet_name                                   = var.main_public_subnet
    public_subnet_network_security_group_association_id  = var.main_public_subnet_nsg_aid
    private_subnet_network_security_group_association_id = var.main_private_subnet_nsg_aid
    storage_account_name                                 = "${var.resource_prefix_wo_hyphen}adbdbfssa"
  }
  lifecycle { ignore_changes = [tags] }
}

resource "azurerm_databricks_workspace" "transit_workspace" {
  name                                  = "${var.resource_prefix}-dbx-webauth-workspace"
  resource_group_name                   = var.rg_transit_name
  location                              = var.rg_resources_location
  managed_resource_group_name           = "${var.rg_transit_name}-dbx-webauth-mgmt"
  sku                                   = "premium"
  network_security_group_rules_required = "NoAzureDatabricksRules" 
  public_network_access_enabled         = false                   
  infrastructure_encryption_enabled     = true
  tags                                  = var.tags

  
  custom_parameters {
    no_public_ip                                         = true
    virtual_network_id                                   = var.transit_vnet_id
    private_subnet_name                                  = var.transit_private_subnet
    public_subnet_name                                   = var.transit_public_subnet
    public_subnet_network_security_group_association_id  = var.transit_public_subnet_nsg_aid
    private_subnet_network_security_group_association_id = var.transit_private_subnet_nsg_aid
    storage_account_name                                 = "${var.resource_prefix_wo_hyphen}adbauthdbfssa"
  }
  lifecycle { ignore_changes = [tags] }
  
  depends_on = [
    azurerm_databricks_workspace.main_workspace
  ]
}

resource "azurerm_databricks_access_connector" "dbx_connector" {
  name                = "${var.resource_prefix}-dbx-cnt"
  resource_group_name = var.rg_resources_name
  location            = var.rg_resources_location

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "dbx_storage_blob_data_contrib" {
  scope                = var.main_storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_databricks_access_connector.dbx_connector.identity[0].principal_id
}