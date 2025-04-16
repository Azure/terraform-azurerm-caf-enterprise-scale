# The following locals are used to extract the Policy Set Definitions
# configuration from the archetype module outputs.
locals {
  es_policy_set_definitions_by_management_group = flatten([
    for archetype in values(module.management_group_archetypes) :
    archetype.configuration.azurerm_policy_set_definition
  ])
  es_policy_set_definitions_by_subscription = local.empty_list
  es_policy_set_definitions = concat(
    local.es_policy_set_definitions_by_management_group,
    local.es_policy_set_definitions_by_subscription,
  )
}

# The following locals are used to build the map of Policy Set
# Definitions to deploy.
locals {
  azurerm_policy_set_definition_enterprise_scale = {
    for definition in local.es_policy_set_definitions :
    definition.resource_id => definition
  }
}
