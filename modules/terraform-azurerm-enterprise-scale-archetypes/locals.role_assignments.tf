# Generate the Role Assignment configurations for the specified archetype.
locals {
  archetype_role_assignments_list      = local.archetype_definition.role_assignments
  archetype_role_assignments_specified = try(length(local.archetype_role_assignments_list) > 0, false)
  archetype_role_assignments_output    = []
}
