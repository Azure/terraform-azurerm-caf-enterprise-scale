# The following block of locals are used to avoid using
# empty object types in the code
locals {
  empty_list   = []
  empty_map    = {}
  empty_string = ""
}

# The following locals are used to convert basic input
# variables to locals before use elsewhere in the module
locals {
  es_root_id                    = var.es_root_id
  es_root_name                  = var.es_root_name
  es_root_parent_id             = var.es_root_parent_id
  es_deploy_core_landing_zones  = var.es_deploy_core_landing_zones
  es_archetype_config_overrides = var.es_archetype_config_overrides
  es_subscription_ids_overrides = var.es_subscription_ids_overrides
  es_deploy_demo_landing_zones  = var.es_deploy_demo_landing_zones
  es_custom_landing_zones       = var.es_custom_landing_zones
  es_archetype_library_path     = var.es_archetype_library_path
  es_default_location           = var.es_default_location
}

# The following locals are used to define base Azure
# provider paths
locals {
  provider_path = {
    management_groups = "/providers/Microsoft.Management/managementGroups/"
  }
}
