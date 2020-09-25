# The following locals are used to extract the Role Definition
# configuration from the archetype module output.
locals {
  es_role_definitions_by_management_group = flatten([
    for archetype in values(module.management_group_archetypes) :
    archetype.configuration.role_definitions
  ])
  es_role_definitions_by_subscription = []
}
