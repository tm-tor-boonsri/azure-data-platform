output "storage_account_id" {
   value = azurerm_storage_account_network_rules.backend.storage_account_id
}

output "storage_account_network_rules" {
   value = azurerm_storage_account_network_rules.backend.ip_rules
}