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

variable "main_service_subnet_id" {
  type = string
}
variable "transit_service_subnet_id" {
  type = string
}

variable "main_databricks_workspace_id" {
  type = string
}
variable "transit_databricks_workspace_id" {
  type = string
}

variable "main_dns_id" {
  type = string
}
variable "transit_auth_dns_id" {
  type = string
}

variable "tags" {
  type = map
}
