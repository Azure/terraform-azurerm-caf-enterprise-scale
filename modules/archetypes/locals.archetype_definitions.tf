# Load the built-in archetype definitions from the internal library path
locals {
  builtin_archetype_definitions_json = tolist(fileset(local.builtin_library_path, "**/archetype_definition_*.json"))
  builtin_archetype_definitions_yaml = tolist(fileset(local.builtin_library_path, "**/archetype_definition_*.{yml,yaml}"))
}

# Load the custom archetype definitions from the custom library path if specified
locals {
  custom_archetype_definitions_json = local.custom_library_path_specified ? tolist(fileset(local.custom_library_path, "**/archetype_definition_*.json")) : []
  custom_archetype_definitions_yaml = local.custom_library_path_specified ? tolist(fileset(local.custom_library_path, "**/archetype_definition_*.{yml,yaml}")) : []
}

# Load the archetype definition extensions
locals {
  extend_archetype_definitions_json = local.custom_library_path_specified ? tolist(fileset(local.custom_library_path, "**/archetype_extension_*.json")) : []       ##issue_72
  extend_archetype_definitions_yaml = local.custom_library_path_specified ? tolist(fileset(local.custom_library_path, "**/archetype_extension_*.{yml,yaml}")) : [] ##issue_72
}

# Load the archetype definition exclusions
locals {
  exclude_archetype_definitions_json = local.custom_library_path_specified ? tolist(fileset(local.custom_library_path, "**/archetype_exclusion_*.json")) : []       ##issue_72
  exclude_archetype_definitions_yaml = local.custom_library_path_specified ? tolist(fileset(local.custom_library_path, "**/archetype_exclusion_*.{yml,yaml}")) : [] ##issue_72
}

# Create datasets containing all built-in and custom archetype definitions from each source and file type
locals {
  builtin_archetype_definitions_dataset_from_json = {
    for filepath in local.builtin_archetype_definitions_json :
    filepath => jsondecode(templatefile("${local.builtin_library_path}/${filepath}", local.template_file_vars))
  }
  builtin_archetype_definitions_dataset_from_yaml = {
    for filepath in local.builtin_archetype_definitions_yaml :
    filepath => yamldecode(templatefile("${local.builtin_library_path}/${filepath}", local.template_file_vars))
  }
  custom_archetype_definitions_dataset_from_json = {
    for filepath in local.custom_archetype_definitions_json :
    filepath => jsondecode(templatefile("${local.custom_library_path}/${filepath}", local.template_file_vars))
  }
  custom_archetype_definitions_dataset_from_yaml = {
    for filepath in local.custom_archetype_definitions_yaml :
    filepath => yamldecode(templatefile("${local.custom_library_path}/${filepath}", local.template_file_vars))
  }
    extend_archetype_definitions_dataset_from_json = { ##issue_72
    for filepath in local.extend_archetype_definitions_json :
    filepath => jsondecode(templatefile("${local.custom_library_path}/${filepath}", local.template_file_vars))
  }
  extend_archetype_definitions_dataset_from_yaml = { ##issue_72
    for filepath in local.extend_archetype_definitions_yaml :
    filepath => jsondecode(templatefile("${local.custom_library_path}/${filepath}", local.template_file_vars))
  }
  exclude_archetype_definitions_dataset_from_json = { ##issue_72
    for filepath in local.exclude_archetype_definitions_json :
    filepath => jsondecode(templatefile("${local.custom_library_path}/${filepath}", local.template_file_vars))
  }
  exclude_archetype_definitions_dataset_from_yaml = { ##issue_72
    for filepath in local.exclude_archetype_definitions_yaml :
    filepath => jsondecode(templatefile("${local.custom_library_path}/${filepath}", local.template_file_vars))
  }
}

