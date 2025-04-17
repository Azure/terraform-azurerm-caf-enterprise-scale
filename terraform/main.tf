locals {
  disable_base_module_tags = false
  empty_map              = {}
  base_module_tags         = {}
  default_tags           = {}
  create_object            = {}



  es_archetype_config_defaults = {


  es_landing_zones_map = {
    for key, value in merge(
      local.es_core_landing_zones_to_include,
      local.es_corp_landing_zones_to_include,
      local.es_online_landing_zones_to_include,
      local.es_sap_landing_zones_to_include,
      local.es_demo_landing_zones_to_include,
      local.custom_landing_zones,
    ) :
    "${local.provider_path.management_groups}${key}" => {
      id                         = key
      display_name               = value.display_name
      parent_management_group_id = coalesce(value.parent_management_group_id, local.root_parent_id)
      subscription_ids           = local.strict_subscription_association ? value.subscription_ids : null
      archetype_config = {
        archetype_id   = value.archetype_config.archetype_id
        access_control = value.archetype_config.access_control
        parameters = {
          for policy_name in toset(keys(merge(
            lookup(module.connectivity_resources.configuration.archetype_config_overrides, key, local.parameter_map_default).parameters,
            lookup(module.identity_resources.configuration.archetype_config_overrides, key, local.parameter_map_default).parameters,
            lookup(module.management_resources.configuration.archetype_config_overrides, key, local.parameter_map_default).parameters,
            value.archetype_config.parameters,
          ))) :
          policy_name => merge(
            lookup(lookup(module.connectivity_resources.configuration.archetype_config_overrides, key, local.parameter_map_default).parameters, policy_name, null),
            lookup(lookup(module.identity_resources.configuration.archetype_config_overrides, key, local.parameter_map_default).parameters, policy_name, null),
            lookup(lookup(module.management_resources.configuration.archetype_config_overrides, key, local.parameter_map_default).parameters, policy_name, null),
            lookup(value.archetype_config.parameters, policy_name, null),
          )
        }
        enforcement_mode = merge(
          lookup(module.connectivity_resources.configuration.archetype_config_overrides, key, local.enforcement_mode_default).enforcement_mode,
          lookup(module.identity_resources.configuration.archetype_config_overrides, key, local.enforcement_mode_default).enforcement_mode,
          lookup(module.management_resources.configuration.archetype_config_overrides, key, local.enforcement_mode_default).enforcement_mode,
          lookup(value.archetype_config, "enforcement_mode", local.empty_map)
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
    coalesce(local.configure_management_resources.advanced, local.empty_map)
  )

  empty_string = ""
  empty_map    = tomap({})

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
    coalesce(local.configure_connectivity_resources.advanced, local.empty_map)
  )


  # The following locals are used to determine which archetype
  # pattern to apply to the core Enterprise-scale Management
  # Groups. To ensure a valid value is always provided, we
  # provide a list of defaults in es_defaults which
  # can be overridden using the es_overrides variable.
  es_archetype_config_defaults = {
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
}


resource "azurerm_management_group" "level_1" {
  count = 0
  # Add configuration for azurerm_management_group resources here
}

resource "azurerm_management_group" "level_2" {
  count = 0
  # Add configuration for azurerm_management_group resources here
}

resource "azurerm_management_group" "level_3" {
  count = 0
  # Add configuration for azurerm_management_group resources here
}

resource "azurerm_management_group" "level_4" {
  count = 0
  # Add configuration for azurerm_management_group resources here
}

resource "azurerm_management_group" "level_5" {
  count = 0
  # Add configuration for azurerm_management_group resources here
}

resource "azurerm_management_group" "level_6" {
  count = 0
  # Add configuration for azurerm_management_group resources here
}


resource "azurerm_management_group_subscription_association" "enterprise_scale" {
  count = 0
  # Add configuration for azurerm_management_group_subscription_association resources here
}

resource "azurerm_policy_definition" "enterprise_scale" {
  count = 0
  # Add configuration for azurerm_policy_definition resources here
}

resource "azurerm_policy_set_definition" "enterprise_scale" {
  count = 0
  # Add configuration for azurerm_policy_set_definition resources here
}

resource "azurerm_management_group_policy_assignment" "enterprise_scale" {
  count = 0
  # Add configuration for azurerm_management_group_policy_assignment resources here
}

resource "azurerm_role_definition" "enterprise_scale" {
  count = 0
  # Add configuration for azurerm_role_definition resources here
}

resource "azurerm_role_assignment" "enterprise_scale" {
  count = 0
  # Add configuration for azurerm_role_assignment resources here
}

resource "azurerm_resource_group" "management" {
  count = 0
  # Add configuration for azurerm_resource_group resources here
}

resource "azurerm_resource_group" "connectivity" {
  count = 0
  # Add configuration for azurerm_resource_group resources here
}

resource "azurerm_resource_group" "virtual_wan" {
  count = 0
  # Add configuration for azurerm_resource_group resources here
}

resource "azurerm_log_analytics_workspace" "management" {
  count = 0
  # Add configuration for azurerm_log_analytics_workspace resources here
}

resource "azurerm_log_analytics_solution" "management" {
  count = 0
  # Add configuration for azurerm_log_analytics_solution resources here
}

resource "azurerm_automation_account" "management" {
  count = 0
  # Add configuration for azurerm_automation_account resources here
}

resource "azurerm_log_analytics_linked_service" "management" {
  count = 0
  # Add configuration for azurerm_log_analytics_linked_service resources here
}

resource "azurerm_virtual_network" "connectivity" {
  count = 0
  # Add configuration for azurerm_virtual_network resources here
}

resource "azurerm_subnet" "connectivity" {
  count = 0
  # Add configuration for azurerm_subnet resources here
}

resource "azurerm_network_ddos_protection_plan" "connectivity" {
  count = 0
  # Add configuration for azurerm_network_ddos_protection_plan resources here
}

resource "azurerm_public_ip" "connectivity" {
  count = 0
  # Add configuration for azurerm_public_ip resources here
}

resource "azurerm_virtual_network_gateway" "connectivity" {
  count = 0
  # Add configuration for azurerm_virtual_network_gateway resources here
}

resource "azurerm_firewall_policy" "connectivity" {
  count = 0
  # Add configuration for azurerm_firewall_policy resources here
}

resource "azurerm_firewall_policy" "virtual_wan" {
  count = 0
  # Add configuration for azurerm_firewall_policy resources here
}

resource "azurerm_firewall" "connectivity" {
  count = 0
  # Add configuration for azurerm_firewall resources here
}

resource "azurerm_firewall" "virtual_wan" {
  count = 0
  # Add configuration for azurerm_firewall resources here
}

resource "azurerm_private_dns_zone" "connectivity" {
  count = 0
  # Add configuration for azurerm_private_dns_zone resources here
}

resource "azurerm_dns_zone" "connectivity" {
  count = 0
  # Add configuration for azurerm_dns_zone resources here
}

resource "azurerm_private_dns_zone_virtual_network_link" "connectivity" {
  count = 0
  # Add configuration for azurerm_private_dns_zone_virtual_network_link resources here
}

resource "azurerm_virtual_network_peering" "connectivity" {
  count = 0
  # Add configuration for azurerm_virtual_network_peering resources here
}

resource "azurerm_virtual_wan" "virtual_wan" {
  count = 0
  # Add configuration for azurerm_virtual_wan resources here
}

resource "azurerm_virtual_hub" "virtual_wan" {
  count = 0
  # Add configuration for azurerm_virtual_hub resources here
}

resource "azurerm_virtual_hub_routing_intent" "virtual_wan" {
  count = 0
  # Add configuration for azurerm_virtual_hub_routing_intent resources here
}

resource "azurerm_express_route_gateway" "virtual_wan" {
  count = 0
  # Add configuration for azurerm_express_route_gateway resources here
}

resource "azurerm_vpn_gateway" "virtual_wan" {
  count = 0
  # Add configuration for azurerm_vpn_gateway resources here
}

resource "azurerm_virtual_hub_connection" "virtual_wan" {
  count = 0
  # Add configuration for azurerm_virtual_hub_connection resources here
}

resource "azapi_resource" "data_collection_rule" {
  count = 0
  # Add configuration for azapi_resource resources here
}

resource "azurerm_user_assigned_identity" "management" {
  count = 0
  # Add configuration for azurerm_user_assigned_identity resources here
}



# The following module is used to generate the configuration
# data used to deploy all archetype resources at the
# Management Group scope. Future plans include repeating this
# for Subscription scope configuration so we can improve
# coverage for archetype patterns which deploy specific
# groups of Resources within a Subscription.
module "management_group_archetypes" {
  for_each = local.es_landing_zones_map
  source = "./modules/archetypes"

  root_id                 = "${local.provider_path.management_groups}${local.root_id}"
  scope_id                = each.key
  archetype_id            = each.value.archetype_config.archetype_id
  parameters              = each.value.archetype_config.parameters
  access_control          = each.value.archetype_config.access_control
  library_path            = local.library_path
  template_file_variables = local.template_file_variables
  default_location        = local.default_location
  enforcement_mode        = each.value.archetype_config.enforcement_mode
}

# The following module is used to generate the configuration
# data used to deploy platform resources based on the
# "management" landing zone archetype.
module "management_resources" {
  source = "./modules/management"

  # Mandatory input variables
  enabled = local.deploy_management_resources
  root_id = local.root_id
  subscription_id = local.subscription_id_management
  settings = local.configure_management_resources.settings

  # Optional input variables (basic configuration)
  location = coalesce(local.configure_management_resources.location, local.default_location)
  tags     = local.management_resources_tags

  # Optional input variables (advanced configuration)
  resource_prefix                              = lookup(local.management_resources_advanced, "resource_prefix", local.empty_string)
  resource_suffix                              = lookup(local.management_resources_advanced, "resource_suffix", local.empty_string)
  existing_resource_group_name                 = lookup(local.management_resources_advanced, "existing_resource_group_name", local.empty_string)
  existing_log_analytics_workspace_resource_id = lookup(local.management_resources_advanced, "existing_log_analytics_workspace_resource_id", local.empty_string)
  existing_automation_account_resource_id      = lookup(local.management_resources_advanced, "existing_automation_account_resource_id", local.empty_string)
  link_log_analytics_to_automation_account     = lookup(local.management_resources_advanced, "link_log_analytics_to_automation_account", true)
  custom_settings_by_resource_type             = lookup(local.management_resources_advanced, "custom_settings_by_resource_type", local.empty_map)
  asc_export_resource_group_name               = lookup(local.management_resources_advanced, "asc_export_resource_group_name", local.empty_string)
}

# The following module is used to generate the configuration
# data used to deploy platform resources based on the
# "identity" landing zone archetype.
module "identity_resources" {
  source = "./modules/identity"

  # Mandatory input variables
  enabled = local.deploy_identity_resources
  root_id = local.root_id
  settings = local.configure_identity_resources.settings
}

# The following module is used to generate the configuration
# data used to deploy platform resources based on the
# "connectivity" landing zone archetype.
module "connectivity_resources" {
  source = "./modules/connectivity"

  # Mandatory input variables
  enabled = local.deploy_connectivity_resources
  root_id = local.root_id
  subscription_id = local.subscription_id_connectivity
  settings = local.configure_connectivity_resources.settings

  # Optional input variables (basic configuration)
  location = coalesce(local.configure_connectivity_resources.location, local.default_location)
  tags     = local.connectivity_resources_tags

  # Optional input variables (advanced configuration)
  resource_prefix                                 = lookup(local.connectivity_resources_advanced, "resource_prefix", local.empty_string)
  resource_suffix                                 = lookup(local.connectivity_resources_advanced, "resource_suffix", local.empty_string)
  existing_ddos_protection_plan_resource_id       = lookup(local.connectivity_resources_advanced, "existing_ddos_protection_plan_resource_id", local.empty_string)
  existing_virtual_wan_resource_id                = lookup(local.connectivity_resources_advanced, "existing_virtual_wan_resource_id", local.empty_string)
  existing_virtual_wan_resource_group_name        = lookup(local.connectivity_resources_advanced, "existing_virtual_wan_resource_group_name", local.empty_string)
  resource_group_per_virtual_hub_location         = lookup(local.connectivity_resources_advanced, "resource_group_per_virtual_hub_location", false)
  custom_azure_backup_geo_codes                   = lookup(local.connectivity_resources_advanced, "custom_azure_backup_geo_codes", local.empty_map)
  custom_privatelink_azurestaticapps_partitionids = lookup(local.connectivity_resources_advanced, "custom_privatelink_azurestaticapps_partitionids", null)
  custom_settings_by_resource_type                = lookup(local.connectivity_resources_advanced, "custom_settings_by_resource_type", local.empty_map)
}
