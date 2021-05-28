package main

import data.child_modules

#### values to test: 
####  display_name ----------------> Done
####  enforcement_mode ----------------> Done
####  identity
####  location
####  name
####  not_scopes
####  parameters
####  policy_definition_id
####  scope
####
####
####
####
####
########################
# Rules
########################

# # # Compare the policy assignments display_name and fail if they are not equal.
violation[policy_assignment_display_name] {
	plc_assign_plan_display_name != plc_assign_change_display_name
	policy_assignment_display_name := sprintf("The policy_assignment planned values: %v are not equal to the changed values %v", [plc_assign_plan_display_name, plc_assign_change_display_name])
}

# # # Compare the policy assignments enforcement_mode and fail if they are not equal.
violation[policy_assignment_enforcement_mode] {
	plc_assign_plan_enforcement_mode != plc_assign_change_enforcement_mode
	policy_assignment_enforcement_mode := sprintf("The policy_assignment planned values: %v are not equal to the changed values %v", [plc_assign_plan_enforcement_mode, plc_assign_change_enforcement_mode])
}

# # # Compare the policy assignments identity and fail if they are not equal.
violation[policy_assignment_identity] {
	plc_assign_plan_identity != plc_assign_change_identity
	policy_assignment_identity := sprintf("The policy_assignment planned values: %v are not equal to the changed values %v", [plc_assign_plan_identity, plc_assign_change_identity])
}

########################
# Library
########################
# # # Get the display name from all policy assignments in planned_values.yml
plc_assign_plan_display_name[module_name] = plcs {
	module := child_modules[_]
	module_name := module.address
	plcs := [plc |
		module.resources[i].type == "azurerm_policy_assignment"
		plc := module.resources[i].values.display_name
	]
}

# # # Get the display name from all policy assignments in the opa.json
plc_assign_change_display_name[module_name] = plcs {
	module := input.resource_changes[_]
	module_name := module.module_address
	plcs := [plc |
		input.resource_changes[r].type == "azurerm_policy_assignment"
		input.resource_changes[r].module_address == module.module_address
		plc := input.resource_changes[r].change.after.display_name
	]
}

# # # Get the enforcement mode from all policy assignments in planned_values.yml
plc_assign_plan_enforcement_mode[module_name] = plcs {
	module := child_modules[_]
	module_name := module.address
	plcs := [plc |
		module.resources[i].type == "azurerm_policy_assignment"
		plc := module.resources[i].values.enforcement_mode
	]
}

# # # Get the enforcement mode from all policy assignments in the opa.json
plc_assign_change_enforcement_mode[module_name] = plcs {
	module := input.resource_changes[_]
	module_name := module.module_address
	plcs := [plc |
		input.resource_changes[r].type == "azurerm_policy_assignment"
		input.resource_changes[r].module_address == module.module_address
		plc := input.resource_changes[r].change.after.enforcement_mode
	]
}

# # # Get the identity from all policy assignments in planned_values.yml
plc_assign_plan_identity[module_name] = plcs {
	module := child_modules[_]
	module_name := module.address
	plcs := [plc |
		module.resources[i].type == "azurerm_policy_assignment"
		plc := module.resources[i].values.identity
	]
}

# # # Get the identity from all policy assignments in the opa.json
plc_assign_change_identity[module_name] = plcs {
	module := input.resource_changes[_]
	module_name := module.module_address
	plcs := [plc |
		input.resource_changes[r].type == "azurerm_policy_assignment"
		input.resource_changes[r].module_address == module.module_address
		plc := input.resource_changes[r].change.after.identity
	]
}
