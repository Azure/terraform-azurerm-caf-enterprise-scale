# Generate the Policy Definition configurations for the specified archetype.
# Logic implemented to determine whether Policy Definitions
# need to be loaded to save on compute and memory resources
# when none defined in archetype definition.
locals {
  archetype_policy_definitions_list      = local.archetype_definition.policy_definitions
  archetype_policy_definitions_specified = try(length(local.archetype_policy_definitions_list) > 0, false)
}

# If Policy Definitions are specified in the archetype definition, generate a list of all Policy Definition files from the built-in and custom library locations
locals {
  builtin_policy_definitions_from_json = local.archetype_policy_definitions_specified ? tolist(fileset(local.builtin_library_path, "**/policy_definition_*.{json,json.tftpl}")) : null
  builtin_policy_definitions_from_yaml = local.archetype_policy_definitions_specified ? tolist(fileset(local.builtin_library_path, "**/policy_definition_*.{yml,yml.tftpl,yaml,yaml.tftpl}")) : null
  custom_policy_definitions_from_json  = local.archetype_policy_definitions_specified && local.custom_library_path_specified ? tolist(fileset(local.custom_library_path, "**/policy_definition_*.{json,json.tftpl}")) : null
  custom_policy_definitions_from_yaml  = local.archetype_policy_definitions_specified && local.custom_library_path_specified ? tolist(fileset(local.custom_library_path, "**/policy_definition_*.{yml,yml.tftpl,yaml,yaml.tftpl}")) : null
}

# If Policy Definition files exist, load content into dataset
locals {
  builtin_policy_definitions_dataset_from_json = try(length(local.builtin_policy_definitions_from_json) > 0, false) ? {
    for filepath in local.builtin_policy_definitions_from_json :
    filepath => jsondecode(templatefile("${local.builtin_library_path}/${filepath}", local.template_file_vars))
  } : null
  builtin_policy_definitions_dataset_from_yaml = try(length(local.builtin_policy_definitions_from_yaml) > 0, false) ? {
    for filepath in local.builtin_policy_definitions_from_yaml :
    filepath => yamldecode(templatefile("${local.builtin_library_path}/${filepath}", local.template_file_vars))
  } : null
  custom_policy_definitions_dataset_from_json = try(length(local.custom_policy_definitions_from_json) > 0, false) ? {
    for filepath in local.custom_policy_definitions_from_json :
    filepath => jsondecode(templatefile("${local.custom_library_path}/${filepath}", local.template_file_vars))
  } : null
  custom_policy_definitions_dataset_from_yaml = try(length(local.custom_policy_definitions_from_yaml) > 0, false) ? {
    for filepath in local.custom_policy_definitions_from_yaml :
    filepath => yamldecode(templatefile("${local.custom_library_path}/${filepath}", local.template_file_vars))
  } : null
}

# If Policy Definition datasets exist, convert to map
locals {
  builtin_policy_definitions_map_from_json = try(length(local.builtin_policy_definitions_dataset_from_json) > 0, false) ? {
    for key, value in local.builtin_policy_definitions_dataset_from_json :
    value.name => value
    if value.type == local.resource_types.policy_definition
  } : null
  builtin_policy_definitions_map_from_yaml = try(length(local.builtin_policy_definitions_dataset_from_yaml) > 0, false) ? {
    for key, value in local.builtin_policy_definitions_dataset_from_yaml :
    value.name => value
    if value.type == local.resource_types.policy_definition
  } : null
  custom_policy_definitions_map_from_json = try(length(local.custom_policy_definitions_dataset_from_json) > 0, false) ? {
    for key, value in local.custom_policy_definitions_dataset_from_json :
    value.name => value
    if value.type == local.resource_types.policy_definition
  } : null
  custom_policy_definitions_map_from_yaml = try(length(local.custom_policy_definitions_dataset_from_yaml) > 0, false) ? {
    for key, value in local.custom_policy_definitions_dataset_from_yaml :
    value.name => value
    if value.type == local.resource_types.policy_definition
  } : null
}

# Merge the Policy Definition maps into a single map.
# If duplicates exist due to a custom Policy Definition being
# defined to override a built-in definition, this is handled by
# merging the custom policies after the built-in policies.
locals {
  archetype_policy_definitions_map = merge(
    local.builtin_policy_definitions_map_from_json,
    local.builtin_policy_definitions_map_from_yaml,
    local.custom_policy_definitions_map_from_json,
    local.custom_policy_definitions_map_from_yaml,
  )
}

# Extract the desired Policy Definitions from archetype_policy_definitions_map.
locals {
  archetype_policy_definitions_output = [
    for policy in local.archetype_policy_definitions_list :
    {
      resource_id = "${local.provider_path.policy_definition}${policy}"
      scope_id    = local.scope_id
      template    = try(local.archetype_policy_definitions_map[policy], null)
    }
  ]
}
