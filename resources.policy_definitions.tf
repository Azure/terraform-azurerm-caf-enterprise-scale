resource "azurerm_policy_definition" "enterprise_scale" {
  for_each = {
    for policy in local.es_policy_definitions_by_management_group :
    policy.resource_id => policy
  }

  # Mandatory resource attributes
  name         = each.value.template.displayName
  policy_type  = "Custom"
  mode         = each.value.template.mode
  display_name = each.value.template.displayName

  # Optional resource attributes
  description           = try(length(each.value.template.description) > 0, false) ? each.value.template.description : "${each.value.template.displayName} Policy Definition at scope ${each.value.scope_id}"
  management_group_name = try(length(each.value.scope_id) > 0, false) ? basename(each.value.scope_id) : null
  policy_rule           = try(length(each.value.template.policyRule) > 0, false) ? jsonencode(each.value.template.policyRule) : local.empty_string
  metadata              = try(length(each.value.template.metadata) > 0, false) ? jsonencode(each.value.template.metadata) : local.empty_string
  parameters            = try(length(each.value.template.parameters) > 0, false) ? jsonencode(each.value.template.parameters) : local.empty_string

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
