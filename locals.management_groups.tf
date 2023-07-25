########################################################
# The locals defined within this file are used to generate
# the data model used to deploy the core Enterprise-scale
# Management Groups and any custom Management Groups
# specified via the custom_landing_zones variable.
########################################################

# The following locals are used to determine which archetype
# pattern to apply to the core Enterprise-scale Management
# Groups. To ensure a valid value is always provided, we
# provide a list of defaults in es_defaults which
# can be overridden using the es_overrides variable.
locals {
  es_archetype_config_defaults = {
    (local.root_id) = {
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
    "${local.root_id}-demo-corp" = {
      archetype_id   = "es_corp"
      parameters     = local.empty_map
      access_control = local.empty_map
    }
    "${local.root_id}-demo-online" = {
      archetype_id   = "es_online"
      parameters     = local.empty_map
      access_control = local.empty_map
    }
    "${local.root_id}-demo-sap" = {
      archetype_id   = "es_sap"
      parameters     = local.empty_map
      access_control = local.empty_map
    }
  }
  archetype_config_overrides_map = {
    for key, value in local.archetype_config_overrides :
    key == "root" ? local.root_id : "${local.root_id}-${key}" => value
  }
  es_archetype_config_map = {
    for key, value in local.es_archetype_config_defaults :
    key => {
      archetype_id     = coalesce(try(local.archetype_config_overrides_map[key].archetype_id, ""), local.es_archetype_config_defaults[key].archetype_id)
      parameters       = merge(try(local.archetype_config_overrides_map[key].parameters, {}), local.es_archetype_config_defaults[key].parameters)
      access_control   = merge(try(local.archetype_config_overrides_map[key].access_control, {}), local.es_archetype_config_defaults[key].access_control)
      enforcement_mode = try(local.archetype_config_overrides_map[key].enforcement_mode, local.empty_map)
    }
  }
}

# The following locals are used to determine which subscription_ids
# should be assigned to the core Enterprise-scale Management
# Groups. To ensure a valid value is always provided, we
# provide a list of defaults in es_subscription_ids_defaults which
# can be overridden using the subscription_id_overrides variable.
locals {
  es_subscription_ids_defaults = {
    (local.root_id)                   = local.empty_list
    "${local.root_id}-decommissioned" = local.empty_list
    "${local.root_id}-sandboxes"      = local.empty_list
    "${local.root_id}-landing-zones"  = local.empty_list
    "${local.root_id}-platform"       = local.empty_list
    "${local.root_id}-connectivity"   = local.empty_list
    "${local.root_id}-management"     = local.empty_list
    "${local.root_id}-identity"       = local.empty_list
    "${local.root_id}-corp"           = local.empty_list
    "${local.root_id}-online"         = local.empty_list
    "${local.root_id}-sap"            = local.empty_list
    "${local.root_id}-demo-corp"      = local.empty_list
    "${local.root_id}-demo-online"    = local.empty_list
    "${local.root_id}-demo-sap"       = local.empty_list
  }
  subscription_id_overrides_map = {
    for key, value in local.subscription_id_overrides :
    key == "root" ? local.root_id : "${local.root_id}-${key}" => value
  }
  es_subscription_ids_map = merge(
    local.es_subscription_ids_defaults,
    local.subscription_id_overrides_map,
  )
}

# The following locals are used to determine Management Group
# placement for the platform Subscriptions. Preference of
# placement is based on the following:
#   1. Management
#   2. Connectivity
#   3. Identity
# If a duplicate value is found in any of these scopes, the
# value will be discarded as per the described logic.
locals {
  subscription_ids_management = distinct(compact(concat(
    [local.subscription_id_management],
    local.es_subscription_ids_map["${local.root_id}-management"],
  )))
  subscription_ids_connectivity = [
    for id in distinct(compact(concat(
      [local.subscription_id_connectivity],
      local.es_subscription_ids_map["${local.root_id}-connectivity"],
    ))) :
    id
    if !contains(local.subscription_ids_management, id)
  ]
  subscription_ids_identity = [
    for id in distinct(compact(concat(
      [local.subscription_id_identity],
      local.es_subscription_ids_map["${local.root_id}-identity"],
    ))) :
    id
    if !contains(local.subscription_ids_management, id) &&
    !contains(local.subscription_ids_connectivity, id)
  ]
}

# The following locals are used to define the core Enterprise
# -scale Management Groups deployed by the module and uses
# logic to determine the full Management Group deployment
# hierarchy.
locals {
  # Mandatory core Enterprise-scale Management Groups
  es_core_landing_zones = {
    (local.root_id) = {
      display_name               = local.root_name
      parent_management_group_id = local.root_parent_id
      subscription_ids           = local.es_subscription_ids_map[local.root_id]
      archetype_config           = local.es_archetype_config_map[local.root_id]
    }
    "${local.root_id}-decommissioned" = {
      display_name               = "Decommissioned"
      parent_management_group_id = local.root_id
      subscription_ids           = local.es_subscription_ids_map["${local.root_id}-decommissioned"]
      archetype_config           = local.es_archetype_config_map["${local.root_id}-decommissioned"]
    }
    "${local.root_id}-sandboxes" = {
      display_name               = "Sandboxes"
      parent_management_group_id = local.root_id
      subscription_ids           = local.es_subscription_ids_map["${local.root_id}-sandboxes"]
      archetype_config           = local.es_archetype_config_map["${local.root_id}-sandboxes"]
    }
    "${local.root_id}-landing-zones" = {
      display_name               = "Landing Zones"
      parent_management_group_id = local.root_id
      subscription_ids           = local.es_subscription_ids_map["${local.root_id}-landing-zones"]
      archetype_config           = local.es_archetype_config_map["${local.root_id}-landing-zones"]
    }
    "${local.root_id}-platform" = {
      display_name               = "Platform"
      parent_management_group_id = local.root_id
      subscription_ids           = local.es_subscription_ids_map["${local.root_id}-platform"]
      archetype_config           = local.es_archetype_config_map["${local.root_id}-platform"]
    }
    "${local.root_id}-connectivity" = {
      display_name               = "Connectivity"
      parent_management_group_id = "${local.root_id}-platform"
      subscription_ids           = local.subscription_ids_connectivity
      archetype_config           = local.es_archetype_config_map["${local.root_id}-connectivity"]
    }
    "${local.root_id}-management" = {
      display_name               = "Management"
      parent_management_group_id = "${local.root_id}-platform"
      subscription_ids           = local.subscription_ids_management
      archetype_config           = local.es_archetype_config_map["${local.root_id}-management"]
    }
    "${local.root_id}-identity" = {
      display_name               = "Identity"
      parent_management_group_id = "${local.root_id}-platform"
      subscription_ids           = local.subscription_ids_identity
      archetype_config           = local.es_archetype_config_map["${local.root_id}-identity"]
    }
  }
  # Optional "Landing Zone" Enterprise-scale Management Groups
  es_corp_landing_zones = {
    "${local.root_id}-corp" = {
      display_name               = "Corp"
      parent_management_group_id = "${local.root_id}-landing-zones"
      subscription_ids           = local.es_subscription_ids_map["${local.root_id}-corp"]
      archetype_config           = local.es_archetype_config_map["${local.root_id}-corp"]
    }
  }
  es_online_landing_zones = {
    "${local.root_id}-online" = {
      display_name               = "Online"
      parent_management_group_id = "${local.root_id}-landing-zones"
      subscription_ids           = local.es_subscription_ids_map["${local.root_id}-online"]
      archetype_config           = local.es_archetype_config_map["${local.root_id}-online"]
    }
  }
  es_sap_landing_zones = {
    "${local.root_id}-sap" = {
      display_name               = "SAP"
      parent_management_group_id = "${local.root_id}-landing-zones"
      subscription_ids           = local.es_subscription_ids_map["${local.root_id}-sap"]
      archetype_config           = local.es_archetype_config_map["${local.root_id}-sap"]
    }
  }
  # Optional demo "Landing Zone" Enterprise-scale Management Groups
  es_demo_landing_zones = {
    "${local.root_id}-demo-corp" = {
      display_name               = "Corp (Demo)"
      parent_management_group_id = "${local.root_id}-landing-zones"
      subscription_ids           = local.es_subscription_ids_map["${local.root_id}-demo-corp"]
      archetype_config           = local.es_archetype_config_map["${local.root_id}-demo-corp"]
    }
    "${local.root_id}-demo-online" = {
      display_name               = "Online (Demo)"
      parent_management_group_id = "${local.root_id}-landing-zones"
      subscription_ids           = local.es_subscription_ids_map["${local.root_id}-demo-online"]
      archetype_config           = local.es_archetype_config_map["${local.root_id}-demo-online"]
    }
    "${local.root_id}-demo-sap" = {
      display_name               = "SAP (Demo)"
      parent_management_group_id = "${local.root_id}-landing-zones"
      subscription_ids           = local.es_subscription_ids_map["${local.root_id}-demo-sap"]
      archetype_config           = local.es_archetype_config_map["${local.root_id}-demo-sap"]
    }
  }
  # Logic to determine whether to include the core Enterprise-scale
  # Management Groups as part of the deployment
  es_core_landing_zones_to_include   = local.deploy_core_landing_zones ? local.es_core_landing_zones : null
  es_corp_landing_zones_to_include   = local.deploy_core_landing_zones && local.deploy_corp_landing_zones ? local.es_corp_landing_zones : null
  es_online_landing_zones_to_include = local.deploy_core_landing_zones && local.deploy_online_landing_zones ? local.es_online_landing_zones : null
  es_sap_landing_zones_to_include    = local.deploy_core_landing_zones && local.deploy_sap_landing_zones ? local.es_sap_landing_zones : null
  # Logic to determine whether to include the demo "Landing Zone"
  # Enterprise-scale Management Groups as part of the deployment
  es_demo_landing_zones_to_include = local.deploy_core_landing_zones && local.deploy_demo_landing_zones ? local.es_demo_landing_zones : null
  # Local map containing all Management Groups to deploy
  es_landing_zones_merge = merge(
    local.es_core_landing_zones_to_include,
    local.es_corp_landing_zones_to_include,
    local.es_online_landing_zones_to_include,
    local.es_sap_landing_zones_to_include,
    local.es_demo_landing_zones_to_include,
    local.custom_landing_zones,
  )
  # Logic to auto-generate values for Management Groups if needed
  # Allows the user to specify the Management Group ID when working with existing
  # Management Groups, or uses standard naming pattern if set to null
  es_landing_zones_map = {
    for key, value in local.es_landing_zones_merge :
    "${local.provider_path.management_groups}${key}" => {
      id                         = key
      display_name               = value.display_name
      parent_management_group_id = coalesce(value.parent_management_group_id, local.root_parent_id)
      subscription_ids           = local.strict_subscription_association ? value.subscription_ids : null
      archetype_config = {
        archetype_id   = value.archetype_config.archetype_id
        access_control = value.archetype_config.access_control
        parameters = {
          # The following logic merges parameter values from the connectivity,
          # identity and management sub-modules with the archetype defaults
          # (including custom_landing_zones) and archetype_config_overrides.
          # These values are then passed to the parameters input variable of the
          # archetypes sub-module.
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

  # Logic to determine which subscriptions to associate with Management Groups in relaxed mode.
  # Empty unless strict_subscription_association is set to false.
  mg_sub_association_list = flatten([
    for key, value in local.es_landing_zones_merge : [
      for sid in value.subscription_ids :
      {
        management_group_name = key
        subscription_id       = sid
      }
    ]
    if !local.strict_subscription_association
  ])

  # azurerm_management_group_subscription_association_enterprise_scale is used as the
  # for_each value to create azurerm_management_group_subscription_association
  # resources in relaxed mode.
  # Empty unless strict_subscription_association is set to false.
  azurerm_management_group_subscription_association_enterprise_scale = { for item in local.mg_sub_association_list :
    "${local.provider_path.management_groups}${item.management_group_name}/subscriptions/${item.subscription_id}" => {
      management_group_id = "${local.provider_path.management_groups}${item.management_group_name}"
      subscription_id     = "/subscriptions/${item.subscription_id}"
    }
  }
}


# The following locals are used to build the map of Management
# Groups to deploy at each level of the hierarchy.
locals {
  azurerm_management_group_level_1 = {
    for key, value in local.es_landing_zones_map :
    key => value
    if value.parent_management_group_id == local.root_parent_id
  }
  azurerm_management_group_level_2 = {
    for key, value in local.es_landing_zones_map :
    key => value
    if contains(keys(azurerm_management_group.level_1), try(length(value.parent_management_group_id) > 0, false) ? "${local.provider_path.management_groups}${value.parent_management_group_id}" : local.empty_string)
  }
  azurerm_management_group_level_3 = {
    for key, value in local.es_landing_zones_map :
    key => value
    if contains(keys(azurerm_management_group.level_2), try(length(value.parent_management_group_id) > 0, false) ? "${local.provider_path.management_groups}${value.parent_management_group_id}" : local.empty_string)
  }
  azurerm_management_group_level_4 = {
    for key, value in local.es_landing_zones_map :
    key => value
    if contains(keys(azurerm_management_group.level_3), try(length(value.parent_management_group_id) > 0, false) ? "${local.provider_path.management_groups}${value.parent_management_group_id}" : local.empty_string)
  }
  azurerm_management_group_level_5 = {
    for key, value in local.es_landing_zones_map :
    key => value
    if contains(keys(azurerm_management_group.level_4), try(length(value.parent_management_group_id) > 0, false) ? "${local.provider_path.management_groups}${value.parent_management_group_id}" : local.empty_string)
  }
  azurerm_management_group_level_6 = {
    for key, value in local.es_landing_zones_map :
    key => value
    if contains(keys(azurerm_management_group.level_5), try(length(value.parent_management_group_id) > 0, false) ? "${local.provider_path.management_groups}${value.parent_management_group_id}" : local.empty_string)
  }
}

# The following local is used to build the list of Management Groups
# that will have Diagnostic Settings deployed, based on boolean variable
# deploy_diagnostics_for_mg
locals {
  azapi_mg_diagnostics = {
    for mg_id in keys(local.es_landing_zones_map) :
    mg_id => ""
    if local.deploy_diagnostics_for_mg
  }
}
