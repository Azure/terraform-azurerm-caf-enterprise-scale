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
output "azurerm_management_group_policy_assignment" {
  value = {
    enterprise_scale = azurerm_management_group_policy_assignment.enterprise_scale
  }
  description = "Returns the configuration data for all Management Group Policy Assignments created by this module."
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
    management   = azurerm_resource_group.management
    connectivity = azurerm_resource_group.connectivity
  }
  description = "Returns the configuration data for all Resource Groups created by this module."
}

# The following output is used to ensure all Log Analytics
# Workspace data is returned to the root module.
# Includes logic to remove sensitive values.
output "azurerm_log_analytics_workspace" {
  value = {
    management = {
      for rk, rv in azurerm_log_analytics_workspace.management :
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
    management = azurerm_log_analytics_solution.management
  }
  description = "Returns the configuration data for all Log Analytics solutions created by this module."
}

# The following output is used to ensure all Automation
# Account data is returned to the root module.
output "azurerm_automation_account" {
  value = {
    management = azurerm_automation_account.management
  }
  description = "Returns the configuration data for all Automation Accounts created by this module."
}

# The following output is used to ensure all Log Analytics
# Linked Service data is returned to the root module.
output "azurerm_log_analytics_linked_service" {
  value = {
    management = azurerm_log_analytics_linked_service.management
  }
  description = "Returns the configuration data for all Log Analytics linked services created by this module."
}

# The following output is used to ensure all Virtual Network
# data is returned to the root module.
output "azurerm_virtual_network" {
  value = {
    connectivity = azurerm_virtual_network.connectivity
  }
  description = "Returns the configuration data for all Virtual Networks created by this module."
}

# The following output is used to ensure all Subnets
# data is returned to the root module.
output "azurerm_subnet" {
  value = {
    connectivity = azurerm_subnet.connectivity
  }
  description = "Returns the configuration data for all Subnets created by this module."
}

# The following output is used to ensure all DDoS Protection Plan
# data is returned to the root module.
output "azurerm_network_ddos_protection_plan" {
  value = {
    connectivity = azurerm_network_ddos_protection_plan.connectivity
  }
  description = "Returns the configuration data for all DDoS Protection Plans created by this module."
}

# The following output is used to ensure all Public IP
# data is returned to the root module.
output "azurerm_public_ip" {
  value = {
    connectivity = azurerm_public_ip.connectivity
  }
  description = "Returns the configuration data for all Public IPs created by this module."
}

# The following output is used to ensure all Virtual Network Gateway
# data is returned to the root module.
output "azurerm_virtual_network_gateway" {
  value = {
    connectivity = azurerm_virtual_network_gateway.connectivity
  }
  description = "Returns the configuration data for all Virtual Network Gateways created by this module."
}

# The following output is used to ensure all Azure Firewall
# data is returned to the root module.
output "azurerm_firewall" {
  value = {
    connectivity = azurerm_firewall.connectivity
  }
  description = "Returns the configuration data for all Azure Firewalls created by this module."
}
