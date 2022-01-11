# The following block of locals are used to avoid using
# empty object types in the code.
locals {
  empty_list   = []
  empty_map    = {}
  empty_string = ""
}

# Convert the input vars to locals, applying any required
# logic needed before they are used in the module.
# No vars should be referenced elsewhere in the module.
# NOTE: Need to catch error for resource_suffix when
# no value for subscription_id is provided.
locals {
  enabled                                   = var.enabled
  root_id                                   = var.root_id
  subscription_id                           = coalesce(var.subscription_id, "00000000-0000-0000-0000-000000000000")
  settings                                  = var.settings
  location                                  = var.location
  tags                                      = var.tags
  resource_prefix                           = coalesce(var.resource_prefix, local.root_id)
  resource_suffix                           = var.resource_suffix != null ? "-${var.resource_suffix}" : local.empty_string
  existing_ddos_protection_plan_resource_id = var.existing_ddos_protection_plan_resource_id
  existing_virtual_wan_resource_id          = var.existing_virtual_wan_resource_id != null ? var.existing_virtual_wan_resource_id : local.empty_string
  resource_group_per_virtual_hub_location   = var.resource_group_per_virtual_hub_location
  custom_settings                           = var.custom_settings_by_resource_type
}

# Logic to help keep code DRY
locals {
  hub_networks = local.settings.hub_networks
  # We generate the hub_networks_by_location as a map
  # to ensure the user has provided unique values for
  # each hub location. If duplicates are found,
  # terraform will throw an error at this point.
  hub_networks_by_location = {
    for hub_network in local.hub_networks :
    coalesce(hub_network.config.location, local.location) => hub_network
  }
  hub_network_locations = keys(local.hub_networks_by_location)
  virtual_hubs          = local.settings.vwan_hub_networks
  # We generate the virtual_hubs_by_location as a map
  # to ensure the user has provided unique values for
  # each hub location. If duplicates are found,
  # terraform will throw an error at this point.
  # By default we recommend creating all Virtual WAN
  # resources in a single Resource Group as per:
  # https://docs.microsoft.com/en-us/azure/virtual-wan/virtual-wan-faq#can-hubs-be-created-in-different-resource-group-in-virtual-wan
  # As this is only an issue for customers using the
  # Portal to manage Virtual WAN resources, the following
  # logic is used to allow a customer to use dedicated Resource
  # Groups per location if preferred.
  virtual_hubs_by_location = {
    for virtual_hub in local.virtual_hubs :
    coalesce(virtual_hub.config.location, local.location) => virtual_hub
  }
  virtual_hubs_by_location_for_resource_group_per_location = {
    for virtual_hub in local.virtual_hubs :
    coalesce(virtual_hub.config.location, local.location) => virtual_hub
    if local.resource_group_per_virtual_hub_location
  }
  virtual_hubs_by_location_for_shared_resource_group = {
    for virtual_hub in local.virtual_hubs :
    coalesce(virtual_hub.config.location, local.location) => virtual_hub
    if !local.resource_group_per_virtual_hub_location
  }
  # The following objects are used to identify azurerm_virtual_hub
  # resources which need to be associated with a new or existing
  # azurerm_virtual_wan resource
  virtual_hubs_by_location_for_managed_virtual_wan = {
    for virtual_hub in local.virtual_hubs :
    coalesce(virtual_hub.config.location, local.location) => virtual_hub
    if local.existing_virtual_wan_resource_id == ""
  }
  virtual_hubs_by_location_for_existing_virtual_wan = {
    for virtual_hub in local.virtual_hubs :
    coalesce(virtual_hub.config.location, local.location) => virtual_hub
    if local.existing_virtual_wan_resource_id != ""
  }
  # Need to know the full list of virtual_hub_locations
  # for azurerm_virtual_hub resource deployments.
  virtual_hub_locations = keys(local.virtual_hubs_by_location)
  # The azurerm_virtual_wan resource will be created in the
  # default location of the connectivity module if a new.
  virtual_wan_locations = anytrue(
    [
      length(local.virtual_hubs_by_location_for_managed_virtual_wan) > 0,
      length(local.virtual_hubs_by_location_for_shared_resource_group) > 0,
    ]
  ) ? [local.location, ] : local.empty_list
  ddos_location = coalesce(local.settings.ddos_protection_plan.config.location, local.location)
  dns_location  = coalesce(local.settings.dns.config.location, local.location)
  connectivity_locations = distinct(concat(
    local.hub_network_locations,
    keys(local.virtual_hubs_by_location_for_resource_group_per_location),
  ))
  result_when_location_missing = {
    enabled = false
  }
}

# Logic to determine whether specific resources
# should be created by this module
# - Resource Groups
locals {
  deploy_resource_groups = {
    connectivity = {
      for location in local.connectivity_locations :
      location =>
      local.enabled &&
      anytrue(
        [
          lookup(local.hub_networks_by_location, location, local.result_when_location_missing).enabled,
          lookup(local.virtual_hubs_by_location_for_resource_group_per_location, location, local.result_when_location_missing).enabled,
        ]
      )
    }
    virtual_wan = {
      for location in local.virtual_wan_locations :
      location =>
      local.enabled &&
      anytrue(concat(
        values(local.virtual_hubs_by_location_for_managed_virtual_wan).*.enabled,
        values(local.virtual_hubs_by_location_for_shared_resource_group).*.enabled,
      ))
    }
    ddos = {
      (local.ddos_location) = local.deploy_ddos_protection_plan
    }
    dns = {
      (local.dns_location) = local.deploy_dns
    }
  }
}

# Logic to determine whether specific resources
# should be created by this module
# - DDoS Protection Plan
locals {
  deploy_ddos_protection_plan = local.enabled && local.settings.ddos_protection_plan.enabled
}

# Logic to determine whether specific resources
# should be created by this module
# - DNS
locals {
  deploy_dns                                             = local.enabled && local.settings.dns.enabled
  deploy_private_dns_zone_virtual_network_link_on_hubs   = local.deploy_dns && local.settings.dns.config.enable_private_dns_zone_virtual_network_link_on_hubs
  deploy_private_dns_zone_virtual_network_link_on_spokes = local.deploy_dns && local.settings.dns.config.enable_private_dns_zone_virtual_network_link_on_spokes
}

# Logic to determine whether specific resources
# should be created by this module
# - Hub networks
locals {
  deploy_hub_network = {
    for location, hub_network in local.hub_networks_by_location :
    location =>
    local.enabled &&
    hub_network.enabled
  }
  deploy_virtual_network_gateway = {
    for location, hub_network in local.hub_networks_by_location :
    location =>
    local.deploy_hub_network[location] &&
    hub_network.config.virtual_network_gateway.enabled &&
    hub_network.config.virtual_network_gateway.config.address_prefix != local.empty_string
  }
  deploy_virtual_network_gateway_express_route = {
    for location, hub_network in local.hub_networks_by_location :
    location =>
    local.deploy_virtual_network_gateway[location] &&
    hub_network.config.virtual_network_gateway.config.gateway_sku_expressroute != local.empty_string
  }
  deploy_virtual_network_gateway_vpn = {
    for location, hub_network in local.hub_networks_by_location :
    location =>
    local.deploy_virtual_network_gateway[location] &&
    hub_network.config.virtual_network_gateway.config.gateway_sku_vpn != local.empty_string
  }
  deploy_azure_firewall = {
    for location, hub_network in local.hub_networks_by_location :
    location =>
    local.deploy_hub_network[location] &&
    hub_network.config.azure_firewall.enabled
  }
  deploy_outbound_virtual_network_peering = {
    for location, hub_network in local.hub_networks_by_location :
    location =>
    local.deploy_dns &&
    local.deploy_hub_network[location] &&
    hub_network.config.enable_outbound_virtual_network_peering
  }
}

# Logic to determine whether specific resources
# should be created by this module
# - VWAN hub networks
locals {
  deploy_virtual_wan = {
    (local.location) = (
      local.enabled &&
      local.existing_virtual_wan_resource_id == "" &&
      anytrue(values(local.deploy_virtual_hub))
    )
  }
  deploy_virtual_hub = {
    for location, virtual_hub in local.virtual_hubs_by_location :
    location =>
    local.enabled &&
    virtual_hub.enabled
  }
  deploy_virtual_hub_express_route_gateway = {
    for location, virtual_hub in local.virtual_hubs_by_location :
    location =>
    local.deploy_virtual_hub[location] &&
    virtual_hub.config.expressroute_gateway.enabled
  }
  deploy_virtual_hub_vpn_gateway = {
    for location, virtual_hub in local.virtual_hubs_by_location :
    location =>
    local.deploy_virtual_hub[location] &&
    virtual_hub.config.vpn_gateway.enabled
  }
  deploy_virtual_hub_azure_firewall = {
    for location, virtual_hub in local.virtual_hubs_by_location :
    location =>
    local.deploy_virtual_hub[location] &&
    virtual_hub.config.azure_firewall.enabled
  }
  deploy_virtual_hub_connection = {
    for location, virtual_hub in local.virtual_hubs_by_location :
    location =>
    local.deploy_virtual_hub[location] &&
    virtual_hub.config.enable_virtual_hub_connections
  }
}

