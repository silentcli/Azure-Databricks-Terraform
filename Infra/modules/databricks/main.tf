# Azure Databricks Workspace Module
resource "azurerm_databricks_workspace" "this" {
  name                = var.workspace_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku

  custom_parameters {
    no_public_ip = var.no_public_ip
  }

  tags = var.tags
}
