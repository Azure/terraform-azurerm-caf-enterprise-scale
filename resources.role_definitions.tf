resource "azurerm_role_definition" "enterprise_scale" {
  for_each = {
    for role in local.es_role_definitions_by_management_group :
    role.resource_id => role
  }

  # Special handling of OPTIONAL role_definition_id to ensure consistent and
  # correct mapping of Terraform state ADDR value to Azure Resource ID value.
  role_definition_id = basename(each.key)

  # Mandatory resource attributes
  name  = "[${upper(local.es_root_id)}] ${each.value.template.roleName}"
  scope = each.value.scope_id

  permissions {
    actions          = try(length(each.value.template.permissions[0].actions) > 0, false) ? each.value.template.permissions[0].actions : local.empty_list
    not_actions      = try(length(each.value.template.permissions[0].notActions) > 0, false) ? each.value.template.permissions[0].notActions : local.empty_list
    data_actions     = try(length(each.value.template.permissions[0].dataActions) > 0, false) ? each.value.template.permissions[0].dataActions : local.empty_list
    not_data_actions = try(length(each.value.template.permissions[0].notDataActions) > 0, false) ? each.value.template.permissions[0].notDataActions : local.empty_list
  }

  # Optional resource attributes
  description       = try(length(each.value.template.description) > 0, false) ? each.value.template.description : "${each.value.template.roleName} Role Definition at scope ${each.value.scope_id}"
  assignable_scopes = try(length(each.value.assignableScopes) > 0, false) ? each.value.assignableScopes : ["${each.value.scope_id}"]

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
