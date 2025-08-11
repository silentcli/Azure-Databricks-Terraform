variable "storage_account_name" {
  description = "The name of the storage account"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the storage account will be created"
  type        = string
}

variable "location" {
  description = "The Azure region where the storage account will be created"
  type        = string
}

variable "account_tier" {
  description = "The storage account tier"
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "The type of replication to use for this storage account"
  type        = string
  default     = "LRS"
}

variable "account_kind" {
  description = "The kind of storage account"
  type        = string
  default     = "StorageV2"
}

variable "is_hns_enabled" {
  description = "Enable hierarchical namespace for Data Lake"
  type        = bool
  default     = true
}

variable "containers" {
  description = "List of container names to create"
  type        = list(string)
  default     = ["source"]
}

variable "container_access_type" {
  description = "The access type for the storage containers"
  type        = string
  default     = "private"
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
