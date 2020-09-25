resource "azurerm_policy_assignment" "enterprise_scale" {
  for_each = {
    for assignment in local.es_policy_assignments_by_management_group :
    assignment.resource_id => assignment
  }

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
  display_name     = try(length(each.value.template.properties.display_name) > 0, false) ? each.value.template.properties.display_name : each.value.template.name
  metadata         = try(length(each.value.template.properties.metadata) > 0, false) ? jsonencode(each.value.template.properties.metadata) : local.empty_string
  parameters       = try(length(each.value.template.properties.parameters) > 0, false) ? jsonencode(merge(each.value.template.properties.parameters, each.value.parameters)) : jsonencode(each.value.parameters)
  not_scopes       = try(length(each.value.template.properties.notScopes) > 0, false) ? each.value.template.properties.notScopes : local.empty_list
  enforcement_mode = try(length(each.value.template.properties.enforcementMode) > 0, false) ? each.value.template.properties.enforcementMode : true

  # Set explicit dependency on Policy Definition and Policy Set Definition deployments
  depends_on = [
    azurerm_policy_definition.enterprise_scale,
    azurerm_policy_set_definition.enterprise_scale,
  ]

}
