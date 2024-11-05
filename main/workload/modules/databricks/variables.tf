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
variable "resource_prefix_wo_hyphen" {
  type = string
}
variable "tags" {
  type = map
}

variable "main_vnet_id" {
  type = string
}
variable "main_public_subnet" {
  type = string
}
variable "main_private_subnet" {
  type = string
}
variable "main_service_subnet" {
  type = string
}
variable "main_public_subnet_nsg_aid" {
  type = string
}
variable "main_private_subnet_nsg_aid" {
  type = string
}
variable "main_public_subnet_id" {
  type = string
}
variable "main_private_subnet_id" {
  type = string
}

variable "transit_vnet_id" {
  type = string
}
variable "transit_public_subnet" {
  type = string
}
variable "transit_private_subnet" {
  type = string
}
variable "transit_service_subnet" {
  type = string
}
variable "transit_public_subnet_nsg_aid" {
  type = string
}
variable "transit_private_subnet_nsg_aid" {
  type = string
}

variable "main_storage_account_id" {
  type = string
}
