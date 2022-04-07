# The following locals are used to build the map of Resource
# Groups to deploy.
locals {
  azurerm_resource_group_connectivity = {
    for resource in module.connectivity_resources.configuration.azurerm_resource_group :
    resource.resource_id => resource
    if resource.managed_by_module &&
    contains(["connectivity", "ddos", "dns"], resource.scope)
  }
}

# The following locals are used to build the map of Virtual
# Networks to deploy.
locals {
  azurerm_virtual_network_connectivity = {
    for resource in module.connectivity_resources.configuration.azurerm_virtual_network :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to build the map of Subnets
# to deploy.
locals {
  azurerm_subnet_connectivity = {
    for resource in module.connectivity_resources.configuration.azurerm_subnet :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to build the map of Virtual
# Network Gateways to deploy.
locals {
  azurerm_virtual_network_gateway_connectivity = {
    for resource in module.connectivity_resources.configuration.azurerm_virtual_network_gateway :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to build the map of Public
# IPs to deploy.
locals {
  azurerm_public_ip_connectivity = {
    for resource in module.connectivity_resources.configuration.azurerm_public_ip :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to build the map of Azure
# Firewall Policies to deploy.
locals {
  azurerm_firewall_policy_connectivity = {
    for resource in module.connectivity_resources.configuration.azurerm_firewall_policy :
    resource.resource_id => resource
    if resource.managed_by_module &&
    resource.scope == "connectivity"
  }
}

# The following locals are used to build the map of Azure
# Firewalls to deploy.
locals {
  azurerm_firewall_connectivity = {
    for resource in module.connectivity_resources.configuration.azurerm_firewall :
    resource.resource_id => resource
    if resource.managed_by_module &&
    resource.scope == "connectivity"
  }
}

# The following locals are used to build the map of DDoS
# Protection Plans to deploy.
locals {
  azurerm_network_ddos_protection_plan_connectivity = {
    for resource in module.connectivity_resources.configuration.azurerm_network_ddos_protection_plan :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to build the map of Private DNS
# Zones to deploy.
locals {
  azurerm_private_dns_zone_connectivity = {
    for resource in module.connectivity_resources.configuration.azurerm_private_dns_zone :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to build the map of Public DNS
# Zones to deploy.
locals {
  azurerm_dns_zone_connectivity = {
    for resource in module.connectivity_resources.configuration.azurerm_dns_zone :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to build the map of Private DNS Zone
# Virtual Network Links to deploy.
locals {
  azurerm_private_dns_zone_virtual_network_link_connectivity = {
    for resource in module.connectivity_resources.configuration.azurerm_private_dns_zone_virtual_network_link :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to build the map of Virtual
# Network Peerings to deploy.
locals {
  azurerm_virtual_network_peering_connectivity = {
    for resource in module.connectivity_resources.configuration.azurerm_virtual_network_peering :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}
