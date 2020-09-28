# The following output is used to ensure all Policy
# Assignment data is returned to the root module.
output "azurerm_policy_assignment" {
  value = {
    enterprise_scale = azurerm_policy_assignment.enterprise_scale
  }
  description = "Returns the configuration data for all Policy Assignments created by this module."
}
