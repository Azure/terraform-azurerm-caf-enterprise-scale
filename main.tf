# The following module is used to generate the configuration
# data used to deploy all archetype resources at the
# Management Group scope. Future plans include repeating this
# for Subscription scope configuration so we can improve
# coverage for archetype patterns which deploy specific
# groups of Resources within a Subscription.
module "management_group_archetypes" {
  for_each = local.es_landing_zones_map
  source   = "./modules/archetypes"

  root_id                 = "${local.provider_path.management_groups}${local.root_id}"
  scope_id                = each.key
  archetype_id            = each.value.archetype_config.archetype_id
  parameters              = each.value.archetype_config.parameters
  access_control          = each.value.archetype_config.access_control
  library_path            = local.library_path
  template_file_variables = local.template_file_variables
  default_location        = local.default_location
  enforcement_mode = merge(
    try(module.connectivity_resources.configuration.archetype_config_overrides[basename(each.key)].enforcement_mode, null),
    try(module.identity_resources.configuration.archetype_config_overrides[basename(each.key)].enforcement_mode, null),
    try(module.management_resources.configuration.archetype_config_overrides[basename(each.key)].enforcement_mode, null),
  )
}

# The following module is used to generate the configuration
# data used to deploy platform resources based on the
# "management" landing zone archetype.
module "management_resources" {
  source = "./modules/management"

  # Mandatory input variables
  enabled         = local.deploy_management_resources
  root_id         = local.root_id
  subscription_id = local.subscription_id_management
  settings        = local.configure_management_resources.settings

  # Optional input variables (basic configuration)
  location = coalesce(local.configure_management_resources.location, local.default_location)
  tags     = local.management_resources_tags

  # Optional input variables (advanced configuration)
  resource_prefix                              = try(local.configure_management_resources.advanced.resource_prefix, local.empty_string)
  resource_suffix                              = try(local.configure_management_resources.advanced.resource_suffix, local.empty_string)
  existing_resource_group_name                 = try(local.configure_management_resources.advanced.existing_resource_group_name, local.empty_string)
  existing_log_analytics_workspace_resource_id = try(local.configure_management_resources.advanced.existing_log_analytics_workspace_resource_id, local.empty_string)
  existing_automation_account_resource_id      = try(local.configure_management_resources.advanced.existing_automation_account_resource_id, local.empty_string)
  link_log_analytics_to_automation_account     = try(local.configure_management_resources.advanced.link_log_analytics_to_automation_account, true)
  custom_settings_by_resource_type             = try(local.configure_management_resources.advanced.custom_settings_by_resource_type, local.empty_map)
}

# The following module is used to generate the configuration
# data used to deploy platform resources based on the
# "identity" landing zone archetype.
module "identity_resources" {
  source = "./modules/identity"

  # Mandatory input variables
  enabled  = local.deploy_identity_resources
  root_id  = local.root_id
  settings = local.configure_identity_resources.settings
}

# The following module is used to generate the configuration
# data used to deploy platform resources based on the
# "connectivity" landing zone archetype.
module "connectivity_resources" {
  source = "./modules/connectivity"

  # Mandatory input variables
  enabled         = local.deploy_connectivity_resources
  root_id         = local.root_id
  subscription_id = local.subscription_id_connectivity
  settings        = local.configure_connectivity_resources.settings

  # Optional input variables (basic configuration)
  location = coalesce(local.configure_connectivity_resources.location, local.default_location)
  tags     = local.connectivity_resources_tags

  # Optional input variables (advanced configuration)
  resource_prefix                           = try(local.configure_connectivity_resources.advanced.resource_prefix, local.empty_string)
  resource_suffix                           = try(local.configure_connectivity_resources.advanced.resource_suffix, local.empty_string)
  existing_ddos_protection_plan_resource_id = try(local.configure_connectivity_resources.advanced.existing_resource_group_name, local.empty_string)
  custom_settings_by_resource_type          = try(local.configure_connectivity_resources.advanced.custom_settings_by_resource_type, local.empty_map)
}