# Configuration settings for resource type:
#  - azurerm_resource_group
locals {
  # Determine the name of each Resource Group per scope and location
  resource_group_names_by_scope_and_location = {
    connectivity = {
      for location in local.connectivity_locations :
      location =>
      try(local.custom_settings.azurerm_resource_group["connectivity"][location].name,
      "${local.resource_prefix}-connectivity-${location}${local.resource_suffix}")
    }
    virtual_wan = {
      for location in local.virtual_wan_locations :
      location =>
      try(local.custom_settings.azurerm_resource_group["virtual_wan"][location].name,
      "${local.resource_prefix}-connectivity${local.resource_suffix}")
    }
    ddos = {
      (local.ddos_location) = try(local.custom_settings.azurerm_resource_group["ddos"][local.ddos_location].name,
      "${local.resource_prefix}-ddos${local.resource_suffix}")
    }
    dns = {
      (local.dns_location) = try(local.custom_settings.azurerm_resource_group["dns"][local.dns_location].name,
      "${local.resource_prefix}-dns${local.resource_suffix}")
    }
  }
  # Generate a map of settings for each Resource Group per scope and location
  resource_group_config_by_scope_and_location = {
    for scope, resource_groups in local.resource_group_names_by_scope_and_location :
    scope => {
      for location, name in resource_groups :
      location => {
        # Resource logic attributes
        resource_id = "/subscriptions/${local.subscription_id}/resourceGroups/${name}"
        scope       = scope
        # Resource definition attributes
        name     = name
        location = location
        tags     = try(local.custom_settings.azurerm_resource_group[scope][location].tags, local.tags)
      }
    }
  }
  # Create a flattened list of resource group configuration blocks for deployment
  azurerm_resource_group = flatten([
    for scope in keys(local.resource_group_config_by_scope_and_location) :
    [
      for config in local.resource_group_config_by_scope_and_location[scope] :
      config
    ]
  ])
}

# # Configuration settings for resource type:
# #  - azurerm_network_ddos_protection_plan
locals {
  ddos_resource_group_id = local.resource_group_config_by_scope_and_location["ddos"][local.ddos_location].resource_id
  ddos_protection_plan_name = try(local.custom_settings.azurerm_network_ddos_protection_plan["ddos"][local.ddos_location].name,
  "${local.resource_prefix}-ddos-${local.ddos_location}${local.resource_suffix}")
  ddos_protection_plan_resource_id = coalesce(
    local.existing_ddos_protection_plan_resource_id,
    "${local.ddos_resource_group_id}/providers/Microsoft.Network/ddosProtectionPlans/${local.ddos_protection_plan_name}"
  )
  azurerm_network_ddos_protection_plan = [
    {
      # Resource logic attributes
      resource_id       = local.ddos_protection_plan_resource_id
      managed_by_module = local.deploy_ddos_protection_plan
      # Resource definition attributes
      name                = local.ddos_protection_plan_name
      location            = local.ddos_location
      resource_group_name = local.resource_group_config_by_scope_and_location["ddos"][local.ddos_location].name
      tags                = try(local.custom_settings.azurerm_network_ddos_protection_plan["ddos"][local.ddos_location].tags, local.tags)
    }
  ]
}

# Configuration settings for resource type:
#  - azurerm_virtual_network
locals {
  virtual_network_name = {
    for location in local.hub_network_locations :
    location =>
    try(local.custom_settings.azurerm_virtual_network["connectivity"][location].name,
    "${local.resource_prefix}-hub-${location}${local.resource_suffix}")
  }
  virtual_network_resource_group_id = {
    for location in local.hub_network_locations :
    location =>
    local.resource_group_config_by_scope_and_location["connectivity"][location].resource_id
  }
  virtual_network_resource_id_prefix = {
    for location in local.hub_network_locations :
    location =>
    "${local.virtual_network_resource_group_id[location]}/providers/Microsoft.Network/virtualNetworks"
  }
  virtual_network_resource_id = {
    for location in local.hub_network_locations :
    location =>
    "${local.virtual_network_resource_id_prefix[location]}/${local.virtual_network_name[location]}"
  }
  azurerm_virtual_network = [
    for location, hub_config in local.hub_networks_by_location :
    {
      # Resource logic attributes
      resource_id = local.virtual_network_resource_id[location]
      # Resource definition attributes
      name                = local.virtual_network_name[location]
      resource_group_name = local.resource_group_names_by_scope_and_location["connectivity"][location]
      address_space       = hub_config.config.address_space
      location            = location
      bgp_community       = hub_config.config.bgp_community != local.empty_string ? hub_config.config.bgp_community : null
      dns_servers         = hub_config.config.dns_servers
      tags                = try(local.custom_settings.azurerm_virtual_network["connectivity"][location].tags, local.tags)
      ddos_protection_plan = hub_config.config.link_to_ddos_protection_plan ? [
        {
          id     = local.ddos_protection_plan_resource_id
          enable = true
        }
      ] : local.empty_list
    }
  ]
}

# Configuration settings for resource type:
#  - azurerm_subnet
locals {
  subnets_by_virtual_network = {
    for location, hub_network in local.hub_networks_by_location :
    local.virtual_network_resource_id[location] => concat(
      # Get customer specified subnets and add additional required attributes
      [
        for subnet in hub_network.config.subnets : merge(
          subnet,
          {
            # Resource logic attributes
            resource_id = "${local.virtual_network_resource_id[location]}/subnets/${subnet.name}"
            location    = location
            # Resource definition attributes
            resource_group_name                            = local.resource_group_names_by_scope_and_location["connectivity"][location]
            virtual_network_name                           = local.virtual_network_name[location]
            enforce_private_link_endpoint_network_policies = try(local.custom_settings.azurerm_subnet["connectivity"][location][subnet.name].enforce_private_link_endpoint_network_policies, null)
            enforce_private_link_service_network_policies  = try(local.custom_settings.azurerm_subnet["connectivity"][location][subnet.name].enforce_private_link_service_network_policies, null)
            service_endpoints                              = try(local.custom_settings.azurerm_subnet["connectivity"][location][subnet.name].service_endpoints, null)
            service_endpoint_policy_ids                    = try(local.custom_settings.azurerm_subnet["connectivity"][location][subnet.name].service_endpoint_policy_ids, null)
            delegation                                     = try(local.custom_settings.azurerm_subnet["connectivity"][location][subnet.name].delegation, local.empty_list)
          }
        )
      ],
      # Conditionally add Virtual Network Gateway subnet
      hub_network.config.virtual_network_gateway.config.address_prefix != local.empty_string ? [
        {
          # Resource logic attributes
          resource_id               = "${local.virtual_network_resource_id[location]}/subnets/GatewaySubnet"
          location                  = location
          network_security_group_id = null
          route_table_id            = null
          # Resource definition attributes
          name                                           = "GatewaySubnet"
          address_prefixes                               = [hub_network.config.virtual_network_gateway.config.address_prefix, ]
          resource_group_name                            = local.resource_group_names_by_scope_and_location["connectivity"][location]
          virtual_network_name                           = local.virtual_network_name[location]
          enforce_private_link_endpoint_network_policies = try(local.custom_settings.azurerm_subnet["connectivity"][location]["GatewaySubnet"].enforce_private_link_endpoint_network_policies, null)
          enforce_private_link_service_network_policies  = try(local.custom_settings.azurerm_subnet["connectivity"][location]["GatewaySubnet"].enforce_private_link_service_network_policies, null)
          service_endpoints                              = try(local.custom_settings.azurerm_subnet["connectivity"][location]["GatewaySubnet"].service_endpoints, null)
          service_endpoint_policy_ids                    = try(local.custom_settings.azurerm_subnet["connectivity"][location]["GatewaySubnet"].service_endpoint_policy_ids, null)
          delegation                                     = try(local.custom_settings.azurerm_subnet["connectivity"][location]["GatewaySubnet"].delegation, local.empty_list)
        }
      ] : local.empty_list,
      # Conditionally add Azure Firewall subnet
      hub_network.config.azure_firewall.config.address_prefix != local.empty_string ? [
        {
          # Resource logic attributes
          resource_id               = "${local.virtual_network_resource_id[location]}/subnets/AzureFirewallSubnet"
          location                  = location
          network_security_group_id = null
          route_table_id            = null
          # Resource definition attributes
          name                                           = "AzureFirewallSubnet"
          address_prefixes                               = [hub_network.config.azure_firewall.config.address_prefix, ]
          resource_group_name                            = local.resource_group_names_by_scope_and_location["connectivity"][location]
          virtual_network_name                           = local.virtual_network_name[location]
          enforce_private_link_endpoint_network_policies = try(local.custom_settings.azurerm_subnet["connectivity"][location]["AzureFirewallSubnet"].enforce_private_link_endpoint_network_policies, null)
          enforce_private_link_service_network_policies  = try(local.custom_settings.azurerm_subnet["connectivity"][location]["AzureFirewallSubnet"].enforce_private_link_service_network_policies, null)
          service_endpoints                              = try(local.custom_settings.azurerm_subnet["connectivity"][location]["AzureFirewallSubnet"].service_endpoints, null)
          service_endpoint_policy_ids                    = try(local.custom_settings.azurerm_subnet["connectivity"][location]["AzureFirewallSubnet"].service_endpoint_policy_ids, null)
          delegation                                     = try(local.custom_settings.azurerm_subnet["connectivity"][location]["AzureFirewallSubnet"].delegation, local.empty_list)
        }
      ] : local.empty_list,
    )
  }
  azurerm_subnet = flatten([
    for subnets in local.subnets_by_virtual_network :
    subnets
  ])
}

