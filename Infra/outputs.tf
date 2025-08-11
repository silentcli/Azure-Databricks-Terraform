# Resource Group Outputs
output "resource_group_name" {
  description = "The name of the resource group"
  value       = module.resource_group.resource_group_name
}

output "resource_group_location" {
  description = "The location of the resource group"
  value       = module.resource_group.resource_group_location
}

# Storage Account Outputs
output "storage_account_name" {
  description = "The name of the storage account"
  value       = module.storage_account.storage_account_name
}

output "storage_account_primary_blob_endpoint" {
  description = "The primary blob endpoint for the storage account"
  value       = module.storage_account.storage_account_primary_blob_endpoint
}

output "storage_account_primary_dfs_endpoint" {
  description = "The primary Data Lake Storage endpoint for the storage account"
  value       = module.storage_account.storage_account_primary_dfs_endpoint
}

output "storage_containers" {
  description = "The names of the created storage containers"
  value       = module.storage_account.container_names
}

# Databricks Outputs
output "databricks_workspace_name" {
  description = "The name of the Databricks workspace"
  value       = module.databricks.databricks_workspace_name
}

output "databricks_workspace_url" {
  description = "The URL of the Databricks workspace"
  value       = module.databricks.databricks_workspace_url
}

output "databricks_workspace_id" {
  description = "The ID of the Databricks workspace"
  value       = module.databricks.databricks_workspace_id
}

# File Upload Status
output "csv_file_upload_status" {
  description = "Status of CSV file upload to storage account"
  value       = "Sales.csv uploaded to ${module.storage_account.storage_account_name}/source/"
  depends_on  = [null_resource.upload_csv_file]
}

# Cleanup Status Output
output "databricks_cleanup_info" {
  description = "Information about Databricks cleanup mechanism"
  value       = "Cleanup mechanism configured - managed resource groups will be deleted during 'terraform destroy'"
}
