# The following output is used to ensure all Policy Set
# Definition data is returned to the root module.
output "azurerm_policy_set_definition" {
  value = {
    enterprise_scale = azurerm_policy_set_definition.enterprise_scale
  }
  description = "Returns the configuration data for all Policy Set Definitions created by this module."
}
