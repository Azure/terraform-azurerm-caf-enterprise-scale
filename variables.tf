# The following variables are used to configure the default
# Enterprise-scale Management Groups.
#
# Further information provided within the description block
# for each variable

variable "es_root_parent_id" {
  type        = string
  description = "The es_root_parent_id is used to specify where to set the root for all Landing Zone deployments. Usually the Tenant ID when deploying the core Enterprise-scale Landing Zones."

  validation {
    condition     = can(regex("^[a-z0-9-]{2,36}$", var.es_root_parent_id))
    error_message = "The es_root_parent_id value must be a valid GUID, or Management Group ID."
  }
}

variable "es_root_id" {
  type        = string
  description = "OPTIONAL: If specified, will set a custom Name (ID) value for the Enterprise-scale \"root\" Management Group, and append this to the ID for all core Enterprise-scale Management Groups."
  default     = "es"

  validation {
    condition     = can(regex("^[a-z]{2,5}$", var.es_root_id))
    error_message = "The es_root_id value must be between 2 to 5 characters long and can only contain lowercase letters."
  }
}

variable "es_root_name" {
  type        = string
  description = "OPTIONAL: If specified, will set a custom DisplayName value for the Enterprise-scale \"root\" Management Group"
  default     = "Enterprise-Scale"

  validation {
    condition     = can(regex("^[A-Za-z][A-Za-z0-9- ]{1,22}[A-Za-z0-9]?$", var.es_root_name))
    error_message = "The es_root_name value must be between 2 to 24 characters long, start with a letter, end with a letter or number, and can only contain space and hyphen characters."
  }
}

variable "es_deploy_core_landing_zones" {
  type        = bool
  description = "OPTIONAL: If set to true, will include the core Enterprise-scale Management Group hierarchy"
  default     = true
}

variable "es_archetype_config_overrides" {
  type        = map(any)
  description = "OPTIONAL: If specified, will set custom Archetype configurations to the default Enterprise-scale Management Groups"
  default     = {}
}

variable "es_subscription_ids_overrides" {
  type        = map(list(string))
  description = "OPTIONAL: If specified, will be used to assign subscription_ids to the default Enterprise-scale Management Groups"
  default     = {}
}

variable "es_deploy_demo_landing_zones" {
  type        = bool
  description = "OPTIONAL: If set to true, will include the demo \"Landing Zone\" Management Groups"
  default     = false
}

variable "es_custom_landing_zones" {
  type = map(
    object({
      display_name               = string
      parent_management_group_id = string
      subscription_ids           = list(string)
      archetype_config = object({
        archetype_id = string
        parameters   = any
      })
    })
  )
  description = "OPTIONAL: If specified, will deploy additional Management Groups alongside Enterprise-scale core Management Groups"
  default     = {}

  validation {
    condition     = can(regex("^[a-z0-9-]{2,36}$", keys(var.es_custom_landing_zones)[0])) || length(keys(var.es_custom_landing_zones)) == 0
    error_message = "The es_custom_landing_zones value must be between 2 to 36 characters long and can only contain lowercase letters, numbers and hyphens."
  }
}

variable "es_archetype_library_path" {
  type        = string
  description = "OPTIONAL: If specified, sets the path to a custom library folder for archetype artefacts."
  default     = ""

  # validation {
  #   condition     = fileexists(var.es_archetype_library_path) // does not work with a directory
  #   error_message = "The es_archetype_library_path must be a valid file path accessible from the root module scope."
  # }
}

variable "es_default_location" {
  type        = string
  description = "OPTIONAL: If specified, will use set the default location used for resource deployments where needed."
  default     = "eastus"

  # Need to add validation covering all Azure locations
}
