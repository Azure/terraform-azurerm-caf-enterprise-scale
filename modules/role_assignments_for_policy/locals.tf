# The following locals are used to convert provided input
# variables to locals before use elsewhere in the module
locals {
  policy_assignment_id = var.policy_assignment_id
  scope_id             = var.scope_id
  principal_id         = var.principal_id
  role_definition_ids  = distinct(var.role_definition_ids)
  additional_scope_ids = var.additional_scope_ids
}

# Determine the list of Role Definitions to create per scope
locals {
  role_assignment_path = "/providers/Microsoft.Authorization/roleAssignments/"
  role_assignment_scopes = distinct(concat(
    [local.scope_id],
    local.additional_scope_ids,
  ))
  role_definition_ids_by_scope = {
    for scope in local.role_assignment_scopes :
    scope => local.role_definition_ids
    if scope != null
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
