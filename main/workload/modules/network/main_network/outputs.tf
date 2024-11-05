output "main_vnet_name" {
  value = azurerm_virtual_network.main_vnet.name
}
output "main_vnet_id" {
  value = azurerm_virtual_network.main_vnet.id
}
output "main_public_subnet_name" {
  value = azurerm_subnet.main_public.name
}
output "main_privte_subnet_name" {
  value = azurerm_subnet.main_private.name
}
output "main_public_subnet_id" {
  value = azurerm_subnet.main_public.id
}
output "main_privte_subnet_id" {
  value = azurerm_subnet.main_private.id
}
output "main_service_subnet_name" {
  value = azurerm_subnet.main_private_link.name
}
output "main_service_subnet_id" {
  value = azurerm_subnet.main_private_link.id
}
output "main_public_subnet_nsg_aid" {
  value = azurerm_subnet_network_security_group_association.main_public.id
}
output "main_private_subnet_nsg_aid" {
  value = azurerm_subnet_network_security_group_association.main_private.id
}
