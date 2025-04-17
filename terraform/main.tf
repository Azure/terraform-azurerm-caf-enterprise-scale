locals {
  root_parent_id                     = var.root_parent_id
  disable_base_module_tags           = false
  strict_subscription_association    = var.strict_subscription_association
  empty_map                          = {}
  base_module_tags                   = {}
  default_tags                       = {}
  create_object                      = {}
  es_core_landing_zones_to_include   = {}
  es_corp_landing_zones_to_include   = {}
  es_online_landing_zones_to_include = {}
  es_sap_landing_zones_to_include    = {}
  es_demo_landing_zones_to_include   = {}
  custom_landing_zones               = {}
  provider_path = {
    management_groups = "${var.root_id}-"
  }
  library_path            = var.library_path
  template_file_variables = var.template_file_variables

  es_archetype_config_defaults = {
    enforcement_mode_default = {}
    parameter_map_default = {}
    "${local.root_id}"              = {
      archetype_id   = "es_root"
      parameters     = local.empty_map
      access_control = local.empty_map
    }
    "${local.root_id}-decommissioned" = {
      archetype_id   = "es_decommissioned"
      parameters     = local.empty_map
      access_control = local.empty_map
    }
    "${local.root_id}-sandboxes"      = {
      archetype_id   = "es_sandboxes"
      parameters     = local.empty_map
      access_control = local.empty_map
    }
    "${local.root_id}-landing-zones"  = {
      archetype_id   = "es_landing_zones"
      parameters     = local.empty_map
      access_control = local.empty_map
    }
    "${local.root_id}-platform"       = {
      archetype_id   = "es_platform"
      parameters     = local.empty_map
      access_control = local.empty_map
    }
    "${local.root_id}-connectivity"   = {
      archetype_id   = "es_connectivity"
      parameters     = local.empty_map
      access_control = local.empty_map
    }
    "${local.root_id}-management"     = {
      archetype_id   = "es_management"
      parameters     = local.empty_map
      access_control = local.empty_map
    }
    "${local.root_id}-identity"       = {
      archetype_id   = "es_identity"
      parameters     = local.empty_map
      access_control = local.empty_map
    }
    "${local.root_id}-corp"           = {
      archetype_id   = "es_corp"
      parameters     = local.empty_map
      access_control = local.empty_map
    }
    "${local.root_id}-online"         = {
      archetype_id   = "es_online"
      parameters     = local.empty_map
      access_control = local.empty_map
    }
    "${local.root_id}-sap"            = {
      archetype_id   = "es_sap"
      parameters     = local.empty_map
      access_control = local.empty_map
    }
  }

  es_landing_zones_map = {
    for key, value in merge(
      local.es_core_landing_zones_to_include,
      local.es_corp_landing_zones_to_include,
      local.es_online_landing_zones_to_include,
      local.es_sap_landing_zones_to_include,
      local.es_demo_landing_zones_to_include,
      local.custom_landing_zones,
    ) :
    "${local.root_id}-${key}" => {
      id                         = key
      display_name               = value.display_name
      parent_management_group_id = coalesce(value.parent_management_group_id, local.root_parent_id)
      subscription_ids           = local.strict_subscription_association ? value.subscription_ids : null
      archetype_config = {
        archetype_id   = value.archetype_config.archetype_id
        access_control = value.archetype_config.access_control
        parameters = {
          for policy_name in toset(keys(merge(
            lookup(module.connectivity_resources.configuration.archetype_config_overrides, key, local.es_archetype_config_defaults.parameter_map_default).parameters,
            lookup(module.identity_resources.configuration.archetype_config_overrides, key, local.es_archetype_config_defaults.parameter_map_default).parameters,
            lookup(module.management_resources.configuration.archetype_config_overrides, key, local.es_archetype_config_defaults.parameter_map_default).parameters,
            value.archetype_config.parameters,
          ))) :
          policy_name => merge(
            lookup(lookup(module.connectivity_resources.configuration.archetype_config_overrides, key, local.es_archetype_config_defaults.parameter_map_default).parameters, policy_name, null),
            lookup(lookup(module.identity_resources.configuration.archetype_config_overrides, key, local.es_archetype_config_defaults.parameter_map_default).parameters, policy_name, null),
            lookup(lookup(module.management_resources.configuration.archetype_config_overrides, key, local.es_archetype_config_defaults.parameter_map_default).parameters, policy_name, null),
            lookup(value.archetype_config.parameters, policy_name, null),
          )
        }
        enforcement_mode = merge(
          lookup(module.connectivity_resources.configuration.archetype_config_overrides, key, local.es_archetype_config_defaults.enforcement_mode_default).enforcement_mode,
          lookup(module.identity_resources.configuration.archetype_config_overrides, key, local.es_archetype_config_defaults.enforcement_mode_default).enforcement_mode,
          lookup(module.management_resources.configuration.archetype_config_overrides, key, local.es_archetype_config_defaults.enforcement_mode_default).enforcement_mode,
          lookup(value.archetype_config, "enforcement_mode", local.es_archetype_config_defaults.enforcement_mode_default)
        )
      }
    }
  }

  deploy_management_resources      = var.deploy_management_resources
  root_id                          = var.root_id
  subscription_id_management       = var.subscription_id_management
  configure_management_resources   = var.configure_management_resources
  default_location                = lower(var.default_location)
  management_resources_tags = merge(
    local.disable_base_module_tags ? local.empty_map : local.base_module_tags,
    local.default_tags,
    local.configure_management_resources.tags,
  )
  management_resources_advanced = merge(
    local.create_object,
    coalesce(local.configure_management_resources.advanced, local.empty_map),
  )

  empty_string = ""

  deploy_identity_resources        = var.deploy_identity_resources
  configure_identity_resources     = var.configure_identity_resources

  deploy_connectivity_resources    = var.deploy_connectivity_resources
  subscription_id_connectivity     = var.subscription_id_connectivity
  configure_connectivity_resources = var.configure_connectivity_resources
  connectivity_resources_tags = merge(
    local.disable_base_module_tags ? local.empty_map : local.base_module_tags,
    local.default_tags,
    local.configure_connectivity_resources.tags,
  )
  connectivity_resources_advanced = merge(
    local.create_object,
    coalesce(local.configure_connectivity_resources.advanced, local.empty_map),
  )
}

