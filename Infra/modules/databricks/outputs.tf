output "databricks_workspace_id" {
  description = "The ID of the Databricks workspace"
  value       = azurerm_databricks_workspace.this.id
}

output "databricks_workspace_url" {
  description = "The URL of the Databricks workspace"
  value       = azurerm_databricks_workspace.this.workspace_url
}

output "databricks_workspace_name" {
  description = "The name of the Databricks workspace"
  value       = azurerm_databricks_workspace.this.name
}
