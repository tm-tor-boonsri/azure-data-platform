variable "subscription_name" {
  type = string
}
variable "subscription_id" {
  type = string
}
variable "tenant_id" {
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
variable "rg_resources_name" {
  type    = string
}
variable "rg_transit_name" {
  type    = string
}
variable "rg_resources_location" {
  type = string
}
variable "rg_resources_location_short" {
  type    = string
}

/*
Networking
*/
variable "be_vnet" {
  type = string
}
variable "be_service_subnet" {
  type = string
}
variable "be_public_subnet" {
  type = string
}
variable "be_private_subnet" {
  type = string
}
variable "be_shir_subnet" {
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
variable "fe_vm_subnet" {
  type = string
}

/*
VM
*/
variable "testvm_user" {
  type = string
}
variable "testvm_pwd" {
  type = string
}