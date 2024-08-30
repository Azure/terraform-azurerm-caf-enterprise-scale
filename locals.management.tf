# The following locals are used to build the map of Resource
# Groups to deploy.
locals {
  azurerm_resource_group_management = {
    for resource in module.management_resources.configuration.azurerm_resource_group :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to build the map of Log
# Analytics workspaces to deploy.
locals {
  azurerm_log_analytics_workspace_management = {
    for resource in module.management_resources.configuration.azurerm_log_analytics_workspace :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to build the map of Log
# Analytics workspaces to deploy.
locals {
  azurerm_log_analytics_solution_management = {
    for resource in module.management_resources.configuration.azurerm_log_analytics_solution :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to build the map of Log
# Analytics workspaces to deploy.
locals {
  azurerm_automation_account_management = {
    for resource in module.management_resources.configuration.azurerm_automation_account :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to build the map of Log
# Analytics workspaces to deploy.
locals {
  azurerm_log_analytics_linked_service_management = {
    for resource in module.management_resources.configuration.azurerm_log_analytics_linked_service :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to build the map of UAMI
# resources to deploy.
locals {
  azurerm_user_assigned_identity_management = {
    for resource in module.management_resources.configuration.azurerm_user_assigned_identity :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to build the map of the DCRs
locals {
  azurerm_monitor_data_collection_rule_management = {
    for resource in module.management_resources.configuration.azurerm_monitor_data_collection_rule :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# locals {
#   azapi_sentinel_onboarding = {
#     for resource in module.management_resources.configuration.azapi_sentinel_onboarding :
#     resource.resource_id => resource
#     if resource.managed_by_module
#   }
# }
