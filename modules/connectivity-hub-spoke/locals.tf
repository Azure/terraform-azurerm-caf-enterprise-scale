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
  resource_suffix                           = length(var.resource_suffix) > 0 ? "-${var.resource_suffix}" : local.empty_string
  existing_ddos_protection_plan_resource_id = var.existing_ddos_protection_plan_resource_id
}

# Placeholder for advanced settings by resource type
locals {
  advanced = {
    azurerm_resource_group               = {}
    azurerm_network_ddos_protection_plan = {}
    azurerm_virtual_network              = {}
    azurerm_subnet                       = {}
    azurerm_virtual_network_gateway      = {}
    azurerm_public_ip                    = {}
    azurerm_firewall                     = {}
    azurerm_dns_zone                     = {}
    azurerm_virtual_network_peering      = {}
  }
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
  ddos_location         = coalesce(local.settings.ddos_protection_plan.config.location, local.location)
  dns_location          = coalesce(local.settings.dns.config.location, local.location)
}


# Logic to determine whether specific resources
# should be created by this module
locals {
  deploy_ddos_protection_plan = local.enabled && local.settings.ddos_protection_plan.enabled
  deploy_dns                  = local.enabled && local.settings.dns.enabled
  deploy_resource_groups = {
    connectivity = {
      for location, hub_network in local.hub_networks_by_location :
      location =>
      local.enabled &&
      hub_network.enabled
    }
    ddos = {
      (local.ddos_location) = local.deploy_ddos_protection_plan
    }
    dns = {
      (local.dns_location) = local.deploy_dns
    }
  }
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
    hub_network.config.virtual_network_gateway.enabled
  }
  deploy_virtual_network_gateway_expressroute = {
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
    local.deploy_virtual_network_gateway[location] &&
    hub_network.config.azure_firewall.enabled
  }
}

# Configuration settings for resource type:
#  - azurerm_resource_group
locals {
  # Determine the name of each Resource Group per scope and location
  resource_group_names_by_scope_and_location = {
    connectivity = {
      for location in local.hub_network_locations :
      location =>
      "${local.resource_prefix}-connectivity-${location}${local.resource_suffix}"
    }
    ddos = {
      (local.ddos_location) = "${local.resource_prefix}-ddos${local.resource_suffix}"
    }
    dns = {
      (local.dns_location) = "${local.resource_prefix}-dns${local.resource_suffix}"
    }
  }
  # Generate a map of settings for each Resource Group per scope and location
  resource_group_config_by_scope_and_location = {
    for rg_scope, resource_groups in local.resource_group_names_by_scope_and_location :
    rg_scope => {
      for rg_location, rg_name in resource_groups :
      rg_location => {
        # Resource logic attributes
        resource_id = "/subscriptions/${local.subscription_id}/resourceGroups/${rg_name}"
        scope       = rg_scope
        # Resource definition attributes
        name     = rg_name
        location = rg_location
        tags     = local.tags
      }
    }
  }
  # Create a flattened list of resource group configuration blocks for deployment
  azurerm_resource_group = flatten([
    for scope in keys(local.resource_group_config_by_scope_and_location) :
    [
      for rg_config in local.resource_group_config_by_scope_and_location[scope] :
      rg_config
    ]
  ])
}

# # Configuration settings for resource type:
# #  - azurerm_network_ddos_protection_plan
locals {
  ddos_resource_group_id    = local.resource_group_config_by_scope_and_location["ddos"][local.ddos_location].resource_id
  ddos_protection_plan_name = "${local.resource_prefix}-ddos-${local.ddos_location}${local.resource_suffix}"
  ddos_protection_plan_resource_id = coalesce(
    local.existing_ddos_protection_plan_resource_id,
    "${local.ddos_resource_group_id}/providers/Microsoft.Network/ddosProtectionPlans/${local.ddos_protection_plan_name}"
  )
  azurerm_network_ddos_protection_plan = [
    {
      # Resource logic attributes
      resource_id = local.ddos_protection_plan_resource_id
      # Resource definition attributes
      name                = local.ddos_protection_plan_name
      location            = local.ddos_location
      resource_group_name = local.resource_group_config_by_scope_and_location["ddos"][local.ddos_location].name
      tags                = local.tags
    }
  ]
}

