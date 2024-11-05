/*
/ back-end
*/
resource "azurerm_private_endpoint" "main_be_private_link" {
  name                = "${var.resource_prefix}-be-dbx-pe" 
  location            = var.rg_resources_location
  resource_group_name = var.rg_resources_name
  subnet_id           = var.main_service_subnet_id

  private_service_connection {
    name                           = "${var.resource_prefix}-be-ple" 
    private_connection_resource_id = var.main_databricks_workspace_id
    is_manual_connection           = false
    subresource_names              = ["databricks_ui_api"]
  }

  private_dns_zone_group {
    name                 = "${var.resource_prefix}-be-private-dns-zone"
    private_dns_zone_ids = [var.main_dns_id]
  }

  lifecycle {
    ignore_changes = [private_dns_zone_group]
  }
}

/*
/ front-end
*/
resource "azurerm_private_endpoint" "main_fe_private_link" {
  name                = "${var.resource_prefix}-fe-dbx-pe"
  location            = var.rg_resources_location
  resource_group_name = var.rg_transit_name
  subnet_id           = var.transit_service_subnet_id

  private_service_connection {
    name                           = "${var.resource_prefix}-fe-ple" 
    private_connection_resource_id = var.main_databricks_workspace_id
    is_manual_connection           = false
    subresource_names              = ["databricks_ui_api"]
  }

  private_dns_zone_group {
    name                 =  "${var.resource_prefix}-fe-private-dns-zone-uiapi"
    private_dns_zone_ids = [var.transit_auth_dns_id]
  }

  depends_on = [
    azurerm_private_endpoint.main_be_private_link,
  ]
}

/*
/ web_auth
*/
resource "azurerm_private_endpoint" "transit_auth_private_link" {
  name                = "${var.resource_prefix}-fe-webauth-pe"
  location            = var.rg_resources_location
  resource_group_name = var.rg_transit_name
  subnet_id           = var.transit_service_subnet_id

  private_service_connection {
    name                           = "${var.resource_prefix}-webauth-ple"
    private_connection_resource_id = var.transit_databricks_workspace_id
    is_manual_connection           = false
    subresource_names              = ["browser_authentication"]
  }

  private_dns_zone_group {
    name                 =  "${var.resource_prefix}-fe-private-dns-zone-auth"
    private_dns_zone_ids = [var.transit_auth_dns_id]
  }

  lifecycle {
    ignore_changes = [private_dns_zone_group]
  }

  depends_on = [
    azurerm_private_endpoint.main_fe_private_link,
  ]
}

