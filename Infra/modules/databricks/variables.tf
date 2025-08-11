variable "workspace_name" {
  description = "The name of the Databricks workspace"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the Databricks workspace will be created"
  type        = string
}

variable "location" {
  description = "The Azure region where the Databricks workspace will be created"
  type        = string
}

variable "sku" {
  description = "The SKU for the Databricks workspace"
  type        = string
  default     = "premium"
  
  validation {
    condition     = contains(["standard", "premium", "trial"], var.sku)
    error_message = "The sku must be either 'standard', 'premium', or 'trial'."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "no_public_ip" {
  description = "Whether to disable public IP for cluster nodes (true = private cluster, false = public cluster)"
  type        = bool
  default     = false
}