resource "azurerm_management_group" "level_1" {
  count        = var.deploy_core_landing_zones ? 1 : 0
  display_name = var.root_name
  name         = local.root_id
  parent_management_group_id = var.root_parent_id
  timeouts {
    create = lookup(var.create_duration_delay, "azurerm_management_group", "30s")
    delete = lookup(var.destroy_duration_delay, "azurerm_management_group", "0s")
  }
}

resource "azurerm_management_group" "level_2" {
  count = var.deploy_core_landing_zones ? 3 : 0
  display_name = element([
    "Platform",
    "Landing Zones",
    "Decommissioned",
  ], count.index)
  name = element([
    "${local.root_id}-platform",
    "${local.root_id}-landing-zones",
    "${local.root_id}-decommissioned",
  ], count.index)
  parent_management_group_id = local.root_id
  timeouts {
    create = lookup(var.create_duration_delay, "azurerm_management_group", "30s")
    delete = lookup(var.destroy_duration_delay, "azurerm_management_group", "0s")
  }
}

resource "azurerm_management_group" "level_3" {
  count = var.deploy_core_landing_zones ? 3 : 0
  display_name = element([
    "Connectivity",
    "Management",
    "Identity",
  ], count.index)
  name = element([
    "${local.root_id}-connectivity",
    "${local.root_id}-management",
    "${local.root_id}-identity",
  ], count.index)
  parent_management_group_id = "${local.root_id}-platform"
  timeouts {
    create = lookup(var.create_duration_delay, "azurerm_management_group", "30s")
    delete = lookup(var.destroy_duration_delay, "azurerm_management_group", "0s")
  }
}

resource "azurerm_management_group" "level_4" {
  count = var.deploy_core_landing_zones ? 1 : 0
  display_name = "Sandboxes"
  name         = "${local.root_id}-sandboxes"
  parent_management_group_id = "${local.root_id}-landing-zones"
  timeouts {
    create = lookup(var.create_duration_delay, "azurerm_management_group", "30s")
    delete = lookup(var.destroy_duration_delay, "azurerm_management_group", "0s")
  }
}

