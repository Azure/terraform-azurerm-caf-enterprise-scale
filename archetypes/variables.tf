# The following variables are used to determine the archetype
# definition to use and create the required resources.
#
# Further information provided within the description block
# for each variable

variable "root_id" {
  type        = string
  description = "Specifies the ID of the Enterprise-scale root Management Group where Policy Definitions are created by default."

  validation {
    condition     = can(regex("^/providers/Microsoft.Management/managementGroups/[a-z0-9-]{2,36}$", var.root_id))
    error_message = "The root_id value must be a valid Management Group ID."
  }
}

variable "scope_id" {
  type        = string
  description = "Specifies the scope to apply the archetype resources against."

  validation {
    condition     = can(regex("^/(subscriptions|providers/Microsoft.Management/managementGroups)/[a-z0-9-]{2,36}$", var.scope_id))
    error_message = "The scope_id value must be a valid Subscription or Management Group ID."
  }
}

variable "archetype_id" {
  type        = string
  description = "Specifies the ID of the archetype to apply against the provided scope. Must be a valid archetype ID from either the built-in module library, or as defined by the archetype_library_path variable."

  # validation {
  #   condition     = can(regex("^[a-z0-9-]{2,36}$", var.archetype_id))
  #   error_message = "The archetype_id value must be a valid archetype ID from either the built-in module library, or as defined by the archetype_library_path variable."
  # }
}

variable "archetype_parameters" {
  type        = map(any)
  description = "OPTIONAL: If specified, will use the specified parameters to override archetype defaults."
  default     = null
}

variable "archetype_library_path" {
  type        = string
  description = "OPTIONAL: If specified, sets the path to a custom library folder for archetype artefacts."
  default     = null

  # validation {
  #   condition     = fileexists(var.archetype_library_path) // does not work with a directory
  #   error_message = "The archetype_library_path must be a valid file path accessible from the root module scope."
  # }
}

variable "default_location" {
  type        = string
  description = "OPTIONAL: If specified, will use set the default location used for resource deployments where needed."
  default     = "eastus"

  # Need to add validation covering all Azure locations
}
