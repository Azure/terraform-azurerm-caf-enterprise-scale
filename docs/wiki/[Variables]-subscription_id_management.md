## Overview 
subscription_id_managmement `string` (optional)

If specified, identifies the Platform subscription for \"Management\" for resource deployment and correct placement in the Management Group hierarchy.

## Default value

variable "subscription_id_management" {
  type        = string
  description = ""
  default     = ""

  validation {
    condition     = can(regex("^[a-z0-9-]{36}$", var.subscription_id_management)) || var.subscription_id_management == ""
    error_message = "Value must be a valid Subscription ID (GUID)."
  }
}
