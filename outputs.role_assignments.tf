# The following output is used to ensure all Role
# Assignment data is returned to the root module.
# <<<<<<<< PENDING DEVELOPMENT >>>>>>>>
output "azurerm_role_assignment" {
  value = {
    # enterprise_scale = azurerm_role_assignment.enterprise_scale
    enterprise_scale = {}
  }
  description = "Returns the configuration data for all Role Assignments created by this module."
}