# Configuration settings for resource type:
#  - azurerm_virtual_network
locals {
  virtual_network_name = {
    for location in local.hub_network_locations :
    location =>
    "${local.resource_prefix}-hub-${location}${local.resource_suffix}"
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
      name                    = local.virtual_network_name[location]
      resource_group_name     = local.resource_group_names_by_scope_and_location["connectivity"][location]
      address_space           = hub_config.config.address_space
      location                = location
      bgp_community           = hub_config.config.bgp_community
      ddos_protection_plan_id = hub_config.config.enable_ddos_protection_standard ? local.ddos_protection_plan_resource_id : null
      dns_servers             = hub_config.config.dns_servers
      tags                    = local.tags
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
            resource_group_name  = local.resource_group_names_by_scope_and_location["connectivity"][location]
            virtual_network_name = local.virtual_network_name[location]
            tags                 = local.tags
          }
        )
      ],
      # Conditionally add Virtual Network Gateway subnet
      hub_network.config.virtual_network_gateway.config.address_prefix != local.empty_string ? [
        {
          # Resource logic attributes
          resource_id = "${local.virtual_network_resource_id[location]}/subnets/GatewaySubnet"
          location    = location
          # Resource definition attributes
          name                      = "GatewaySubnet"
          address_prefixes          = [hub_network.config.virtual_network_gateway.config.address_prefix, ]
          resource_group_name       = local.resource_group_names_by_scope_and_location["connectivity"][location]
          virtual_network_name      = local.virtual_network_name[location]
          network_security_group_id = null
          route_table_id            = null
          tags                      = local.tags
        }
      ] : local.empty_list,
      # Conditionally add Azure Firewall subnet
      hub_network.config.azure_firewall.config.address_prefix != local.empty_string ? [
        {
          # Resource logic attributes
          resource_id = "${local.virtual_network_resource_id[location]}/subnets/AzureFirewallSubnet"
          location    = location
          # Resource definition attributes
          name                      = "AzureFirewallSubnet"
          address_prefixes          = [hub_network.config.azure_firewall.config.address_prefix, ]
          resource_group_name       = local.resource_group_names_by_scope_and_location["connectivity"][location]
          virtual_network_name      = local.virtual_network_name[location]
          network_security_group_id = null
          route_table_id            = null
          tags                      = local.tags
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
    location => "${local.resource_prefix}-ergw-${location}${local.resource_suffix}"
  }
  er_gateway_resource_id_prefix = {
    for location in local.hub_network_locations :
    location =>
    "${local.virtual_network_resource_group_id[location]}/providers/Microsoft.Network/expressRouteGateways"
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
      managed_by_module = local.deploy_virtual_network_gateway_expressroute[location]
      # Resource definition attributes
      name                             = local.er_gateway_name[location]
      resource_group_name              = local.resource_group_names_by_scope_and_location["connectivity"][location]
      location                         = location
      type                             = "ExpressRoute"
      sku                              = hub_network.config.virtual_network_gateway.config.gateway_sku_expressroute
      vpn_type                         = try(local.advanced.azurerm_virtual_network_gateway.expressroute[location].vpn_type, "RouteBased")
      enable_bgp                       = try(local.advanced.azurerm_virtual_network_gateway.expressroute[location].enable_bgp, false)
      active_active                    = try(local.advanced.azurerm_virtual_network_gateway.expressroute[location].active_active, false)
      private_ip_address_enabled       = try(local.advanced.azurerm_virtual_network_gateway.expressroute[location].private_ip_address_enabled, null)
      default_local_network_gateway_id = try(local.advanced.azurerm_virtual_network_gateway.expressroute[location].default_local_network_gateway_id, null)
      generation                       = try(local.advanced.azurerm_virtual_network_gateway.expressroute[location].generation, null)
      ip_configuration                 = try(local.advanced.azurerm_virtual_network_gateway.expressroute[location].ip_configuration, null)
      tags                             = try(local.advanced.azurerm_virtual_network_gateway.expressroute[location].tags, local.tags)
      # Child resource definition attributes
      azurerm_public_ip = {
        # Resource logic attributes
        resource_id       = "${local.virtual_network_resource_group_id[location]}/providers/Microsoft.Network/publicIPAddresses/${local.er_gateway_name[location]}-pip"
        managed_by_module = local.deploy_virtual_network_gateway_expressroute[location]
        # Resource definition attributes
        name                    = "${local.er_gateway_name[location]}-pip"
        resource_group_name     = local.resource_group_names_by_scope_and_location["connectivity"][location]
        location                = location
        sku                     = try(local.advanced.azurerm_public_ip.expressroute[location].sku, "Standard")
        allocation_method       = try(local.advanced.azurerm_public_ip.expressroute[location].allocation_method, "Static")
        ip_version              = try(local.advanced.azurerm_public_ip.expressroute[location].ip_version, null)
        idle_timeout_in_minutes = try(local.advanced.azurerm_public_ip.expressroute[location].idle_timeout_in_minutes, null)
        domain_name_label       = try(local.advanced.azurerm_public_ip.expressroute[location].domain_name_label, null)
        reverse_fqdn            = try(local.advanced.azurerm_public_ip.expressroute[location].reverse_fqdn, null)
        public_ip_prefix_id     = try(local.advanced.azurerm_public_ip.expressroute[location].public_ip_prefix_id, null)
        ip_tags                 = try(local.advanced.azurerm_public_ip.expressroute[location].ip_tags, null)
        tags                    = try(local.advanced.azurerm_public_ip.expressroute[location].tags, local.tags)
      }
    }
    # if local.deploy_virtual_network_gateway_expressroute[location]
  ]
}

