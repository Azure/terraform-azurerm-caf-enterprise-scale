resource "azurerm_policy_definition" "enterprise_scale" {
  for_each = local.azurerm_policy_definition_enterprise_scale

  # Mandatory resource attributes
  name         = each.value.template.name
  policy_type  = "Custom"
  mode         = each.value.template.properties.mode
  display_name = each.value.template.properties.displayName

  # Optional resource attributes
  description           = try(length(each.value.template.properties.description) > 0, false) ? each.value.template.properties.description : "${each.value.template.properties.displayName} Policy Definition at scope ${each.value.scope_id}"
  management_group_name = try(length(each.value.scope_id) > 0, false) ? basename(each.value.scope_id) : null
  policy_rule           = try(length(each.value.template.properties.policyRule) > 0, false) ? jsonencode(each.value.template.properties.policyRule) : local.empty_string
  metadata              = try(length(each.value.template.properties.metadata) > 0, false) ? jsonencode(each.value.template.properties.metadata) : local.empty_string
  parameters            = try(length(each.value.template.properties.parameters) > 0, false) ? jsonencode(each.value.template.properties.parameters) : local.empty_string

  # Set explicit dependency on Management Group deployments
  depends_on = [
    azurerm_management_group.level_1,
    azurerm_management_group.level_2,
    azurerm_management_group.level_3,
    azurerm_management_group.level_4,
    azurerm_management_group.level_5,
    azurerm_management_group.level_6,
  ]

}