resource "azurerm_management_group" "level_5" {
  count = var.deploy_demo_landing_zones ? 3 : 0
  display_name = element([
    "Corp",
    "Online",
    "SAP",
  ], count.index)
  name = element([
    "${local.root_id}-corp",
    "${local.root_id}-online",
    "${local.root_id}-sap",
  ], count.index)
  parent_management_group_id = "${local.root_id}-landing-zones"
  timeouts {
    create = lookup(var.create_duration_delay, "azurerm_management_group", "30s")
    delete = lookup(var.destroy_duration_delay, "azurerm_management_group", "0s")
  }
}

resource "azurerm_management_group" "level_6" {
  count = length(var.custom_landing_zones)
  for_each = {
    for key, value in var.custom_landing_zones : key => value
  }
  display_name = each.value.display_name
  name         = "${local.root_id}-${each.key}"
  parent_management_group_id = each.value.parent_management_group_id
  timeouts {
    create = lookup(var.create_duration_delay, "azurerm_management_group", "30s")
    delete = lookup(var.destroy_duration_delay, "azurerm_management_group", "0s")
  }
}

resource "azurerm_management_group_subscription_association" "enterprise_scale" {
  for_each = {
    for key, value in local.es_landing_zones_map : key => value
    if length(value.subscription_ids) > 0
  }
  subscription_id     = each.value.subscription_ids[0]
  management_group_id = each.key
  depends_on = [
    module.management_group_archetypes
  ]
}

resource "azurerm_policy_definition" "enterprise_scale" {
  count        = length(module.management_group_archetypes) > 0 ? length(module.management_group_archetypes[keys(module.management_group_archetypes)[0]].policy_definition) : 0
  name         = module.management_group_archetypes[keys(module.management_group_archetypes)[0]].policy_definition[count.index].policy_definition_name
  policy_type  = "Custom"
  mode = module.management_group_archetypes[keys(module.management_group_archetypes)[0]].policy_definition[count.index].policy_definition_mode
  display_name = module.management_group_archetypes[keys(module.management_group_archetypes)[0]].policy_definition[count.index].policy_definition_display_name
  metadata = jsonencode(module.management_group_archetypes[keys(module.management_group_archetypes)[0]].policy_definition[count.index].metadata)
}

resource "azurerm_policy_set_definition" "enterprise_scale" {
  count = length(module.management_group_archetypes) > 0 ? length(module.management_group_archetypes[keys(module.management_group_archetypes)[0]].policy_set_definition) : 0
  name = module.management_group_archetypes[keys(module.management_group_archetypes)[0]].policy_set_definition[count.index].policy_set_definition_name
  display_name = module.management_group_archetypes[keys(module.management_group_archetypes)[0]].policy_set_definition[count.index].policy_set_definition_display_name
  policy_type = "Custom"
  description = module.management_group_archetypes[keys(module.management_group_archetypes)[0]].policy_set_definition[count.index].policy_set_definition_description
  management_group_id = keys(module.management_group_archetypes)[0]
  policy_definition_reference {
    policy_definition_id = module.management_group_archetypes[keys(module.management_group_archetypes)[0]].policy_set_definition[count.index].policy_definition_id
    reference_id = module.management_group_archetypes[keys(module.management_group_archetypes)[0]].policy_set_definition[count.index].reference_id
    parameter_values = jsonencode(module.management_group_archetypes[keys(module.management_group_archetypes)[0]].policy_set_definition[count.index].parameter_values)
  }
  metadata = jsonencode(module.management_group_archetypes[keys(module.management_group_archetypes)[0]].policy_set_definition[count.index].metadata)
  timeouts {
    create = lookup(var.create_duration_delay, "azurerm_policy_set_definition", "30s")
  }
}

resource "azurerm_management_group_policy_assignment" "enterprise_scale" {
  for_each = module.management_group_archetypes
  name                 = each.value.policy_assignment_name
  display_name         = each.value.policy_assignment_display_name
  description          = each.value.policy_assignment_description
  management_group_id  = each.key
  policy_definition_id = each.value.policy_definition_id
}

resource "azurerm_role_definition" "enterprise_scale" {
  count = length(module.management_group_archetypes) > 0 ? length(module.management_group_archetypes[keys(module.management_group_archetypes)[0]].role_definition) : 0
  name = module.management_group_archetypes[keys(module.management_group_archetypes)[0]].role_definition[count.index].role_definition_name
  scope = keys(module.management_group_archetypes)[0]
  description = module.management_group_archetypes[keys(module.management_group_archetypes)[0]].role_definition[count.index].role_definition_description
}