# Configuration settings for resource type:
#  - azurerm_virtual_network_gateway (VPN)
locals {
  vpn_gateway_name = {
    for location in local.hub_network_locations :
    location => "${local.resource_prefix}-vpngw-${location}${local.resource_suffix}"
  }
  vpn_gateway_resource_id_prefix = {
    for location in local.hub_network_locations :
    location =>
    "${local.virtual_network_resource_group_id[location]}/providers/Microsoft.Network/vpnGateways"
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
      name                             = local.vpn_gateway_name[location]
      resource_group_name              = local.resource_group_names_by_scope_and_location["connectivity"][location]
      location                         = location
      type                             = "Vpn"
      sku                              = hub_network.config.virtual_network_gateway.config.gateway_sku_vpn
      vpn_type                         = try(local.advanced.azurerm_virtual_network_gateway.vpn[location].vpn_type, "RouteBased")
      enable_bgp                       = try(local.advanced.azurerm_virtual_network_gateway.vpn[location].enable_bgp, false)
      active_active                    = try(local.advanced.azurerm_virtual_network_gateway.vpn[location].active_active, false)
      private_ip_address_enabled       = try(local.advanced.azurerm_virtual_network_gateway.vpn[location].private_ip_address_enabled, null)
      default_local_network_gateway_id = try(local.advanced.azurerm_virtual_network_gateway.vpn[location].default_local_network_gateway_id, null)
      generation                       = try(local.advanced.azurerm_virtual_network_gateway.vpn[location].generation, null)
      ip_configuration                 = try(local.advanced.azurerm_virtual_network_gateway.vpn[location].ip_configuration, null)
      tags                             = try(local.advanced.azurerm_virtual_network_gateway.vpn[location].tags, local.tags)
      # Child resource definition attributes
      azurerm_public_ip = {
        # Resource logic attributes
        resource_id       = "${local.virtual_network_resource_group_id[location]}/providers/Microsoft.Network/publicIPAddresses/${local.vpn_gateway_name[location]}-pip"
        managed_by_module = local.deploy_virtual_network_gateway_vpn[location]
        # Resource definition attributes
        name                    = "${local.vpn_gateway_name[location]}-pip"
        resource_group_name     = local.resource_group_names_by_scope_and_location["connectivity"][location]
        location                = location
        sku                     = try(local.advanced.azurerm_public_ip.vpn[location].sku, "Standard")
        allocation_method       = try(local.advanced.azurerm_public_ip.vpn[location].allocation_method, "Static")
        ip_version              = try(local.advanced.azurerm_public_ip.vpn[location].ip_version, null)
        idle_timeout_in_minutes = try(local.advanced.azurerm_public_ip.vpn[location].idle_timeout_in_minutes, null)
        domain_name_label       = try(local.advanced.azurerm_public_ip.vpn[location].domain_name_label, null)
        reverse_fqdn            = try(local.advanced.azurerm_public_ip.vpn[location].reverse_fqdn, null)
        public_ip_prefix_id     = try(local.advanced.azurerm_public_ip.vpn[location].public_ip_prefix_id, null)
        ip_tags                 = try(local.advanced.azurerm_public_ip.vpn[location].ip_tags, null)
        tags                    = try(local.advanced.azurerm_public_ip.vpn[location].tags, local.tags)
      }
    }
    # if local.deploy_virtual_network_gateway_vpn[location]
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
locals {
  azfw_name = {
    for location in local.hub_network_locations :
    location => "${local.resource_prefix}-fw-${location}${local.resource_suffix}"
  }
  azfw_resource_id_prefix = {
    for location in local.hub_network_locations :
    location =>
    "${local.virtual_network_resource_group_id[location]}/providers/Microsoft.Network/azureFirewalls"
  }
  azfw_resource_id = {
    for location in local.hub_network_locations :
    location =>
    "${local.azfw_resource_id_prefix[location]}/${local.azfw_name[location]}"
  }
  azurerm_firewall = [
    for location, hub_network in local.hub_networks_by_location :
    {
      # Resource logic attributes
      resource_id       = local.azfw_resource_id[location]
      managed_by_module = local.deploy_azure_firewall[location]
      # Resource definition attributes
      name                        = local.azfw_name[location]
      resource_group_name         = local.resource_group_names_by_scope_and_location["connectivity"][location]
      location                    = location
      type                        = "Vpn"
      sku_name                    = try(local.advanced.azurerm_firewall[location].sku_name, "AZFW_VNet")
      sku_tier                    = try(local.advanced.azurerm_firewall[location].sku_tier, "Standard")
      firewall_policy_id          = try(local.advanced.azurerm_firewall[location].firewall_policy_id, null)
      ip_configuration            = try(local.advanced.azurerm_firewall[location].ip_configuration, null)
      dns_servers                 = try(local.advanced.azurerm_firewall[location].dns_servers, null)
      private_ip_ranges           = try(local.advanced.azurerm_firewall[location].private_ip_ranges, null)
      management_ip_configuration = try(local.advanced.azurerm_firewall[location].management_ip_configuration, null)
      threat_intel_mode           = try(local.advanced.azurerm_firewall[location].threat_intel_mode, null)
      virtual_hub                 = null
      zones                       = try(local.advanced.azurerm_firewall[location].zones, null)
      tags                        = try(local.advanced.azurerm_firewall[location].tags, local.tags)
      # Child resource definition attributes
      azurerm_public_ip = {
        # Resource logic attributes
        resource_id       = "${local.virtual_network_resource_group_id[location]}/providers/Microsoft.Network/publicIPAddresses/${local.azfw_name[location]}-pip"
        managed_by_module = local.deploy_azure_firewall[location]
        # Resource definition attributes
        name                    = "${local.azfw_name[location]}-pip"
        resource_group_name     = local.resource_group_names_by_scope_and_location["connectivity"][location]
        location                = location
        sku                     = try(local.advanced.azurerm_public_ip.azfw[location].sku, "Standard")
        allocation_method       = try(local.advanced.azurerm_public_ip.azfw[location].allocation_method, "Static")
        ip_version              = try(local.advanced.azurerm_public_ip.azfw[location].ip_version, null)
        idle_timeout_in_minutes = try(local.advanced.azurerm_public_ip.azfw[location].idle_timeout_in_minutes, null)
        domain_name_label       = try(local.advanced.azurerm_public_ip.azfw[location].domain_name_label, null)
        reverse_fqdn            = try(local.advanced.azurerm_public_ip.azfw[location].reverse_fqdn, null)
        public_ip_prefix_id     = try(local.advanced.azurerm_public_ip.azfw[location].public_ip_prefix_id, null)
        ip_tags                 = try(local.advanced.azurerm_public_ip.azfw[location].ip_tags, null)
        tags                    = try(local.advanced.azurerm_public_ip.azfw[location].tags, local.tags)
      }
    }
    # if local.deploy_azure_firewall[location]
  ]
}

# Configuration settings for resource type:
#  - azurerm_public_ip
locals {
  azurerm_public_ip = concat(
    local.azurerm_virtual_network_gateway.*.azurerm_public_ip,
    local.azurerm_firewall.*.azurerm_public_ip,
  )
}

# Configuration settings for resource type:
#  - azurerm_dns_zone
locals {
  azurerm_dns_zone = []
}

# Configuration settings for resource type:
#  - azurerm_virtual_network_peering
locals {
  azurerm_virtual_network_peering = []
}

# Archetype configuration overrides
locals {
  archetype_config_overrides = {}
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
          key != "scope"
        }
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
          key != "resource_id"
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
          key != "location"
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
          key != "resource_id"
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
          key != "azurerm_public_ip"
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
          if local.deploy_ddos_protection_plan &&
          key != "resource_id"
        }
        managed_by_module = local.deploy_ddos_protection_plan
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
          key != "resource_id"
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
          key != "resource_id"
        }
        managed_by_module = resource.managed_by_module
      }
    ]
    archetype_config_overrides = local.archetype_config_overrides
  }
}

