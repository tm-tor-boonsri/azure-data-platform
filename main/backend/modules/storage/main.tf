resource "azurerm_storage_account_network_rules" "backend" {
  storage_account_id = var.backend_storage_account_id

  default_action             = "Deny"
  virtual_network_subnet_ids = [var.backend_devops_subnet_id]
  ip_rules                   = [var.user_ip_address]
}
