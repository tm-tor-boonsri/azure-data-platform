variable "rg_backend_name" {
  type = string
}
variable "rg_backend_loc" {
  type = string
}
variable "resource_prefix" {
  type = string
}

/*
Resources
*/
variable "devops_pat" {
  type = string
}
variable "devops_org_url" {
  type = string
}
variable "devops_sh_pool" {
  type = string
}
variable "vm_admin_username" {
  type = string
}
variable "vm_admin_password" {
  type = string
}
variable "vm_devops_size" {
  type = string
}
variable "vm_devops_ip" {
  type = string
}
variable "backend_devops_subnet_id" {
  type = string
}
variable "backend_storage_account_id" {
  type = string
}