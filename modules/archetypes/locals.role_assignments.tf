# Generate the Role Assignment configurations for the specified archetype.
locals {
  archetype_role_assignments_map = merge(
    try(local.archetype_definition.archetype_config.access_control, local.empty_map),
    try(local.access_control, local.empty_map),
  )
}

# Extract the desired Role Assignments from archetype_role_assignments_map.
locals {
  archetype_role_assignments_output = flatten([
    for role_definition_name, members in local.archetype_role_assignments_map : [
      for member in members : [
        {
          resource_id          = "${local.provider_path.role_assignment}${uuidv5(uuidv5(uuidv5("url", role_definition_name), local.scope_id), member)}"
          scope_id             = local.scope_id
          principal_id         = member
          role_definition_name = role_definition_name
        }
      ]
    ]
  ])
}
