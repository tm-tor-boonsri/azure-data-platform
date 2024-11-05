output "storage_account_name" {
   value = azurerm_storage_account.resources.name
}
output "storage_account_id" {
  value = azurerm_storage_account.resources.id
}
output "storage_adls_staging_name" {
   value = azurerm_storage_data_lake_gen2_filesystem.staging.name
}
output "storage_adls_bronze_name" {
   value = azurerm_storage_data_lake_gen2_filesystem.bronze.name
}
output "storage_adls_gold_name" {
   value = azurerm_storage_data_lake_gen2_filesystem.gold.name
}
output "storage_raw_name" {
   value = azurerm_storage_container.raw.name
}