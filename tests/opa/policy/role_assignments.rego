package main

import input.planned_values.root_module as plan
import data.root_module as baseline

########################
# Rules
########################

# Compare the role_assignment_name and fail if they are not equal.
violation[role_assignment_name] {
	plan_role_assignment_name != baseline_role_assignment_name
	role_assignment_name := sprintf("The role_assignment_name planned values:\n \n %v \n \n are not equal to the role_assignment_name changed values:\n \n %v", [plan_role_assignment_name, baseline_role_assignment_name])
}

# Compare the role_assignment_role_definition_id and fail if they are not equal.
violation[role_assignment_role_definition_id] {
	plan_role_assignment_role_definition_id != baseline_role_assignment_role_definition_id
	role_assignment_role_definition_id := sprintf("The role_assignment_role_definition_id planned values:\n \n %v \n \n are not equal to the role_assignment_role_definition_id changed values:\n \n %v", [plan_role_assignment_role_definition_id, baseline_role_assignment_role_definition_id])
}

# Compare the role_assignment_scope and fail if they are not equal.
violation[role_assignment_scope] {
	plan_role_assignment_scope != baseline_role_assignment_scope
	role_assignment_scope := sprintf("The role_assignment_scope planned values:\n \n %v \n \n are not equal to the role_assignment_scope changed values:\n \n %v", [plan_role_assignment_scope, baseline_role_assignment_scope])
}

########################
# Library
########################

# Get the role_assignment_name from all role_assignments in planned_values.json
baseline_role_assignment_name[module_name] = role_assignments {
	module := baseline.child_modules[_]
	module_name := module.address
	role_assignments := [role_assignment |
		module.resources[i].type == "azurerm_role_assignment"
		role_assignment := module.resources[i].values.name
	]
}

# Get the role_assignment_name from all role_assignments in the terraform_plan.json
plan_role_assignment_name[module_name] = role_assignments {
	module := plan.child_modules[_]
	module_name := module.address
	role_assignments := [role_assignment |
		module.resources[r].type == "azurerm_role_assignment"
		role_assignment := module.resources[r].values.name
	]
}

# Get the role_definition_id from all role_assignments in planned_values.json
baseline_role_assignment_role_definition_id[module_name] = role_assignments {
	module := baseline.child_modules[_]
	module_name := module.address
	role_assignments := [role_assignment |
		module.resources[i].type == "azurerm_role_assignment"
		role_assignment := module.resources[i].values.role_definition_id
	]
}

# Get the role_definition_id from all role_assignments in the terraform_plan.json
plan_role_assignment_role_definition_id[module_name] = role_assignments {
	module := plan.child_modules[_]
	module_name := module.address
	role_assignments := [role_assignment |
		module.resources[r].type == "azurerm_role_assignment"
		role_assignment := module.resources[r].values.role_definition_id
	]
}

# Get the scope from all role_assignments in planned_values.json
baseline_role_assignment_scope[module_name] = role_assignments {
	module := baseline.child_modules[_]
	module_name := module.address
	role_assignments := [role_assignment |
		module.resources[i].type == "azurerm_role_assignment"
		role_assignment := module.resources[i].values.scope
	]
}

# Get the scope from all role_assignments in the terraform_plan.json
plan_role_assignment_scope[module_name] = role_assignments {
	module := plan.child_modules[_]
	module_name := module.address
	role_assignments := [role_assignment |
		module.resources[r].type == "azurerm_role_assignment"
		role_assignment := module.resources[r].values.scope
	]
}
