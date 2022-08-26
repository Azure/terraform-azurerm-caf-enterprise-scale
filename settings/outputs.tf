output "connectivity" {
  description = "Configuration settings for the \"connectivity\" module instance."
  value = {
    configure_connectivity_resources = local.configure_connectivity_resources
  }
}

output "core" {
  description = "Configuration settings for the \"core\" module instance."
  value = {
    custom_landing_zones           = local.custom_landing_zones
    archetype_config_overrides     = local.archetype_config_overrides
    subscription_id_overrides      = local.subscription_id_overrides
    custom_template_file_variables = local.custom_template_file_variables
  }
}

output "management" {
  description = "Configuration settings for the \"management\" module instance."
  value = {
    configure_management_resources = local.configure_management_resources
  }
}

output "nested" {
  description = "Configuration settings for the \"nested\" module instance."
  value = {
    custom_landing_zones = local.nested_custom_landing_zones
  }
}

output "shared" {
  description = "Configuration settings for the \"shared\" settings across module instances."
  value = {
    default_tags = local.default_tags
  }
}
