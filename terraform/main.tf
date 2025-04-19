  terraform {
    required_providers {
      azapi = {
          source = "azure/azapi"
      }
      azurerm = {
          source = "hashicorp/azurerm"
      }
    }
  }
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

    subscription_id_connectivity     = var.subscription_id_connectivity
    configure_connectivity_resources = var.configure_connectivity_resources
    connectivity_resources_advanced = merge(
      local.create_object,
      coalesce(local.configure_connectivity_resources.advanced, local.empty_map),
    )
    connectivity_resources_tags = merge(
      local.disable_base_module_tags ? local.empty_map : local.base_module_tags,
      local.default_tags,
      local.configure_connectivity_resources.tags,
    )

    root_id                        = var.root_id
    subscription_id_management     = var.subscription_id_management
    configure_management_resources = var.configure_management_resources
    default_location               = lower(var.default_location)
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

    deploy_identity_resources    = var.deploy_identity_resources
    configure_identity_resources = var.configure_identity_resources

    es_archetype_config_defaults = {
      enforcement_mode_default = {}
      parameter_map_default    = {}
      "${local.root_id}" = {
        archetype_id   = "es_root"
        parameters     = local.empty_map
        access_control = local.empty_map
      }
      "${local.root_id}-decommissioned" = {
        archetype_id   = "es_decommissioned"
        parameters     = local.empty_map
        access_control = local.empty_map
      }
      "${local.root_id}-sandboxes" = {
        archetype_id   = "es_sandboxes"
        parameters     = local.empty_map
        access_control = local.empty_map
      }
      "${local.root_id}-landing-zones" = {
        archetype_id   = "es_landing_zones"
        parameters     = local.empty_map
        access_control = local.empty_map
      }
      "${local.root_id}-platform" = {
        archetype_id   = "es_platform"
        parameters     = local.empty_map
        access_control = local.empty_map
      }
      "${local.root_id}-connectivity" = {
        archetype_id   = "es_connectivity"
        parameters     = local.empty_map
        access_control = local.empty_map
      }
      "${local.root_id}-management" = {
        archetype_id   = "es_management"
        parameters     = local.empty_map
        access_control = local.empty_map
      }
      "${local.root_id}-identity" = {
        archetype_id   = "es_identity"
        parameters     = local.empty_map
        access_control = local.empty_map
      }
      "${local.root_id}-corp" = {
        archetype_id   = "es_corp"
        parameters     = local.empty_map
        access_control = local.empty_map
      }
      "${local.root_id}-online" = {
        archetype_id   = "es_online"
        parameters     = local.empty_map
        access_control = local.empty_map
      }
      "${local.root_id}-sap" = {
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

    connectivity_settings = lookup(local.configure_connectivity_resources.settings, "settings", {})
    vwan_hub_networks     = lookup(local.connectivity_settings, "vwan_hub_networks", [])
    hub_networks          = lookup(local.connectivity_settings, "hub_networks", [])
    dns_settings          = lookup(local.connectivity_settings, "dns", {})
    hub_network_settings  = lookup(local.connectivity_settings, "hub_network", {})
    vpn_gateway_settings  = lookup(local.connectivity_settings, "vpn_gateway", {})
    firewall_settings     = lookup(local.connectivity_settings, "firewall", {})
    ddos_protection_settings = lookup(local.connectivity_settings, "ddos_protection", {})
    express_route_gateway_settings = lookup(local.connectivity_settings, "express_route_gateway", {})

    management_settings   = lookup(local.configure_management_resources.settings, "settings", {})
    log_analytics_settings = lookup(local.management_settings, "log_analytics", {})
    security_center_settings = lookup(local.management_settings, "security_center", {})
    automation_settings    = lookup(local.management_settings, "automation", {})

    vwan_enabled = length(local.vwan_hub_networks) > 0
    hub_enabled  = length(local.hub_networks) > 0

    is_connectivity_enabled = var.deploy_connectivity_resources
    is_management_enabled   = var.deploy_management_resources

    # Alias for the output of the archetypes module (assuming a single instance)
    mgmt_group_archetypes_output = module.management_group_archetypes[keys(module.management_group_archetypes)[0]]

    # Aliases for common resource group names
    management_rg_name  = "${local.root_id}-management-rg"
    connectivity_rg_name = "${local.root_id}-connectivity-rg"
    virtual_wan_rg_name = "${local.root_id}-virtual-wan-rg"

    # Aliases for timeout lookups
    get_create_timeout = func(resource_type, default_value) {
      lookup(var.create_duration_delay, resource_type, default_value)
    }



    get_delete_timeout = func(resource_type, default_value) {
      lookup(var.destroy_duration_delay, resource_type, default_value)
    }
  }


  module "connectivity_resources" {
    source        = "./modules/connectivity"
    providers = {
      azurerm.connectivity = azurerm.connectivity
      azurerm              = azurerm.connectivity
      azurerm.subscription = azurerm.subscription
      azapi                = azapi
    }
    root_id         = local.root_id
    enabled         = local.is_connectivity_enabled
    subscription_id = var.subscription_id_connectivity
    settings        = local.configure_connectivity_resources.settings
    location        = local.configure_connectivity_resources.location
    tags            = local.connectivity_resources_tags
  }



  module "identity_resources" {
    source = "./modules/identity"
    providers = {
      azurerm.identity     = azurerm.identity
      azurerm              = azurerm.identity
      azurerm.subscription = azurerm.subscription
      azapi                = azapi
    }
    root_id  = local.root_id
    enabled  = var.deploy_identity_resources
    settings = local.configure_identity_resources.settings
  }

  module "management_resources" {
    source = "./modules/management"
    providers = {
      azurerm.management = azurerm.management
      azurerm              = azurerm.management
      azurerm.subscription = azurerm.management
      azapi                = azapi
    }
    root_id         = local.root_id
    subscription_id = var.subscription_id_management
    enabled         = local.is_management_enabled
  }

  module "management_group_archetypes" {
    source = "./modules/archetypes"
    providers = {
      azurerm.root         = azurerm.root
      azurerm              = azurerm.root
      azurerm.subscription = azurerm.subscription
      azapi                = azapi
    }
    root_id                 = local.root_id
    default_location        = local.default_location
    library_path            = var.library_path
    template_file_variables = local.template_file_variables
    archetype_id            = local.root_id # You might need to adjust this based on the module's requirements
    scope_id                = local.root_id # You might need to adjust this based on the module's requirements
    management_subscription_id = var.subscription_id_management
    connectivity_subscription_id = var.subscription_id_connectivity
  }

  resource "azurerm_management_group" "level_1" {
    count        = var.deploy_core_landing_zones ? 1 : 0
    display_name = var.root_name
    name         = local.root_id
    parent_management_group_id = var.root_parent_id
    timeouts {
      create = local.get_create_timeout("azurerm_management_group", "30s")
      delete = local.get_delete_timeout("azurerm_management_group", "0s")
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
      create = local.get_create_timeout("azurerm_management_group", "0s")
      delete = local.get_delete_timeout("azurerm_management_group", "0s")
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
      create = local.get_create_timeout("azurerm_management_group", "0s")
      delete = local.get_delete_timeout("azurerm_management_group", "0s")
    }
  }

  resource "azurerm_management_group" "level_4" {
    count                      = var.deploy_core_landing_zones ? 1 : 0
    display_name               = "Sandboxes"
    name                       = "${local.root_id}-sandboxes"
    parent_management_group_id = "${local.root_id}-landing-zones"
    timeouts {
      create = local.get_create_timeout("azurerm_management_group", "0s")
      delete = local.get_delete_timeout("azurerm_management_group", "0s")
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
      create = local.get_create_timeout("azurerm_management_group", "0s")
      delete = local.get_delete_timeout("azurerm_management_group", "0s")
    }
  }

  resource "azurerm_management_group" "level_6" {
    for_each = {
      for key, value in var.custom_landing_zones : key => value
    }
    display_name               = each.value.display_name
    name                       = "${local.root_id}-${each.key}"
    parent_management_group_id = each.value.parent_management_group_id
    timeouts {
      create = local.get_create_timeout("azurerm_management_group", "30s")
      delete = local.get_delete_timeout("azurerm_management_group", "0s")
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
    count        = length(module.management_group_archetypes) > 0 ? length(local.mgmt_group_archetypes_output.policy_definition) : 0
    name         = local.mgmt_group_archetypes_output.policy_definition[count.index].policy_definition_name
    policy_type  = "Custom"
    mode         = local.mgmt_group_archetypes_output.policy_definition[count.index].policy_definition_mode
    display_name = local.mgmt_group_archetypes_output.policy_definition[count.index].policy_definition_display_name
    metadata     = jsonencode(local.mgmt_group_archetypes_output.policy_definition[count.index].metadata)
  }

  resource "azurerm_policy_set_definition" "enterprise_scale" {
    count               = length(module.management_group_archetypes) > 0 ? length(local.mgmt_group_archetypes_output.policy_set_definition) : 0
    name                = local.mgmt_group_archetypes_output.policy_set_definition[count.index].policy_set_definition_name
    display_name        = local.mgmt_group_archetypes_output.policy_set_definition[count.index].policy_set_definition_display_name
    policy_type         = "Custom"
    description         = local.mgmt_group_archetypes_output.policy_set_definition[count.index].policy_set_definition_description
    management_group_id = keys(module.management_group_archetypes)[0]
    policy_definition_reference {
      policy_definition_id = local.mgmt_group_archetypes_output.policy_set_definition[count.index].policy_definition_id
      reference_id         = local.mgmt_group_archetypes_output.policy_set_definition[count.index].reference_id
      parameter_values     = jsonencode(local.mgmt_group_archetypes_output.policy_set_definition[count.index].parameter_values)
    }
    metadata = jsonencode(local.mgmt_group_archetypes_output.policy_set_definition[count.index].metadata)
    timeouts {
      create = local.get_create_timeout("azurerm_policy_set_definition", "30s")
    }
  }

  resource "azurerm_management_group_policy_assignment" "enterprise_scale" {
    for_each             = module.management_group_archetypes
    name                 = each.value.policy_assignment_name
    display_name         = each.value.policy_assignment_display_name
    description          = each.value.policy_assignment_description
    management_group_id  = each.key
    policy_definition_id = each.value.policy_definition_id
  }

  resource "azurerm_role_definition" "enterprise_scale" {
    count       = length(module.management_group_archetypes) > 0 ? length(local.mgmt_group_archetypes_output.role_definition) : 0
    name        = local.mgmt_group_archetypes_output.role_definition[count.index].role_definition_name
    scope       = keys(module.management_group_archetypes)[0]
    description = local.mgmt_group_archetypes_output.role_definition[count.index].role_definition_description
  }

  resource "azurerm_role_assignment" "enterprise_scale" {
    for_each           = module.management_group_archetypes
    scope              = each.key
    role_definition_id = each.value.role_definition_id

    principal_id = each.value.principal_id
  }

  resource "azurerm_resource_group" "management" {
    count    = local.is_management_enabled ? 1 : 0
    name     = local.management_rg_name
    location = local.default_location
    tags     = local.management_resources_tags
  }

  resource "azurerm_resource_group" "connectivity" {
    count    = local.is_connectivity_enabled ? 1 : 0
    name     = local.connectivity_rg_name
    location = local.default_location
    tags     = local.connectivity_resources_tags
  }

  resource "azurerm_resource_group" "virtual_wan" {
    count    = local.is_connectivity_enabled && lookup(local.connectivity_settings.virtual_wan, "enabled", false) ? 1 : 0
    name     = local.virtual_wan_rg_name
    location = local.default_location
    tags     = local.connectivity_resources_tags
  }

  resource "azurerm_log_analytics_workspace" "management" {
    count               = local.is_management_enabled && lookup(local.log_analytics_settings, "enabled", false) && local.management_resources_advanced.existing_log_analytics_workspace_resource_id == local.empty_string ? 1 : 0
    name                = "${local.root_id}-log-analytics" # Specific name, not aliased
    location            = local.configure_management_resources.location
    resource_group_name = azurerm_resource_group.management[0].name
    sku                 = "PerGB2018"
    tags                = local.management_resources_tags
  }

  resource "azurerm_log_analytics_solution" "management" {
    count                 = local.is_management_enabled && lookup(local.security_center_settings, "enabled", false) && local.management_resources_advanced.existing_log_analytics_workspace_resource_id == local.empty_string ? 1 : 0
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
    count               = local.is_management_enabled && lookup(local.automation_settings, "enabled", false) && local.management_resources_advanced.existing_automation_account_resource_id == local.empty_string ? 1 : 0
    name                = "${local.root_id}-automation" # Specific name, not aliased
    location            = local.configure_management_resources.location
    resource_group_name = azurerm_resource_group.management[0].name
    sku_name            = "Basic"
    tags                = local.management_resources_tags
  }

  resource "azurerm_log_analytics_linked_service" "management" {
    count               = local.is_management_enabled && lookup(local.automation_settings, "enabled", false) && local.management_resources_advanced.existing_log_analytics_workspace_resource_id == local.empty_string && local.management_resources_advanced.existing_automation_account_resource_id == local.empty_string && local.management_resources_advanced.link_log_analytics_to_automation_account ? 1 : 0
    resource_group_name = azurerm_resource_group.management[0].name
    workspace_id        = azurerm_log_analytics_workspace.management[0].id
    # You need to specify either read_access_id or write_access_id here based on your requirements.
    # Example:
    # write_access_id = azurerm_automation_account.management[0].id
  }

  resource "azurerm_virtual_network" "connectivity" {
    count               = local.is_connectivity_enabled && local.hub_enabled ? 1 : 0
    name                = "${local.root_id}-hub-network" # Specific name, not aliased
    location            = local.configure_connectivity_resources.location
    resource_group_name = azurerm_resource_group.connectivity[0].name
    address_space       = [lookup(local.hub_network_settings, "address_prefixes", [""])[0]]
    tags                = local.connectivity_resources_tags
  }

  #resource "azurerm_subnet" "connectivity" {
  #  count                = local.is_connectivity_enabled && lookup(local.hub_network_settings, "enabled", false) && length(lookup(local.hub_network_settings, "subnets", [])) > 0 ? length(lookup(local.hub_network_settings, "subnets", [])) : 0
  #  name                 = lookup(local.hub_network_settings.subnets[count.index], "name", "")
  #  resource_group_name  = azurerm_resource_group.connectivity[0].name
  #  virtual_network_name = azurerm_virtual_network.connectivity[0].name
  #  address_prefixes     = [lookup(local.hub_network_settings.subnets[count.index], "address_prefix", "")]
  #}

  resource "azurerm_network_ddos_protection_plan" "connectivity" {
    count               = local.is_connectivity_enabled && lookup(local.ddos_protection_settings, "enabled", false) ? 1 : 0
    name                = "${local.root_id}-ddos-plan" # Specific name, not aliased
    location            = local.configure_connectivity_resources.location
    resource_group_name = azurerm_resource_group.connectivity[0].name
    tags                = local.connectivity_resources_tags
  }

  resource "azurerm_public_ip" "connectivity" {
    count               = local.is_connectivity_enabled && lookup(local.firewall_settings, "enabled", false) ? 1 : 0
    name                = "${local.root_id}-firewall-pip" # Specific name, not aliased
    location            = local.configure_connectivity_resources.location
    resource_group_name = azurerm_resource_group.connectivity[0].name
    allocation_method   = "Static"
    sku                 = "Standard"
    tags                = local.connectivity_resources_tags
  }

  resource "azurerm_virtual_network_gateway" "connectivity" {
    count               = local.is_connectivity_enabled && lookup(local.hub_networks[0].virtual_network_gateway, "enabled", false) ? 1 : 0
    name                = "${local.root_id}-vpn-gateway" # Specific name, not aliased
    location            = local.configure_connectivity_resources.location
    resource_group_name = azurerm_resource_group.connectivity[0].name
    sku                 = lookup(local.vpn_gateway_settings, "sku", "")
    type                = lookup(local.vpn_gateway_settings, "type", "")
    ip_configuration {
      name                 = "vnetGatewayConfig"
      subnet_id            = azurerm_subnet.connectivity[index(azurerm_subnet.connectivity[*].name, "GatewaySubnet")].id
      public_ip_address_id = azurerm_public_ip.connectivity[0].id
    }
    tags = local.connectivity_resources_tags
  }

  resource "azurerm_firewall_policy" "connectivity" {
    count               = local.is_connectivity_enabled && lookup(local.hub_networks[0].azure_firewall, "enabled", false) ? 1 : 0
    name                = "${local.root_id}-firewall-policy" # Specific name, not aliased
    resource_group_name = azurerm_resource_group.connectivity[0].name
    location            = local.configure_connectivity_resources.location
    tags                = local.connectivity_resources_tags
  }

  resource "azurerm_firewall_policy" "virtual_wan" {
    count               = local.is_connectivity_enabled && local.vwan_enabled && lookup(local.vwan_hub_networks[0].azure_firewall, "enabled", false) ? 1 : 0
    name                = "${local.root_id}-vwan-firewall-policy" # Specific name, not aliased
    resource_group_name = azurerm_resource_group.virtual_wan[0].name
    location            = local.default_location
    tags                = local.connectivity_resources_tags
  }

  resource "azurerm_firewall" "connectivity" {
    count               = local.is_connectivity_enabled && lookup(local.hub_networks[0].azure_firewall, "enabled", false) && !local.vwan_enabled ? 1 : 0
    name                = "${local.root_id}-firewall" # Specific name, not aliased
    location            = local.configure_connectivity_resources.location
    resource_group_name = azurerm_resource_group.connectivity[0].name
    firewall_policy_id  = azurerm_firewall_policy.connectivity[0].id
    ip_configuration {
      name                 = "firewallConfig"
      subnet_id            = azurerm_subnet.connectivity[index(azurerm_subnet.connectivity[*].name, "AzureFirewallSubnet")].id
      public_ip_address_id = azurerm_public_ip.connectivity[0].id
    }
    sku_name = "AZFW_VNet"
    sku_tier = lookup(local.hub_network_settings.azure_firewall.config, "sku_tier", "")
    tags     = local.connectivity_resources_tags
  }

  resource "azurerm_firewall" "virtual_wan" {
    count               = local.is_connectivity_enabled && local.vwan_enabled && lookup(local.vwan_hub_networks[0].azure_firewall, "enabled", false) ? 1 : 0
    name                = "${local.root_id}-vwan-firewall" # Specific name, not aliased
    location            = local.default_location
    resource_group_name = azurerm_resource_group.virtual_wan[0].name
    firewall_policy_id  = azurerm_firewall_policy.virtual_wan[0].id

    sku_name = "AZFW_Hub"
    sku_tier = lookup(local.connectivity_settings.virtual_wan.azure_firewall.config, "sku_tier", "")
    tags     = local.connectivity_resources_tags
  }

  resource "azurerm_private_dns_zone" "connectivity" {
    count               = local.is_connectivity_enabled && lookup(local.dns_settings, "enabled", false) ? length(lookup(local.dns_settings.config, "private_dns_zones", [])) : 0
    name                = lookup(local.dns_settings.config.private_dns_zones[count.index], "", "")
    resource_group_name = azurerm_resource_group.connectivity[0].name
    tags                = local.connectivity_resources_tags
  }

  resource "azurerm_dns_zone" "connectivity" {
    count               = local.is_connectivity_enabled && lookup(local.dns_settings, "enabled", false) ? length(lookup(local.dns_settings.config, "public_dns_zones", [])) : 0
    name                = lookup(local.dns_settings.config.public_dns_zones[count.index], "", "")
    resource_group_name = azurerm_resource_group.connectivity[0].name
    tags                = local.connectivity_resources_tags
  }

  resource "azurerm_private_dns_zone_virtual_network_link" "connectivity" {
    count                 = local.is_connectivity_enabled && lookup(local.dns_settings, "enabled", false) ? length(lookup(local.dns_settings.config, "private_dns_zones", [])) : 0
    name                  = "${local.root_id}-${lookup(local.dns_settings.config.private_dns_zones[count.index], "", "")}-link"
    resource_group_name   = azurerm_resource_group.connectivity[0].name
    private_dns_zone_name = azurerm_private_dns_zone.connectivity[count.index].name
    virtual_network_id    = azurerm_virtual_network.connectivity[0].id
    registration_enabled  = false
    tags                  = local.connectivity_resources_tags
  }

  resource "azurerm_virtual_network_peering" "connectivity" {
    count                         = local.is_connectivity_enabled && local.vwan_enabled && lookup(local.vwan_hub_networks[0], "enable_virtual_hub_connections", false) ? 1 : 0
    name                          = "${local.root_id}-vnet-peering" # Specific name, not aliased
    resource_group_name           = azurerm_resource_group.connectivity[0].name
    virtual_network_name          = azurerm_virtual_network.connectivity[0].name
    remote_virtual_network_id     = azurerm_virtual_hub.virtual_wan[0].id
    allow_virtual_network_access  = true
    allow_forwarded_traffic       = true
    use_remote_gateways           = false
  }

  resource "azurerm_virtual_wan" "virtual_wan" {
    count               = local.is_connectivity_enabled && local.vwan_enabled && local.connectivity_resources_advanced.existing_virtual_wan_resource_id == local.empty_string ? 1 : 0
    name                = "${local.root_id}-virtual-wan" # Specific name, not aliased
    location            = local.configure_connectivity_resources.location
    resource_group_name = azurerm_resource_group.virtual_wan[0].name
    tags                = local.connectivity_resources_tags
  }

  resource "azurerm_virtual_hub" "virtual_wan" {
    count               = local.is_connectivity_enabled && local.vwan_enabled ? 1 : 0
    name                = "${local.root_id}-virtual-hub" # Specific name, not aliased
    location            = local.configure_connectivity_resources.location
    resource_group_name = lookup(local.configure_connectivity_resources.settings.virtual_wan, "resource_group_per_virtual_hub_location", false) ? azurerm_resource_group.virtual_wan[0].name : azurerm_resource_group.connectivity[0].name
    virtual_wan_id      = local.connectivity_resources_advanced.existing_virtual_wan_resource_id != local.empty_string ? local.connectivity_resources_advanced.existing_virtual_wan_resource_id : azurerm_virtual_wan.virtual_wan[0].id
    address_prefix      = lookup(local.connectivity_settings.virtual_wan, "hub_address_prefix", "")
    tags                = local.connectivity_resources_tags
  }

  resource "azurerm_virtual_hub_routing_intent" "virtual_wan" {
    count          = local.is_connectivity_enabled && local.vwan_enabled && lookup(local.vwan_hub_networks[0].routing_intent, "enabled", false) ? 1 : 0
    name           = "${local.root_id}-default-routing-intent" # Specific name, not aliased
    virtual_hub_id = azurerm_virtual_hub.virtual_wan[0].id
    routing_policy {
      name         = "RouteToAzureFirewall"
      destinations = ["PrivateTraffic"]
      next_hop     = azurerm_firewall.virtual_wan[0].id
    }
  }

  resource "azurerm_express_route_gateway" "virtual_wan" {
    count               = local.is_connectivity_enabled && local.vwan_enabled && lookup(local.vwan_hub_networks[0].expressroute_gateway, "enabled", false) ? 1 : 0
    name                = "${local.root_id}-er-gateway" # Specific name, not aliased
    location            = local.configure_connectivity_resources.location
    resource_group_name = lookup(local.configure_connectivity_resources.settings.virtual_wan, "resource_group_per_virtual_hub_location", false) ? azurerm_resource_group.virtual_wan[0].name : azurerm_resource_group.connectivity[0].name
    virtual_hub_id      = azurerm_virtual_hub.virtual_wan[0].id
    scale_units         = lookup(local.connectivity_settings.express_route_gateway, "scale_units", 1)
    tags                = local.connectivity_resources_tags
  }

  resource "azurerm_vpn_gateway" "virtual_wan" {
    count               = local.is_connectivity_enabled && local.vwan_enabled && lookup(local.vwan_hub_networks[0].vpn_gateway, "enabled", false) ? 1 : 0
    name                = "${local.root_id}-vwan-vpn-gateway" # Specific name, not aliased
    location            = local.configure_connectivity_resources.location
    resource_group_name = lookup(local.configure_connectivity_resources.settings.virtual_wan, "resource_group_per_virtual_hub_location", false) ? azurerm_resource_group.virtual_wan[0].name : azurerm_resource_group.connectivity[0].name
    virtual_hub_id      = azurerm_virtual_wan[0].id
    tags                = local.connectivity_resources_tags
  }

  resource "azurerm_virtual_hub_connection" "virtual_wan" {
    count                     = local.is_connectivity_enabled && local.vwan_enabled && local.hub_enabled && lookup(local.vwan_hub_networks[0], "enable_virtual_hub_connections", false) ? 1 : 0
    name                      = "${local.root_id}-hub-connection" # Specific name, not aliased
    virtual_hub_id            = azurerm_virtual_hub.virtual_wan[0].id
    remote_virtual_network_id = azurerm_virtual_network.connectivity[0].id
  }

  resource "azapi_resource" "data_collection_rule" {
    count    = local.is_management_enabled && lookup(local.log_analytics_settings, "export_all_logs_to_storage_account", false) && local.management_resources_advanced.asc_export_resource_group_name != local.empty_string ? 1 : 0
    type     = "Microsoft.Insights/dataCollectionRules@2021-09-01-preview"
    name     = "${local.root_id}-asc-dcr" # Specific name, not aliased
    location = local.configure_management_resources.location
    # You need to determine the correct parent_id for this resource.
    # It might be the subscription ID or a resource group ID.
    parent_id = "/subscriptions/${local.subscription_id_management}"
    body = jsonencode({
      properties = {
        dataSources = {
          resourceHealthLogs      = {}
          securityAlerts          = {}
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
          { destinations = ["Microsoft-SecurityRecommendation"] }
        ]
      }
    })
