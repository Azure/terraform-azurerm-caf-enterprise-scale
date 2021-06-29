package main

import data.child_modules

########################
# Rules
########################

# # # Some rules are commented out to prevent Azure Pipelines runner running out of memory (error code 137)

# # # # Compare the policy_assignment_display_name and fail if they are not equal.
# violation[policy_assignment_display_name] {
# 	plc_assign_plan_display_name != plc_assign_change_display_name
# 	policy_assignment_display_name := sprintf("The policy_assignment_display_name planned values:\n \n %v \n \n are not equal to the policy_assignment_display_name changed values:\n \n %v", [plc_assign_plan_display_name, plc_assign_change_display_name])
# }

# # # Compare the policy_assignment_enforcement_mode and fail if they are not equal.
violation[policy_assignment_enforcement_mode] {
	plc_assign_plan_enforcement_mode != plc_assign_change_enforcement_mode
	policy_assignment_enforcement_mode := sprintf("The policy_assignment_enforcement_mode planned values:\n \n %v \n \n are not equal to the policy_assignment_enforcement_mode changed values:\n \n %v", [plc_assign_plan_enforcement_mode, plc_assign_change_enforcement_mode])
}

# # # Compare the policy_assignment_identity and fail if they are not equal.
violation[policy_assignment_identity] {
	plc_assign_plan_identity != plc_assign_change_identity
	policy_assignment_identity := sprintf("The policy_assignment_identity planned values:\n \n %v \n \n are not equal to the policy_assignment_identity changed values:\n \n %v", [plc_assign_plan_identity, plc_assign_change_identity])
}

# # # # Compare the policy_assignment_location and fail if they are not equal.
# violation[policy_assignment_location] {
# 	plc_assign_plan_location != plc_assign_change_location
# 	policy_assignment_location := sprintf("The policy_assignment_location planned values:\n \n %v \n \n are not equal to the policy_assignment_location changed values:\n \n %v", [plc_assign_plan_location, plc_assign_change_location])
# }

# # # # Compare the policy_assignment_name and fail if they are not equal.
# violation[policy_assignment_name] {
# 	plc_assign_plan_name != plc_assign_change_name
# 	policy_assignment_name := sprintf("The policy_assignment_name planned values:\n \n %v \n \n are not equal to the policy_assignment_name changed values:\n \n %v", [plc_assign_plan_name, plc_assign_change_name])
# }

# # # Compare the policy_assignment_not_scopes and fail if they are not equal.
violation[policy_assignment_not_scopes] {
	plc_assign_plan_not_scopes != plc_assign_change_not_scopes
	policy_assignment_not_scopes := sprintf("The policy_assignment_not_scopes planned values:\n \n %v \n \n are not equal to the policy_assignment_not_scopes changed values:\n \n %v", [plc_assign_plan_not_scopes, plc_assign_change_not_scopes])
}

# # # # Compare the policy_assignment_parameters and fail if they are not equal.
# violation[policy_assignment_parameters] {
# 	plc_assign_plan_parameters != plc_assign_change_parameters
# 	policy_assignment_parameters := sprintf("The policy_assignment_parameters planned values:\n \n %v \n \n are not equal to the policy_assignment_parameters changed values:\n \n %v", [plc_assign_plan_parameters, plc_assign_change_parameters])
# }

# # # Compare the policy_assignment_policy_definition_id and fail if they are not equal.
violation[policy_assignment_policy_definition_id] {
	plc_assign_plan_policy_definition_id != plc_assign_change_policy_definition_id
	policy_assignment_policy_definition_id := sprintf("The policy_assignment_policy_definition_id planned values:\n \n %v \n \n are not equal to the policy_assignment_policy_definition_id changed values:\n \n %v", [plc_assign_plan_policy_definition_id, plc_assign_change_policy_definition_id])
}

# # # # Compare the policy_assignment_scope and fail if they are not equal.
# violation[policy_assignment_scope] {
# 	plc_assign_plan_scope != plc_assign_change_scope
# 	policy_assignment_scope := sprintf("The policy_assignment_scope planned values:\n \n %v \n \n are not equal to the policy_assignment_scope changed values:\n \n %v", [plc_assign_plan_scope, plc_assign_change_scope])
# }

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

