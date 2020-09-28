# The following output is used to reconcile the multi-level
# Management Group deployments into a single data object to
# simplify consumption of configuration data from this group
# of resources.
output "azurerm_management_group" {
  value = {
    enterprise_scale = local.es_management_group_output
  }
  description = "Returns the configuration data for all Management Groups created by this module."
}
