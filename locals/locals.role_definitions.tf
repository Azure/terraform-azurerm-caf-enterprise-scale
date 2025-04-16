# The following locals are used to extract the Role Definition
# configuration from the archetype module outputs.
locals {
  es_role_definitions_by_management_group = flatten([
    for archetype in values(module.management_group_archetypes) :
    archetype.configuration.azurerm_role_definition
  ])
  es_role_definitions_by_subscription = local.empty_list
  es_role_definitions = concat(
    local.es_role_definitions_by_management_group,
    local.es_role_definitions_by_subscription,
  )
}

# The following locals are used to build the map of Role
# Definitions to deploy.
locals {
  azurerm_role_definition_enterprise_scale = {
    for definition in local.es_role_definitions :
    definition.resource_id => definition
  }
}
