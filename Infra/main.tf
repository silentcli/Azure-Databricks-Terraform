# Configure the Azure Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "~>1.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~>2.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  skip_provider_registration = true
}

# Configure Databricks Provider
provider "databricks" {
  host = module.databricks.databricks_workspace_url
}

# Local values for common tags
locals {
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    CreatedBy   = "Terraform"
  }
}

# Create Resource Group using module
module "resource_group" {
  source = "./modules/resource_group"
  
  name     = var.resource_group_name
  location = var.location
  tags     = local.common_tags
}

# Create Storage Account for Data Lake using module
module "storage_account" {
  source = "./modules/storage_account"
  
  storage_account_name     = var.storage_account_name
  resource_group_name      = module.resource_group.resource_group_name
  location                 = module.resource_group.resource_group_location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_replication_type
  account_kind             = var.storage_account_kind
  is_hns_enabled           = var.enable_hierarchical_namespace
  containers               = var.storage_containers
  container_access_type    = var.container_access_type
  tags                     = local.common_tags
}

# Create Azure Databricks Workspace using module
module "databricks" {
  source = "./modules/databricks"
  
  workspace_name      = var.databricks_workspace_name
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  sku                 = var.databricks_sku
  no_public_ip        = var.databricks_no_public_ip
  tags                = local.common_tags
}

# Upload CSV file to storage account after creation
resource "null_resource" "upload_csv_file" {
  depends_on = [module.storage_account]

  provisioner "local-exec" {
    command = "./upload-files.sh"
    
    # Set working directory to the script location
    working_dir = path.module
  }

  # Trigger re-upload if the CSV file changes
  triggers = {
    csv_file_hash = filemd5("../demo_data/Sales.csv")
    storage_account_name = module.storage_account.storage_account_name
  }
}

# Data source to find the Databricks managed resource group
data "azurerm_resources" "databricks_managed_resources" {
  depends_on = [module.databricks]
  
  type = "Microsoft.Resources/resourceGroups"
}

# Cleanup mechanism for Databricks managed resource group
resource "null_resource" "databricks_cleanup" {
  depends_on = [module.databricks]

  # This runs when the resource is destroyed
  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      echo "=== TERRAFORM DESTROY: Databricks Cleanup Starting ==="
      
      # Set error handling
      set -e
      
      # Check if Azure CLI is available
      if ! command -v az >/dev/null 2>&1; then
        echo "ERROR: Azure CLI is not installed or not in PATH"
        exit 1
      fi
      
      # Check if logged in to Azure
      if ! az account show >/dev/null 2>&1; then
        echo "ERROR: Not logged in to Azure CLI. Please run: az login"
        exit 1
      fi
      
      echo "Finding Databricks managed resource groups..."
      
      # Find Databricks managed resource groups with better error handling
      MANAGED_RGS=$(az group list --query "[?starts_with(name, 'databricks-rg-')].name" --output tsv 2>/dev/null || echo "")
      
      if [ -n "$MANAGED_RGS" ] && [ "$MANAGED_RGS" != "" ]; then
        echo "Found Databricks managed resource groups to delete:"
        echo "$MANAGED_RGS"
        echo "----------------------------------------"
        
        # Process each managed resource group
        while IFS= read -r rg; do
          if [ -n "$rg" ] && [ "$rg" != "" ]; then
            echo "🗑️  Deleting managed resource group: $rg"
            
            # Delete with synchronous wait to ensure completion
            if az group delete --name "$rg" --yes --no-wait; then
              echo "✅ Deletion initiated successfully for: $rg"
            else
              echo "❌ Failed to delete: $rg"
            fi
          fi
        done <<< "$MANAGED_RGS"
        
        echo "----------------------------------------"
        echo "✅ All Databricks managed resource groups deletion initiated"
        echo "💡 Resources will be fully deleted in the background within 5-10 minutes"
        echo "💰 Billing for these resources will stop once deletion completes"
        
      else
        echo "ℹ️  No Databricks managed resource groups found to clean up"
      fi
      
      echo "=== TERRAFORM DESTROY: Databricks Cleanup Complete ==="
    EOT
  }

  # Trigger cleanup when Databricks workspace changes
  triggers = {
    databricks_workspace_id = module.databricks.databricks_workspace_id
  }
}