resource "azurerm_role_assignment" "enterprise_scale" {
  for_each = module.management_group_archetypes
  scope                = each.key
  role_definition_id   = each.value.role_definition_id

  principal_id         = each.value.principal_id
}

resource "azurerm_resource_group" "management" {
  count    = local.deploy_management_resources ? 1 : 0
  name     = "${local.root_id}-management-rg"
  location = local.default_location
  tags     = local.management_resources_tags
}

resource "azurerm_resource_group" "connectivity" {
  count    = local.deploy_connectivity_resources ? 1 : 0
  name     = "${local.root_id}-connectivity-rg"
  location = local.default_location
  tags     = local.connectivity_resources_tags
}

resource "azurerm_resource_group" "virtual_wan" {
  count    = local.deploy_connectivity_resources && local.configure_connectivity_resources.settings.virtual_wan.enabled ? 1 : 0
  name     = "${local.root_id}-virtual-wan-rg"
  location = local.default_location
  tags     = local.connectivity_resources_tags
}

resource "azurerm_log_analytics_workspace" "management" {
  count               = local.deploy_management_resources && local.configure_management_resources.settings.log_analytics.enabled && local.management_resources_advanced.existing_log_analytics_workspace_resource_id == local.empty_string ? 1 : 0
  name                = "${local.root_id}-log-analytics"
  location            = local.configure_management_resources.location
  resource_group_name = azurerm_resource_group.management[0].name
  sku                 = "PerGB2018"
  tags                = local.management_resources_tags
}

resource "azurerm_log_analytics_solution" "management" {
  count                 = local.deploy_management_resources && local.configure_management_resources.settings.security_center.enabled && local.management_resources_advanced.existing_log_analytics_workspace_resource_id == local.empty_string ? 1 : 0
  location              = local.configure_management_resources.location
  resource_group_name   = azurerm_resource_group.management[0].name
  workspace_resource_id = azurerm_log_analytics_workspace.management[0].id
  solution_name         = "SecurityInsights"
  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/SecurityInsights"
  }
  workspace_name = azurerm_log_analytics_workspace.management[0].name
}


resource "azurerm_automation_account" "management" {
  count                     = local.deploy_management_resources && local.configure_management_resources.settings.automation.enabled && local.management_resources_advanced.existing_automation_account_resource_id == local.empty_string ? 1 : 0
  name                      = "${local.root_id}-automation"
  location                  = local.configure_management_resources.location
  resource_group_name       = azurerm_resource_group.management[0].name
  sku_name                  = "Basic"
  tags                      = local.management_resources_tags
}

resource "azurerm_log_analytics_linked_service" "management" {
  count                     = local.deploy_management_resources && local.configure_management_resources.settings.automation.enabled && local.management_resources_advanced.existing_log_analytics_workspace_resource_id == local.empty_string && local.management_resources_advanced.existing_automation_account_resource_id == local.empty_string && local.management_resources_advanced.link_log_analytics_to_automation_account ? 1 : 0
  resource_group_name       = azurerm_resource_group.management[0].name
  workspace_id              = azurerm_log_analytics_workspace.management[0].id
}

resource "azurerm_virtual_network" "connectivity" {
  count               = local.deploy_connectivity_resources && local.configure_connectivity_resources.settings.hub_network.enabled ? 1 : 0
  name                = "${local.root_id}-hub-network"
  location            = local.configure_connectivity_resources.location
  resource_group_name = azurerm_resource_group.connectivity[0].name
  address_space       = [local.configure_connectivity_resources.settings.hub_network.address_prefixes[0]]
  tags                = local.connectivity_resources_tags
}

resource "azurerm_subnet" "connectivity" {
  count                = local.deploy_connectivity_resources && local.configure_connectivity_resources.settings.hub_network.enabled && length(local.configure_connectivity_resources.settings.hub_network.subnets) > 0 ? length(local.configure_connectivity_resources.settings.hub_network.subnets) : 0
  name                 = local.configure_connectivity_resources.settings.hub_network.subnets[count.index].name
  resource_group_name  = azurerm_resource_group.connectivity[0].name
  virtual_network_name = azurerm_virtual_network.connectivity[0].name
  address_prefixes     = [local.configure_connectivity_resources.settings.hub_network.subnets[count.index].address_prefix]
}