# Configuration settings for resource type:
#  - azurerm_virtual_network_gateway (ExpressRoute)
locals {
  er_gateway_name = {
    for location in local.hub_network_locations :
    location =>
    try(local.custom_settings.azurerm_virtual_network_gateway["expressroute"][location].name,
    "${local.resource_prefix}-ergw-${location}${local.resource_suffix}")
  }
  er_gateway_resource_id_prefix = {
    for location in local.hub_network_locations :
    location =>
    "${local.virtual_network_resource_group_id[location]}/providers/Microsoft.Network/virtualNetworkGateways"
  }
  er_gateway_resource_id = {
    for location in local.hub_network_locations :
    location =>
    "${local.er_gateway_resource_id_prefix[location]}/${local.er_gateway_name[location]}"
  }
  er_gateway_config = [
    for location, hub_network in local.hub_networks_by_location :
    {
      # Resource logic attributes
      resource_id       = local.er_gateway_resource_id[location]
      managed_by_module = local.deploy_virtual_network_gateway_express_route[location]
      # Resource definition attributes
      name                = local.er_gateway_name[location]
      resource_group_name = local.resource_group_names_by_scope_and_location["connectivity"][location]
      location            = location
      type                = "ExpressRoute"
      sku                 = hub_network.config.virtual_network_gateway.config.gateway_sku_expressroute
      ip_configuration = try(
        # To support `active_active = true` must currently specify a custom ip_configuration
        local.custom_settings.azurerm_virtual_network_gateway["connectivity"]["ergw"][location].ip_configuration,
        [
          {
            name                          = "${local.er_gateway_name[location]}-pip"
            private_ip_address_allocation = null
            subnet_id                     = "${local.virtual_network_resource_id[location]}/subnets/GatewaySubnet"
            public_ip_address_id          = "${local.virtual_network_resource_group_id[location]}/providers/Microsoft.Network/publicIPAddresses/${local.er_gateway_name[location]}-pip"
          }
        ]
      )
      vpn_type                         = try(local.custom_settings.azurerm_virtual_network_gateway["connectivity"]["ergw"][location].vpn_type, "RouteBased")
      enable_bgp                       = try(local.custom_settings.azurerm_virtual_network_gateway["connectivity"]["ergw"][location].enable_bgp, true)
      active_active                    = try(local.custom_settings.azurerm_virtual_network_gateway["connectivity"]["ergw"][location].active_active, false)
      private_ip_address_enabled       = try(local.custom_settings.azurerm_virtual_network_gateway["connectivity"]["ergw"][location].private_ip_address_enabled, null)
      default_local_network_gateway_id = try(local.custom_settings.azurerm_virtual_network_gateway["connectivity"]["ergw"][location].default_local_network_gateway_id, null)
      generation                       = try(local.custom_settings.azurerm_virtual_network_gateway["connectivity"]["ergw"][location].generation, null)
      vpn_client_configuration         = try(local.custom_settings.azurerm_virtual_network_gateway["connectivity"]["ergw"][location].vpn_client_configuration, local.empty_list)
      bgp_settings                     = try(local.custom_settings.azurerm_virtual_network_gateway["connectivity"]["ergw"][location].bgp_settings, local.empty_list)
      custom_route                     = try(local.custom_settings.azurerm_virtual_network_gateway["connectivity"]["ergw"][location].custom_route, local.empty_list)
      tags                             = try(local.custom_settings.azurerm_virtual_network_gateway["connectivity"]["ergw"][location].tags, local.tags)
      # Child resource definition attributes
      azurerm_public_ip = {
        # Resource logic attributes
        resource_id       = "${local.virtual_network_resource_group_id[location]}/providers/Microsoft.Network/publicIPAddresses/${local.er_gateway_name[location]}-pip"
        managed_by_module = local.deploy_virtual_network_gateway_express_route[location]
        # Resource definition attributes
        name                    = "${local.er_gateway_name[location]}-pip"
        resource_group_name     = local.resource_group_names_by_scope_and_location["connectivity"][location]
        location                = location
        sku                     = try(local.custom_settings.azurerm_public_ip["connectivity"]["ergw"][location].sku, "Standard")
        ip_version              = try(local.custom_settings.azurerm_public_ip["connectivity"]["ergw"][location].ip_version, null)
        idle_timeout_in_minutes = try(local.custom_settings.azurerm_public_ip["connectivity"]["ergw"][location].idle_timeout_in_minutes, null)
        domain_name_label       = try(local.custom_settings.azurerm_public_ip["connectivity"]["ergw"][location].domain_name_label, null)
        reverse_fqdn            = try(local.custom_settings.azurerm_public_ip["connectivity"]["ergw"][location].reverse_fqdn, null)
        public_ip_prefix_id     = try(local.custom_settings.azurerm_public_ip["connectivity"]["ergw"][location].public_ip_prefix_id, null)
        ip_tags                 = try(local.custom_settings.azurerm_public_ip["connectivity"]["ergw"][location].ip_tags, null)
        tags                    = try(local.custom_settings.azurerm_public_ip["connectivity"]["ergw"][location].tags, local.tags)
        allocation_method = try(
          local.custom_settings.azurerm_public_ip["connectivity"]["ergw"][location].allocation_method,
          try(local.custom_settings.azurerm_public_ip["connectivity"]["ergw"][location].sku, "Standard") == "Standard" ? "Static" : "Dynamic"
        )
        availability_zone = try(
          local.custom_settings.azurerm_public_ip["connectivity"]["ergw"][location].availability_zone,
          length(regexall("AZ$", hub_network.config.virtual_network_gateway.config.gateway_sku_expressroute)) > 0 ? "Zone-Redundant" : "No-Zone"
        )
      }
    }
  ]
}

# Configuration settings for resource type:
#  - azurerm_virtual_network_gateway (VPN)
locals {
  vpn_gateway_name = {
    for location in local.hub_network_locations :
    location =>
    try(local.custom_settings.azurerm_virtual_network_gateway["vpn"][location].name,
    "${local.resource_prefix}-vpngw-${location}${local.resource_suffix}")
  }
  vpn_gateway_resource_id_prefix = {
    for location in local.hub_network_locations :
    location =>
    "${local.virtual_network_resource_group_id[location]}/providers/Microsoft.Network/virtualNetworkGateways"
  }
  vpn_gateway_resource_id = {
    for location in local.hub_network_locations :
    location =>
    "${local.vpn_gateway_resource_id_prefix[location]}/${local.vpn_gateway_name[location]}"
  }
  vpn_gateway_config = [
    for location, hub_network in local.hub_networks_by_location :
    {
      # Resource logic attributes
      resource_id       = local.vpn_gateway_resource_id[location]
      managed_by_module = local.deploy_virtual_network_gateway_vpn[location]
      # Resource definition attributes
      name                = local.vpn_gateway_name[location]
      resource_group_name = local.resource_group_names_by_scope_and_location["connectivity"][location]
      location            = location
      type                = "Vpn"
      sku                 = hub_network.config.virtual_network_gateway.config.gateway_sku_vpn
      ip_configuration = try(
        # To support `active_active = true` must currently specify a custom ip_configuration
        local.custom_settings.azurerm_virtual_network_gateway["connectivity"]["vpngw"][location].ip_configuration,
        [
          {
            name                          = "${local.vpn_gateway_name[location]}-pip"
            private_ip_address_allocation = null
            subnet_id                     = "${local.virtual_network_resource_id[location]}/subnets/GatewaySubnet"
            public_ip_address_id          = "${local.virtual_network_resource_group_id[location]}/providers/Microsoft.Network/publicIPAddresses/${local.vpn_gateway_name[location]}-pip"
          }
        ]
      )
      vpn_type                         = try(local.custom_settings.azurerm_virtual_network_gateway["connectivity"]["vpngw"][location].vpn_type, "RouteBased")
      enable_bgp                       = try(local.custom_settings.azurerm_virtual_network_gateway["connectivity"]["vpngw"][location].enable_bgp, false)
      active_active                    = try(local.custom_settings.azurerm_virtual_network_gateway["connectivity"]["vpngw"][location].active_active, false)
      private_ip_address_enabled       = try(local.custom_settings.azurerm_virtual_network_gateway["connectivity"]["vpngw"][location].private_ip_address_enabled, null)
      default_local_network_gateway_id = try(local.custom_settings.azurerm_virtual_network_gateway["connectivity"]["vpngw"][location].default_local_network_gateway_id, null)
      generation                       = try(local.custom_settings.azurerm_virtual_network_gateway["connectivity"]["vpngw"][location].generation, null)
      vpn_client_configuration         = try(local.custom_settings.azurerm_virtual_network_gateway["connectivity"]["vpngw"][location].vpn_client_configuration, local.empty_list)
      bgp_settings                     = try(local.custom_settings.azurerm_virtual_network_gateway["connectivity"]["vpngw"][location].bgp_settings, local.empty_list)
      custom_route                     = try(local.custom_settings.azurerm_virtual_network_gateway["connectivity"]["vpngw"][location].custom_route, local.empty_list)
      tags                             = try(local.custom_settings.azurerm_virtual_network_gateway["connectivity"]["vpngw"][location].tags, local.tags)
      # Child resource definition attributes
      azurerm_public_ip = {
        # Resource logic attributes
        resource_id       = "${local.virtual_network_resource_group_id[location]}/providers/Microsoft.Network/publicIPAddresses/${local.vpn_gateway_name[location]}-pip"
        managed_by_module = local.deploy_virtual_network_gateway_vpn[location]
        # Resource definition attributes
        name                    = "${local.vpn_gateway_name[location]}-pip"
        resource_group_name     = local.resource_group_names_by_scope_and_location["connectivity"][location]
        location                = location
        ip_version              = try(local.custom_settings.azurerm_public_ip["connectivity"]["vpngw"][location].ip_version, null)
        idle_timeout_in_minutes = try(local.custom_settings.azurerm_public_ip["connectivity"]["vpngw"][location].idle_timeout_in_minutes, null)
        domain_name_label       = try(local.custom_settings.azurerm_public_ip["connectivity"]["vpngw"][location].domain_name_label, null)
        reverse_fqdn            = try(local.custom_settings.azurerm_public_ip["connectivity"]["vpngw"][location].reverse_fqdn, null)
        public_ip_prefix_id     = try(local.custom_settings.azurerm_public_ip["connectivity"]["vpngw"][location].public_ip_prefix_id, null)
        ip_tags                 = try(local.custom_settings.azurerm_public_ip["connectivity"]["vpngw"][location].ip_tags, null)
        tags                    = try(local.custom_settings.azurerm_public_ip["connectivity"]["vpngw"][location].tags, local.tags)
        sku = try(
          local.custom_settings.azurerm_public_ip["connectivity"]["vpngw"][location].sku,
          length(regexall("AZ$", hub_network.config.virtual_network_gateway.config.gateway_sku_vpn)) > 0 ? "Standard" : "Basic"
        )
        allocation_method = try(
          local.custom_settings.azurerm_public_ip["connectivity"]["vpngw"][location].allocation_method,
          length(regexall("AZ$", hub_network.config.virtual_network_gateway.config.gateway_sku_vpn)) > 0 ? "Static" : "Dynamic"
        )
        availability_zone = try(
          local.custom_settings.azurerm_public_ip["connectivity"]["vpngw"][location].availability_zone,
          length(regexall("AZ$", hub_network.config.virtual_network_gateway.config.gateway_sku_vpn)) > 0 ? "Zone-Redundant" : "No-Zone"
        )
      }
    }
  ]
}

