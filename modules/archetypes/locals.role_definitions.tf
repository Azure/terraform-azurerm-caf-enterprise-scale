# Generate the Role Definition configurations for the specified archetype.
# Logic implemented to determine whether Role Definitions
# need to be loaded to save on compute and memory resources
# when none defined in archetype definition.
locals {
  archetype_role_definitions_list      = local.archetype_definition.role_definitions
  archetype_role_definitions_specified = try(length(local.archetype_role_definitions_list) > 0, false)
}

# If Role Definitions are specified in the archetype definition, generate a list of all Role Definition files from the built-in and custom library locations
locals {
  builtin_role_definitions_from_json = local.archetype_role_definitions_specified ? tolist(fileset(local.builtin_library_path, "**/role_definition_*.{json,json.tftpl}")) : null
  builtin_role_definitions_from_yaml = local.archetype_role_definitions_specified ? tolist(fileset(local.builtin_library_path, "**/role_definition_*.{yml,yml.tftpl,yaml,yaml.tftpl}")) : null
  custom_role_definitions_from_json  = local.archetype_role_definitions_specified && local.custom_library_path_specified ? tolist(fileset(local.custom_library_path, "**/role_definition_*.{json,json.tftpl}")) : null
  custom_role_definitions_from_yaml  = local.archetype_role_definitions_specified && local.custom_library_path_specified ? tolist(fileset(local.custom_library_path, "**/role_definition_*.{yml,yml.tftpl,yaml,yaml.tftpl}")) : null
}

# If Role Definition files exist, load content into dataset
locals {
  builtin_role_definitions_dataset_from_json = try(length(local.builtin_role_definitions_from_json) > 0, false) ? {
    for filepath in local.builtin_role_definitions_from_json :
    filepath => jsondecode(templatefile("${local.builtin_library_path}/${filepath}", local.template_file_vars))
  } : null
  builtin_role_definitions_dataset_from_yaml = try(length(local.builtin_role_definitions_from_yaml) > 0, false) ? {
    for filepath in local.builtin_role_definitions_from_yaml :
    filepath => yamldecode(templatefile("${local.builtin_library_path}/${filepath}", local.template_file_vars))
  } : null
  custom_role_definitions_dataset_from_json = try(length(local.custom_role_definitions_from_json) > 0, false) ? {
    for filepath in local.custom_role_definitions_from_json :
    filepath => jsondecode(templatefile("${local.custom_library_path}/${filepath}", local.template_file_vars))
  } : null
  custom_role_definitions_dataset_from_yaml = try(length(local.custom_role_definitions_from_yaml) > 0, false) ? {
    for filepath in local.custom_role_definitions_from_yaml :
    filepath => yamldecode(templatefile("${local.custom_library_path}/${filepath}", local.template_file_vars))
  } : null
}

# If Role Definition datasets exist, convert to map
locals {
  builtin_role_definitions_map_from_json = try(length(local.builtin_role_definitions_dataset_from_json) > 0, false) ? {
    for key, value in local.builtin_role_definitions_dataset_from_json :
    uuidv5(value.name, local.scope_id) => value
    if value.type == local.resource_types.role_definition
  } : null
  builtin_role_definitions_map_from_yaml = try(length(local.builtin_role_definitions_dataset_from_yaml) > 0, false) ? {
    for key, value in local.builtin_role_definitions_dataset_from_yaml :
    uuidv5(value.name, local.scope_id) => value
    if value.type == local.resource_types.role_definition
  } : null
  custom_role_definitions_map_from_json = try(length(local.custom_role_definitions_dataset_from_json) > 0, false) ? {
    for key, value in local.custom_role_definitions_dataset_from_json :
    uuidv5(value.name, local.scope_id) => value
    if value.type == local.resource_types.role_definition
  } : null
  custom_role_definitions_map_from_yaml = try(length(local.custom_role_definitions_dataset_from_yaml) > 0, false) ? {
    for key, value in local.custom_role_definitions_dataset_from_yaml :
    uuidv5(value.name, local.scope_id) => value
    if value.type == local.resource_types.role_definition
  } : null
}

# Merge the Role Definition maps into a single map.
# If duplicates exist due to a custom Role Definition being
# defined to override a built-in definition, this is handled by
# merging the custom policies after the built-in policies.
locals {
  archetype_role_definitions_map = merge(
    local.builtin_role_definitions_map_from_json,
    local.builtin_role_definitions_map_from_yaml,
    local.custom_role_definitions_map_from_json,
    local.custom_role_definitions_map_from_yaml,
  )
}

# Generate a map containing all roleName to name (GUID) mappings.
# This is used to allow the friendly roleName value to
# select the Role Definition within the archetype
# definition files, whilst still being able to predict
# the Resource ID for the Role Definition as part of
# the naming standard for ATTR values in the Terraform
# state file.
locals {
  convert_role_definition_name_to_id = try(length(local.archetype_role_definitions_map) > 0, false) ? {
    for key, value in local.archetype_role_definitions_map :
    value.properties.roleName => key
  } : null
}

# Extract the desired Role Definitions from archetype_role_definitions_map.
locals {
  archetype_role_definitions_output = [
    for role in local.archetype_role_definitions_list :
    {
      resource_id          = "${local.provider_path.role_definition}${local.convert_role_definition_name_to_id[role]}"
      resource_id_path     = local.provider_path.role_definition
      scope_id             = local.scope_id
      template             = local.archetype_role_definitions_map[local.convert_role_definition_name_to_id[role]]
      role_definition_name = "[${basename(upper(local.scope_id))}] ${local.archetype_role_definitions_map[local.convert_role_definition_name_to_id[role]].properties.roleName}"
    }
  ]
}
