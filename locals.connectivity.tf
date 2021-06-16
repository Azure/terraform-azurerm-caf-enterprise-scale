# The following locals are used to extract the Virtual Network
# configuration from the solution module outputs.
locals {
  es_virtual_network = module.connectivity_resources.configuration.azurerm_virtual_network
}

# The following locals are used to build the map of Virtual
# Networks to deploy.
locals {
  azurerm_virtual_network_enterprise_scale = {
    for resource in local.es_virtual_network :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to extract the Subnets
# configuration from the solution module outputs.
locals {
  es_subnet = module.connectivity_resources.configuration.azurerm_subnet
}

# The following locals are used to build the map of Subnets
# to deploy.
locals {
  azurerm_subnet_enterprise_scale = {
    for resource in local.es_subnet :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to extract the Virtual Network
# Gateway configuration from the solution module outputs.
locals {
  es_virtual_network_gateway = module.connectivity_resources.configuration.azurerm_virtual_network_gateway
}

# The following locals are used to build the map of Virtual
# Network Gateways to deploy.
locals {
  azurerm_virtual_network_gateway_enterprise_scale = {
    for resource in local.es_virtual_network_gateway :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to extract the Public IP
# configuration from the solution module outputs.
locals {
  es_public_ip = module.connectivity_resources.configuration.azurerm_public_ip
}

# The following locals are used to build the map of Public
# IPs to deploy.
locals {
  azurerm_public_ip_enterprise_scale = {
    for resource in local.es_public_ip :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to extract the Azure Firewall
# configuration from the solution module outputs.
locals {
  es_firewall = module.connectivity_resources.configuration.azurerm_firewall
}

# The following locals are used to build the map of Azure
# Firewalls to deploy.
locals {
  azurerm_firewall_enterprise_scale = {
    for resource in local.es_firewall :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to extract the DDoS Protection
# Plan configuration from the solution module outputs.
locals {
  es_network_ddos_protection_plan = module.connectivity_resources.configuration.azurerm_network_ddos_protection_plan
}

# The following locals are used to build the map of DDoS
# Protection Plans to deploy.
locals {
  azurerm_network_ddos_protection_plan_enterprise_scale = {
    for resource in local.es_network_ddos_protection_plan :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to extract the DNS Zone
# configuration from the solution module outputs.
locals {
  es_dns_zone = module.connectivity_resources.configuration.azurerm_dns_zone
}

# The following locals are used to build the map of DNS
# Zones to deploy.
locals {
  azurerm_dns_zone_enterprise_scale = {
    for resource in local.es_dns_zone :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to extract the Virtual Network
# Peering configuration from the solution module outputs.
locals {
  es_virtual_network_peering = module.connectivity_resources.configuration.azurerm_virtual_network_peering
}

# The following locals are used to build the map of Virtual
# Network Peerings to deploy.
locals {
  azurerm_virtual_network_peering_enterprise_scale = {
    for resource in local.es_virtual_network_peering :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}
