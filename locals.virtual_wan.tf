# The following locals are used to build the map of Resource
# Groups to deploy.
locals {
  azurerm_resource_group_virtual_wan = {
    for resource in module.connectivity_resources.configuration.azurerm_resource_group :
    resource.resource_id => resource
    if resource.managed_by_module &&
    resource.scope == "virtual_wan"
  }
}

# The following locals are used to build the map of Azure
# Virtual WANs to deploy.
locals {
  azurerm_virtual_wan_virtual_wan = {
    for resource in module.connectivity_resources.configuration.azurerm_virtual_wan :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to build the map of Azure
# Virtual Hubs to deploy.
locals {
  azurerm_virtual_hub_virtual_wan = {
    for resource in module.connectivity_resources.configuration.azurerm_virtual_hub :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to build the map of Azure
# Expressroute Gateways to deploy.
locals {
  azurerm_express_route_gateway_virtual_wan = {
    for resource in module.connectivity_resources.configuration.azurerm_express_route_gateway :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to build the map of Azure
# VPN Gateways to deploy.
locals {
  azurerm_vpn_gateway_virtual_wan = {
    for resource in module.connectivity_resources.configuration.azurerm_vpn_gateway :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to build the map of Azure
# Firewall Policies to deploy.
locals {
  azurerm_firewall_policy_virtual_wan = {
    for resource in module.connectivity_resources.configuration.azurerm_firewall_policy :
    resource.resource_id => resource
    if resource.managed_by_module &&
    resource.scope == "virtual_wan"
  }
}

# The following locals are used to build the map of Azure
# Firewalls to deploy.
locals {
  azurerm_firewall_virtual_wan = {
    for resource in module.connectivity_resources.configuration.azurerm_firewall :
    resource.resource_id => resource
    if resource.managed_by_module &&
    resource.scope == "virtual_wan"
  }
}

# The following locals are used to build the map of Virtual
# Network Peerings to deploy.
locals {
  azurerm_virtual_hub_connection = {
    for resource in module.connectivity_resources.configuration.azurerm_virtual_hub_connection :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

locals {
  azurerm_virtual_hub_routing_intent = {
    for resource in module.connectivity_resources.configuration.azurerm_virtual_hub_routing_intent :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}
