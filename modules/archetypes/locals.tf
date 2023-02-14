# The following block of locals are used to avoid using
# empty object types in the code
locals {
  empty_list   = []
  empty_map    = {}
  empty_string = ""
}

# The following locals are used to convert basic input
# variables to locals before use elsewhere in the module
locals {
  root_id                 = var.root_id
  scope_id                = var.scope_id
  archetype_id            = var.archetype_id
  parameters              = var.parameters
  enforcement_mode        = var.enforcement_mode
  access_control          = var.access_control
  library_path            = var.library_path
  template_file_variables = var.template_file_variables
  default_location        = var.default_location
}

# The following locals are used to define the built-in
# library path, and determine whether a custom library
# path has been provided to enable conditional logic on
# loading configuration files from the library path(s).
locals {
  builtin_library_path          = "${path.module}/lib"
  custom_library_path_specified = try(length(local.library_path) > 0, false)
  custom_library_path           = local.custom_library_path_specified ? replace(local.library_path, "//$/", local.empty_string) : null
}

# The following locals are used to define base Azure
# provider paths and resource types
locals {
  # scope_is_management_group = length(regexall("^/providers/Microsoft.Management/managementGroups/.*", local.scope_id)) > 0
  # scope_is_subscription     = length(regexall("^/subscriptions/.*", local.scope_id)) > 0
  resource_types = {
    policy_assignment     = "Microsoft.Authorization/policyAssignments"
    policy_definition     = "Microsoft.Authorization/policyDefinitions"
    policy_set_definition = "Microsoft.Authorization/policySetDefinitions"
    role_assignment       = "Microsoft.Authorization/roleAssignments"
    role_definition       = "Microsoft.Authorization/roleDefinitions"
  }
  provider_path = {
    policy_assignment     = "${local.scope_id}/providers/Microsoft.Authorization/policyAssignments/"
    policy_definition     = "${local.scope_id}/providers/Microsoft.Authorization/policyDefinitions/"
    policy_set_definition = "${local.scope_id}/providers/Microsoft.Authorization/policySetDefinitions/"
    role_assignment       = "${local.scope_id}/providers/Microsoft.Authorization/roleAssignments/"
    role_definition       = "/providers/Microsoft.Authorization/roleDefinitions/"
  }
}

# The following locals are used in template functions to provide values
locals {
  core_template_file_variables = {
    root_scope_id             = basename(local.root_id)
    root_scope_resource_id    = local.root_id
    current_scope_id          = basename(local.scope_id)
    current_scope_resource_id = local.scope_id
    default_location          = local.default_location
    location                  = local.default_location
    builtin                   = local.builtin_library_path
    builtin_library_path      = local.builtin_library_path
    custom                    = local.custom_library_path
    custom_library_path       = local.custom_library_path
  }
  template_file_vars = merge(
    local.template_file_variables,
    local.core_template_file_variables,
  )
}

# The following locals are used to specify default values for the lookup() function
locals {
  parameter_map_default = {
    properties = {
      parameters = local.empty_map
    }
  }
}

# Generate the configuration output object for the specified archetype
# depends_on_files = [
#   locals.policy_assignments.tf
#   locals.policy_definitions.tf
#   locals.policy_set_definitions.tf
#   locals.role_assignments.tf
#   locals.role_definitions.tf
# ]
locals {
  module_output = {
    azurerm_policy_assignment     = local.archetype_policy_assignments_output
    azurerm_policy_definition     = local.archetype_policy_definitions_output
    azurerm_policy_set_definition = local.archetype_policy_set_definitions_output
    azurerm_role_assignment       = local.archetype_role_assignments_output
    azurerm_role_definition       = local.archetype_role_definitions_output
  }
}
