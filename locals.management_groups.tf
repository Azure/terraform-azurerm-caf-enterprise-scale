########################################################
# The locals defined within this file are used to generate
# the data model used to deploy the core Enterprise-scale
# Management Groups and any custom Management Groups
# specified via the es_custom_landing_zones variable.
########################################################

# The following locals are used to determine which archetype
# pattern to apply to the core Enterprise-scale Management
# Groups. To ensure a valid value is always provided, we
# provide a list of defaults in es_defaults which
# can be overridden using the es_overrides variable.
locals {
  es_archetype_config_defaults = {
    "${local.es_root_id}" = {
      archetype_id = "es_root"
      parameters   = local.empty_map
    }
    "${local.es_root_id}-decommissioned" = {
      archetype_id = "es_decommissioned"
      parameters   = local.empty_map
    }
    "${local.es_root_id}-sandboxes" = {
      archetype_id = "es_sandboxes"
      parameters   = local.empty_map
    }
    "${local.es_root_id}-landing-zones" = {
      archetype_id = "es_landing_zones"
      parameters   = local.empty_map
    }
    "${local.es_root_id}-platform" = {
      archetype_id = "es_platform"
      parameters   = local.empty_map
    }
    "${local.es_root_id}-connectivity" = {
      archetype_id = "es_connectivity_foundation"
      parameters   = local.empty_map
    }
    "${local.es_root_id}-management" = {
      archetype_id = "es_management"
      parameters   = local.empty_map
    }
    "${local.es_root_id}-identity" = {
      archetype_id = "es_identity"
      parameters   = local.empty_map
    }
    "${local.es_root_id}-demo-corp" = {
      archetype_id = "es_demo_corp"
      parameters   = local.empty_map
    }
    "${local.es_root_id}-demo-online" = {
      archetype_id = "es_demo_online"
      parameters   = local.empty_map
    }
    "${local.es_root_id}-demo-sap" = {
      archetype_id = "es_demo_sap"
      parameters   = local.empty_map
    }
  }
  es_archetype_config_overrides_map = {
    for key, value in local.es_archetype_config_overrides :
    key == "root" ? "${local.es_root_id}" : "${local.es_root_id}-${key}" => value
  }
  es_archetype_config_map = merge(
    local.es_archetype_config_defaults,
    local.es_archetype_config_overrides_map,
  )
}

# The following locals are used to determine which subscription_ids
# should be assigned to the core Enterprise-scale Management
# Groups. To ensure a valid value is always provided, we
# provide a list of defaults in es_subscription_ids_defaults which
# can be overridden using the es_subscription_ids_map variable.
locals {
  es_subscription_ids_defaults = {
    "${local.es_root_id}"                = local.empty_list
    "${local.es_root_id}-decommissioned" = local.empty_list
    "${local.es_root_id}-sandboxes"      = local.empty_list
    "${local.es_root_id}-landing-zones"  = local.empty_list
    "${local.es_root_id}-platform"       = local.empty_list
    "${local.es_root_id}-connectivity"   = local.empty_list
    "${local.es_root_id}-management"     = local.empty_list
    "${local.es_root_id}-identity"       = local.empty_list
    "${local.es_root_id}-demo-corp"      = local.empty_list
    "${local.es_root_id}-demo-online"    = local.empty_list
    "${local.es_root_id}-demo-sap"       = local.empty_list
  }
  es_subscription_ids_overrides_map = {
    for key, value in local.es_subscription_ids_overrides :
    key == "root" ? "${local.es_root_id}" : "${local.es_root_id}-${key}" => value
  }
  es_subscription_ids_map = merge(
    local.es_subscription_ids_defaults,
    local.es_subscription_ids_overrides_map,
  )
}

