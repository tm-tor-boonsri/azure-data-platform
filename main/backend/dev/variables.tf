variable "subscription_name" {
  type = string
}
variable "subscription_id" {
  type = string
}

/*
Client Convension
*/
variable "department" {
  type = string
}
variable "country_code" {
  type = string
}
variable "project_name" {
  type    = string
}
variable "project_name_full" {
  type = string
}

variable "env" {
  type    = string
}

/*
Resources
*/
variable "rg_backend_name" {
  type    = string
}
variable "rg_backend_loc" {
  type = string
}
variable "rg_backend_loc_short" {
  type    = string
}
variable "backend_storage_account" {
  type = string
}

/*
Resources
DevOps
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
variable "user_ip_address" {
  type = string
}

/*
Resources
DevOps - Runner
*/
variable "vnet_main_address_space" {
  type    = string
}
variable "snet_devops_adddress" {
  type    = string
}
variable "vm_admin_username" {
  type = string
}
variable "vm_admin_password" {
  type = string
}
variable "vm_devops_size" {
  type    = string
}
variable "vm_devops_ip" {
  type    = string
}