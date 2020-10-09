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
  root_id                    = var.root_id
  root_name                  = var.root_name
  root_parent_id             = var.root_parent_id
  deploy_core_landing_zones  = var.deploy_core_landing_zones
  archetype_config_overrides = var.archetype_config_overrides
  subscription_id_overrides  = var.subscription_id_overrides
  deploy_demo_landing_zones  = var.deploy_demo_landing_zones
  custom_landing_zones       = var.custom_landing_zones
  library_path               = var.library_path
  template_file_variables    = var.template_file_variables
  default_location           = var.default_location
}

# The following locals are used to define base Azure
# provider paths
locals {
  provider_path = {
    management_groups = "/providers/Microsoft.Management/managementGroups/"
  }
}
