# The following locals are used to extract the Policy Assignment
# configuration from the archetype module output.
locals {
  es_policy_assignments_by_management_group = flatten([
    for archetype in values(module.management_group_archetypes) :
    archetype.configuration.policy_assignments
  ])
  es_policy_assignments_by_subscription = []
}
