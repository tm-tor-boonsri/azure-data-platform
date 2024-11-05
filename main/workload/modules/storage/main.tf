resource "azurerm_storage_account" "resources" {
  name                          = "${var.resource_prefix_wo_hyphen}rssa"
  resource_group_name           = var.rg_resources_name
  location                      = var.rg_resources_loc
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  account_kind                  = "StorageV2"
  is_hns_enabled                = "true"
  allowed_copy_scope            = "PrivateLink"
  tags                          = var.tags

  blob_properties {
    delete_retention_policy {
      days = 30
    }
    container_delete_retention_policy {
    days = 30
    }
  }

  lifecycle { ignore_changes = [tags] }
}

resource "azurerm_storage_data_lake_gen2_filesystem" "staging" {
  name               = "${var.resource_prefix}-staging-adls"
  storage_account_id = azurerm_storage_account.resources.id
}

resource "azurerm_storage_data_lake_gen2_filesystem" "bronze" {
  name               = "${var.resource_prefix}-bronze-adls"
  storage_account_id = azurerm_storage_account.resources.id
}

resource "azurerm_storage_data_lake_gen2_filesystem" "gold" {
  name               = "${var.resource_prefix}-gold-adls"
  storage_account_id = azurerm_storage_account.resources.id
}

resource "azurerm_storage_container" "raw" {
  name                  = "${var.resource_prefix}-raw-stct"
  storage_account_name  = azurerm_storage_account.resources.name
  container_access_type = "container"
}

# need to move to another part of tf to add backend_devops_subnet_id, adb_public_subnet_id, adb_private_subnet_id
# resource "azurerm_storage_account_network_rules" "devops_subnet_rule" {
#   storage_account_id         = azurerm_storage_account.resources.id
#   default_action             = "Deny"
#   virtual_network_subnet_ids = [var.backend_devops_subnet_id]
# }