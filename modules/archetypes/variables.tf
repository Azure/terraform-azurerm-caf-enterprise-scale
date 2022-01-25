# The following variables are used to determine the archetype
# definition to use and create the required resources.
#
# Further information provided within the description block
# for each variable

variable "root_id" {
  type        = string
  description = "Specifies the ID of the Enterprise-scale root Management Group where Policy Definitions are created by default."

  validation {
    condition     = can(regex("^/providers/Microsoft.Management/managementGroups/[a-zA-Z0-9-_\\(\\)\\.]{1,36}$", var.root_id))
    error_message = "The root_id value must be a valid Management Group ID."
  }
}

variable "scope_id" {
  type        = string
  description = "Specifies the scope to apply the archetype resources against."

  validation {
    condition     = can(regex("^/(subscriptions|providers/Microsoft.Management/managementGroups)/[a-zA-Z0-9-_\\(\\)\\.]{1,36}$", var.scope_id))
    error_message = "The scope_id value must be a valid Subscription or Management Group ID."
  }
}

variable "archetype_id" {
  type        = string
  description = "Specifies the ID of the archetype to apply against the provided scope. Must be a valid archetype ID from either the built-in module library, or as defined by the library_path variable."
}

variable "parameters" {
  type        = any
  description = "If specified, will use the specified parameters to override defaults for Policy Assignments."
  default     = {}
}

variable "enforcement_mode" {
  type        = map(string)
  description = "If specified, will use the specified enforcement_mode values to override defaults for Policy Assignments."
  default     = {}
}

variable "access_control" {
  type        = map(any)
  description = "If specified, will use the specified access control map to set Role Assignments on the archetype instance at the current scope."
  default     = {}
}

variable "library_path" {
  type        = string
  description = "If specified, sets the path to a custom library folder for archetype artefacts."
  default     = ""
}

variable "template_file_variables" {
  type        = any
  description = "If specified, provides the ability to define custom template vars used when reading in template files from the library_path"
  default     = {}
}

variable "default_location" {
  type        = string
  description = "Sets the default location used for resource deployments where needed."
}
