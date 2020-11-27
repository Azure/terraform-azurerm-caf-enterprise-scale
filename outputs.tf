# The following output is used to reconcile the multi-level
# Management Group deployments into a single data object to
# simplify consumption of configuration data from this group
# of resources.
output "azurerm_management_group" {
  value = {
    enterprise_scale = local.es_management_group_output
  }
  description = "Returns the configuration data for all Management Groups created by this module."
}

# The following output is used to ensure all Policy
# Definition data is returned to the root module.
output "azurerm_policy_definition" {
  value = {
    enterprise_scale = azurerm_policy_definition.enterprise_scale
  }
  description = "Returns the configuration data for all Policy Definitions created by this module."
}

# The following output is used to ensure all Policy Set
# Definition data is returned to the root module.
output "azurerm_policy_set_definition" {
  value = {
    enterprise_scale = azurerm_policy_set_definition.enterprise_scale
  }
  description = "Returns the configuration data for all Policy Set Definitions created by this module."
}

# The following output is used to ensure all Policy
# Assignment data is returned to the root module.
output "azurerm_policy_assignment" {
  value = {
    enterprise_scale = azurerm_policy_assignment.enterprise_scale
  }
  description = "Returns the configuration data for all Policy Assignments created by this module."
}

# The following output is used to ensure all Role
# Definition data is returned to the root module.
output "azurerm_role_definition" {
  value = {
    enterprise_scale = azurerm_role_definition.enterprise_scale
  }
  description = "Returns the configuration data for all Role Definitions created by this module."
}

# The following output is used to ensure all Role
# Assignment data is returned to the root module.
output "azurerm_role_assignment" {
  value = {
    enterprise_scale = azurerm_role_assignment.enterprise_scale
  }
  description = "Returns the configuration data for all Role Assignments created by this module."
}
