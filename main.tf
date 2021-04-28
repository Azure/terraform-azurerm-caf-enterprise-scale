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
  enforcement_mode        = try(module.management_resources.configuration.archetype_config_overrides[basename(each.key)].enforcement_mode, null)
  access_control          = each.value.archetype_config.access_control
  library_path            = local.library_path
  template_file_variables = local.template_file_variables
  default_location        = local.default_location
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
  tags     = coalesce(local.configure_management_resources.tags, local.default_tags)

  # Optional input variables (advanced configuration)
  resource_prefix                              = try(local.configure_management_resources.advanced.resource_prefix, local.empty_string)
  resource_suffix                              = try(local.configure_management_resources.advanced.resource_suffix, local.empty_string)
  existing_resource_group_name                 = try(local.configure_management_resources.advanced.existing_resource_group_name, local.empty_string)
  existing_log_analytics_workspace_resource_id = try(local.configure_management_resources.advanced.existing_log_analytics_workspace_resource_id, local.empty_string)
  existing_automation_account_resource_id      = try(local.configure_management_resources.advanced.existing_automation_account_resource_id, local.empty_string)
  link_log_analytics_to_automation_account     = try(local.configure_management_resources.advanced.link_log_analytics_to_automation_account, true)
  custom_settings_by_resource_type             = try(local.configure_management_resources.advanced.custom_settings_by_resource_type, local.empty_map)
}
