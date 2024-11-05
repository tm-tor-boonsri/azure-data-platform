data "azurerm_storage_account" "this" {
  name                = var.storage_account_name
  resource_group_name = var.rg_resources_name
}

resource "azurerm_data_factory" "this" {
  name                            = "${var.resource_prefix}-df"
  location                        = var.rg_resources_loc
  resource_group_name             = var.rg_resources_name
  managed_virtual_network_enabled = true
  public_network_enabled          = false
  tags                            = var.tags 

  identity {
    type = "SystemAssigned"
  }

  lifecycle { ignore_changes = [tags, vsts_configuration] }
}

/*
* consider to remove components and move to create in adf console 
*/
resource "azurerm_data_factory_managed_private_endpoint" "datafactory_adls_pe" {
  name               = "${var.resource_prefix}-df-adls-pe"
  data_factory_id    = azurerm_data_factory.this.id
  target_resource_id = data.azurerm_storage_account.this.id
  subresource_name   = "dfs"

  lifecycle { ignore_changes = [target_resource_id] }
}

resource "azurerm_data_factory_managed_private_endpoint" "datafactory_blob_pe" {
  name               = "${var.resource_prefix}-df-blob-pe"
  data_factory_id    = azurerm_data_factory.this.id
  target_resource_id = data.azurerm_storage_account.this.id
  subresource_name   = "blob"

  lifecycle { ignore_changes = [target_resource_id] }

  depends_on = [ azurerm_data_factory_managed_private_endpoint.datafactory_adls_pe ]
}

resource "azurerm_data_factory_integration_runtime_azure" "this" {
  name                = "${var.resource_prefix}-df-ir"
  data_factory_id     = azurerm_data_factory.this.id
  location            = azurerm_data_factory.this.location
  compute_type        = "General"
  core_count          = 8
  time_to_live_min    = 0
  virtual_network_enabled = true
}

resource "azurerm_data_factory_linked_service_data_lake_storage_gen2" "adf_adls_pl" {
  name                     = "${var.resource_prefix}-df-adls-ls"
  url                      = "https://${data.azurerm_storage_account.this.name}.dfs.core.windows.net/"
  data_factory_id          = azurerm_data_factory.this.id
  integration_runtime_name = azurerm_data_factory_integration_runtime_azure.this.name
  storage_account_key      = data.azurerm_storage_account.this.primary_access_key

  lifecycle { ignore_changes = [storage_account_key] }
}

resource "azurerm_data_factory_linked_service_key_vault" "adf_kv_pl" {
  name            = "${var.resource_prefix}-df-kv-ls"
  data_factory_id = azurerm_data_factory.this.id
  key_vault_id    = var.keyvault_id
}

resource "azurerm_role_assignment" "adf_kv_role_reader" {
  scope                = var.keyvault_id
  role_definition_name = "Key Vault Reader"
  principal_id         = azurerm_data_factory.this.identity[0].principal_id
}

resource "azurerm_role_assignment" "adf_kv_role_secret_user" {
  scope                = var.keyvault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_data_factory.this.identity[0].principal_id
}