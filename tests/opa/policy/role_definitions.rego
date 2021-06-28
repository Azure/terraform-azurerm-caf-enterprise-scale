package main

import data.child_modules

########################
# Rules
########################

# # # Some rules are commented out to prevent Azure Pipelines runner running out of memory (error code 137)

# # # # Compare the role_definition_name and fail if they are not equal.
# violation[role_definition_name] {
# 	role_def_plan_name != role_def_change_name
# 	role_definition_name := sprintf("The role_definition_name planned values:\n \n %v \n \n are not equal to the role_definition_name changed values:\n \n %v", [role_def_plan_name, role_def_change_name])
# }

# # # Compare the role_definition_permissions and fail if they are not equal.
violation[role_definition_permissions] {
	role_def_plan_permissions != role_def_change_permissions
	role_definition_permissions := sprintf("The role_definition_permissions planned values:\n \n %v \n \n are not equal to the role_definition_permissions changed values:\n \n %v", [role_def_plan_permissions, role_def_change_permissions])
}

# # # # Compare the role_definition_id and fail if they are not equal.
# violation[role_definition_id] {
# 	role_def_plan_role_definition_id != role_def_change_role_definition_id
# 	role_definition_id := sprintf("The role_definition_id planned values:\n \n %v \n \n are not equal to the role_definition_id changed values:\n \n %v", [role_def_plan_role_definition_id, role_def_change_role_definition_id])
# }

# # # Compare the role_definition_scope and fail if they are not equal.
violation[role_definition_scope] {
	role_def_plan_scope != role_def_change_scope
	role_definition_scope := sprintf("The role_definition_scope planned values:\n \n %v \n \n are not equal to the role_definition_scope changed values:\n \n %v", [role_def_plan_scope, role_def_change_scope])
}

########################
# Library
########################

# # # Get the role_definition_name from all role_assignments in planned_values.yml
role_def_plan_name[module_name] = plcs {
	module := child_modules[_]
	module_name := module.address
	plcs := [plc |
		module.resources[i].type == "azurerm_role_definition"
		plc := module.resources[i].values.name
	]
}

# # # Get the role_definition_name from all role_assignments in the opa.json
role_def_change_name[module_name] = plcs {
	module := input.resource_changes[_]
	module_name := module.module_address
	plcs := [plc |
		input.resource_changes[r].type == "azurerm_role_definition"
		input.resource_changes[r].module_address == module.module_address
		plc := input.resource_changes[r].change.after.name
	]
}

# # # Get the role_definition_permissions from all role_assignments in planned_values.yml
role_def_plan_permissions[module_name] = plcs {
	module := child_modules[_]
	module_name := module.address
	plcs := [plc |
		module.resources[i].type == "azurerm_role_definition"
		plc := module.resources[i].values.permissions
	]
}

# # # Get the role_definition_permissions from all role_assignments in the opa.json
role_def_change_permissions[module_name] = plcs {
	module := input.resource_changes[_]
	module_name := module.module_address
	plcs := [plc |
		input.resource_changes[r].type == "azurerm_role_definition"
		input.resource_changes[r].module_address == module.module_address
		plc := input.resource_changes[r].change.after.permissions
	]
}

# # # Get the role_definition_id from all role_assignments in planned_values.yml
role_def_plan_role_definition_id[module_name] = plcs {
	module := child_modules[_]
	module_name := module.address
	plcs := [plc |
		module.resources[i].type == "azurerm_role_definition"
		plc := module.resources[i].values.role_definition_id
	]
}

# # # Get the role_definition_id from all role_assignments in the opa.json
role_def_change_role_definition_id[module_name] = plcs {
	module := input.resource_changes[_]
	module_name := module.module_address
	plcs := [plc |
		input.resource_changes[r].type == "azurerm_role_definition"
		input.resource_changes[r].module_address == module.module_address
		plc := input.resource_changes[r].change.after.role_definition_id
	]
}

# # # Get the role_definition_scope from all role_assignments in planned_values.yml
role_def_plan_scope[module_name] = plcs {
	module := child_modules[_]
	module_name := module.address
	plcs := [plc |
		module.resources[i].type == "azurerm_role_definition"
		plc := module.resources[i].values.scope
	]
}

# # # Get the role_definition_scope from all role_assignments in the opa.json
role_def_change_scope[module_name] = plcs {
	module := input.resource_changes[_]
	module_name := module.module_address
	plcs := [plc |
		input.resource_changes[r].type == "azurerm_role_definition"
		input.resource_changes[r].module_address == module.module_address
		plc := input.resource_changes[r].change.after.scope
	]
}
