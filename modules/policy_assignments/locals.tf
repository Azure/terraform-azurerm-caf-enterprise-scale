# The following block of locals are used to avoid using
# empty object types in the code
locals {
  empty_list   = []
  empty_map    = {}
}

# The following locals are used to convert provided input
# variables to locals before use elsewhere in the module
locals {
  name                      = var.name
  scope_id                  = var.scope_id
  policy_definition_id      = var.policy_definition_id
  description               = coalesce(var.description, "${local.name} Policy Assignment at scope ${local.scope_id}")
  display_name              = coalesce(var.display_name, var.name)
  metadata                  = var.metadata
  not_scopes                = var.not_scopes
  location                  = var.location
  identity                  = var.identity
  parameters                = var.parameters
  enforce                   = var.enforce
  role_definition_ids       = distinct(var.role_definition_ids)
  role_assignment_scope_ids = var.role_assignment_scope_ids
}

# The following locals are used to determine the scope type
# from the `scope_id` input so the correct Policy Assignment
# resource is used by the module.
locals {
  regex_scope_is_management_group = "(?i)(/providers/Microsoft.Management/managementGroups/)([^/]+)$"
  regex_scope_is_subscription     = "(?i)(/subscriptions/)([^/]+)$"
  regex_scope_is_resource_group   = "(?i)(/subscriptions/[^/]+/resourceGroups/)([^/]+)$"
  regex_scope_is_resource         = "(?i)(/subscriptions/[^/]+/resourceGroups(?:/[^/]+){4}/)([^/]+)$"
  scope_is_management_group       = length(regexall(local.regex_scope_is_management_group, local.scope_id)) > 0
  scope_is_subscription           = length(regexall(local.regex_scope_is_subscription, local.scope_id)) > 0
  scope_is_resource_group         = length(regexall(local.regex_scope_is_resource_group, local.scope_id)) > 0
  scope_is_resource               = length(regexall(local.regex_scope_is_resource, local.scope_id)) > 0
}

# Extract principal_id from correct resource (based on scope)
locals {
  null_principal_id = {
    identity = [
      {
        principal_id = null
      }
    ]
  }
  principal_id = (
    local.scope_is_management_group && length(local.role_definition_ids) > 0
    ? azurerm_management_group_policy_assignment.enterprise_scale[0].identity[0].principal_id
    : null
  )
}

# Determine the list of Role Definitions to create per scope
locals {
  policy_assignment_id = "${local.scope_id}/providers/Microsoft.Authorization/policyAssignments/${local.name}"
  role_assignment_path = "/providers/Microsoft.Authorization/roleAssignments/"
  role_assignment_scopes = distinct(concat(
    [local.scope_id],
    local.role_assignment_scope_ids,
  ))
  role_definition_ids_by_scope = {
    for scope in local.role_assignment_scopes :
    scope => local.role_definition_ids
  }
  role_assignments = flatten([
    for scope, role_definition_ids in local.role_definition_ids_by_scope :
    [
      for role_definition_id in role_definition_ids :
      {
        resource_id        = "${scope}${local.role_assignment_path}${uuidv5(uuidv5(uuidv5("url", role_definition_id), local.policy_assignment_id), scope)}"
        scope              = scope
        role_definition_id = role_definition_id
      }
    ]
  ])
  # Extract the scope from each Role Assignment ID (will only be associated with a single scope).
  azurerm_role_assignments = {
    for role_assignment in local.role_assignments :
    (role_assignment.resource_id) => {
      name                 = basename(role_assignment.resource_id)
      scope                = role_assignment.scope
      principal_id         = local.principal_id
      role_definition_name = null
      role_definition_id   = role_assignment.role_definition_id
    }
  }
}
