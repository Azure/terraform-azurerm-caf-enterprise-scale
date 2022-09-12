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
    "${local.root_id}-prod-lz" = {
      archetype_id   = "es_landing_zones"
      parameters     = local.empty_map
      access_control = local.empty_map
    }
    "${local.root_id}-dev-lz" = {
      archetype_id   = "es_landing_zones"
      parameters     = local.empty_map
      access_control = local.empty_map
    }
    "${local.root_id}-test-lz" = {
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
    #Prod
    "${local.root_id}-corp_prod" = {
      archetype_id   = "es_corp_prod"
      parameters     = local.empty_map
      access_control = local.empty_map
    }
    "${local.root_id}-online_prod" = {
      archetype_id   = "es_online_prod"
      parameters     = local.empty_map
      access_control = local.empty_map
    }
    "${local.root_id}-epic_prod" = {
      archetype_id   = "es_epic_prod"
      parameters     = local.empty_map
      access_control = local.empty_map
    }
    "${local.root_id}-citrix_prod" = {
      archetype_id   = "es_citrix_prod"
      parameters     = local.empty_map
      access_control = local.empty_map
    }
    "${local.root_id}-clinic_prod" = {
      archetype_id   = "es_clinic_prod"
      parameters     = local.empty_map
      access_control = local.empty_map
    }
    "${local.root_id}-finance_prod" = {
      archetype_id   = "es_finance_prod"
      parameters     = local.empty_map
      access_control = local.empty_map
    }
    "${local.root_id}-business_prod" = {
      archetype_id   = "es_business_prod"
      parameters     = local.empty_map
      access_control = local.empty_map
    }
    #dev
    "${local.root_id}-corp_dev" = {
      archetype_id   = "es_corp_dev"
      parameters     = local.empty_map
      access_control = local.empty_map
    }
    "${local.root_id}-online_dev" = {
      archetype_id   = "es_online_dev"
      parameters     = local.empty_map
      access_control = local.empty_map
    }
    "${local.root_id}-epic_dev" = {
      archetype_id   = "es_epic_dev"
      parameters     = local.empty_map
      access_control = local.empty_map
    }
    "${local.root_id}-citrix_dev" = {
      archetype_id   = "es_citrix_dev"
      parameters     = local.empty_map
      access_control = local.empty_map
    }
    "${local.root_id}-clinic_dev" = {
      archetype_id   = "es_clinic_dev"
      parameters     = local.empty_map
      access_control = local.empty_map
    }
    "${local.root_id}-finance_dev" = {
      archetype_id   = "es_finance_dev"
      parameters     = local.empty_map
      access_control = local.empty_map
    }
    "${local.root_id}-business_dev" = {
      archetype_id   = "es_business_dev"
      parameters     = local.empty_map
      access_control = local.empty_map
    }
        #test
    "${local.root_id}-corp_test" = {
      archetype_id   = "es_corp_test"
      parameters     = local.empty_map
      access_control = local.empty_map
    }
    "${local.root_id}-online_test" = {
      archetype_id   = "es_online_test"
      parameters     = local.empty_map
      access_control = local.empty_map
    }
    "${local.root_id}-epic_test" = {
      archetype_id   = "es_epic_test"
      parameters     = local.empty_map
      access_control = local.empty_map
    }
    "${local.root_id}-citrix_test" = {
      archetype_id   = "es_citrix_test"
      parameters     = local.empty_map
      access_control = local.empty_map
    }
    "${local.root_id}-clinic_test" = {
      archetype_id   = "es_clinic_test"
      parameters     = local.empty_map
      access_control = local.empty_map
    }
    "${local.root_id}-finance_test" = {
      archetype_id   = "es_finance_test"
      parameters     = local.empty_map
      access_control = local.empty_map
    }
    "${local.root_id}-business_test" = {
      archetype_id   = "es_business_test"
      parameters     = local.empty_map
      access_control = local.empty_map
    }
    #demo
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
    "${local.root_id}-demo-epic" = {
      archetype_id   = "es_epic"
      parameters     = local.empty_map
      access_control = local.empty_map
    }

  }
  archetype_config_overrides_map = {
    for key, value in local.archetype_config_overrides :
    key == "root" ? local.root_id : "${local.root_id}-${key}" => value
  }
  es_archetype_config_map = merge(
    local.es_archetype_config_defaults,
    local.archetype_config_overrides_map,
  )
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
    "${local.root_id}-prod-lz"        = local.empty_list
    "${local.root_id}-dev-lz"         = local.empty_list
    "${local.root_id}-test-lz"        = local.empty_list
    "${local.root_id}-platform"       = local.empty_list
    "${local.root_id}-connectivity"   = local.empty_list
    "${local.root_id}-management"     = local.empty_list
    "${local.root_id}-identity"       = local.empty_list
    "${local.root_id}-corp_prod"      = local.empty_list
    "${local.root_id}-online_prod"    = local.empty_list
    "${local.root_id}-epic_prod"      = local.empty_list
    "${local.root_id}-citrix_prod"    = local.empty_list
    "${local.root_id}-finance_prod"   = local.empty_list
    "${local.root_id}-clinic_prod"    = local.empty_list
    "${local.root_id}-business_prod"  = local.empty_list
    "${local.root_id}-corp_dev"       = local.empty_list
    "${local.root_id}-online_dev"     = local.empty_list
    "${local.root_id}-epic_dev"       = local.empty_list
    "${local.root_id}-citrix_dev"     = local.empty_list
    "${local.root_id}-finance_dev"    = local.empty_list
    "${local.root_id}-clinic_dev"     = local.empty_list
    "${local.root_id}-business_dev"   = local.empty_list
        "${local.root_id}-corp_test"       = local.empty_list
    "${local.root_id}-online_test"     = local.empty_list
    "${local.root_id}-epic_test"       = local.empty_list
    "${local.root_id}-citrix_test"     = local.empty_list
    "${local.root_id}-finance_test"    = local.empty_list
    "${local.root_id}-clinic_test"     = local.empty_list
    "${local.root_id}-business_test"   = local.empty_list
    "${local.root_id}-demo-corp"      = local.empty_list
    "${local.root_id}-demo-online"    = local.empty_list
    "${local.root_id}-demo-epic"      = local.empty_list
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
    "${local.root_id}-prod-lz" = {
      display_name               = "Ohit Prod LZ"
      parent_management_group_id = local.root_id
      subscription_ids           = local.es_subscription_ids_map["${local.root_id}-prod-lz"]
      archetype_config           = local.es_archetype_config_map["${local.root_id}-prod-lz"]
    }
    "${local.root_id}-dev-lz" = {
      display_name               = "Ohit Dev LZ"
      parent_management_group_id = local.root_id
      subscription_ids           = local.es_subscription_ids_map["${local.root_id}-dev-lz"]
      archetype_config           = local.es_archetype_config_map["${local.root_id}-dev-lz"]
    }
    "${local.root_id}-test-lz" = {
      display_name               = "Ohit Test LZ"
      parent_management_group_id = local.root_id
      subscription_ids           = local.es_subscription_ids_map["${local.root_id}-test-lz"]
      archetype_config           = local.es_archetype_config_map["${local.root_id}-test-lz"]
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
  # Optional " Production Landing Zone" Enterprise-scale Management Groups
  es_corp_prod_landing_zones = {
    "${local.root_id}-corp-prod" = {
      display_name               = "Corp Production"
      parent_management_group_id = "${local.root_id}-prod-lz"
      subscription_ids           = local.es_subscription_ids_map["${local.root_id}-corp_prod"]
      archetype_config           = local.es_archetype_config_map["${local.root_id}-corp_prod"]
    }
  }
  es_online_prod_landing_zones = {
    "${local.root_id}-online-prod" = {
      display_name               = "Online Production"
      parent_management_group_id = "${local.root_id}-prod-lz"
      subscription_ids           = local.es_subscription_ids_map["${local.root_id}-online_prod"]
      archetype_config           = local.es_archetype_config_map["${local.root_id}-online_prod"]
    }
  }
  es_epic_prod_landing_zones = {
    "${local.root_id}-epic-prod" = {
      display_name               = "Epic Production"
      parent_management_group_id = "${local.root_id}-prod-lz"
      subscription_ids           = local.es_subscription_ids_map["${local.root_id}-epic_prod"]
      archetype_config           = local.es_archetype_config_map["${local.root_id}-epic_prod"]
    }
  }
  es_finance_prod_landing_zones = {
    "${local.root_id}-finance-prod" = {
      display_name               = "Finance Production"
      parent_management_group_id = "${local.root_id}-prod-lz"
      subscription_ids           = local.es_subscription_ids_map["${local.root_id}-finance_prod"]
      archetype_config           = local.es_archetype_config_map["${local.root_id}-finance_prod"]
    }
  }
  es_citrix_prod_landing_zones = {
    "${local.root_id}-citrix-prod" = {
      display_name               = "Citrix Production"
      parent_management_group_id = "${local.root_id}-prod-lz"
      subscription_ids           = local.es_subscription_ids_map["${local.root_id}-citrix_prod"]
      archetype_config           = local.es_archetype_config_map["${local.root_id}-citrix_prod"]
    }
  }
  es_clinic_prod_landing_zones = {
    "${local.root_id}-clinic-prod" = {
      display_name               = "Clinic Production"
      parent_management_group_id = "${local.root_id}-prod-lz"
      subscription_ids           = local.es_subscription_ids_map["${local.root_id}-clinic_prod"]
      archetype_config           = local.es_archetype_config_map["${local.root_id}-clinic_prod"]
    }
  }
  es_business_prod_landing_zones = {
    "${local.root_id}-business-prod" = {
      display_name               = "Business Production"
      parent_management_group_id = "${local.root_id}-prod-lz"
      subscription_ids           = local.es_subscription_ids_map["${local.root_id}-business_prod"]
      archetype_config           = local.es_archetype_config_map["${local.root_id}-business_prod"]
    }
  }
  # Optional " Dev Landing Zone" Enterprise-scale Management Groups
  es_corp_dev_landing_zones = {
    "${local.root_id}-corp-dev" = {
      display_name               = "Corp Development"
      parent_management_group_id = "${local.root_id}-dev-lz"
      subscription_ids           = local.es_subscription_ids_map["${local.root_id}-corp_dev"]
      archetype_config           = local.es_archetype_config_map["${local.root_id}-corp_dev"]
    }
  }
  es_online_dev_landing_zones = {
    "${local.root_id}-online-dev" = {
      display_name               = "Online Development"
      parent_management_group_id = "${local.root_id}-dev-lz"
      subscription_ids           = local.es_subscription_ids_map["${local.root_id}-online_dev"]
      archetype_config           = local.es_archetype_config_map["${local.root_id}-online_dev"]
    }
  }
  es_epic_dev_landing_zones = {
    "${local.root_id}-epic-dev" = {
      display_name               = "Epic Development"
      parent_management_group_id = "${local.root_id}-dev-lz"
      subscription_ids           = local.es_subscription_ids_map["${local.root_id}-epic_dev"]
      archetype_config           = local.es_archetype_config_map["${local.root_id}-epic_dev"]
    }
  }
  es_finance_dev_landing_zones = {
    "${local.root_id}-finance-dev" = {
      display_name               = "Finance Development"
      parent_management_group_id = "${local.root_id}-dev-lz"
      subscription_ids           = local.es_subscription_ids_map["${local.root_id}-finance_dev"]
      archetype_config           = local.es_archetype_config_map["${local.root_id}-finance_dev"]
    }
  }
  es_citrix_dev_landing_zones = {
    "${local.root_id}-citrix-dev" = {
      display_name               = "Citrix Development"
      parent_management_group_id = "${local.root_id}-dev-lz"
      subscription_ids           = local.es_subscription_ids_map["${local.root_id}-citrix_dev"]
      archetype_config           = local.es_archetype_config_map["${local.root_id}-citrix_dev"]
    }
  }
  es_clinic_dev_landing_zones = {
    "${local.root_id}-clinic-dev" = {
      display_name               = "Clinic Development"
      parent_management_group_id = "${local.root_id}-dev-lz"
      subscription_ids           = local.es_subscription_ids_map["${local.root_id}-clinic_dev"]
      archetype_config           = local.es_archetype_config_map["${local.root_id}-clinic_dev"]
    }
  }
  es_business_dev_landing_zones = {
    "${local.root_id}-business-dev" = {
      display_name               = "Business Development"
      parent_management_group_id = "${local.root_id}-dev-lz"
      subscription_ids           = local.es_subscription_ids_map["${local.root_id}-business_dev"]
      archetype_config           = local.es_archetype_config_map["${local.root_id}-business_dev"]
    }
  }
    # Optional " test Landing Zone" Enterprise-scale Management Groups
  es_corp_test_landing_zones = {
    "${local.root_id}-corp-test" = {
      display_name               = "Corp Testing"
      parent_management_group_id = "${local.root_id}-test-lz"
      subscription_ids           = local.es_subscription_ids_map["${local.root_id}-corp_test"]
      archetype_config           = local.es_archetype_config_map["${local.root_id}-corp_test"]
    }
  }
  es_online_test_landing_zones = {
    "${local.root_id}-online-test" = {
      display_name               = "Online Testing"
      parent_management_group_id = "${local.root_id}-test-lz"
      subscription_ids           = local.es_subscription_ids_map["${local.root_id}-online_test"]
      archetype_config           = local.es_archetype_config_map["${local.root_id}-online_test"]
    }
  }
  es_epic_test_landing_zones = {
    "${local.root_id}-epic-test" = {
      display_name               = "Epic Testing"
      parent_management_group_id = "${local.root_id}-test-lz"
      subscription_ids           = local.es_subscription_ids_map["${local.root_id}-epic_test"]
      archetype_config           = local.es_archetype_config_map["${local.root_id}-epic_test"]
    }
  }
  es_finance_test_landing_zones = {
    "${local.root_id}-finance-test" = {
      display_name               = "Finance Testing"
      parent_management_group_id = "${local.root_id}-test-lz"
      subscription_ids           = local.es_subscription_ids_map["${local.root_id}-finance_test"]
      archetype_config           = local.es_archetype_config_map["${local.root_id}-finance_test"]
    }
  }
  es_citrix_test_landing_zones = {
    "${local.root_id}-citrix-test" = {
      display_name               = "Citrix Testing"
      parent_management_group_id = "${local.root_id}-test-lz"
      subscription_ids           = local.es_subscription_ids_map["${local.root_id}-citrix_test"]
      archetype_config           = local.es_archetype_config_map["${local.root_id}-citrix_test"]
    }
  }
  es_clinic_test_landing_zones = {
    "${local.root_id}-clinic-test" = {
      display_name               = "Clinic Testing"
      parent_management_group_id = "${local.root_id}-test-lz"
      subscription_ids           = local.es_subscription_ids_map["${local.root_id}-clinic_test"]
      archetype_config           = local.es_archetype_config_map["${local.root_id}-clinic_test"]
    }
  }
  es_business_test_landing_zones = {
    "${local.root_id}-business-test" = {
      display_name               = "Business Testing"
      parent_management_group_id = "${local.root_id}-test-lz"
      subscription_ids           = local.es_subscription_ids_map["${local.root_id}-business_test"]
      archetype_config           = local.es_archetype_config_map["${local.root_id}-business_test"]
    }
  }
  # Optional demo "Landing Zone" Enterprise-scale Management Groups
  es_demo_landing_zones = {
    "${local.root_id}-demo-corp" = {
      display_name               = "Corp (Demo)"
      parent_management_group_id = "${local.root_id}-prod-lz"
      subscription_ids           = local.es_subscription_ids_map["${local.root_id}-demo-corp"]
      archetype_config           = local.es_archetype_config_map["${local.root_id}-demo-corp"]
    }
    "${local.root_id}-demo-online" = {
      display_name               = "Online (Demo)"
      parent_management_group_id = "${local.root_id}-prod-lz"
      subscription_ids           = local.es_subscription_ids_map["${local.root_id}-demo-online"]
      archetype_config           = local.es_archetype_config_map["${local.root_id}-demo-online"]
    }
    "${local.root_id}-demo-epic" = {
      display_name               = "epic (Demo)"
      parent_management_group_id = "${local.root_id}-prod-lz"
      subscription_ids           = local.es_subscription_ids_map["${local.root_id}-demo-epic"]
      archetype_config           = local.es_archetype_config_map["${local.root_id}-demo-epic"]
    }
  }
  # Logic to determine whether to include the core Enterprise-scale
  # Management Groups as part of the deployment
  es_core_landing_zones_to_include          = local.deploy_core_landing_zones ? local.es_core_landing_zones : null
  es_corp_prod_landing_zones_to_include     = local.deploy_core_landing_zones && local.deploy_corp_prod_landing_zones ? local.es_corp_prod_landing_zones : null
  es_online_prod_landing_zones_to_include   = local.deploy_core_landing_zones && local.deploy_online_prod_landing_zones ? local.es_online_prod_landing_zones : null
  es_epic_prod_landing_zones_to_include     = local.deploy_core_landing_zones && local.deploy_epic_prod_landing_zones ? local.es_epic_prod_landing_zones : null
  es_business_prod_landing_zones_to_include = local.deploy_core_landing_zones && local.deploy_business_prod_landing_zones ? local.es_business_prod_landing_zones : null
  es_citrix_prod_landing_zones_to_include   = local.deploy_core_landing_zones && local.deploy_citrix_prod_landing_zones ? local.es_citrix_prod_landing_zones : null
  es_clinic_prod_landing_zones_to_include   = local.deploy_core_landing_zones && local.deploy_clinic_prod_landing_zones ? local.es_clinic_prod_landing_zones : null
  es_finance_prod_landing_zones_to_include  = local.deploy_core_landing_zones && local.deploy_finance_prod_landing_zones ? local.es_finance_prod_landing_zones : null
  es_corp_dev_landing_zones_to_include      = local.deploy_core_landing_zones && local.deploy_corp_dev_landing_zones ? local.es_corp_dev_landing_zones : null
  es_online_dev_landing_zones_to_include    = local.deploy_core_landing_zones && local.deploy_online_dev_landing_zones ? local.es_online_dev_landing_zones : null
  es_epic_dev_landing_zones_to_include      = local.deploy_core_landing_zones && local.deploy_epic_dev_landing_zones ? local.es_epic_dev_landing_zones : null
  es_business_dev_landing_zones_to_include  = local.deploy_core_landing_zones && local.deploy_business_dev_landing_zones ? local.es_business_dev_landing_zones : null
  es_citrix_dev_landing_zones_to_include    = local.deploy_core_landing_zones && local.deploy_citrix_dev_landing_zones ? local.es_citrix_dev_landing_zones : null
  es_clinic_dev_landing_zones_to_include    = local.deploy_core_landing_zones && local.deploy_clinic_dev_landing_zones ? local.es_clinic_dev_landing_zones : null
  es_finance_dev_landing_zones_to_include   = local.deploy_core_landing_zones && local.deploy_finance_dev_landing_zones ? local.es_finance_dev_landing_zones : null
es_corp_test_landing_zones_to_include      = local.deploy_core_landing_zones && local.deploy_corp_test_landing_zones ? local.es_corp_test_landing_zones : null
  es_online_test_landing_zones_to_include    = local.deploy_core_landing_zones && local.deploy_online_test_landing_zones ? local.es_online_test_landing_zones : null
  es_epic_test_landing_zones_to_include      = local.deploy_core_landing_zones && local.deploy_epic_test_landing_zones ? local.es_epic_test_landing_zones : null
  es_business_test_landing_zones_to_include  = local.deploy_core_landing_zones && local.deploy_business_test_landing_zones ? local.es_business_test_landing_zones : null
  es_citrix_test_landing_zones_to_include    = local.deploy_core_landing_zones && local.deploy_citrix_test_landing_zones ? local.es_citrix_test_landing_zones : null
  es_clinic_test_landing_zones_to_include    = local.deploy_core_landing_zones && local.deploy_clinic_test_landing_zones ? local.es_clinic_test_landing_zones : null
  es_finance_test_landing_zones_to_include   = local.deploy_core_landing_zones && local.deploy_finance_test_landing_zones ? local.es_finance_test_landing_zones : null

  # Logic to determine whether to include the demo "Landing Zone"
  # Enterprise-scale Management Groups as part of the deployment
  es_demo_landing_zones_to_include = local.deploy_core_landing_zones && local.deploy_demo_landing_zones ? local.es_demo_landing_zones : null
  # Local map containing all Management Groups to deploy
  es_landing_zones_merge = merge(
    local.es_core_landing_zones_to_include,
    local.es_corp_prod_landing_zones_to_include,
    local.es_online_prod_landing_zones_to_include,
    local.es_epic_prod_landing_zones_to_include,
    local.es_citrix_prod_landing_zones_to_include,
    local.es_clinic_prod_landing_zones_to_include,
    local.es_business_prod_landing_zones_to_include,
    local.es_finance_prod_landing_zones_to_include,
    local.es_corp_dev_landing_zones_to_include,
    local.es_online_dev_landing_zones_to_include,
    local.es_epic_dev_landing_zones_to_include,
    local.es_citrix_dev_landing_zones_to_include,
    local.es_clinic_dev_landing_zones_to_include,
    local.es_business_dev_landing_zones_to_include,
    local.es_finance_dev_landing_zones_to_include,
        local.es_corp_test_landing_zones_to_include,
    local.es_online_test_landing_zones_to_include,
    local.es_epic_test_landing_zones_to_include,
    local.es_citrix_test_landing_zones_to_include,
    local.es_clinic_test_landing_zones_to_include,
    local.es_business_test_landing_zones_to_include,
    local.es_finance_test_landing_zones_to_include,
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
        parameters = merge(
          try(module.connectivity_resources.configuration.archetype_config_overrides[key].parameters, null),
          try(module.identity_resources.configuration.archetype_config_overrides[key].parameters, null),
          try(module.management_resources.configuration.archetype_config_overrides[key].parameters, null),
          value.archetype_config.parameters,
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
