resource "azurerm_policy_assignment" "enterprise_scale" {
  for_each = local.azurerm_policy_assignment_enterprise_scale

  # Mandatory resource attributes
  # The policy assignment name length must not exceed '24' characters, but Terraform plan is unable to validate this in the plan stage. The following logic forces an error during plan if an invalid name length is specified.
  name                 = tonumber(length(each.value.template.name) > 24 ? "The policy assignment name '${each.value.template.name}' is invalid. The policy assignment name length must not exceed '24' characters." : length(each.value.template.name)) > 24 ? null : each.value.template.name
  scope                = each.value.scope_id
  policy_definition_id = each.value.template.properties.policyDefinitionId

  # Optional resource attributes
  identity {
    type = try(length(each.value.template.identity.type) > 0, false) ? each.value.template.identity.type : "None"
  }

  location         = try(length(each.value.template.location) > 0, false) ? each.value.template.location : null
  description      = try(length(each.value.template.properties.description) > 0, false) ? each.value.template.properties.description : "${each.value.template.name} Policy Assignment at scope ${each.value.scope_id}"
  display_name     = try(length(each.value.template.properties.displayName) > 0, false) ? each.value.template.properties.displayName : each.value.template.name
  metadata         = try(length(each.value.template.properties.metadata) > 0, false) ? jsonencode(each.value.template.properties.metadata) : local.empty_string
  parameters       = try(length(each.value.template.properties.parameters) > 0, false) ? jsonencode(merge(each.value.template.properties.parameters, each.value.parameters)) : jsonencode(each.value.parameters)
  not_scopes       = try(length(each.value.template.properties.notScopes) > 0, false) ? each.value.template.properties.notScopes : local.empty_list
  enforcement_mode = try(lower(each.value.template.properties.enforcementMode) == "default", true) ? true : false

  # Set explicit dependency on Management Group, Policy Definition and Policy Set Definition deployments
  depends_on = [
    time_sleep.after_azurerm_management_group,
    time_sleep.after_azurerm_policy_definition,
    time_sleep.after_azurerm_policy_set_definition,
  ]

}

resource "time_sleep" "after_azurerm_policy_assignment" {
  depends_on = [
    time_sleep.after_azurerm_management_group,
    time_sleep.after_azurerm_policy_definition,
    time_sleep.after_azurerm_policy_set_definition,
    azurerm_policy_assignment.enterprise_scale,
  ]

  triggers = {
    "azurerm_policy_assignment_enterprise_scale" = jsonencode(keys(azurerm_policy_assignment.enterprise_scale))
  }

  create_duration  = local.create_duration_delay["after_azurerm_policy_assignment"]
  destroy_duration = local.destroy_duration_delay["after_azurerm_policy_assignment"]
}
