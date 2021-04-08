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
}

# Merge the archetype maps into a single map, and extract the desired archetype definition.
# If duplicates exist due to a custom archetype definition being
# defined to override a built-in definition, this is handled by
# merging the custom archetypes after the built-in archetypes.
locals {
  archetype_definitions = merge(
    local.builtin_archetype_definitions_map_from_json,
    local.builtin_archetype_definitions_map_from_yaml,
    local.custom_archetype_definitions_map_from_json,
    local.custom_archetype_definitions_map_from_yaml,
  )
  archetype_definition = local.archetype_definitions[local.archetype_id]
}
