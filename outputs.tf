# The following output is used to ensure all Management Group
# data is returned to the root module.
output "azurerm_management_group" {
  value = {
    level_1 = azurerm_management_group.level_1
    level_2 = azurerm_management_group.level_2
    level_3 = azurerm_management_group.level_3
    level_4 = azurerm_management_group.level_4
    level_5 = azurerm_management_group.level_5
    level_6 = azurerm_management_group.level_6
  }
  description = "Returns the configuration data for all Management Groups created by this module."
}

# The following output is used to ensure all Management Group
# Subscription Association data is returned to the root module.
output "azurerm_management_group_subscription_association" {
  value = {
    enterprise_scale = azurerm_management_group_subscription_association.enterprise_scale
  }
  description = "Returns the configuration data for all Management Group Subscription Associations created by this module."
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
    enterprise_scale  = azurerm_role_assignment.enterprise_scale
    policy_assignment = local.role_assignments_for_policy_output
  }
  description = "Returns the configuration data for all Role Assignments created by this module."
}

# The following output is used to ensure all Resource
# Group data is returned to the root module.
output "azurerm_resource_group" {
  value = {
    management   = azurerm_resource_group.management
    connectivity = azurerm_resource_group.connectivity
    virtual_wan  = azurerm_resource_group.virtual_wan
  }
  description = "Returns the configuration data for all Resource Groups created by this module."
}

# The following output is used to ensure all Log Analytics
# Workspace data is returned to the root module.
# Includes logic to remove sensitive values.
output "azurerm_log_analytics_workspace" {
  value = {
    management = azurerm_log_analytics_workspace.management
  }
  description = "Returns the configuration data for all Log Analytics workspaces created by this module."
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
# Policy data is returned to the root module.
output "azurerm_firewall_policy" {
  value = {
    connectivity = azurerm_firewall_policy.connectivity
    virtual_wan  = azurerm_firewall_policy.virtual_wan
  }
  description = "Returns the configuration data for all Azure Firewall Policies created by this module."
}

# The following output is used to ensure all Azure Firewall
# data is returned to the root module.
output "azurerm_firewall" {
  value = {
    connectivity = azurerm_firewall.connectivity
    virtual_wan  = azurerm_firewall.virtual_wan
  }
  description = "Returns the configuration data for all Azure Firewalls created by this module."
}

# The following output is used to ensure all Private DNS Zone
# data is returned to the root module.
output "azurerm_private_dns_zone" {
  value = {
    connectivity = azurerm_private_dns_zone.connectivity
  }
  description = "Returns the configuration data for all Private DNS Zones created by this module."
}

# The following output is used to ensure all DNS Zone
# data is returned to the root module.
output "azurerm_dns_zone" {
  value = {
    connectivity = azurerm_dns_zone.connectivity
  }
  description = "Returns the configuration data for all DNS Zones created by this module."
}

# The following output is used to ensure all Private DNS Zone network link
# data is returned to the root module.
output "azurerm_private_dns_zone_virtual_network_link" {
  value = {
    connectivity = azurerm_private_dns_zone_virtual_network_link.connectivity
  }
  description = "Returns the configuration data for all Private DNS Zone network links created by this module."
}

# The following output is used to ensure all Virtual Network Peering
# data is returned to the root module.
output "azurerm_virtual_network_peering" {
  value = {
    connectivity = azurerm_virtual_network_peering.connectivity
  }
  description = "Returns the configuration data for all Virtual Network Peerings created by this module."
}

# The following output is used to ensure all Virtual WAN
# data is returned to the root module.
output "azurerm_virtual_wan" {
  value = {
    virtual_wan = azurerm_virtual_wan.virtual_wan
  }
  description = "Returns the configuration data for all Virtual WANs created by this module."
}

# The following output is used to ensure all Virtual Hub
# data is returned to the root module.
output "azurerm_virtual_hub" {
  value = {
    virtual_wan = azurerm_virtual_hub.virtual_wan
  }
  description = "Returns the configuration data for all Virtual Hubs created by this module."
}

# The following output is used to ensure all ExpressRoute
# Gateway data is returned to the root module.
output "azurerm_express_route_gateway" {
  value = {
    virtual_wan = azurerm_express_route_gateway.virtual_wan
  }
  description = "Returns the configuration data for all (Virtual WAN) ExpressRoute Gateways created by this module."
}

# The following output is used to ensure all VPN
# Gateway data is returned to the root module.
output "azurerm_vpn_gateway" {
  value = {
    virtual_wan = azurerm_vpn_gateway.virtual_wan
  }
  description = "Returns the configuration data for all (Virtual WAN) VPN Gateways created by this module."
}

# The following output is used to ensure all ExpressRoute
# Gateway data is returned to the root module.
output "azurerm_virtual_hub_connection" {
  value = {
    virtual_wan = azurerm_virtual_hub_connection.virtual_wan
  }
  description = "Returns the configuration data for all Virtual Hub Connections created by this module."
}
