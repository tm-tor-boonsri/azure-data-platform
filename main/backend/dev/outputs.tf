output "backend_resource_group_name" {
  value = var.rg_backend_name
}

output "backend_vnet_name" {
  value = module.network.backend_vnet_name
}

output "backend_devops_subnet_name" {
  value = module.network.backend_devops_subnet_name
}

output "storage_account_id" {
  value = module.storage.storage_account_id
}

output "backend_devops_vm_runner_name" {
  value = module.devops_runner.backend_devops_vm_runner_name
}

output "backend_devops_vm_runner_admin_username" {
  value = module.devops_runner.backend_devops_vm_runner_admin_username
}

output "backend_devops_vm_runner_admin_password" {
  value = module.devops_runner.backend_devops_vm_runner_admin_password
  sensitive = true
}

output "backend_devops_vm_runner_size" {
  value = module.devops_runner.backend_devops_vm_runner_size
}