locals {
  debug_output = {
    deploy_resource_groups                      = local.deploy_resource_groups
    deploy_hub_network                          = local.deploy_hub_network
    deploy_virtual_network_gateway              = local.deploy_virtual_network_gateway
    deploy_virtual_network_gateway_expressroute = local.deploy_virtual_network_gateway_expressroute
    deploy_virtual_network_gateway_vpn          = local.deploy_virtual_network_gateway_vpn
    deploy_azure_firewall                       = local.deploy_azure_firewall
    resource_group_names_by_scope_and_location  = local.resource_group_names_by_scope_and_location
    resource_group_config_by_scope_and_location = local.resource_group_config_by_scope_and_location
    azurerm_resource_group                      = local.azurerm_resource_group
    ddos_resource_group_id                      = local.ddos_resource_group_id
    ddos_protection_plan_name                   = local.ddos_protection_plan_name
    ddos_protection_plan_resource_id            = local.ddos_protection_plan_resource_id
    azurerm_network_ddos_protection_plan        = local.azurerm_network_ddos_protection_plan
    hub_network_locations                       = local.hub_network_locations
    ddos_location                               = local.ddos_location
    dns_location                                = local.dns_location
    virtual_network_resource_group_id           = local.virtual_network_resource_group_id
    virtual_network_resource_id_prefix          = local.virtual_network_resource_id_prefix
    virtual_network_resource_id                 = local.virtual_network_resource_id
    azurerm_virtual_network                     = local.azurerm_virtual_network
    subnets_by_virtual_network                  = local.subnets_by_virtual_network
    azurerm_subnet                              = local.azurerm_subnet
    er_gateway_name                             = local.er_gateway_name
    er_gateway_resource_id_prefix               = local.er_gateway_resource_id_prefix
    er_gateway_resource_id                      = local.er_gateway_resource_id
    er_gateway_config                           = local.er_gateway_config
    vpn_gateway_name                            = local.vpn_gateway_name
    vpn_gateway_resource_id_prefix              = local.vpn_gateway_resource_id_prefix
    vpn_gateway_resource_id                     = local.vpn_gateway_resource_id
    vpn_gateway_config                          = local.vpn_gateway_config
    azurerm_virtual_network_gateway             = local.azurerm_virtual_network_gateway
    azfw_name                                   = local.azfw_name
    azfw_resource_id_prefix                     = local.azfw_resource_id_prefix
    azfw_resource_id                            = local.azfw_resource_id
    azurerm_firewall                            = local.azurerm_firewall
    azurerm_public_ip                           = local.azurerm_public_ip
  }
}