# Configuration settings for resource type:
#  - azurerm_virtual_network_gateway
locals {
  azurerm_virtual_network_gateway = concat(
    local.er_gateway_config,
    local.vpn_gateway_config,
  )
}

# Configuration settings for resource type:
#  - azurerm_firewall
# For VWAN, VPN gateway is required for Security Partner Provider integration
locals {
  azfw_name = {
    for location in local.hub_network_locations :
    location => "${local.resource_prefix}-fw-${location}${local.resource_suffix}"
  }
  virtual_hub_azfw_name = {
    for location in local.virtual_hub_locations :
    location => "${local.resource_prefix}-fw-hub-${location}${local.resource_suffix}"
  }
  azfw_resource_id_prefix = {
    for location in local.hub_network_locations :
    location =>
    "${local.virtual_network_resource_group_id[location]}/providers/Microsoft.Network/azureFirewalls"
  }
  virtual_hub_azfw_resource_id_prefix = {
    for location in local.virtual_hub_locations :
    location =>
    "${local.virtual_hub_resource_group_id[location]}/providers/Microsoft.Network/azureFirewalls"
  }
  azfw_resource_id = {
    for location in local.hub_network_locations :
    location =>
    "${local.azfw_resource_id_prefix[location]}/${local.azfw_name[location]}"
  }
  virtual_hub_azfw_resource_id = {
    for location in local.virtual_hub_locations :
    location =>
    "${local.virtual_hub_azfw_resource_id_prefix[location]}/${local.virtual_hub_azfw_name[location]}"
  }
  azfw_zones = {
    for location, hub_network in local.hub_networks_by_location :
    location =>
    flatten(
      [
        hub_network.config.azure_firewall.config.availability_zones.zone_1 ? ["1"] : [],
        hub_network.config.azure_firewall.config.availability_zones.zone_2 ? ["2"] : [],
        hub_network.config.azure_firewall.config.availability_zones.zone_3 ? ["3"] : [],
      ]
    )
  }
  azfw_zones_enabled = {
    for location, hub_network in local.hub_networks_by_location :
    location =>
    length(local.azfw_zones[location]) > 0
  }
  azurerm_firewall = concat(
    [
      for location, hub_network in local.hub_networks_by_location :
      {
        # Resource logic attributes
        resource_id       = local.azfw_resource_id[location]
        managed_by_module = local.deploy_azure_firewall[location]
        scope             = "connectivity"
        # Resource definition attributes
        name                = local.azfw_name[location]
        resource_group_name = local.resource_group_names_by_scope_and_location["connectivity"][location]
        location            = location
        ip_configuration = try(
          local.custom_settings.azurerm_firewall["connectivity"][location].ip_configuration,
          [
            {
              name                 = "${local.azfw_name[location]}-pip"
              public_ip_address_id = "${local.virtual_network_resource_group_id[location]}/providers/Microsoft.Network/publicIPAddresses/${local.azfw_name[location]}-pip"
              subnet_id            = "${local.virtual_network_resource_id[location]}/subnets/AzureFirewallSubnet"
            }
          ]
        )
        sku_name                    = "AZFW_VNet"
        sku_tier                    = try(local.custom_settings.azurerm_firewall["connectivity"][location].sku_tier, "Standard")
        firewall_policy_id          = try(local.custom_settings.azurerm_firewall["connectivity"][location].firewall_policy_id, null)
        dns_servers                 = try(local.custom_settings.azurerm_firewall["connectivity"][location].dns_servers, null)
        private_ip_ranges           = try(local.custom_settings.azurerm_firewall["connectivity"][location].private_ip_ranges, null)
        management_ip_configuration = try(local.custom_settings.azurerm_firewall["connectivity"][location].management_ip_configuration, local.empty_list)
        threat_intel_mode           = try(local.custom_settings.azurerm_firewall["connectivity"][location].threat_intel_mode, null)
        virtual_hub                 = local.empty_list
        zones                       = try(local.custom_settings.azurerm_firewall["connectivity"][location].zones, local.azfw_zones[location])
        tags                        = try(local.custom_settings.azurerm_firewall["connectivity"][location].tags, local.tags)
        # Child resource definition attributes
        azurerm_public_ip = {
          # Resource logic attributes
          resource_id       = "${local.virtual_network_resource_group_id[location]}/providers/Microsoft.Network/publicIPAddresses/${local.azfw_name[location]}-pip"
          managed_by_module = local.deploy_azure_firewall[location]
          # Resource definition attributes
          name                    = "${local.azfw_name[location]}-pip"
          resource_group_name     = local.resource_group_names_by_scope_and_location["connectivity"][location]
          location                = location
          sku                     = try(local.custom_settings.azurerm_public_ip["connectivity"]["azfw"][location].sku, "Standard")
          allocation_method       = try(local.custom_settings.azurerm_public_ip["connectivity"]["azfw"][location].allocation_method, "Static")
          ip_version              = try(local.custom_settings.azurerm_public_ip["connectivity"]["azfw"][location].ip_version, null)
          idle_timeout_in_minutes = try(local.custom_settings.azurerm_public_ip["connectivity"]["azfw"][location].idle_timeout_in_minutes, null)
          domain_name_label       = try(local.custom_settings.azurerm_public_ip["connectivity"]["azfw"][location].domain_name_label, null)
          reverse_fqdn            = try(local.custom_settings.azurerm_public_ip["connectivity"]["azfw"][location].reverse_fqdn, null)
          public_ip_prefix_id     = try(local.custom_settings.azurerm_public_ip["connectivity"]["azfw"][location].public_ip_prefix_id, null)
          ip_tags                 = try(local.custom_settings.azurerm_public_ip["connectivity"]["azfw"][location].ip_tags, null)
          tags                    = try(local.custom_settings.azurerm_public_ip["connectivity"]["azfw"][location].tags, local.tags)
          availability_zone = try(
            local.custom_settings.azurerm_public_ip["connectivity"]["azfw"][location].availability_zone,
            local.azfw_zones_enabled[location] ? "Zone-Redundant" : "No-Zone"
          )
        }
      }
    ],
    [
      for location, virtual_hub in local.virtual_hubs_by_location :
      {
        # Resource logic attributes
        resource_id       = local.virtual_hub_azfw_resource_id[location]
        managed_by_module = local.deploy_virtual_hub_azure_firewall[location]
        scope             = "virtual_wan"
        # Resource definition attributes
        name                = local.virtual_hub_azfw_name[location]
        resource_group_name = local.virtual_hub_resource_group_name[location]
        location            = location
        ip_configuration = try(
          local.custom_settings.azurerm_firewall["virtual_wan"][location].ip_configuration,
          local.empty_list
        )
        sku_name                    = "AZFW_Hub"
        sku_tier                    = try(local.custom_settings.azurerm_firewall["virtual_wan"][location].sku_tier, "Standard")
        firewall_policy_id          = try(local.custom_settings.azurerm_firewall["virtual_wan"][location].firewall_policy_id, null)
        dns_servers                 = try(local.custom_settings.azurerm_firewall["virtual_wan"][location].dns_servers, null)
        private_ip_ranges           = try(local.custom_settings.azurerm_firewall["virtual_wan"][location].private_ip_ranges, null)
        management_ip_configuration = try(local.custom_settings.azurerm_firewall["virtual_wan"][location].management_ip_configuration, local.empty_list)
        threat_intel_mode           = "" # If virtual_hub_settting is specified, the threat_intel_mode has to be explicitly set as "".
        virtual_hub = [
          {
            virtual_hub_id  = local.virtual_hub_resource_id[location]
            public_ip_count = try(local.custom_settings.azurerm_firewall["virtual_wan"][location].virtual_hub[0].public_ip_count, 1)
          }
        ]
        zones = try(local.custom_settings.azurerm_firewall["virtual_wan"][location].zones, null)
        tags  = try(local.custom_settings.azurerm_firewall["virtual_wan"][location].tags, local.tags)
        # Child resource definition attributes
        azurerm_public_ip = {}
      }
    ]
  )
}

