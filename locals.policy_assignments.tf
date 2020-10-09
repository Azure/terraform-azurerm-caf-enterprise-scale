# The following locals are used to extract the Policy Assignment
# configuration from the archetype module outputs.
locals {
  es_policy_assignments_by_management_group = flatten([
    for archetype in values(module.management_group_archetypes) :
    archetype.configuration.policy_assignments
  ])
  es_policy_assignments_by_subscription = []
  es_policy_assignments = concat(
    local.es_policy_assignments_by_management_group,
    local.es_policy_assignments_by_subscription,
  )
}

# The following locals are used to build the map of Policy
# Assignments to deploy.
locals {
  azurerm_policy_assignment_enterprise_scale = {
    for assignment in local.es_policy_assignments :
    assignment.resource_id => assignment
  }
}