resource "azurerm_network_ddos_protection_plan" "connectivity" {
  count               = local.deploy_connectivity_resources && local.configure_connectivity_resources.settings.ddos_protection.enabled && local.connectivity_resources_advanced.existing_ddos_protection_plan_resource_id == local.empty_string ? 1 : 0
  name                = "${local.root_id}-ddos-plan"
  location            = local.configure_connectivity_resources.location
  resource_group_name = azurerm_resource_group.connectivity[0].name
  tags                = local.connectivity_resources_tags
}

resource "azurerm_public_ip" "connectivity" {
  count               = local.deploy_connectivity_resources && local.configure_connectivity_resources.settings.firewall.enabled ? 1 : 0
  name                = "${local.root_id}-firewall-pip"
  location            = local.configure_connectivity_resources.location
  resource_group_name = azurerm_resource_group.connectivity[0].name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.connectivity_resources_tags
}

resource "azurerm_virtual_network_gateway" "connectivity" {
  count               = local.deploy_connectivity_resources && local.configure_connectivity_resources.settings.vpn_gateway.enabled ? 1 : 0
  name                = "${local.root_id}-vpn-gateway"
  location            = local.configure_connectivity_resources.location
  resource_group_name = azurerm_resource_group.connectivity[0].name
  sku                 = local.configure_connectivity_resources.settings.vpn_gateway.sku
  type                = local.configure_connectivity_resources.settings.vpn_gateway.type
  ip_configuration {
    name                          = "vnetGatewayConfig"
    subnet_id                     = azurerm_subnet.connectivity[index(azurerm_subnet.connectivity[*].name, "GatewaySubnet")].id
    public_ip_address_id          = azurerm_public_ip.connectivity[0].id
  }
  tags = local.connectivity_resources_tags
}

resource "azurerm_firewall_policy" "connectivity" {
  count               = local.deploy_connectivity_resources && local.configure_connectivity_resources.settings.firewall.enabled && !local.configure_connectivity_resources.settings.firewall.use_existing_firewall_policy ? 1 : 0
  name                = "${local.root_id}-firewall-policy"
  resource_group_name = azurerm_resource_group.connectivity[0].name
  location            = local.configure_connectivity_resources.location
  tags                = local.connectivity_resources_tags
}

resource "azurerm_firewall_policy" "virtual_wan" {
  count               = local.deploy_connectivity_resources && local.configure_connectivity_resources.settings.firewall.enabled && local.configure_connectivity_resources.settings.virtual_wan.enabled && local.configure_connectivity_resources.settings.virtual_wan.use_existing_firewall_policy && !local.configure_connectivity_resources.settings.firewall.use_existing_firewall_policy ? 1 : 0
  name                = "${local.root_id}-vwan-firewall-policy"
  resource_group_name = azurerm_resource_group.virtual_wan[0].name
  location            = local.default_location
  tags                = local.connectivity_resources_tags
}

resource "azurerm_firewall" "connectivity" {
  count                   = local.deploy_connectivity_resources && local.configure_connectivity_resources.settings.firewall.enabled && !local.configure_connectivity_resources.settings.virtual_wan.enabled ? 1 : 0
  name                    = "${local.root_id}-firewall"
  location                = local.configure_connectivity_resources.location
  resource_group_name     = azurerm_resource_group.connectivity[0].name
  firewall_policy_id      = azurerm_firewall_policy.connectivity[0].id
  ip_configuration {
    name              = "firewallConfig"
    subnet_id         = azurerm_subnet.connectivity[index(azurerm_subnet.connectivity[*].name, "AzureFirewallSubnet")].id
    public_ip_address_id = azurerm_public_ip.connectivity[0].id
  }
  sku_name = "AZFW_VNet"
  sku_tier = local.configure_connectivity_resources.settings.hub_network.azure_firewall.config.sku_tier
  tags = local.connectivity_resources_tags
}

resource "azurerm_firewall" "virtual_wan" {
  count                   = local.deploy_connectivity_resources && local.configure_connectivity_resources.settings.firewall.enabled && local.configure_connectivity_resources.settings.virtual_wan.enabled && !local.configure_connectivity_resources.settings.virtual_wan.use_existing_firewall_policy ? 1 : 0
  name                    = "${local.root_id}-vwan-firewall"
  location                = local.default_location
  resource_group_name     = azurerm_resource_group.virtual_wan[0].name
  firewall_policy_id      = azurerm_firewall_policy.virtual_wan[0].id

  sku_name = "AZFW_Hub"
  sku_tier = local.configure_connectivity_resources.settings.virtual_wan.azure_firewall.config.sku_tier
  tags = local.connectivity_resources_tags
}