# Configuration settings for resource type:
#  - azurerm_virtual_wan
# We only support creation of a single azurerm_virtual_wan resource
# per module deployment. This uses the default location set at the
# scope of the connectivity child module.
locals {
  virtual_wan_name = {
    for location in local.virtual_wan_locations :
    location =>
    try(local.custom_settings.azurerm_virtual_wan["virtual_wan"][location].name,
    "${local.resource_prefix}-vwan-${location}${local.resource_suffix}")
  }
  virtual_wan_resource_group_id = {
    for location in local.virtual_wan_locations :
    location =>
    local.resource_group_config_by_scope_and_location["virtual_wan"][location].resource_id
  }
  virtual_wan_resource_id_prefix = {
    for location in local.virtual_wan_locations :
    location =>
    "${local.virtual_wan_resource_group_id[location]}/providers/Microsoft.Network/virtualWans"
  }
  virtual_wan_resource_id = {
    for location in local.virtual_wan_locations :
    location =>
    "${local.virtual_wan_resource_id_prefix[location]}/${local.virtual_wan_name[location]}"
  }
  azurerm_virtual_wan = [
    for location in local.virtual_wan_locations :
    {
      # Resource logic attributes
      resource_id       = local.virtual_wan_resource_id[location]
      managed_by_module = local.deploy_virtual_wan[location]
      # Resource definition attributes
      name                = local.virtual_wan_name[location]
      resource_group_name = local.resource_group_names_by_scope_and_location["virtual_wan"][location]
      location            = location
      # Optional definition attributes
      disable_vpn_encryption            = try(local.custom_settings.azurerm_virtual_wan["virtual_wan"][location].disable_vpn_encryption, false)
      allow_branch_to_branch_traffic    = try(local.custom_settings.azurerm_virtual_wan["virtual_wan"][location].allow_branch_to_branch_traffic, true)
      office365_local_breakout_category = try(local.custom_settings.azurerm_virtual_wan["virtual_wan"][location].office365_local_breakout_category, "None")
      type                              = try(local.custom_settings.azurerm_virtual_wan["virtual_wan"][location].type, "Standard")
      tags                              = try(local.custom_settings.azurerm_virtual_wan["virtual_wan"][location].tags, local.tags)
    }
  ]
}

# Configuration settings for resource type:
#  - azurerm_virtual_hub
locals {
  virtual_hub_name = {
    for location in local.virtual_hub_locations :
    location =>
    try(local.custom_settings.azurerm_virtual_hub["virtual_wan"][location].name,
    "${local.resource_prefix}-hub-${location}${local.resource_suffix}")
  }
  virtual_hub_resource_group_name = {
    for location in local.virtual_hub_locations :
    location => (
      contains(keys(local.virtual_hubs_by_location_for_resource_group_per_location), location) ?
      local.resource_group_names_by_scope_and_location["connectivity"][location] :
      local.resource_group_names_by_scope_and_location["virtual_wan"][local.virtual_wan_locations[0]]
    )
  }
  virtual_hub_resource_group_id = {
    for location in local.virtual_hub_locations :
    location => (
      contains(keys(local.virtual_hubs_by_location_for_resource_group_per_location), location) ?
      local.resource_group_config_by_scope_and_location["connectivity"][location].resource_id :
      local.resource_group_config_by_scope_and_location["virtual_wan"][local.virtual_wan_locations[0]].resource_id
    )
  }
  virtual_hub_resource_id_prefix = {
    for location in local.virtual_hub_locations :
    location =>
    "${local.virtual_hub_resource_group_id[location]}/providers/Microsoft.Network/virtualHubs"
  }
  virtual_hub_resource_id = {
    for location in local.virtual_hub_locations :
    location =>
    "${local.virtual_hub_resource_id_prefix[location]}/${local.virtual_hub_name[location]}"
  }
  azurerm_virtual_hub = [
    for location, virtual_hub in local.virtual_hubs_by_location :
    {
      # Resource logic attributes
      resource_id       = local.virtual_hub_resource_id[location]
      managed_by_module = local.deploy_virtual_hub[location]
      # Resource definition attributes
      name                = local.virtual_hub_name[location]
      resource_group_name = local.virtual_hub_resource_group_name[location]
      location            = location
      # Optional definition attributes
      sku            = coalesce(virtual_hub.config.sku, "Standard")
      address_prefix = virtual_hub.config.address_prefix
      virtual_wan_id = length(local.existing_virtual_wan_resource_id) > 0 ? local.existing_virtual_wan_resource_id : (
        length(local.virtual_wan_locations) > 0 ?
        lookup(local.virtual_wan_resource_id, local.virtual_wan_locations[0], null) :
        null
      )
      tags = try(local.custom_settings.azurerm_virtual_hub["virtual_wan"][location].tags, local.tags)
      route = [
        for route in virtual_hub.config.routes :
        {
          address_prefixes    = route.address_prefixes
          next_hop_ip_address = route.next_hop_ip_address
        }
      ]
    }
  ]
}

# Configuration settings for resource type:
#  - azurerm_express_route_gateway
locals {
  virtual_hub_express_route_gateway_name = {
    for location in local.virtual_hub_locations :
    location =>
    try(local.custom_settings.azurerm_express_route_gateway["virtual_wan"][location].name,
    "${local.resource_prefix}-ergw-${location}${local.resource_suffix}")
  }
  virtual_hub_express_route_gateway_resource_id_prefix = {
    for location in local.virtual_hub_locations :
    location =>
    "${local.virtual_hub_resource_group_id[location]}/providers/Microsoft.Network/expressRouteGateways"
  }
  virtual_hub_express_route_gateway_resource_id = {
    for location in local.virtual_hub_locations :
    location =>
    "${local.virtual_hub_express_route_gateway_resource_id_prefix[location]}/${local.virtual_hub_express_route_gateway_name[location]}"
  }
  azurerm_express_route_gateway = [
    for location, virtual_hub in local.virtual_hubs_by_location :
    {
      # Resource logic attributes
      resource_id       = local.virtual_hub_express_route_gateway_resource_id[location]
      managed_by_module = local.deploy_virtual_hub_express_route_gateway[location]
      # Resource definition attributes
      name                = local.virtual_hub_express_route_gateway_name[location]
      resource_group_name = local.virtual_hub_resource_group_name[location]
      location            = location
      virtual_hub_id      = local.virtual_hub_resource_id[location]
      scale_units         = virtual_hub.config.expressroute_gateway.config.scale_unit
      # Optional definition attributes
      tags = try(local.custom_settings.azurerm_express_route_gateway["virtual_wan"][location].tags, local.tags)
    }
  ]
}

# Configuration settings for resource type:
#  - azurerm_vpn_gateway
locals {
  virtual_hub_vpn_gateway_name = {
    for location in local.virtual_hub_locations :
    location =>
    try(local.custom_settings.azurerm_vpn_gateway["virtual_wan"][location].name,
    "${local.resource_prefix}-ergw-${location}${local.resource_suffix}")
  }
  virtual_hub_vpn_gateway_resource_id_prefix = {
    for location in local.virtual_hub_locations :
    location =>
    "${local.virtual_hub_resource_group_id[location]}/providers/Microsoft.Network/expressRouteGateways"
  }
  virtual_hub_vpn_gateway_resource_id = {
    for location in local.virtual_hub_locations :
    location =>
    "${local.virtual_hub_vpn_gateway_resource_id_prefix[location]}/${local.virtual_hub_vpn_gateway_name[location]}"
  }
  azurerm_vpn_gateway = [
    for location, virtual_hub in local.virtual_hubs_by_location :
    {
      # Resource logic attributes
      resource_id       = local.virtual_hub_vpn_gateway_resource_id[location]
      managed_by_module = local.deploy_virtual_hub_vpn_gateway[location]
      # Resource definition attributes
      name                = local.virtual_hub_vpn_gateway_name[location]
      resource_group_name = local.virtual_hub_resource_group_name[location]
      location            = location
      virtual_hub_id      = local.virtual_hub_resource_id[location]
      # Optional definition attributes
      routing_preference = coalesce(virtual_hub.config.vpn_gateway.config.routing_preference, "Microsoft Network")
      scale_unit         = virtual_hub.config.vpn_gateway.config.scale_unit
      tags               = try(local.custom_settings.azurerm_vpn_gateway["virtual_wan"][location].tags, local.tags)
      bgp_settings = [
        for bgp_setting in virtual_hub.config.vpn_gateway.config.bgp_settings :
        {
          asn         = bgp_setting.asn
          peer_weight = bgp_setting.peer_weight
          instance_0_bgp_peering_address = [
            for instance_bgp_peering_address in bgp_setting.instance_0_bgp_peering_address :
            {
              custom_ips = instance_bgp_peering_address.custom_ips
            }
          ]
          instance_1_bgp_peering_address = [
            for instance_bgp_peering_address in bgp_setting.instance_1_bgp_peering_address :
            {
              custom_ips = instance_bgp_peering_address.custom_ips
            }
          ]
        }
      ]
    }
  ]
}

# Configuration settings for resource type:
#  - azurerm_public_ip
locals {
  azurerm_public_ip = [
    for azurerm_public_ip in concat(
      local.azurerm_virtual_network_gateway.*.azurerm_public_ip,
      local.azurerm_firewall.*.azurerm_public_ip,
    ) :
    azurerm_public_ip
    if length(azurerm_public_ip) > 0
  ]
}

