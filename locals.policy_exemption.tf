locals {
  policy_mitigated = flatten([
    for k, v in local.azurerm_management_group_policy_assignment_enterprise_scale : [
      for overwrite in
      lookup(lookup(lookup(var.archetype_config_overrides, reverse(split("/", v.scope_id))[0], {}), "policy_exemption", {}), v.template.name, [])
      : [
        {
          scope : v.template.properties.scope
          policy_assignment_id : k
          overwrite_id : overwrite
          name : v.template.name
          metadata = try(length(v.template.properties.metadata) > 0, false) ? jsonencode(v.template.properties.metadata) : null
          is_subscription : length(regexall("/subscriptions/[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}/?$", overwrite)) > 0
          is_resource_group : length(regexall("/subscriptions/[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}/resourceGroups/[^/]*/?$", overwrite)) > 0
        }
      ]
    ]
    ]
  )
  initiative_mitigated = flatten([
    for k, v in local.azurerm_management_group_policy_assignment_enterprise_scale : [
      for overwrite_key, overwrite_value in
      lookup(lookup(lookup(var.archetype_config_overrides, reverse(split("/", v.scope_id))[0], {}), "initiative_exemption", {}), v.template.name, []) : [
        for overwrite in overwrite_value : [
          {
            scope : v.template.properties.scope
            policy_assignment_id : k
            overwrite_id : overwrite
            name : v.template.name
            metadata = try(length(v.template.properties.metadata) > 0, false) ? jsonencode(v.template.properties.metadata) : null
            is_subscription : length(regexall("/subscriptions/[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}/?$", overwrite)) > 0
            is_resource_group : length(regexall("/subscriptions/[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}/resourceGroups/[^/]*/?$", overwrite)) > 0
            policy_definition_reference_ids : [overwrite_key]
          }
        ]
      ]
    ]
    ]
  )
}