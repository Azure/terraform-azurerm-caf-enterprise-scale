resource "azurerm_role_assignment" "enterprise_scale" {
  for_each = local.azurerm_role_assignment_enterprise_scale

  # Special handling of OPTIONAL name to ensure consistent and correct
  # mapping of Terraform state ADDR value to Azure Resource ID value.
  name = basename(each.key)

  # Mandatory resource attributes
  scope        = each.value.scope_id
  principal_id = each.value.principal_id

  # Optional resource attributes
  role_definition_name = lookup(each.value, "role_definition_name", null)
  role_definition_id   = lookup(each.value, "role_definition_id", null)

  # Set explicit dependency on Management Group, Policy, and Role Definition deployments
  depends_on = [
    time_sleep.after_azurerm_management_group,
    time_sleep.after_azurerm_role_definition,
  ]

}

# The following module is used to generate the Role
# Assignments for Policy Assignments as needed.
# This was implemented to fix issue:
# https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/266
module "role_assignments_for_policy" {
  for_each = local.es_role_assignments_by_policy_assignment
  source   = "./modules/role_assignments_for_policy"

  # Mandatory resource attributes
  policy_assignment_id = each.key
  scope_id             = azurerm_management_group_policy_assignment.enterprise_scale[each.key].management_group_id
  principal_id         = azurerm_management_group_policy_assignment.enterprise_scale[each.key].identity[0].principal_id
  role_definition_ids  = each.value

  # Optional resource attributes
  additional_scope_ids = local.empty_list

  # Set explicit dependency on Management Group, Policy Definition, Policy Set Definition, and Policy Assignment deployments
  depends_on = [
    time_sleep.after_azurerm_management_group,
    time_sleep.after_azurerm_policy_definition,
    time_sleep.after_azurerm_policy_set_definition,
    time_sleep.after_azurerm_policy_assignment,
    azurerm_role_assignment.policy_assignment,
  ]

}

# The following resource is left to help manage the
# upgrade to using module.role_assignments_for_policy
# To be removed in `v2.0.0`
resource "azurerm_role_assignment" "policy_assignment" {
  for_each = local.empty_map

  # Mandatory resource attributes
  name         = basename(each.key)
  scope        = each.value.scope_id
  principal_id = each.value.principal_id

}

resource "time_sleep" "after_azurerm_role_assignment" {
  depends_on = [
    time_sleep.after_azurerm_management_group,
    time_sleep.after_azurerm_role_definition,
    azurerm_role_assignment.enterprise_scale,
    module.role_assignments_for_policy,
  ]

  triggers = {
    "azurerm_role_assignment_enterprise_scale" = jsonencode(keys(azurerm_role_assignment.enterprise_scale))
    "module_role_assignments_for_policy"       = jsonencode(keys(module.role_assignments_for_policy))
  }

  create_duration  = local.create_duration_delay["after_azurerm_role_assignment"]
  destroy_duration = local.destroy_duration_delay["after_azurerm_role_assignment"]
}