# Configuration settings for resource type:
#  - azurerm_private_dns_zone
locals {
  enable_private_link_by_service = local.settings.dns.config.enable_private_link_by_service
  private_link_locations         = coalescelist(local.settings.dns.config.private_link_locations, [local.location])
  private_dns_zone_prefix        = "${local.resource_group_config_by_scope_and_location["dns"][local.dns_location].resource_id}/providers/Microsoft.Network/privateDnsZones/"
  lookup_private_link_dns_zone_by_service = {
    azure_automation_webhook             = ["privatelink.azure-automation.net"]
    azure_automation_dscandhybridworker  = ["privatelink.azure-automation.net"]
    azure_sql_database_sqlserver         = ["privatelink.database.windows.net"]
    azure_synapse_analytics_sqlserver    = ["privatelink.database.windows.net"]
    azure_synapse_analytics_sql          = ["privatelink.sql.azuresynapse.net"]
    storage_account_blob                 = ["privatelink.blob.core.windows.net"]
    storage_account_table                = ["privatelink.table.core.windows.net"]
    storage_account_queue                = ["privatelink.queue.core.windows.net"]
    storage_account_file                 = ["privatelink.file.core.windows.net"]
    storage_account_web                  = ["privatelink.web.core.windows.net"]
    azure_data_lake_file_system_gen2     = ["privatelink.dfs.core.windows.net"]
    azure_cosmos_db_sql                  = ["privatelink.documents.azure.com"]
    azure_cosmos_db_mongodb              = ["privatelink.mongo.cosmos.azure.com"]
    azure_cosmos_db_cassandra            = ["privatelink.cassandra.cosmos.azure.com"]
    azure_cosmos_db_gremlin              = ["privatelink.gremlin.cosmos.azure.com"]
    azure_cosmos_db_table                = ["privatelink.table.cosmos.azure.com"]
    azure_database_for_postgresql_server = ["privatelink.postgres.database.azure.com"]
    azure_database_for_mysql_server      = ["privatelink.mysql.database.azure.com"]
    azure_database_for_mariadb_server    = ["privatelink.mariadb.database.azure.com"]
    azure_key_vault                      = ["privatelink.vaultcore.azure.net"]
    azure_kubernetes_service_management = [
      for location in local.private_link_locations :
      "privatelink.${location}.azmk8s.io"
    ]
    azure_search_service           = ["privatelink.search.windows.net"]
    azure_container_registry       = ["privatelink.azurecr.io"]
    azure_app_configuration_stores = ["privatelink.azconfig.io"]
    azure_backup = [
      for location in local.private_link_locations :
      "privatelink.${location}.backup.windowsazure.com"
    ]
    azure_site_recovery = [
      for location in local.private_link_locations :
      "${location}.privatelink.siterecovery.windowsazure.com"
    ]
    azure_event_hubs_namespace       = ["privatelink.servicebus.windows.net"]
    azure_service_bus_namespace      = ["privatelink.servicebus.windows.net"]
    azure_iot_hub                    = ["privatelink.azure-devices.net", "privatelink.servicebus.windows.net"]
    azure_relay_namespace            = ["privatelink.servicebus.windows.net"]
    azure_event_grid_topic           = ["privatelink.eventgrid.azure.net"]
    azure_event_grid_domain          = ["privatelink.eventgrid.azure.net"]
    azure_web_apps_sites             = ["privatelink.azurewebsites.net"]
    azure_machine_learning_workspace = ["privatelink.api.azureml.ms", "privatelink.notebooks.azure.net"]
    signalr                          = ["privatelink.service.signalr.net"]
    azure_monitor                    = ["privatelink.monitor.azure.com", "privatelink.oms.opinsights.azure.com", "privatelink.ods.opinsights.azure.com", "privatelink.agentsvc.azure-automation.net"]
    cognitive_services_account       = ["privatelink.cognitiveservices.azure.com"]
    azure_file_sync                  = ["privatelink.afs.azure.net"]
    azure_data_factory               = ["privatelink.datafactory.azure.net"]
    azure_data_factory_portal        = ["privatelink.adf.azure.com"]
    azure_cache_for_redis            = ["privatelink.redis.cache.windows.net"]
  }
  lookup_private_link_group_id_by_service = {
    azure_automation_webhook             = ""
    azure_automation_dscandhybridworker  = ""
    azure_sql_database_sqlserver         = "sqlServer"
    azure_synapse_analytics_sqlserver    = ""
    azure_synapse_analytics_sql          = ""
    storage_account_blob                 = "blob"
    storage_account_table                = "table"
    storage_account_queue                = "queue"
    storage_account_file                 = "file"
    storage_account_web                  = "web"
    azure_data_lake_file_system_gen2     = "dfs"
    azure_cosmos_db_sql                  = ""
    azure_cosmos_db_mongodb              = ""
    azure_cosmos_db_cassandra            = ""
    azure_cosmos_db_gremlin              = ""
    azure_cosmos_db_table                = ""
    azure_database_for_postgresql_server = ""
    azure_database_for_mysql_server      = ""
    azure_database_for_mariadb_server    = ""
    azure_key_vault                      = "vault"
    azure_kubernetes_service_management  = ""
    azure_search_service                 = ""
    azure_container_registry             = ""
    azure_app_configuration_stores       = ""
    azure_backup                         = ""
    azure_site_recovery                  = ""
    azure_event_hubs_namespace           = ""
    azure_service_bus_namespace          = ""
    azure_iot_hub                        = ""
    azure_relay_namespace                = ""
    azure_event_grid_topic               = ""
    azure_event_grid_domain              = ""
    azure_web_apps_sites                 = ""
    azure_machine_learning_workspace     = ""
    signalr                              = ""
    azure_monitor                        = ""
    cognitive_services_account           = ""
    azure_file_sync                      = ""
    azure_data_factory                   = ""
    azure_data_factory_portal            = ""
    azure_cache_for_redis                = ""
  }
  services_by_private_link_dns_zone = transpose(local.lookup_private_link_dns_zone_by_service)
  private_dns_zone_enabled = {
    for fqdn, services in local.services_by_private_link_dns_zone :
    fqdn => anytrue(
      [
        for service in services : local.enable_private_link_by_service[service]
      ]
    )
  }
  azurerm_private_dns_zone = concat(
    [
      for fqdn, services in local.services_by_private_link_dns_zone :
      {
        # Resource logic attributes
        resource_id       = "${local.resource_group_config_by_scope_and_location["dns"][local.dns_location].resource_id}/providers/Microsoft.Network/privateDnsZones/${fqdn}"
        managed_by_module = local.deploy_dns && local.private_dns_zone_enabled[fqdn]
        # Resource definition attributes
        name = fqdn
        resource_group_name = try(
          local.custom_settings.azurerm_private_dns_zone["connectivity"][fqdn]["global"].resource_group_name,
          local.resource_group_names_by_scope_and_location["dns"][local.dns_location]
        )
        # Optional definition attributes
        soa_record = try(local.custom_settings.azurerm_private_dns_zone["connectivity"][fqdn]["global"].soa_record, local.empty_list)
        tags       = try(local.custom_settings.azurerm_private_dns_zone["connectivity"][fqdn]["global"].tags, local.tags)
      }
    ],
    [
      for fqdn in local.settings.dns.config.private_dns_zones :
      {
        # Resource logic attributes
        resource_id       = "${local.resource_group_config_by_scope_and_location["dns"][local.dns_location].resource_id}/providers/Microsoft.Network/privateDnsZones/${fqdn}"
        managed_by_module = local.deploy_dns
        # Resource definition attributes
        name = fqdn
        resource_group_name = try(
          local.custom_settings.azurerm_private_dns_zone["connectivity"][fqdn]["global"].resource_group_name,
          local.resource_group_names_by_scope_and_location["dns"][local.dns_location]
        )
        # Optional definition attributes
        soa_record = try(local.custom_settings.azurerm_private_dns_zone["connectivity"][fqdn]["global"].soa_record, local.empty_list)
        tags       = try(local.custom_settings.azurerm_private_dns_zone["connectivity"][fqdn]["global"].tags, local.tags)
      }
    ],
  )
}

# Configuration settings for resource type:
#  - azurerm_dns_zone
locals {
  azurerm_dns_zone = [
    for fqdn in local.settings.dns.config.public_dns_zones :
    {
      # Resource logic attributes
      resource_id       = "${local.resource_group_config_by_scope_and_location["dns"][local.dns_location].resource_id}/providers/Microsoft.Network/dnszones/${fqdn}"
      managed_by_module = local.deploy_dns
      # Resource definition attributes
      name = fqdn
      resource_group_name = try(
        local.custom_settings.azurerm_private_dns_zone["connectivity"][fqdn]["global"].resource_group_name,
        local.resource_group_names_by_scope_and_location["dns"][local.dns_location]
      )
      # Optional definition attributes
      soa_record = try(local.custom_settings.azurerm_dns_zone["connectivity"][fqdn]["global"].soa_record, local.empty_list)
      tags       = try(local.custom_settings.azurerm_dns_zone["connectivity"][fqdn]["global"].tags, local.tags)
    }
  ]
}

