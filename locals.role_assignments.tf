# The following locals are used to extract the Role Assignment
# configuration from the archetype module outputs.
locals {
  es_role_assignments_by_management_group = flatten([
    for archetype in values(module.management_group_archetypes) :
    archetype.configuration.azurerm_role_assignment
  ])
  es_role_assignments_by_subscription = []
  es_role_assignments = concat(
    local.es_role_assignments_by_management_group,
    local.es_role_assignments_by_subscription,
    local.es_role_assignments_by_policy_assignment,
  )
}

# The following locals are used to build the map of Role
# Assignments to deploy.
locals {
  azurerm_role_assignment_enterprise_scale = {
    for assignment in local.es_role_assignments :
    assignment.resource_id => assignment
  }
}
