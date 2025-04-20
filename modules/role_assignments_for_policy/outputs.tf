# The following output is used to ensure all Role
# Assignment data is returned to the root module.
output "azurerm_role_assignment" {
  value       = local.azurerm_role_assignments
  description = "Returns the configuration data for Role Assignments to be created by the calling module."
}
