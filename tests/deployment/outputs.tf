# The following output gives the a summary of all resources
# created by the enterprise_scale module, formatted to allow
# easy identification of the resource IDs as stored in the
# Terraform state.

output "resource_ids" {
  value = {
    for module_name, module_output in {
      test_root_id_1     = module.test_root_id_1
      test_root_id_2     = module.test_root_id_2
      test_root_id_3     = module.test_root_id_3
      test_root_id_3_lz1 = module.test_root_id_3_lz1
    } :
    module_name => {
      for resource_type, resource_instances in module_output :
      resource_type => {
        for resource_name, resource_configs in resource_instances :
        resource_name => keys(resource_configs)
      }
    }
  }
}
