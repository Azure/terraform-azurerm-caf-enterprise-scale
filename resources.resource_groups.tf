resource "azurerm_resource_group" "enterprise_scale" {
  for_each = local.azurerm_resource_group_enterprise_scale

  # Mandatory resource attributes
  name     = each.value.template.name
  location = each.value.template.location
  tags     = each.value.template.tags
}
