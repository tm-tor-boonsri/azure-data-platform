output "backend_vnet_name" {
  value = azurerm_virtual_network.backend.name
}

output "backend_devops_subnet_id" {
  value = azurerm_subnet.devops.id
}

output "backend_devops_subnet_name" {
  value = azurerm_subnet.devops.name
}