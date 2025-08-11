# General Configuration
variable "environment" {
  description = "The environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "Demo"
}

variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "DataOps"
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
  default     = "East US 2"
}

# Resource Group Configuration
variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

# Storage Account Configuration
variable "storage_account_name" {
  description = "The name of the storage account (must be globally unique)"
  type        = string
}

variable "storage_account_tier" {
  description = "The storage account tier"
  type        = string
  default     = "Standard"
}

variable "storage_replication_type" {
  description = "The type of replication to use for this storage account"
  type        = string
  default     = "LRS"
}

variable "storage_account_kind" {
  description = "The kind of storage account"
  type        = string
  default     = "StorageV2"
}

variable "enable_hierarchical_namespace" {
  description = "Enable hierarchical namespace for Data Lake"
  type        = bool
  default     = true
}

variable "storage_containers" {
  description = "List of container names to create"
  type        = list(string)
  default     = ["source"]
}

variable "container_access_type" {
  description = "The access type for the storage containers"
  type        = string
  default     = "private"
}

# Databricks Configuration
variable "databricks_workspace_name" {
  description = "The name of the Databricks workspace"
  type        = string
}

variable "databricks_sku" {
  description = "The SKU for the Databricks workspace"
  type        = string
  default     = "premium"
  
  validation {
    condition     = contains(["standard", "premium", "trial"], var.databricks_sku)
    error_message = "The databricks_sku must be either 'standard', 'premium', or 'trial'."
  }
}

variable "databricks_no_public_ip" {
  description = "Whether to disable public IP for Databricks cluster nodes (true = private cluster with NAT costs, false = public cluster)"
  type        = bool
  default     = false
}
