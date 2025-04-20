# The following output is used to ensure all Role
# Assignment data is returned to the root module.
output "azurerm_role_assignment" {
  value       = azurerm_role_assignment.for_policy
  description = "Returns the configuration data for all Role Assignments created by this module."
}
