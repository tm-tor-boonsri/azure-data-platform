data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "main" {
  name                        = "${var.resource_prefix}-kv"
  location                    = var.rg_resources_loc
  resource_group_name         = var.rg_resources_name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  enable_rbac_authorization   = true
  enabled_for_disk_encryption = true
  soft_delete_retention_days  = 7
}