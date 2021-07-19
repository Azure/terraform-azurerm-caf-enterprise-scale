# The following locals are used to extract the Resource Group
# configuration from the solution module outputs.
locals {
  es_management_resource_groups = module.management_resources.configuration.azurerm_resource_group
}

# The following locals are used to build the map of Resource
# Groups to deploy.
locals {
  azurerm_resource_group_management = {
    for resource in local.es_management_resource_groups :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to extract the Log Analytics
# configuration from the solution module outputs.
locals {
  es_management_log_analytics_workspaces = module.management_resources.configuration.azurerm_log_analytics_workspace
}

# The following locals are used to build the map of Log
# Analytics workspaces to deploy.
locals {
  azurerm_log_analytics_workspace_management = {
    for resource in local.es_management_log_analytics_workspaces :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to extract the Log Analytics
# Solutions configuration from the solution module outputs.
locals {
  es_management_log_analytics_solution = module.management_resources.configuration.azurerm_log_analytics_solution
}

# The following locals are used to build the map of Log
# Analytics workspaces to deploy.
locals {
  azurerm_log_analytics_solution_management = {
    for resource in local.es_management_log_analytics_solution :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to extract the Automation
# Account configuration from the solution module outputs.
locals {
  es_management_automation_account = module.management_resources.configuration.azurerm_automation_account
}

# The following locals are used to build the map of Log
# Analytics workspaces to deploy.
locals {
  azurerm_automation_account_management = {
    for resource in local.es_management_automation_account :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to extract the Log Analytics
# Linked Service configuration from the solution module outputs.
locals {
  es_management_log_analytics_linked_service = module.management_resources.configuration.azurerm_log_analytics_linked_service
}

# The following locals are used to build the map of Log
# Analytics workspaces to deploy.
locals {
  azurerm_log_analytics_linked_service_management = {
    for resource in local.es_management_log_analytics_linked_service :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}
