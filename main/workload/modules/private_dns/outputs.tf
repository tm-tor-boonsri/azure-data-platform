output "main_dns_id" {
  value = azurerm_private_dns_zone.main_be.id
}
output "transit_dns_id" {
  value = azurerm_private_dns_zone.transit_auth.id
}