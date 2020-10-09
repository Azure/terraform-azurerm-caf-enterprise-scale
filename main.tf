# The following module is used to generate the configuration
# data used to deploy all archetype resources at the 
# Management Group scope. Future plans include repeating this
# for Subscription scope configuration so we can improve
# coverage for archetype patterns which deploy specific
# groups of Resources within a Subscription.
module "management_group_archetypes" {
  for_each = {
    for key, value in local.es_landing_zones_map :
    key => value
  }
  source = "./modules/terraform-azurerm-enterprise-scale-archetypes"

  root_id                           = "${local.provider_path.management_groups}${local.es_root_id}"
  scope_id                          = each.key
  archetype_id                      = each.value.archetype_config.archetype_id
  archetype_parameters              = each.value.archetype_config.parameters
  archetype_access_control          = each.value.archetype_config.access_control
  archetype_library_path            = local.es_archetype_library_path
  archetype_template_file_variables = local.es_archetype_template_file_variables
  default_location                  = local.es_default_location
}
