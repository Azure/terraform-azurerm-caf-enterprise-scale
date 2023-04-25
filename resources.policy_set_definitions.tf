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
        parameters                  = try(jsonencode(item.parameters), null)
        policyDefinitionReferenceId = try(item.policyDefinitionReferenceId, null)
        groupNames                  = try(item.groupNames, null)
      }
    ]
    content {
      policy_definition_id = policy_definition_reference.value["policyDefinitionId"]
      parameter_values     = policy_definition_reference.value["parameters"]
      reference_id         = policy_definition_reference.value["policyDefinitionReferenceId"]
      policy_group_names   = policy_definition_reference.value["groupNames"]
    }
  }
  dynamic "policy_definition_group" {
    for_each = [for item in coalesce(each.value.template.properties.policyDefinitionGroups, []) :
      {
        name                 = item.name
        displayName          = try(item.displayName, null)
        description          = try(item.description, null)
        category             = try(item.category, null)
        additionalMetadataId = try(item.additionalMetadataId, null)
      } if item.name != null && item.name != ""
    ]
    content {
      name                            = policy_definition_group.value["name"]
      display_name                    = policy_definition_group.value["displayName"]
      category                        = policy_definition_group.value["category"]
      description                     = policy_definition_group.value["description"]
      additional_metadata_resource_id = policy_definition_group.value["additionalMetadataId"]
    }
  }


  # Optional resource attributes
  description         = try(each.value.template.properties.description, "${each.value.template.properties.displayName} Policy Set Definition at scope ${each.value.scope_id}")
  management_group_id = try(each.value.scope_id, null)
  metadata            = try(length(each.value.template.properties.metadata) > 0, false) ? jsonencode(each.value.template.properties.metadata) : null
  parameters          = try(length(each.value.template.properties.parameters) > 0, false) ? jsonencode(each.value.template.properties.parameters) : null

  # Set explicit dependency on Management Group and Policy Definition deployments
  depends_on = [
    time_sleep.after_azurerm_management_group,
    time_sleep.after_azurerm_policy_definition,
  ]

}

resource "time_sleep" "after_azurerm_policy_set_definition" {
  depends_on = [
    time_sleep.after_azurerm_management_group,
    time_sleep.after_azurerm_policy_definition,
    azurerm_policy_set_definition.enterprise_scale,
  ]

  triggers = {
    "azurerm_policy_set_definition_enterprise_scale" = jsonencode(keys(azurerm_policy_set_definition.enterprise_scale))
  }

  create_duration  = local.create_duration_delay["after_azurerm_policy_set_definition"]
  destroy_duration = local.destroy_duration_delay["after_azurerm_policy_set_definition"]
}
