# The following output gives the a summary of all resources
# created by the enterprise_scale module, formatted to allow
# easy identification of the resource IDs as stored in the
# Terraform state.

output "resource_ids" {
  value = {
    test_root_id_1 = {
      for key, value in module.test_root_id_1 :
      key => {
        enterprise_scale = try(keys(value.enterprise_scale), [])
        level_1          = try(keys(value.level_1), [])
        level_2          = try(keys(value.level_2), [])
        level_3          = try(keys(value.level_3), [])
        level_4          = try(keys(value.level_4), [])
        level_5          = try(keys(value.level_5), [])
        level_6          = try(keys(value.level_6), [])
        management       = try(keys(value.management), [])
        connectivity     = try(keys(value.connectivity), [])
      }
    }
    test_root_id_2 = {
      for key, value in module.test_root_id_2 :
      key => {
        enterprise_scale = try(keys(value.enterprise_scale), [])
        level_1          = try(keys(value.level_1), [])
        level_2          = try(keys(value.level_2), [])
        level_3          = try(keys(value.level_3), [])
        level_4          = try(keys(value.level_4), [])
        level_5          = try(keys(value.level_5), [])
        level_6          = try(keys(value.level_6), [])
        management       = try(keys(value.management), [])
        connectivity     = try(keys(value.connectivity), [])
      }
    }
    test_root_id_3 = {
      for key, value in module.test_root_id_3 :
      key => {
        enterprise_scale = try(keys(value.enterprise_scale), [])
        level_1          = try(keys(value.level_1), [])
        level_2          = try(keys(value.level_2), [])
        level_3          = try(keys(value.level_3), [])
        level_4          = try(keys(value.level_4), [])
        level_5          = try(keys(value.level_5), [])
        level_6          = try(keys(value.level_6), [])
        management       = try(keys(value.management), [])
        connectivity     = try(keys(value.connectivity), [])
      }
    }
    test_root_id_3_lz1 = {
      for key, value in module.test_root_id_3_lz1 :
      key => {
        enterprise_scale = try(keys(value.enterprise_scale), [])
        level_1          = try(keys(value.level_1), [])
        level_2          = try(keys(value.level_2), [])
        level_3          = try(keys(value.level_3), [])
        level_4          = try(keys(value.level_4), [])
        level_5          = try(keys(value.level_5), [])
        level_6          = try(keys(value.level_6), [])
        management       = try(keys(value.management), [])
        connectivity     = try(keys(value.connectivity), [])
      }
    }
  }
}
