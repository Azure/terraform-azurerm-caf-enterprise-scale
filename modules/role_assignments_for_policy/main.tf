resource "azurerm_role_assignment" "for_policy" {
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

}
