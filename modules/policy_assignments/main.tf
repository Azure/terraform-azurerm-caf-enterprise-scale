resource "azurerm_management_group_policy_assignment" "enterprise_scale" {
  count = local.scope_is_management_group ? 1 : 0

  # Mandatory resource attributes
  # The policy assignment name length must not exceed '24' characters, but Terraform plan is unable to validate this in the plan stage. The following logic forces an error during plan if an invalid name length is specified.
  name                 = tonumber(length(local.name) > 24 ? "The policy assignment name '${local.name}' is invalid. The policy assignment name length must not exceed '24' characters." : length(local.name)) > 24 ? null : local.name
  management_group_id  = local.scope_id
  policy_definition_id = local.policy_definition_id

  # Optional resource attributes
  location     = local.location
  description  = local.description
  display_name = local.display_name
  metadata     = length(local.metadata) > 0 ? jsonencode(local.metadata) : null
  parameters   = length(local.parameters) > 0 ? jsonencode(local.parameters) : null
  not_scopes   = local.not_scopes
  enforce      = local.enforce

  # Dynamic configuration blocks
  # The identity block only supports a single value
  # for type = "SystemAssigned" so the following logic
  # ensures the block is only created when this value
  # is specified in the source template
  dynamic "identity" {
    for_each = {
      for ik, iv in local.identity :
      ik => iv
      if lower(iv) == "systemassigned"
    }
    content {
      type = "SystemAssigned"
    }
  }

}

resource "azurerm_role_assignment" "policy_assignment" {
  for_each = local.azurerm_role_assignments

  # Special handling of OPTIONAL name to ensure consistent and correct
  # mapping of Terraform state ADDR value to Azure Resource ID value.
  name = each.value.name

  # Mandatory resource attributes
  scope        = each.value.scope
  principal_id = each.value.principal_id

  # Optional attributes
  role_definition_name = lookup(each.value, "role_definition_name", null)
  role_definition_id   = lookup(each.value, "role_definition_id", null)

  # Set explicit dependency on Management Group, Policy, and Role Definition deployments
  depends_on = [
    azurerm_management_group_policy_assignment.enterprise_scale
  ]

}
