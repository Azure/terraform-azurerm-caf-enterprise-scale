resource "azurerm_policy_set_definition" "enterprise_scale" {
  for_each = local.azurerm_policy_set_definition_enterprise_scale

  # Mandatory resource attributes
  name         = each.value.template.name
  policy_type  = "Custom"
  display_name = each.value.template.properties.displayName

  # Dynamic configuration blocks
  dynamic "policy_definition_reference" {
    for_each = [
      for item in each.value.template.properties.policyDefinitions :
      {
        policyDefinitionId          = item.policyDefinitionId
        parameters                  = item.parameters
        policyDefinitionReferenceId = item.policyDefinitionReferenceId
      }
      if try(length(each.value.template.properties.policyDefinitions) > 0, false)
    ]
    content {
      policy_definition_id = policy_definition_reference.value["policyDefinitionId"]
      parameter_values     = try(length(policy_definition_reference.value["parameters"]) > 0, false) ? jsonencode(policy_definition_reference.value["parameters"]) : null
      reference_id         = try(length(policy_definition_reference.value["policyDefinitionReferenceId"]) > 0, false) ? policy_definition_reference.value["policyDefinitionReferenceId"] : policy_definition_reference.value["policyDefinitionId"]
    }
  }

  # Optional resource attributes
  description           = try(length(each.value.template.properties.description) > 0, false) ? each.value.template.properties.description : "${each.value.template.properties.displayName} Policy Set Definition at scope ${each.value.scope_id}"
  management_group_name = try(length(each.value.scope_id) > 0, false) ? basename(each.value.scope_id) : null
  metadata              = try(length(each.value.template.properties.metadata) > 0, false) ? jsonencode(each.value.template.properties.metadata) : local.empty_string
  parameters            = try(length(each.value.template.properties.parameters) > 0, false) ? jsonencode(each.value.template.properties.parameters) : local.empty_string

  # Set explicit dependency on Management Group and Policy Definition deployments
  depends_on = [
    azurerm_management_group.level_1,
    azurerm_management_group.level_2,
    azurerm_management_group.level_3,
    azurerm_management_group.level_4,
    azurerm_management_group.level_5,
    azurerm_management_group.level_6,
    azurerm_policy_definition.enterprise_scale,
  ]

}
