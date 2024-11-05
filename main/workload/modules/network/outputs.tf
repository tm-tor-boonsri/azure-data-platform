/*
main
*/
output "main_vnet_name" {
  value = module.main_vnet.main_vnet_name
}
output "main_vnet_id" {
  value = module.main_vnet.main_vnet_id
}
output "main_public_subnet_name" {
  value = module.main_vnet.main_public_subnet_name
}
output "main_privte_subnet_name" {
  value = module.main_vnet.main_privte_subnet_name
}
output "main_public_subnet_id" {
  value = module.main_vnet.main_public_subnet_id
}
output "main_privte_subnet_id" {
  value = module.main_vnet.main_privte_subnet_id
}
/*
service zone
*/
output "main_service_subnet_name" {
  value = module.main_vnet.main_service_subnet_name
}
output "main_service_subnet_id" {
  value = module.main_vnet.main_service_subnet_id
}
output "main_public_subnet_nsg_aid" {
  value = module.main_vnet.main_public_subnet_nsg_aid
}
output "main_private_subnet_nsg_aid" {
  value = module.main_vnet.main_private_subnet_nsg_aid
}

/*
transit
*/
output "transit_vnet_name" {
  value = module.transit_vnet.transit_vnet_name
}
output "transit_vnet_id" {
  value = module.transit_vnet.transit_vnet_id
}
output "transit_public_subnet_name" {
  value = module.transit_vnet.transit_public_subnet_name
}
output "transit_private_subnet_name" {
  value = module.transit_vnet.transit_private_subnet_name
}
/*
service zone
*/
output "transit_service_subnet_name" {
  value = module.transit_vnet.transit_service_subnet_name
}
output "transit_service_subnet_id" {
  value = module.transit_vnet.transit_service_subnet_id
}
output "transit_public_subnet_nsg_aid" {
  value = module.transit_vnet.transit_public_subnet_nsg_aid
}
output "transit_private_subnet_nsg_aid" {
  value = module.transit_vnet.transit_private_subnet_nsg_aid
}