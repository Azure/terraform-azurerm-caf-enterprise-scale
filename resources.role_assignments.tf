resource "azurerm_role_assignment" "enterprise_scale" {
  for_each = local.azurerm_role_assignment_enterprise_scale

  # Special handling of OPTIONAL name to ensure consistent and correct
  # mapping of Terraform state ADDR value to Azure Resource ID value.
  name = basename(each.key)

  # Mandatory resource attributes
  scope        = each.value.scope_id
  principal_id = each.value.principal_id

  # Optional attributes
  role_definition_name             = try(each.value.role_definition_name, null)
  role_definition_id               = try(each.value.role_definition_id, null)
  skip_service_principal_aad_check = try(each.value.skip_service_principal_aad_check, null)

  # Set explicit dependency on Management Group, Policy, and Role Definition deployments
  depends_on = [
    azurerm_management_group.level_1,
    azurerm_management_group.level_2,
    azurerm_management_group.level_3,
    azurerm_management_group.level_4,
    azurerm_management_group.level_5,
    azurerm_management_group.level_6,
    azurerm_policy_definition.enterprise_scale,
    azurerm_policy_set_definition.enterprise_scale,
    azurerm_policy_assignment.enterprise_scale,
    azurerm_role_definition.enterprise_scale,
  ]

}
