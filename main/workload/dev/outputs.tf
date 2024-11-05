output "storage_account_name" {
  value = module.storage.storage_account_name
}
output "storage_adls_staging_name" {
  value = module.storage.storage_adls_staging_name
}
output "storage_adls_bronze_name" {
  value = module.storage.storage_adls_bronze_name
}
output "storage_adls_gold_name" {
  value = module.storage.storage_adls_gold_name
}
output "storage_container_raw_name" {
  value = module.storage.storage_raw_name
}
output "datafactory_name" {
  value = module.data_factory.azurerm_data_factory_name
}
output "data_factory_adls_link_service_name" {
  value = module.data_factory.azurerm_data_factory_adls_link_service_name
}
output "keyvault_name" {
  value = module.keyvault.azurerm_key_vault_name
}
output "vnet_main_name" {
  value = module.network.main_vnet_name
}
output "vnet_transit_name" {
  value = module.network.transit_vnet_name
}
output "main_public_subnet_name" {
  value = module.network.main_public_subnet_name
}
output "main_privte_subnet_name" {
  value = module.network.main_privte_subnet_name
}
output "main_service_subnet_name" {
  value = module.network.main_service_subnet_name
}
output "main_databricks_workspace_name" {
  value = module.databricks.main_databricks_workspace_name
}
output "transit_databricks_workspace_name" {
  value = module.databricks.transit_databricks_workspace_name
}