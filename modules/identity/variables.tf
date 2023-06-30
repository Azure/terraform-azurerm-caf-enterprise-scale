# The following variables are used to determine the archetype
# definition to use and create the required resources.
#
# Further information provided within the description block
# for each variable

variable "enabled" {
  type        = bool
  description = "Controls whether to manage the identity landing zone policies and deploy the identity resources into the current Subscription context."
}

variable "root_id" {
  type        = string
  description = "Specifies the ID of the Enterprise-scale root Management Group, used as a prefix for resources created by this module."

  validation {
    condition     = can(regex("[a-zA-Z0-9-_\\(\\)\\.]", var.root_id))
    error_message = "Value must consist of alphanumeric characters and hyphens."
  }
}

variable "settings" {
  type = object({
    identity = optional(object({
      enabled = optional(bool, true)
      config = optional(object({
        enable_deny_public_ip             = optional(bool, true)
        enable_deny_rdp_from_internet     = optional(bool, true)
        enable_deny_subnet_without_nsg    = optional(bool, true)
        enable_deploy_azure_backup_on_vms = optional(bool, true)
      }), {})
    }), {})
  })
  description = "Configuration settings for the \"Identity\" landing zone resources."
  default     = {}
}
