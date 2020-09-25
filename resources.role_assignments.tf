# <<<<<<<< PENDING DEVELOPMENT >>>>>>>>
# resource "azurerm_role_assignment" "enterprise_scale" {
#   for_each = local.es_role_assignments_map

#   # Mandatory attributes
#   scope        = each.value.scope
#   principal_id = each.value.principal_id

#   # Optional attributes
#   name                             = try(length(each.value.name) > 0, false) ? each.value.name : null
#   role_definition_id               = try(length(each.value.role_definition_id) > 0, false) ? each.value.role_definition_id : null
#   skip_service_principal_aad_check = try(length(each.value.skip_service_principal_aad_check) > 0, false) ? each.value.skip_service_principal_aad_check : false

# }
