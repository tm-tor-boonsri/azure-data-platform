/*
/ be and fe
*/
resource "azurerm_private_dns_zone" "main_be" {
  name                = "privatelink.azuredatabricks.net"
  resource_group_name = var.rg_resources_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "maindnszonevnetlink" {
  name                  = "mainspokevnetconnection"
  resource_group_name   = var.rg_resources_name
  private_dns_zone_name = azurerm_private_dns_zone.main_be.name
  virtual_network_id    = var.main_vnet_id
  registration_enabled  = true
}

/*
/ web_auth
*/
resource "azurerm_private_dns_zone" "transit_auth" {
  name                = "privatelink.azuredatabricks.net"
  resource_group_name = var.rg_transit_name

  depends_on = [ azurerm_private_dns_zone.main_be ]
}

resource "azurerm_private_dns_zone_virtual_network_link" "transitdnszonevnetlink" {
  name                  = "transitspokevnetconnection"
  resource_group_name   = var.rg_transit_name
  private_dns_zone_name = azurerm_private_dns_zone.transit_auth.name
  virtual_network_id    = var.transit_vnet_id
}