resource "azurerm_private_dns_zone" "connectivity" {
  count               = local.deploy_connectivity_resources && local.configure_connectivity_resources.settings.private_dns_zones.enabled ? length(local.configure_connectivity_resources.settings.private_dns_zones.resource_links) : 0
  name                = local.configure_connectivity_resources.settings.private_dns_zones.resource_links[count.index].private_dns_zone_name
  resource_group_name = azurerm_resource_group.connectivity[0].name
  tags                = local.connectivity_resources_tags
}

resource "azurerm_dns_zone" "connectivity" {
  count               = local.deploy_connectivity_resources && local.configure_connectivity_resources.settings.dns_zones.enabled ? length(local.configure_connectivity_resources.settings.dns_zones.zones) : 0
  name                = local.configure_connectivity_resources.settings.dns_zones.zones[count.index].name
  resource_group_name = azurerm_resource_group.connectivity[0].name
  tags                = local.connectivity_resources_tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "connectivity" {
  count                 = local.deploy_connectivity_resources && local.configure_connectivity_resources.settings.private_dns_zones.enabled ? length(local.configure_connectivity_resources.settings.private_dns_zones.resource_links) : 0
  name                  = "${local.root_id}-${local.configure_connectivity_resources.settings.private_dns_zones.resource_links[count.index].resource_link_name}"
  resource_group_name   = azurerm_resource_group.connectivity[0].name
  private_dns_zone_name = azurerm_private_dns_zone.connectivity[count.index].name
  virtual_network_id    = azurerm_virtual_network.connectivity[0].id
  registration_enabled  = false
  tags                  = local.connectivity_resources_tags
}

resource "azurerm_virtual_network_peering" "connectivity" {
  count                         = local.deploy_connectivity_resources && local.configure_connectivity_resources.settings.hub_network.enabled && local.configure_connectivity_resources.settings.virtual_wan.enabled && local.configure_connectivity_resources.settings.virtual_wan.enable_vpn_peering ? 1 : 0
  name                          = "${local.root_id}-vnet-peering"
  resource_group_name           = azurerm_resource_group.connectivity[0].name
  virtual_network_name          = azurerm_virtual_network.connectivity[0].name
  remote_virtual_network_id     = azurerm_virtual_hub.virtual_wan[0].id
  allow_virtual_network_access  = true
  allow_forwarded_traffic       = true
  use_remote_gateways           = false
}

resource "azurerm_virtual_wan" "virtual_wan" {
  count               = local.deploy_connectivity_resources && local.configure_connectivity_resources.settings.virtual_wan.enabled && local.connectivity_resources_advanced.existing_virtual_wan_resource_id == local.empty_string ? 1 : 0
  name                = "${local.root_id}-virtual-wan"
  location            = local.configure_connectivity_resources.location
  resource_group_name = azurerm_resource_group.virtual_wan[0].name
  tags                = local.connectivity_resources_tags
}

resource "azurerm_virtual_hub" "virtual_wan" {
  count               = local.deploy_connectivity_resources && local.configure_connectivity_resources.settings.virtual_wan.enabled ? 1 : 0
  name                = "${local.root_id}-virtual-hub"
  location            = local.configure_connectivity_resources.location
  resource_group_name = local.configure_connectivity_resources.settings.virtual_wan.resource_group_per_virtual_hub_location ? azurerm_resource_group.virtual_wan[0].name : azurerm_resource_group.connectivity[0].name
  virtual_wan_id      = local.connectivity_resources_advanced.existing_virtual_wan_resource_id != local.empty_string ? local.connectivity_resources_advanced.existing_virtual_wan_resource_id : azurerm_virtual_wan.virtual_wan[0].id
  address_prefix      = local.configure_connectivity_resources.settings.virtual_wan.hub_address_prefix
  tags                = local.connectivity_resources_tags
}

resource "azurerm_virtual_hub_routing_intent" "virtual_wan" {
  count               = local.deploy_connectivity_resources && local.configure_connectivity_resources.settings.virtual_wan.enabled && local.configure_connectivity_resources.settings.virtual_wan.default_routing.enabled ? 1 : 0
  name                = "${local.root_id}-default-routing-intent"
  virtual_hub_id      = azurerm_virtual_hub.virtual_wan[0].id
  routing_policy {
    name = "RouteToAzureFirewall"
    destinations = ["PrivateTraffic"]
    next_hop = azurerm_firewall.virtual_wan[0].id
  }
  # dynamic "policy" {
  #   for_each = local.deploy_connectivity_resources && local.configure_connectivity_resources.settings.virtual_wan.enabled && local.configure_connectivity_resources.settings.virtual_wan.default_routing.enabled ? [1] : []
  #   content {
  #     name = "RouteToAzureFirewall"
  #     destinations = ["PrivateTraffic"]
  #     next_hop {
  #       resource_id = azurerm_firewall.virtual_wan[0].id
  #       type = "VirtualAppliance"
  #     }
  #   }
  # }
      }

resource "azurerm_express_route_gateway" "virtual_wan" {
  count               = local.deploy_connectivity_resources && local.configure_connectivity_resources.settings.express_route_gateway.enabled ? 1 : 0
  name                = "${local.root_id}-er-gateway"
  location            = local.configure_connectivity_resources.location
  resource_group_name = local.configure_connectivity_resources.settings.virtual_wan.resource_group_per_virtual_hub_location ? azurerm_resource_group.virtual_wan[0].name : azurerm_resource_group.connectivity[0].name
  virtual_hub_id      = azurerm_virtual_hub.virtual_wan[0].id
  scale_units         = local.configure_connectivity_resources.settings.express_route_gateway.scale_units
  tags                = local.connectivity_resources_tags
}

resource "azurerm_vpn_gateway" "virtual_wan" {
  count               = local.deploy_connectivity_resources && local.configure_connectivity_resources.settings.vpn_gateway.enabled && local.configure_connectivity_resources.settings.virtual_wan.enabled ? 1 : 0
  name                = "${local.root_id}-vwan-vpn-gateway"
  location            = local.configure_connectivity_resources.location
  resource_group_name = local.configure_connectivity_resources.settings.virtual_wan.resource_group_per_virtual_hub_location ? azurerm_resource_group.virtual_wan[0].name : azurerm_resource_group.connectivity[0].name
  virtual_hub_id      = azurerm_virtual_hub.virtual_wan[0].id
  tags                = local.connectivity_resources_tags
}

resource "azurerm_virtual_hub_connection" "virtual_wan" {
  count                     = local.deploy_connectivity_resources && local.configure_connectivity_resources.settings.virtual_wan.enabled && local.configure_connectivity_resources.settings.hub_network.enabled && local.configure_connectivity_resources.settings.virtual_wan.enable_vpn_peering ? 1 : 0
  name                      = "${local.root_id}-hub-connection"
  virtual_hub_id            = azurerm_virtual_hub.virtual_wan[0].id
  remote_virtual_network_id = azurerm_virtual_network.connectivity[0].id
}

resource "azapi_resource" "data_collection_rule" {
  count = local.deploy_management_resources && local.configure_management_resources.settings.log_analytics.export_all_logs_to_storage_account && local.management_resources_advanced.asc_export_resource_group_name != local.empty_string ? 1 : 0
  type  = "Microsoft.Insights/dataCollectionRules@2021-09-01-preview"
  name  = "${local.root_id}-asc-dcr"
  location = local.configure_management_resources.location
  body = jsonencode({
    properties = {
      dataSources = {
        resourceHealthLogs = {}
        securityAlerts     = {}
        securityRecommendations = {}
      }
      destinations = {
        azureMonitorMetrics = {
          name = "AzureMonitorMetrics"
        }
        azureStorageBlobs = [
          {
            container                = "security-logs"
            name                     = "ESASCExport"
            storageAccountResourceId = "/subscriptions/${local.subscription_id_management}/resourceGroups/${local.management_resources_advanced.asc_export_resource_group_name}/providers/Microsoft.Storage/storageAccounts/${local.root_id}asclogexport"
          }
        ]
      }
      dataFlows = [
        { destinations = ["ESASCExport"], streams = ["Microsoft-ResourceHealthLogs"] },
        { destinations = ["ESASCExport"], streams = ["Microsoft-SecurityAlert"] },
        { destinations = ["ESASCExport"], streams = ["Microsoft-SecurityRecommendation"] }
      ]
    }
  })
}
