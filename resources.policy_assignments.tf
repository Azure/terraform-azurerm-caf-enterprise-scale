resource "azurerm_management_group_policy_assignment" "enterprise_scale" {
  for_each = local.azurerm_management_group_policy_assignment_enterprise_scale

  # Mandatory resource attributes
  # The policy assignment name length must not exceed '24' characters, but Terraform plan is unable to validate this in the plan stage. The following logic forces an error during plan if an invalid name length is specified.
  name                 = tonumber(length(each.value.template.name) > 24 ? "The policy assignment name '${each.value.template.name}' is invalid. The policy assignment name length must not exceed '24' characters." : length(each.value.template.name)) > 24 ? null : each.value.template.name
  management_group_id  = each.value.scope_id
  policy_definition_id = each.value.template.properties.policyDefinitionId

  # Optional resource attributes
  location     = try(each.value.template.location, null)
  description  = try(each.value.template.properties.description, "${each.value.template.name} Policy Assignment at scope ${each.value.scope_id}")
  display_name = try(each.value.template.properties.displayName, each.value.template.name)
  metadata     = try(length(each.value.template.properties.metadata) > 0, false) ? jsonencode(each.value.template.properties.metadata) : null
  parameters   = try(length(each.value.parameters) > 0, false) ? jsonencode(each.value.parameters) : null
  not_scopes   = try(each.value.template.properties.notScopes, local.empty_list)
  enforce      = each.value.enforcement_mode

  # Dynamic configuration blocks
  # The identity block only supports a single value
  # for type = "SystemAssigned" so the following logic
  # ensures the block is only created when this value
  # is specified in the source template
  dynamic "identity" {
    for_each = {
      for ik, iv in try(each.value.template.identity, local.empty_map) :
      ik => iv
      if lower(iv) == "systemassigned"
    }
    content {
      type = "SystemAssigned"
    }
  }

  # Optional Non-compliance messages
  # The mesage will have the placeholder replaced with 'must' or 'should' by default dependent on the enforcement mode
  # The language can the altered or localised using the variables
  dynamic "non_compliance_message" {
    for_each = local.policy_non_compliance_message_enabled ? (contains(local.non_compliance_message_supported_policy_modes, lookup(local.all_policy_modes, each.value.template.properties.policyDefinitionId, local.policy_set_mode)) ? lookup(each.value.template.properties, "nonComplianceMessages", local.default_non_compliance_message_list) : local.empty_list) : local.empty_list
    content {
      content                        = replace(lookup(non_compliance_message.value, "message", local.policy_non_compliance_message_default), local.non_compliance_message_enforcement_mode_placeholder, each.value.enforcement_mode ? local.non_compliance_message_enforcement_mode_replacements.default : local.non_compliance_message_enforcement_mode_replacements.donotenforce)
      policy_definition_reference_id = lookup(non_compliance_message.value, "policyDefinitionReferenceId", null)
    }
  }

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
    azurerm_management_group_policy_assignment.enterprise_scale,
  ]

  triggers = {
    "azurerm_management_group_policy_assignment_enterprise_scale" = jsonencode(keys(azurerm_management_group_policy_assignment.enterprise_scale))
  }

  create_duration  = local.create_duration_delay["after_azurerm_policy_assignment"]
  destroy_duration = local.destroy_duration_delay["after_azurerm_policy_assignment"]
}
