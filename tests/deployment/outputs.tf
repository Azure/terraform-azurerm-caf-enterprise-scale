# The following output gives the a summary of all resources
# created by the enterprise_scale module, formatted to allow
# easy identification of the resource IDs as stored in the
# Terraform state.

output "resource_ids" {
  value = {
    test_root_id_1 = {
      for resource_type, resource_instances in module.test_root_id_1 :
      resource_type => {
        for resource_name, resource_configs in resource_instances :
        resource_name => keys(resource_configs)
      }
    }
    test_root_id_2 = {
      for resource_type, resource_instances in module.test_root_id_2 :
      resource_type => {
        for resource_name, resource_configs in resource_instances :
        resource_name => keys(resource_configs)
      }
    }
    test_root_id_3 = {
      for resource_type, resource_instances in module.test_root_id_3 :
      resource_type => {
        for resource_name, resource_configs in resource_instances :
        resource_name => keys(resource_configs)
      }
    }
    test_root_id_3_lz1 = {
      for resource_type, resource_instances in module.test_root_id_3_lz1 :
      resource_type => {
        for resource_name, resource_configs in resource_instances :
        resource_name => keys(resource_configs)
      }
    }
  }
}
