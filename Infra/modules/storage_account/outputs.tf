output "storage_account_name" {
  description = "The name of the storage account"
  value       = azurerm_storage_account.this.name
}

output "storage_account_id" {
  description = "The ID of the storage account"
  value       = azurerm_storage_account.this.id
}

output "storage_account_primary_access_key" {
  description = "The primary access key for the storage account"
  value       = azurerm_storage_account.this.primary_access_key
  sensitive   = true
}

output "storage_account_primary_blob_endpoint" {
  description = "The primary blob endpoint for the storage account"
  value       = azurerm_storage_account.this.primary_blob_endpoint
}

output "storage_account_primary_dfs_endpoint" {
  description = "The primary Data Lake Storage endpoint for the storage account"
  value       = azurerm_storage_account.this.primary_dfs_endpoint
}

output "container_names" {
  description = "The names of the created containers"
  value       = [for container in azurerm_storage_container.containers : container.name]
}
