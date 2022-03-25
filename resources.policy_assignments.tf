# The following module is used to generate the Policy
# Assignments and their corresponding Role Assignments
# (if needed).
# This was implemented in a module to link the Role
# Assignments to the Policy Assignment to fix issue:
# https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/266
module "policy_assignments" {
  for_each = local.azurerm_management_group_policy_assignment_enterprise_scale
  source   = "./modules/policy_assignments"

  # Mandatory resource attributes
  name                 = each.value.template.name
  scope_id             = each.value.scope_id
  policy_definition_id = each.value.template.properties.policyDefinitionId

  # Optional resource attributes
  description               = lookup(each.value.template.properties, "description", null)
  display_name              = lookup(each.value.template.properties, "displayName", null)
  metadata                  = lookup(each.value.template.properties, "metadata", local.empty_map)
  not_scopes                = lookup(each.value.template.properties, "notScopes", local.empty_list)
  location                  = lookup(each.value.template, "location", null)
  identity                  = lookup(each.value.template, "identity", local.empty_map)
  parameters                = each.value.parameters
  enforce                   = each.value.enforcement_mode
  role_definition_ids       = lookup(local.es_role_assignments_by_policy_assignment, each.key, local.empty_list)
  role_assignment_scope_ids = local.empty_list

  # Set explicit dependency on Management Group, Policy Definition and Policy Set Definition deployments
  depends_on = [
    time_sleep.after_azurerm_management_group,
    time_sleep.after_azurerm_policy_definition,
    time_sleep.after_azurerm_policy_set_definition,
  ]

}

# # The following resource is here to allow a clean upgrade from previous versions.
# resource "azurerm_management_group_policy_assignment" "enterprise_scale" {
#   for_each = local.empty_map

#   # Mandatory resource attributes
#   name                 = each.value.name
#   management_group_id  = each.value.scope_id
#   policy_definition_id = each.value.policyDefinitionId

# }

resource "time_sleep" "after_azurerm_policy_assignment" {
  depends_on = [
    time_sleep.after_azurerm_management_group,
    time_sleep.after_azurerm_policy_definition,
    time_sleep.after_azurerm_policy_set_definition,
    module.policy_assignments,
  ]

  triggers = {
    "azurerm_policy_assignment" = jsonencode(keys(module.policy_assignments))
  }

  create_duration  = local.create_duration_delay["after_azurerm_policy_assignment"]
  destroy_duration = local.destroy_duration_delay["after_azurerm_policy_assignment"]
}
