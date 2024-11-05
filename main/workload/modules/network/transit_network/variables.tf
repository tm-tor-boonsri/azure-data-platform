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
variable "fe_vnet" {
  type = string
}
variable "fe_service_subnet" {
  type = string
}
variable "fe_public_subnet" {
  type = string
}
variable "fe_private_subnet" {
  type = string
}
variable "tags" {
  type = map 
}