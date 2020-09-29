# The following output is used to ensure all Role
# Definition data is returned to the root module.
output "azurerm_role_definition" {
  value = {
    enterprise_scale = azurerm_role_definition.enterprise_scale
  }
  description = "Returns the configuration data for all Role Definitions created by this module."
}
