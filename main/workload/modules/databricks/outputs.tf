output "main_databricks_workspace_name" {
  value = azurerm_databricks_workspace.main_workspace.name
}
output "transit_databricks_workspace_name" {
  value = azurerm_databricks_workspace.transit_workspace.name
}
output "main_databricks_workspace_id" {
  value = azurerm_databricks_workspace.main_workspace.id
}
output "transit_databricks_workspace_id" {
  value = azurerm_databricks_workspace.transit_workspace.id
}