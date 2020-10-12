# The following module is used to generate the configuration
# data used to deploy all archetype resources at the 
# Management Group scope. Future plans include repeating this
# for Subscription scope configuration so we can improve
# coverage for archetype patterns which deploy specific
# groups of Resources within a Subscription.
module "management_group_archetypes" {
  for_each = local.es_landing_zones_map
  source   = "./modules/terraform-azurerm-caf-enterprise-scale-archetypes"

  root_id                 = "${local.provider_path.management_groups}${local.root_id}"
  scope_id                = each.key
  archetype_id            = each.value.archetype_config.archetype_id
  parameters              = each.value.archetype_config.parameters
  access_control          = each.value.archetype_config.access_control
  library_path            = local.library_path
  template_file_variables = local.template_file_variables
  default_location        = local.default_location
}
