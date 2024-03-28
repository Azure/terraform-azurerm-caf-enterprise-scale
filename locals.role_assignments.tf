# The following locals are used to extract the Role Assignment
# configuration from the archetype module outputs.
locals {
  es_role_assignments_by_management_group = flatten([
    for archetype in values(module.management_group_archetypes) :
    archetype.configuration.azurerm_role_assignment
  ])
  es_role_assignments_by_subscription = local.empty_list
  es_role_assignments = concat(
    local.es_role_assignments_by_management_group,
    local.es_role_assignments_by_subscription,
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

# The following locals are used to build the output of Role
# Assignments created by the child module.
locals {
  flatten_role_assignments_for_policy_output = flatten([
    for pa_id, role_assignments in module.role_assignments_for_policy : [
      for role_assignment_id, role_assignment_config in role_assignments.azurerm_role_assignment : {
        role_assignment_id     = role_assignment_id
        role_assignment_config = role_assignment_config
      }
    ]
  ])
  role_assignments_for_policy_output = {
    for role in local.flatten_role_assignments_for_policy_output :
    (role.role_assignment_id) => role.role_assignment_config
  }
}

# The following locals is required to resolve bug as per https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/794
# This locals is used by resource "azurerm_role_assignment" "private_dns_zone_contributor_connectivity"
# in resources.role_assignments.tf to determine if the connectivity management group exists

locals {
  connectivity_mg_exists = length([for k, v in local.es_landing_zones_map : v if (v.id == "${var.root_id}-connectivity")]) > 0
}