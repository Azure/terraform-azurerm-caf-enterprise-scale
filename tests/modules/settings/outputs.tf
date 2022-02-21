output "connectivity" {
  value = {
    configure_connectivity_resources = local.configure_connectivity_resources
  }
}

output "core" {
  value = {
    custom_landing_zones           = local.custom_landing_zones
    archetype_config_overrides     = local.archetype_config_overrides
    subscription_id_overrides      = local.subscription_id_overrides
    custom_template_file_variables = local.custom_template_file_variables
  }
}

output "management" {
  value = {
    configure_management_resources = local.configure_management_resources
  }
}

output "nested" {
  value = {
    custom_landing_zones = local.nested_custom_landing_zones
  }
}

output "shared" {
  value = {
    default_tags = local.default_tags
  }
}