# # # Get the location from all policy assignments in planned_values.yml
plc_assign_plan_location[module_name] = plcs {
	module := child_modules[_]
	module_name := module.address
	plcs := [plc |
		module.resources[i].type == "azurerm_policy_assignment"
		plc := module.resources[i].values.location
	]
}

# # # Get the location from all policy assignments in the opa.json
plc_assign_change_location[module_name] = plcs {
	module := input.resource_changes[_]
	module_name := module.module_address
	plcs := [plc |
		input.resource_changes[r].type == "azurerm_policy_assignment"
		input.resource_changes[r].module_address == module.module_address
		plc := input.resource_changes[r].change.after.location
	]
}

# # # Get the name from all policy assignments in planned_values.yml
plc_assign_plan_name[module_name] = plcs {
	module := child_modules[_]
	module_name := module.address
	plcs := [plc |
		module.resources[i].type == "azurerm_policy_assignment"
		plc := module.resources[i].values.name
	]
}

# # # Get the name from all policy assignments in the opa.json
plc_assign_change_name[module_name] = plcs {
	module := input.resource_changes[_]
	module_name := module.module_address
	plcs := [plc |
		input.resource_changes[r].type == "azurerm_policy_assignment"
		input.resource_changes[r].module_address == module.module_address
		plc := input.resource_changes[r].change.after.name
	]
}

# # # Get the not_scopes from all policy assignments in planned_values.yml
plc_assign_plan_not_scopes[module_name] = plcs {
	module := child_modules[_]
	module_name := module.address
	plcs := [plc |
		module.resources[i].type == "azurerm_policy_assignment"
		plc := module.resources[i].values.not_scopes
	]
}

# # # Get the not_scopes from all policy assignments in the opa.json
plc_assign_change_not_scopes[module_name] = plcs {
	module := input.resource_changes[_]
	module_name := module.module_address
	plcs := [plc |
		input.resource_changes[r].type == "azurerm_policy_assignment"
		input.resource_changes[r].module_address == module.module_address
		plc := input.resource_changes[r].change.after.not_scopes
	]
}

# # # Get the parameters from all policy assignments in planned_values.yml
plc_assign_plan_parameters[module_name] = plcs {
	module := child_modules[_]
	module_name := module.address
	plcs := [plc |
		module.resources[i].type == "azurerm_policy_assignment"
		plc := module.resources[i].values.parameters
	]
}

# # # Get the parameters from all policy assignments in the opa.json
plc_assign_change_parameters[module_name] = plcs {
	module := input.resource_changes[_]
	module_name := module.module_address
	plcs := [plc |
		input.resource_changes[r].type == "azurerm_policy_assignment"
		input.resource_changes[r].module_address == module.module_address
		plc := input.resource_changes[r].change.after.parameters
	]
}

# # # Get the policy_definition_id from all policy assignments in planned_values.yml
plc_assign_plan_policy_definition_id[module_name] = plcs {
	module := child_modules[_]
	module_name := module.address
	plcs := [plc |
		module.resources[i].type == "azurerm_policy_assignment"
		plc := module.resources[i].values.policy_definition_id
	]
}

# # # Get the policy_definition_id from all policy assignments in the opa.json
plc_assign_change_policy_definition_id[module_name] = plcs {
	module := input.resource_changes[_]
	module_name := module.module_address
	plcs := [plc |
		input.resource_changes[r].type == "azurerm_policy_assignment"
		input.resource_changes[r].module_address == module.module_address
		plc := input.resource_changes[r].change.after.policy_definition_id
	]
}

# # # Get the scope from all policy assignments in planned_values.yml
plc_assign_plan_scope[module_name] = plcs {
	module := child_modules[_]
	module_name := module.address
	plcs := [plc |
		module.resources[i].type == "azurerm_policy_assignment"
		plc := module.resources[i].values.scope
	]
}

# # # Get the scope from all policy assignments in the opa.json
plc_assign_change_scope[module_name] = plcs {
	module := input.resource_changes[_]
	module_name := module.module_address
	plcs := [plc |
		input.resource_changes[r].type == "azurerm_policy_assignment"
		input.resource_changes[r].module_address == module.module_address
		plc := input.resource_changes[r].change.after.scope
	]
}
