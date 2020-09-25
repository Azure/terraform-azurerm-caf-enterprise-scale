resource "azurerm_policy_set_definition" "enterprise_scale" {
  for_each = {
    for policy_set in local.es_policy_set_definitions_by_management_group :
    policy_set.resource_id => policy_set
  }

  # Mandatory resource attributes
  name         = each.value.template.displayName
  policy_type  = "Custom"
  display_name = each.value.template.displayName

  # Dynamic configuration blocks
  dynamic "policy_definition_reference" {
    for_each = [
      for item in each.value.template.policyDefinitions :
      {
        policyDefinitionId          = item.policyDefinitionId
        parameters                  = item.parameters
        policyDefinitionReferenceId = item.policyDefinitionReferenceId
      }
      if try(length(each.value.template.policyDefinitions) > 0, false)
    ]
    content {
      policy_definition_id = policy_definition_reference.value["policyDefinitionId"]
      parameter_values     = try(length(policy_definition_reference.value["parameters"]) > 0, false) ? jsonencode(policy_definition_reference.value["parameters"]) : jsonencode(local.empty_map)
      reference_id         = try(length(policy_definition_reference.value["policyDefinitionReferenceId"]) > 0, false) ? policy_definition_reference.value["policyDefinitionReferenceId"] : policy_definition_reference.value["policyDefinitionId"]
    }
  }

  # Optional resource attributes
  description           = try(length(each.value.template.description) > 0, false) ? each.value.template.description : "${each.value.template.displayName} Policy Set Definition at scope ${each.value.scope_id}"
  management_group_name = try(length(each.value.scope_id) > 0, false) ? basename(each.value.scope_id) : null
  metadata              = try(length(each.value.template.metadata) > 0, false) ? jsonencode(each.value.template.metadata) : local.empty_string
  parameters            = try(length(each.value.template.parameters) > 0, false) ? jsonencode(each.value.template.parameters) : local.empty_string

  # Set explicit dependency on Policy Definition deployments
  depends_on = [
    azurerm_policy_definition.enterprise_scale,
  ]

}