# Convert the archetype datasets into maps
locals {
  builtin_archetype_definitions_map_from_json = {
    for key, value in local.builtin_archetype_definitions_dataset_from_json :
    keys(value)[0] => values(value)[0]
  }
  builtin_archetype_definitions_map_from_yaml = {
    for key, value in local.builtin_archetype_definitions_dataset_from_yaml :
    keys(value)[0] => values(value)[0]
  }
  custom_archetype_definitions_map_from_json = {
    for key, value in local.custom_archetype_definitions_dataset_from_json :
    keys(value)[0] => values(value)[0]
  }
  custom_archetype_definitions_map_from_yaml = {
    for key, value in local.custom_archetype_definitions_dataset_from_yaml :
    keys(value)[0] => values(value)[0]
  }
    extend_archetype_definitions_map_from_json = { ##issue_72
    for key, value in local.extend_archetype_definitions_dataset_from_json :
    keys(value)[0] => values(value)[0]
  }
  extend_archetype_definitions_map_from_yaml = { ##issue_72
    for key, value in local.extend_archetype_definitions_dataset_from_yaml :
    keys(value)[0] => values(value)[0]
  }
  exclude_archetype_definitions_map_from_json = { ##issue_72
    for key, value in local.exclude_archetype_definitions_dataset_from_json :
    keys(value)[0] => values(value)[0]
  }
  exclude_archetype_definitions_map_from_yaml = { ##issue_72
    for key, value in local.exclude_archetype_definitions_dataset_from_yaml :
    keys(value)[0] => values(value)[0]
  }
}

# Merge the archetype maps into a single map, and extract the desired archetype definition.
# If duplicates exist due to a custom archetype definition being
# defined to override a built-in definition, this is handled by
# merging the custom archetypes after the built-in archetypes.
locals {
  base_archetype_definitions = merge(
    local.builtin_archetype_definitions_map_from_json,
    local.builtin_archetype_definitions_map_from_yaml,
    local.custom_archetype_definitions_map_from_json,
    local.custom_archetype_definitions_map_from_yaml,
  )
}

# Merge the extend archetype maps into a single map.
locals {
  extend_archetype_definitions = merge(
    local.extend_archetype_definitions_map_from_json, ##issue_72 
    local.extend_archetype_definitions_map_from_yaml, ##issue_72 
  )
}

# Merge the exclude archetype maps into a single map.
locals {
  exclude_archetype_definitions = merge(
    local.exclude_archetype_definitions_map_from_json, ##issue_72 
    local.exclude_archetype_definitions_map_from_yaml, ##issue_72 
  )
}

# Add or remove configuration settings from an existing [built-in] archetype definition.
# Get full description context in github #issue_72
locals {
  archetype_definitions = {
    for adk, adv in local.base_archetype_definitions :
    adk => {
      policy_assignments = [
        for value in distinct(concat(
          adv.policy_assignments,
          try(local.extend_archetype_definitions["extend_${adk}"].policy_assignments, local.empty_list)
        )) : value
        if contains(try(local.exclude_archetype_definitions["exclude_${adk}"].policy_assignments, local.empty_list), value) != true
      ],
      policy_definitions = [
        for value in distinct(concat(
          adv.policy_definitions,
          try(local.extend_archetype_definitions["extend_${adk}"].policy_definitions, local.empty_list)
        )) : value
        if contains(try(local.exclude_archetype_definitions["exclude_${adk}"].policy_definitions, local.empty_list), value) != true
      ],
      policy_set_definitions = [
        for value in distinct(concat(
          adv.policy_set_definitions,
          try(local.extend_archetype_definitions["extend_${adk}"].policy_set_definitions, local.empty_list)
        )) : value
        if contains(try(local.exclude_archetype_definitions["exclude_${adk}"].policy_set_definitions, local.empty_list), value) != true
      ],
      role_definitions = [
        for value in distinct(concat(
          adv.role_definitions,
          try(local.extend_archetype_definitions["extend_${adk}"].role_definitions, local.empty_list)
        )) : value
        if contains(try(local.exclude_archetype_definitions["exclude_${adk}"].role_definitions, local.empty_list), value) != true
      ],
      archetype_config = {
        parameters = merge(
          adv.archetype_config.parameters,
          try(local.extend_archetype_definitions["extend_${adk}"].archetype_config.parameters, local.empty_map)
        )
        access_control = merge(
          adv.archetype_config.access_control,
          try(local.extend_archetype_definitions["extend_${adk}"].archetype_config.access_control, local.empty_map)
        )
      }
    }
  }
}

# Extract the required archetype_definition value for the current context
locals {
  archetype_definition = local.archetype_definitions[local.archetype_id]
}

# Generate the configuration output object for the specified archetype
# depends_on_files = [
#   locals.policy_assignments.tf
#   locals.policy_definitions.tf
#   locals.policy_set_definitions.tf
#   locals.role_assignments.tf
#   locals.role_definitions.tf
# ]
locals {
  archetype_output = {
    policy_assignments     = local.archetype_policy_assignments_output
    policy_definitions     = local.archetype_policy_definitions_output
    policy_set_definitions = local.archetype_policy_set_definitions_output
    role_assignments       = local.archetype_role_assignments_output
    role_definitions       = local.archetype_role_definitions_output
  }
}