# The following locals are used to define the core Enterprise
# -scale Management Groups deployed by the module and uses
# logic to determine the full Management Group deployment
# hierarchy.
locals {
  # Mandatory core Enterprise-scale Management Groups
  es_core_landing_zones = {
    "${local.es_root_id}" = {
      display_name               = local.es_root_name
      parent_management_group_id = local.es_root_parent_id
      subscription_ids           = local.es_subscription_ids_map["${local.es_root_id}"]
      archetype_config           = local.es_archetype_config_map["${local.es_root_id}"]
    }
    "${local.es_root_id}-decommissioned" = {
      display_name               = "Decommissioned"
      parent_management_group_id = local.es_root_id
      subscription_ids           = local.es_subscription_ids_map["${local.es_root_id}-decommissioned"]
      archetype_config           = local.es_archetype_config_map["${local.es_root_id}-decommissioned"]
    }
    "${local.es_root_id}-sandboxes" = {
      display_name               = "Sandboxes"
      parent_management_group_id = local.es_root_id
      subscription_ids           = local.es_subscription_ids_map["${local.es_root_id}-sandboxes"]
      archetype_config           = local.es_archetype_config_map["${local.es_root_id}-sandboxes"]
    }
    "${local.es_root_id}-landing-zones" = {
      display_name               = "Landing Zones"
      parent_management_group_id = local.es_root_id
      subscription_ids           = local.es_subscription_ids_map["${local.es_root_id}-landing-zones"]
      archetype_config           = local.es_archetype_config_map["${local.es_root_id}-landing-zones"]
    }
    "${local.es_root_id}-platform" = {
      display_name               = "Platform"
      parent_management_group_id = local.es_root_id
      subscription_ids           = local.es_subscription_ids_map["${local.es_root_id}-platform"]
      archetype_config           = local.es_archetype_config_map["${local.es_root_id}-platform"]
    }
    "${local.es_root_id}-connectivity" = {
      display_name               = "Connectivity"
      parent_management_group_id = "${local.es_root_id}-platform"
      subscription_ids           = local.es_subscription_ids_map["${local.es_root_id}-connectivity"]
      archetype_config           = local.es_archetype_config_map["${local.es_root_id}-connectivity"]
    }
    "${local.es_root_id}-management" = {
      display_name               = "Management"
      parent_management_group_id = "${local.es_root_id}-platform"
      subscription_ids           = local.es_subscription_ids_map["${local.es_root_id}-management"]
      archetype_config           = local.es_archetype_config_map["${local.es_root_id}-management"]
    }
    "${local.es_root_id}-identity" = {
      display_name               = "Identity"
      parent_management_group_id = "${local.es_root_id}-platform"
      subscription_ids           = local.es_subscription_ids_map["${local.es_root_id}-identity"]
      archetype_config           = local.es_archetype_config_map["${local.es_root_id}-identity"]
    }
  }
  # Optional demo "Landing Zone" Enterprise-scale Management Groups
  es_demo_landing_zones = {
    "${local.es_root_id}-demo-corp" = {
      display_name               = "Corp"
      parent_management_group_id = "${local.es_root_id}-landing-zones"
      subscription_ids           = local.es_subscription_ids_map["${local.es_root_id}-demo-corp"]
      archetype_config           = local.es_archetype_config_map["${local.es_root_id}-demo-corp"]
    }
    "${local.es_root_id}-demo-online" = {
      display_name               = "Online"
      parent_management_group_id = "${local.es_root_id}-landing-zones"
      subscription_ids           = local.es_subscription_ids_map["${local.es_root_id}-demo-online"]
      archetype_config           = local.es_archetype_config_map["${local.es_root_id}-demo-online"]
    }
    "${local.es_root_id}-demo-sap" = {
      display_name               = "SAP"
      parent_management_group_id = "${local.es_root_id}-landing-zones"
      subscription_ids           = local.es_subscription_ids_map["${local.es_root_id}-demo-sap"]
      archetype_config           = local.es_archetype_config_map["${local.es_root_id}-demo-sap"]
    }
  }
  # Logic to determine whether to include the core Enterprise-scale
  # Management Groups as part of the deployment
  es_core_landing_zones_to_include = local.es_deploy_core_landing_zones ? local.es_core_landing_zones : local.empty_map
  # Logic to determine whether to include the demo "Landing Zone"
  # Enterprise-scale Management Groups as part of the deployment
  es_demo_landing_zones_to_include = local.es_deploy_demo_landing_zones ? local.es_demo_landing_zones : local.empty_map
  # Local map containing all Management Groups to deploy
  es_landing_zones_merge = merge(
    local.es_core_landing_zones_to_include,
    local.es_demo_landing_zones_to_include,
    local.es_custom_landing_zones,
  )
  # Logic to auto-generate values for Management Groups if needed
  # Allows the user to specify the Management Group ID when working with existing
  # Management Groups, or uses standard naming pattern if set to null
  es_landing_zones_map = {
    for key, value in local.es_landing_zones_merge :
    "${local.provider_path.management_groups}${key}" => {
      id                         = key
      display_name               = value.display_name
      parent_management_group_id = try(length(value.parent_management_group_id) > 0, false) ? replace(lower(value.parent_management_group_id), "/[^a-z0-9]/", "-") : local.es_root_parent_id
      subscription_ids           = value.subscription_ids
      archetype_config           = value.archetype_config
    }
  }
}

# The following local is used to merge the Management Group
# configuration from each level back into a single data
# object to return in the module outputs.
locals {
  es_management_group_output = merge(
    azurerm_management_group.level_1,
    azurerm_management_group.level_2,
    azurerm_management_group.level_3,
    azurerm_management_group.level_4,
    azurerm_management_group.level_5,
    azurerm_management_group.level_6,
  )
}
