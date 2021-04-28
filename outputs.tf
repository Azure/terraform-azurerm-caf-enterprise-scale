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

# The following output is used to ensure all Resource
# Group data is returned to the root module.
output "azurerm_resource_group" {
  value = {
    enterprise_scale = azurerm_resource_group.enterprise_scale
  }
  description = "Returns the configuration data for all Resource Groups created by this module."
}

# The following output is used to ensure all Log Analytics
# Workspace data is returned to the root module.
# Includes logic to remove sensitive values.
output "azurerm_log_analytics_workspace" {
  value = {
    enterprise_scale = {
      for rk, rv in azurerm_log_analytics_workspace.enterprise_scale :
      rk => {
        for ak, av in rv :
        ak => av
        if contains(local.sensitive_attributes["azurerm_log_analytics_workspace"], ak) != true
      }
    }
  }
  description = "Returns the configuration data for all Log Analytics workspaces created by this module. Excludes sensitive values."
}

# The following output is used to ensure all Log Analytics
# Solution data is returned to the root module.
output "azurerm_log_analytics_solution" {
  value = {
    enterprise_scale = azurerm_log_analytics_solution.enterprise_scale
  }
  description = "Returns the configuration data for all Log Analytics solutions created by this module."
}

# The following output is used to ensure all Automation
# Account data is returned to the root module.
output "azurerm_automation_account" {
  value = {
    enterprise_scale = azurerm_automation_account.enterprise_scale
  }
  description = "Returns the configuration data for all Automation Accounts created by this module."
}

# The following output is used to ensure all Log Analytics
# Linked Service data is returned to the root module.
output "azurerm_log_analytics_linked_service" {
  value = {
    enterprise_scale = azurerm_log_analytics_linked_service.enterprise_scale
  }
  description = "Returns the configuration data for all Log Analytics linked services created by this module."
}