# Configuration settings for resource type:
#  - azurerm_private_dns_zone_virtual_network_link
locals {
  hub_virtual_networks_for_dns = [
    for hub_config in local.azurerm_virtual_network :
    {
      resource_id       = hub_config.resource_id
      name              = "${split("/", hub_config.resource_id)[2]}-${uuidv5("url", hub_config.resource_id)}"
      managed_by_module = local.deploy_private_dns_zone_virtual_network_link_on_hubs
    }
  ]
  spoke_virtual_networks_for_dns = flatten([
    [
      for location, hub_config in local.hub_networks_by_location :
      [
        for spoke_resource_id in hub_config.config.spoke_virtual_network_resource_ids :
        {
          resource_id       = spoke_resource_id
          name              = "${split("/", spoke_resource_id)[2]}-${uuidv5("url", spoke_resource_id)}"
          managed_by_module = local.deploy_private_dns_zone_virtual_network_link_on_spokes
        }
      ]
    ],
    [
      for location, virtual_hub_config in local.virtual_hubs_by_location :
      [
        for spoke_resource_id in virtual_hub_config.config.spoke_virtual_network_resource_ids :
        {
          resource_id       = spoke_resource_id
          name              = "${split("/", spoke_resource_id)[2]}-${uuidv5("url", spoke_resource_id)}"
          managed_by_module = local.deploy_private_dns_zone_virtual_network_link_on_spokes
        }
      ]
    ]
  ])
  # Distinct is used to allow for situations where
  # the same spoke is associated with multiple hub
  # networks for peering.
  virtual_networks_for_dns = distinct(concat(
    local.hub_virtual_networks_for_dns,
    local.spoke_virtual_networks_for_dns,
  ))
  azurerm_private_dns_zone_virtual_network_link = flatten(
    [
      for zone in local.azurerm_private_dns_zone :
      [
        for link_config in local.virtual_networks_for_dns :
        {
          # Resource logic attributes
          resource_id       = "${zone.resource_id}/virtualNetworkLinks/${link_config.name}"
          managed_by_module = zone.managed_by_module && link_config.managed_by_module
          # Resource definition attributes
          name                  = link_config.name
          resource_group_name   = zone.resource_group_name
          private_dns_zone_name = zone.name
          virtual_network_id    = link_config.resource_id
          # Optional definition attributes
          registration_enabled = try(local.custom_settings.azurerm_private_dns_zone_virtual_network_link["connectivity"][link_config.name][zone.name].registration_enabled, false)
          tags                 = try(local.custom_settings.azurerm_private_dns_zone_virtual_network_link["connectivity"][link_config.name]["global"].tags, local.tags)
        }
      ]
    ]
  )
}

# Configuration settings for resource type:
#  - azurerm_virtual_network_peering
locals {
  azurerm_virtual_network_peering = flatten(
    [
      for location, hub_config in local.hub_networks_by_location :
      [
        for spoke_resource_id in hub_config.config.spoke_virtual_network_resource_ids :
        {
          # Resource logic attributes
          resource_id       = "${local.virtual_network_resource_id[location]}/virtualNetworkPeerings/peering-${uuidv5("url", spoke_resource_id)}"
          managed_by_module = local.deploy_outbound_virtual_network_peering[location]
          # Resource definition attributes
          name                      = "peering-${uuidv5("url", spoke_resource_id)}"
          resource_group_name       = local.resource_group_names_by_scope_and_location["connectivity"][location]
          virtual_network_name      = local.virtual_network_name[location]
          remote_virtual_network_id = spoke_resource_id
          # Optional definition attributes
          allow_virtual_network_access = true
          allow_forwarded_traffic      = true
          allow_gateway_transit        = true
          use_remote_gateways          = false
        }
      ]
    ]
  )
}

# Configuration settings for resource type:
#  - azurerm_virtual_hub_connection
locals {
  azurerm_virtual_hub_connection = flatten(
    [
      for location, virtual_hub_config in local.virtual_hubs_by_location :
      [
        for spoke_resource_id in virtual_hub_config.config.spoke_virtual_network_resource_ids :
        {
          # Resource logic attributes
          resource_id       = "${local.virtual_hub_resource_id[location]}/hubVirtualNetworkConnections/peering-${uuidv5("url", spoke_resource_id)}"
          managed_by_module = local.deploy_virtual_hub_connection[location]
          # Resource definition attributes
          name                      = "peering-${uuidv5("url", spoke_resource_id)}"
          virtual_hub_id            = local.virtual_hub_resource_id[location]
          remote_virtual_network_id = spoke_resource_id
          # Optional definition attributes
          internet_security_enabled = false
          routing                   = local.empty_list
        }
      ]
    ]
  )
}

# Archetype configuration overrides
locals {
  archetype_config_overrides = {
    "${local.root_id}-connectivity" = {
      parameters = {
        Enable-DDoS-VNET = {
          ddosPlan = local.ddos_protection_plan_resource_id
        }
      }
      enforcement_mode = {
        Enable-DDoS-VNET = local.deploy_ddos_protection_plan
      }
    }
    "${local.root_id}-corp" = {
      parameters = {
        Deploy-Private-DNS-Zones = {
          azureFilePrivateDnsZoneId                     = "${local.private_dns_zone_prefix}privatelink.afs.azure.net"
          azureWebPrivateDnsZoneId                      = "${local.private_dns_zone_prefix}privatelink.webpubsub.azure.com"
          azureBatchPrivateDnsZoneId                    = "${local.private_dns_zone_prefix}privatelink.${local.location}.batch.azure.com"
          azureAppPrivateDnsZoneId                      = "${local.private_dns_zone_prefix}privatelink.azconfig.io"
          azureAsrPrivateDnsZoneId                      = "${local.private_dns_zone_prefix}privatelink.siterecovery.windowsazure.com"
          azureIoTPrivateDnsZoneId                      = "${local.private_dns_zone_prefix}privatelink.azure-devices-provisioning.net"
          azureKeyVaultPrivateDnsZoneId                 = "${local.private_dns_zone_prefix}privatelink.vaultcore.azure.net"
          azureSignalRPrivateDnsZoneId                  = "${local.private_dns_zone_prefix}privatelink.service.signalr.net"
          azureAppServicesPrivateDnsZoneId              = "${local.private_dns_zone_prefix}privatelink.azurewebsites.net"
          azureEventGridTopicsPrivateDnsZoneId          = "${local.private_dns_zone_prefix}privatelink.eventgrid.azure.net"
          azureDiskAccessPrivateDnsZoneId               = "${local.private_dns_zone_prefix}privatelink.blob.core.windows.net"
          azureCognitiveServicesPrivateDnsZoneId        = "${local.private_dns_zone_prefix}privatelink.cognitiveservices.azure.com"
          azureIotHubsPrivateDnsZoneId                  = "${local.private_dns_zone_prefix}privatelink.azure-devices.net"
          azureEventGridDomainsPrivateDnsZoneId         = "${local.private_dns_zone_prefix}privatelink.eventgrid.azure.net"
          azureRedisCachePrivateDnsZoneId               = "${local.private_dns_zone_prefix}privatelink.redis.cache.windows.net"
          azureAcrPrivateDnsZoneId                      = "${local.private_dns_zone_prefix}privatelink.azurecr.io"
          azureEventHubNamespacePrivateDnsZoneId        = "${local.private_dns_zone_prefix}privatelink.servicebus.windows.net"
          azureMachineLearningWorkspacePrivateDnsZoneId = "${local.private_dns_zone_prefix}privatelink.api.azureml.ms"
          azureServiceBusNamespacePrivateDnsZoneId      = "${local.private_dns_zone_prefix}privatelink.servicebus.windows.net"
          azureCognitiveSearchPrivateDnsZoneId          = "${local.private_dns_zone_prefix}privatelink.search.windows.net"
        }
      }
      enforcement_mode = {
        Deploy-Private-DNS-Zones = local.deploy_dns
      }
    }
    "${local.root_id}-landing-zones" = {
      parameters = {
        Enable-DDoS-VNET = {
          ddosPlan = local.ddos_protection_plan_resource_id
        }
      }
      enforcement_mode = {
        Enable-DDoS-VNET = local.deploy_ddos_protection_plan
      }
    }
  }
}

# Template file variable outputs
locals {
  template_file_variables = {
    private_dns_zone_prefix = local.private_dns_zone_prefix
  }
}

