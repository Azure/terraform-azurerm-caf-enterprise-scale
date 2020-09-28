# The following output is used to ensure all Policy
# Definition data is returned to the root module.
output "azurerm_policy_definition" {
  value = {
    enterprise_scale = azurerm_policy_definition.enterprise_scale
  }
}
