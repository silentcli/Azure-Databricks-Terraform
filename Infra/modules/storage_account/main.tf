# Storage Account Module for Data Lake
resource "azurerm_storage_account" "this" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  account_kind             = var.account_kind
  is_hns_enabled           = var.is_hns_enabled

  tags = var.tags
}

# Create Storage Container for source data
resource "azurerm_storage_container" "containers" {
  for_each = toset(var.containers)
  
  name                  = each.key
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = var.container_access_type
}
