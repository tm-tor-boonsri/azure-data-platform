variable "rg_resources_name" {
  type = string
}
variable "rg_transit_name" {
  type = string
}
variable "rg_resources_location" {
  type = string
}
variable "resource_prefix" {
  type = string
}

variable "transit_vnet_name" {
  type = string
}
variable "testvm_subnet" {
  type = string
}
variable "testvm_user" {
  type = string
}
variable "testvm_pwd" {
  type = string
}

variable "tags" {
  type = map
}