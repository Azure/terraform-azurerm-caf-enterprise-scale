# The following output gives the a summary of all resources
# created by the enterprise_scale module, formatted to allow
# easy identification of the resource IDs as stored in the
# Terraform state.

# output "resource_ids" {
#   description = "Map containing resource IDs for all resources created by this module."
#   value = {
#     for module_name, module_output in {
#       test_core = module.test_core
#     } :
#     module_name => {
#       for resource_type, resource_instances in module_output :
#       resource_type => {
#         for resource_name, resource_configs in resource_instances :
#         resource_name => keys(resource_configs)
#       }
#     }
#   }
# }
