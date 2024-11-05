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

variable "main_vnet_id" {
  type = string
}
variable "transit_vnet_id" {
  type = string
}

variable "tags" {
  type = map
}