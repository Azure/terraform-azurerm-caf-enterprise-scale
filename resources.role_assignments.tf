resource "azurerm_role_assignment" "enterprise_scale" {
  for_each = local.azurerm_role_assignment_enterprise_scale

  # Special handling of OPTIONAL name to ensure consistent and correct
  # mapping of Terraform state ADDR value to Azure Resource ID value.
  name = basename(each.key)

  # Mandatory resource attributes
  scope        = each.value.scope_id
  principal_id = each.value.principal_id

  # Optional attributes
  role_definition_name = try(each.value.role_definition_name, null)
  role_definition_id   = try(each.value.role_definition_id, null)

  # Set explicit dependency on Management Group, Policy, and Role Definition deployments
  depends_on = [
    time_sleep.after_azurerm_management_group,
    time_sleep.after_azurerm_policy_definition,
    time_sleep.after_azurerm_policy_set_definition,
    time_sleep.after_azurerm_policy_assignment,
    time_sleep.after_azurerm_role_definition,
  ]

}

resource "azurerm_role_assignment" "policy_assignment" {
  for_each = local.azurerm_role_assignment_policy_assignment

  # Special handling of OPTIONAL name to ensure consistent and correct
  # mapping of Terraform state ADDR value to Azure Resource ID value.
  name = basename(each.key)

  # Mandatory resource attributes
  scope        = each.value.scope_id
  principal_id = each.value.principal_id

  # Optional attributes
  role_definition_name = try(each.value.role_definition_name, null)
  role_definition_id   = try(each.value.role_definition_id, null)

  # Set explicit dependency on Management Group, Policy, and Role Definition deployments
  depends_on = [
    time_sleep.after_azurerm_management_group,
    time_sleep.after_azurerm_policy_definition,
    time_sleep.after_azurerm_policy_set_definition,
    time_sleep.after_azurerm_policy_assignment,
    time_sleep.after_azurerm_role_definition,
  ]

}

resource "time_sleep" "after_azurerm_role_assignment" {
  depends_on = [
    time_sleep.after_azurerm_management_group,
    time_sleep.after_azurerm_policy_definition,
    time_sleep.after_azurerm_policy_set_definition,
    time_sleep.after_azurerm_policy_assignment,
    time_sleep.after_azurerm_role_definition,
    azurerm_role_assignment.enterprise_scale,
  ]

  triggers = {
    "azurerm_policy_assignment_enterprise_scale"  = jsonencode(keys(azurerm_role_assignment.enterprise_scale))
    "azurerm_policy_assignment_policy_assignment" = jsonencode(keys(azurerm_role_assignment.policy_assignment))
  }

  create_duration  = local.create_duration_delay["after_azurerm_role_assignment"]
  destroy_duration = local.destroy_duration_delay["after_azurerm_role_assignment"]
}
