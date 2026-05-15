variable "workload" {
  type        = string
  description = "Short workload or application name used in resource naming (lowercase, no spaces, max 8 chars)."

  validation {
    condition     = can(regex("^[a-z0-9]{1,8}$", var.workload))
    error_message = "workload must be 1–8 lowercase alphanumeric characters."
  }
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g. dev, test, prod)."

  validation {
    condition     = contains(["dev", "test", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, test, staging, prod."
  }
}

variable "location" {
  type        = string
  description = "Azure region for all resources (e.g. norwayeast, northeurope, westeurope)."
  default     = "norwayeast"
}

variable "instance" {
  type        = string
  description = "Instance number suffix for disambiguation (e.g. 001)."
  default     = "001"
}

# ── Tagging ────────────────────────────────────────────────────────────────────

variable "cost_center" {
  type        = string
  description = "Cost center code for billing allocation."
}

variable "owner" {
  type        = string
  description = "Team or individual responsible for this workload (e.g. platform-team)."
}

variable "additional_tags" {
  type        = map(string)
  description = "Additional tags to merge with the default tag set."
  default     = {}
}

# ── Network ────────────────────────────────────────────────────────────────────

variable "private_endpoint_subnet_id" {
  type        = string
  description = "Resource ID of the subnet where the private endpoint NIC will be placed."
}

variable "private_dns_zone_vnet_id" {
  type        = string
  description = "Resource ID of the VNet to link to the private DNS zone for blob storage."
}

# ── Diagnostics ────────────────────────────────────────────────────────────────

variable "log_analytics_workspace_id" {
  type        = string
  description = "Resource ID of the Log Analytics workspace for diagnostic settings."
}

# ── Storage ────────────────────────────────────────────────────────────────────

variable "account_replication_type" {
  type        = string
  description = "Storage account replication type (LRS, ZRS, GRS, GZRS, RA-GRS, RA-GZRS)."
  default     = "ZRS"

  validation {
    condition     = contains(["LRS", "ZRS", "GRS", "GZRS", "RA-GRS", "RA-GZRS"], var.account_replication_type)
    error_message = "account_replication_type must be one of: LRS, ZRS, GRS, GZRS, RA-GRS, RA-GZRS."
  }
}

variable "blob_soft_delete_retention_days" {
  type        = number
  description = "Number of days to retain soft-deleted blobs (1–365)."
  default     = 7
}

variable "container_soft_delete_retention_days" {
  type        = number
  description = "Number of days to retain soft-deleted containers (1–365)."
  default     = 7
}
