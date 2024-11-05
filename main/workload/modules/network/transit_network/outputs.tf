output "transit_vnet_name" {
  value = azurerm_virtual_network.transit_vnet.name
}
output "transit_vnet_id" {
  value = azurerm_virtual_network.transit_vnet.id
}
output "transit_public_subnet_name" {
  value = azurerm_subnet.transit_public.name
}
output "transit_private_subnet_name" {
  value = azurerm_subnet.transit_private.name
}
output "transit_service_subnet_name" {
  value = azurerm_subnet.transit_plsubnet.name
}
output "transit_service_subnet_id" {
  value = azurerm_subnet.transit_plsubnet.id
}
output "transit_public_subnet_nsg_aid" {
  value = azurerm_subnet_network_security_group_association.transit_public.id
}
output "transit_private_subnet_nsg_aid" {
  value = azurerm_subnet_network_security_group_association.transit_private.id
}