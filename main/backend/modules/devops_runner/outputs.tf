output "backend_devops_vm_runner_name" {
  value = azurerm_linux_virtual_machine.devops.name
}

output "backend_devops_vm_runner_admin_username" {
  value = azurerm_linux_virtual_machine.devops.admin_username
}

output "backend_devops_vm_runner_admin_password" {
  value = azurerm_linux_virtual_machine.devops.admin_password
  sensitive = true
}

output "backend_devops_vm_runner_size" {
  value = azurerm_linux_virtual_machine.devops.size
}