# Generate the configuration output object for the module
locals {
  module_output = {
    azurerm_resource_group = [
      for resource in local.azurerm_resource_group :
      {
        resource_id   = resource.resource_id
        resource_name = resource.name
        template = {
          for key, value in resource :
          key => value
          if local.deploy_resource_groups[resource.scope][resource.location] &&
          key != "resource_id" &&
          key != "managed_by_module" &&
          key != "scope"
        }
        scope             = resource.scope
        managed_by_module = local.deploy_resource_groups[resource.scope][resource.location]
      }
    ]
    azurerm_virtual_network = [
      for resource in local.azurerm_virtual_network :
      {
        resource_id   = resource.resource_id
        resource_name = resource.name
        template = {
          for key, value in resource :
          key => value
          if local.deploy_hub_network[resource.location] &&
          key != "resource_id" &&
          key != "managed_by_module"
        }
        managed_by_module = local.deploy_hub_network[resource.location]
      }
    ]
    azurerm_subnet = [
      for resource in local.azurerm_subnet :
      {
        resource_id   = resource.resource_id
        resource_name = resource.name
        template = {
          for key, value in resource :
          key => value
          if local.deploy_hub_network[resource.location] &&
          key != "resource_id" &&
          key != "managed_by_module" &&
          key != "location" &&
          key != "network_security_group_id" &&
          key != "route_table_id"
        }
        managed_by_module = local.deploy_hub_network[resource.location]
      }
    ]
    azurerm_virtual_network_gateway = [
      for resource in local.azurerm_virtual_network_gateway :
      {
        resource_id   = resource.resource_id
        resource_name = resource.name
        template = {
          for key, value in resource :
          key => value
          if resource.managed_by_module &&
          key != "resource_id" &&
          key != "managed_by_module" &&
          key != "azurerm_public_ip"
        }
        managed_by_module = resource.managed_by_module
      }
    ]
    azurerm_public_ip = [
      for resource in local.azurerm_public_ip :
      {
        resource_id   = resource.resource_id
        resource_name = resource.name
        template = {
          for key, value in resource :
          key => value
          if resource.managed_by_module &&
          key != "resource_id" &&
          key != "managed_by_module"
        }
        managed_by_module = resource.managed_by_module
      }
    ]
    azurerm_firewall = [
      for resource in local.azurerm_firewall :
      {
        resource_id   = resource.resource_id
        resource_name = resource.name
        template = {
          for key, value in resource :
          key => value
          if resource.managed_by_module &&
          key != "resource_id" &&
          key != "managed_by_module" &&
          key != "azurerm_public_ip" &&
          key != "scope"
        }
        scope             = resource.scope
        managed_by_module = resource.managed_by_module
      }
    ]
    azurerm_virtual_wan = [
      for resource in local.azurerm_virtual_wan :
      {
        resource_id   = resource.resource_id
        resource_name = resource.name
        template = {
          for key, value in resource :
          key => value
          if resource.managed_by_module &&
          key != "resource_id" &&
          key != "managed_by_module"
        }
        managed_by_module = resource.managed_by_module
      }
    ]
    azurerm_virtual_hub = [
      for resource in local.azurerm_virtual_hub :
      {
        resource_id   = resource.resource_id
        resource_name = resource.name
        template = {
          for key, value in resource :
          key => value
          if resource.managed_by_module &&
          key != "resource_id" &&
          key != "managed_by_module"
        }
        managed_by_module = resource.managed_by_module
      }
    ]
    azurerm_express_route_gateway = [
      for resource in local.azurerm_express_route_gateway :
      {
        resource_id   = resource.resource_id
        resource_name = resource.name
        template = {
          for key, value in resource :
          key => value
          if resource.managed_by_module &&
          key != "resource_id" &&
          key != "managed_by_module"
        }
        managed_by_module = resource.managed_by_module
      }
    ]
    azurerm_vpn_gateway = [
      for resource in local.azurerm_vpn_gateway :
      {
        resource_id   = resource.resource_id
        resource_name = resource.name
        template = {
          for key, value in resource :
          key => value
          if resource.managed_by_module &&
          key != "resource_id" &&
          key != "managed_by_module"
        }
        managed_by_module = resource.managed_by_module
      }
    ]
    azurerm_network_ddos_protection_plan = [
      for resource in local.azurerm_network_ddos_protection_plan :
      {
        resource_id   = resource.resource_id
        resource_name = resource.name
        template = {
          for key, value in resource :
          key => value
          if resource.managed_by_module &&
          key != "resource_id" &&
          key != "managed_by_module"
        }
        managed_by_module = resource.managed_by_module
      }
    ]
    azurerm_private_dns_zone = [
      for resource in local.azurerm_private_dns_zone :
      {
        resource_id   = resource.resource_id
        resource_name = resource.name
        template = {
          for key, value in resource :
          key => value
          if resource.managed_by_module &&
          key != "resource_id" &&
          key != "managed_by_module"
        }
        managed_by_module = resource.managed_by_module
      }
    ]
    azurerm_dns_zone = [
      for resource in local.azurerm_dns_zone :
      {
        resource_id   = resource.resource_id
        resource_name = resource.name
        template = {
          for key, value in resource :
          key => value
          if resource.managed_by_module &&
          key != "resource_id" &&
          key != "managed_by_module"
        }
        managed_by_module = resource.managed_by_module
      }
    ]
    azurerm_private_dns_zone_virtual_network_link = [
      for resource in local.azurerm_private_dns_zone_virtual_network_link :
      {
        resource_id   = resource.resource_id
        resource_name = resource.name
        template = {
          for key, value in resource :
          key => value
          if resource.managed_by_module &&
          key != "resource_id" &&
          key != "managed_by_module"
        }
        managed_by_module = resource.managed_by_module
      }
    ]
    azurerm_virtual_network_peering = [
      for resource in local.azurerm_virtual_network_peering :
      {
        resource_id   = resource.resource_id
        resource_name = resource.name
        template = {
          for key, value in resource :
          key => value
          if resource.managed_by_module &&
          key != "resource_id" &&
          key != "managed_by_module"
        }
        managed_by_module = resource.managed_by_module
      }
    ]
    azurerm_virtual_hub_connection = [
      for resource in local.azurerm_virtual_hub_connection :
      {
        resource_id   = resource.resource_id
        resource_name = resource.name
        template = {
          for key, value in resource :
          key => value
          if resource.managed_by_module &&
          key != "resource_id" &&
          key != "managed_by_module"
        }
        managed_by_module = resource.managed_by_module
      }
    ]
    archetype_config_overrides = local.archetype_config_overrides
    template_file_variables    = local.template_file_variables
  }
}

locals {
  debug_output = {
    hub_networks                                             = local.hub_networks
    hub_networks_by_location                                 = local.hub_networks_by_location
    hub_network_locations                                    = local.hub_network_locations
    virtual_hubs                                             = local.virtual_hubs
    virtual_hubs_by_location                                 = local.virtual_hubs_by_location
    virtual_hub_locations                                    = local.virtual_hub_locations
    virtual_hubs_by_location_for_resource_group_per_location = local.virtual_hubs_by_location_for_resource_group_per_location
    virtual_hubs_by_location_for_shared_resource_group       = local.virtual_hubs_by_location_for_shared_resource_group
    virtual_hubs_by_location_for_managed_virtual_wan         = local.virtual_hubs_by_location_for_managed_virtual_wan
    virtual_hubs_by_location_for_existing_virtual_wan        = local.virtual_hubs_by_location_for_existing_virtual_wan
    virtual_wan_locations                                    = local.virtual_wan_locations
    ddos_location                                            = local.ddos_location
    dns_location                                             = local.dns_location
    connectivity_locations                                   = local.connectivity_locations
    result_when_location_missing                             = local.result_when_location_missing
    deploy_resource_groups                                   = local.deploy_resource_groups
    deploy_ddos_protection_plan                              = local.deploy_ddos_protection_plan
    deploy_dns                                               = local.deploy_dns
    deploy_private_dns_zone_virtual_network_link_on_hubs     = local.deploy_private_dns_zone_virtual_network_link_on_hubs
    deploy_private_dns_zone_virtual_network_link_on_spokes   = local.deploy_private_dns_zone_virtual_network_link_on_spokes
    deploy_hub_network                                       = local.deploy_hub_network
    deploy_virtual_network_gateway                           = local.deploy_virtual_network_gateway
    deploy_virtual_network_gateway_express_route             = local.deploy_virtual_network_gateway_express_route
    deploy_virtual_network_gateway_vpn                       = local.deploy_virtual_network_gateway_vpn
    deploy_azure_firewall                                    = local.deploy_azure_firewall
    deploy_outbound_virtual_network_peering                  = local.deploy_outbound_virtual_network_peering
    deploy_virtual_wan                                       = local.deploy_virtual_wan
    deploy_virtual_hub                                       = local.deploy_virtual_hub
    deploy_virtual_hub_express_route_gateway                 = local.deploy_virtual_hub_express_route_gateway
    deploy_virtual_hub_vpn_gateway                           = local.deploy_virtual_hub_vpn_gateway
    deploy_virtual_hub_azure_firewall                        = local.deploy_virtual_hub_azure_firewall
    deploy_virtual_hub_connection                            = local.deploy_virtual_hub_connection
    resource_group_names_by_scope_and_location               = local.resource_group_names_by_scope_and_location
    resource_group_config_by_scope_and_location              = local.resource_group_config_by_scope_and_location
    azurerm_resource_group                                   = local.azurerm_resource_group
    ddos_resource_group_id                                   = local.ddos_resource_group_id
    ddos_protection_plan_name                                = local.ddos_protection_plan_name
    ddos_protection_plan_resource_id                         = local.ddos_protection_plan_resource_id
    azurerm_network_ddos_protection_plan                     = local.azurerm_network_ddos_protection_plan
    virtual_network_resource_group_id                        = local.virtual_network_resource_group_id
    virtual_network_resource_id_prefix                       = local.virtual_network_resource_id_prefix
    virtual_network_resource_id                              = local.virtual_network_resource_id
    azurerm_virtual_network                                  = local.azurerm_virtual_network
    subnets_by_virtual_network                               = local.subnets_by_virtual_network
    azurerm_subnet                                           = local.azurerm_subnet
    er_gateway_name                                          = local.er_gateway_name
    er_gateway_resource_id_prefix                            = local.er_gateway_resource_id_prefix
    er_gateway_resource_id                                   = local.er_gateway_resource_id
    er_gateway_config                                        = local.er_gateway_config
    vpn_gateway_name                                         = local.vpn_gateway_name
    vpn_gateway_resource_id_prefix                           = local.vpn_gateway_resource_id_prefix
    vpn_gateway_resource_id                                  = local.vpn_gateway_resource_id
    vpn_gateway_config                                       = local.vpn_gateway_config
    azurerm_virtual_network_gateway                          = local.azurerm_virtual_network_gateway
    azfw_name                                                = local.azfw_name
    azfw_resource_id_prefix                                  = local.azfw_resource_id_prefix
    azfw_resource_id                                         = local.azfw_resource_id
    azurerm_firewall                                         = local.azurerm_firewall
    azurerm_public_ip                                        = local.azurerm_public_ip
    enable_private_link_by_service                           = local.enable_private_link_by_service
    private_link_locations                                   = local.private_link_locations
    lookup_private_link_dns_zone_by_service                  = local.lookup_private_link_dns_zone_by_service
    lookup_private_link_group_id_by_service                  = local.lookup_private_link_group_id_by_service
    services_by_private_link_dns_zone                        = local.services_by_private_link_dns_zone
    private_dns_zone_enabled                                 = local.private_dns_zone_enabled
    azurerm_private_dns_zone                                 = local.azurerm_private_dns_zone
    azurerm_dns_zone                                         = local.azurerm_dns_zone
    hub_virtual_networks_for_dns                             = local.hub_virtual_networks_for_dns
    spoke_virtual_networks_for_dns                           = local.spoke_virtual_networks_for_dns
    virtual_networks_for_dns                                 = local.virtual_networks_for_dns
    azurerm_private_dns_zone_virtual_network_link            = local.azurerm_private_dns_zone_virtual_network_link
  }
}
