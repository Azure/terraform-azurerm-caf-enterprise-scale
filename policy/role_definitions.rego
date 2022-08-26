package main

import input.planned_values.root_module as plan
import data.root_module as baseline

########################
# Rules
########################

# Compare the role_definition_name and fail if they are not equal.
violation[role_definition_name] {
	plan_role_definition_name != baseline_role_definition_name
	role_definition_name := sprintf("The role_definition_name planned values:\n \n %v \n \n are not equal to the role_definition_name _baseline values:\n \n %v", [plan_role_definition_name, baseline_role_definition_name])
}

# Compare the role_definition_permissions and fail if they are not equal.
violation[role_definition_permissions] {
	plan_role_definition_permissions != baseline_role_definition_permissions
	role_definition_permissions := sprintf("The role_definition_permissions planned values:\n \n %v \n \n are not equal to the role_definition_permissions _baseline values:\n \n %v", [plan_role_definition_permissions, baseline_role_definition_permissions])
}

# Compare the role_definition_id and fail if they are not equal.
# Will not work due to the way ids are generated using uuidv5() function.
# violation[role_definition_id] {
# 	plan_role_definition_role_definition_id != baseline_role_definition_role_definition_id
# 	role_definition_id := sprintf("The role_definition_id planned values:\n \n %v \n \n are not equal to the role_definition_id _baseline values:\n \n %v", [plan_role_definition_role_definition_id, baseline_role_definition_role_definition_id])
# }

# Compare the role_definition_scope and fail if they are not equal.
violation[role_definition_scope] {
	plan_role_definition_scope != baseline_role_definition_scope
	role_definition_scope := sprintf("The role_definition_scope planned values:\n \n %v \n \n are not equal to the role_definition_scope _baseline values:\n \n %v", [plan_role_definition_scope, baseline_role_definition_scope])
}

########################
# Library
########################

# Get the role_definition_name from all role_assignments in planned_values.json
baseline_role_definition_name[module_name] = role_definitions {
	module := baseline.child_modules[_]
	module_name := module.address
	role_definitions := sort([role_definition |
		module.resources[i].type == "azurerm_role_definition"
		role_definition := module.resources[i].values.name
	])
}

# Get the role_definition_name from all role_assignments in the terraform_plan.json
plan_role_definition_name[module_name] = role_definitions {
	module := plan.child_modules[_]
	module_name := module.address
	role_definitions := sort([role_definition |
		module.resources[r].type == "azurerm_role_definition"
		role_definition := module.resources[r].values.name
	])
}

# Get the role_definition_permissions from all role_assignments in planned_values.json
baseline_role_definition_permissions[module_name] = role_definitions {
	module := baseline.child_modules[_]
	module_name := module.address
	role_definitions := sort([role_definition |
		module.resources[i].type == "azurerm_role_definition"
		role_definition := module.resources[i].values.permissions
	])
}

# Get the role_definition_permissions from all role_assignments in the terraform_plan.json
plan_role_definition_permissions[module_name] = role_definitions {
	module := plan.child_modules[_]
	module_name := module.address
	role_definitions := sort([role_definition |
		module.resources[r].type == "azurerm_role_definition"
		role_definition := module.resources[r].values.permissions
	])
}

# Get the role_definition_id from all role_assignments in planned_values.json
baseline_role_definition_role_definition_id[module_name] = role_definitions {
	module := baseline.child_modules[_]
	module_name := module.address
	role_definitions := [role_definition |
		module.resources[i].type == "azurerm_role_definition"
		role_definition := module.resources[i].values.role_definition_id
	]
}

# Get the role_definition_id from all role_assignments in the terraform_plan.json
plan_role_definition_role_definition_id[module_name] = role_definitions {
	module := plan.child_modules[_]
	module_name := module.address
	role_definitions := [role_definition |
		module.resources[r].type == "azurerm_role_definition"
		role_definition := module.resources[r].values.role_definition_id
	]
}

# Get the role_definition_scope from all role_assignments in planned_values.json
baseline_role_definition_scope[module_name] = role_definitions {
	module := baseline.child_modules[_]
	module_name := module.address
	role_definitions := [role_definition |
		module.resources[i].type == "azurerm_role_definition"
		role_definition := module.resources[i].values.scope
	]
}

# Get the role_definition_scope from all role_assignments in the terraform_plan.json
plan_role_definition_scope[module_name] = role_definitions {
	module := plan.child_modules[_]
	module_name := module.address
	role_definitions := [role_definition |
		module.resources[r].type == "azurerm_role_definition"
		role_definition := module.resources[r].values.scope
	]
}
