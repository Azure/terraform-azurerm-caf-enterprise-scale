locals {
  empty_list   = []
  empty_map    = {}
  empty_string = ""
}

locals {
  root_id                   = var.root_id
  scope_id                  = var.scope_id
  scope_is_management_group = length(regexall("^/providers/Microsoft.Management/managementGroups/.*", local.scope_id)) > 0
  scope_is_subscription     = length(regexall("^/subscriptions/.*", local.scope_id)) > 0
  default_location          = var.default_location
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
    role_definition       = "${local.scope_id}/providers/Microsoft.Authorization/roleDefinitions/"
  }
}
