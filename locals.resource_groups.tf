# The following locals are used to extract the Resource Group
# configuration from the solution module outputs.
locals {
  es_resource_groups = concat(
    # module.connectivity_hub_spoke_resources.configuration.azurerm_resource_group,
    # module.connectivity_virtual_wan_resources.configuration.azurerm_resource_group,
    # module.identity_resources.configuration.azurerm_resource_group,
    # module.landing_zone_hub_spoke_resources.configuration.azurerm_resource_group,
    # module.landing_zone_virtual_wan_resources.configuration.azurerm_resource_group,
    module.management_resources.configuration.azurerm_resource_group,
  )
}

# The following locals are used to build the map of Resource
# Groups to deploy.
locals {
  azurerm_resource_group_enterprise_scale = {
    for resource in local.es_resource_groups :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}
