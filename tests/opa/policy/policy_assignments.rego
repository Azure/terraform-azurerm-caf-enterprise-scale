package main

import input.planned_values.root_module as plan
import data.root_module as baseline

########################
# Rules
########################

# Compare the policy_assignment_display_name and fail if they are not equal.
violation[policy_assignment_display_name] {
	plan_policy_assignment_display_name != baseline_policy_assignment_display_name
	policy_assignment_display_name := sprintf("The policy_assignment_display_name planned values:\n \n %v \n \n are not equal to the policy_assignment_display_name baseline values:\n \n %v", [plan_policy_assignment_display_name, baseline_policy_assignment_display_name])
}

# Compare the policy_assignment_name and fail if they are not equal.
violation[policy_assignment_name] {
	plan_policy_assignment_name != baseline_policy_assignment_name
	policy_assignment_name := sprintf("The policy_assignment_name planned values:\n \n %v \n \n are not equal to the policy_assignment_name baseline values:\n \n %v", [plan_policy_assignment_name, baseline_policy_assignment_name])
}

# Compare the policy_assignment_enforcement_mode and fail if they are not equal.
violation[policy_assignment_enforcement_mode] {
	plan_policy_assignment_enforcement_mode != baseline_policy_assignment_enforcement_mode
	policy_assignment_enforcement_mode := sprintf("The policy_assignment_enforcement_mode planned values:\n \n %v \n \n are not equal to the policy_assignment_enforcement_mode baseline values:\n \n %v", [plan_policy_assignment_enforcement_mode, baseline_policy_assignment_enforcement_mode])
}

# Compare the policy_assignment_identity and fail if they are not equal.
violation[policy_assignment_identity] {
	plan_policy_assignment_identity != baseline_policy_assignment_identity
	policy_assignment_identity := sprintf("The policy_assignment_identity planned values:\n \n %v \n \n are not equal to the policy_assignment_identity baseline values:\n \n %v", [plan_policy_assignment_identity, baseline_policy_assignment_identity])
}

# Compare the policy_assignment_location and fail if they are not equal.
violation[policy_assignment_location] {
	plan_policy_assignment_location != baseline_policy_assignment_location
	policy_assignment_location := sprintf("The policy_assignment_location planned values:\n \n %v \n \n are not equal to the policy_assignment_location baseline values:\n \n %v", [plan_policy_assignment_location, baseline_policy_assignment_location])
}

# Compare the policy_assignment_not_scopes and fail if they are not equal.
violation[policy_assignment_not_scopes] {
	plan_policy_assignment_not_scopes != baseline_policy_assignment_not_scopes
	policy_assignment_not_scopes := sprintf("The policy_assignment_not_scopes planned values:\n \n %v \n \n are not equal to the policy_assignment_not_scopes baseline values:\n \n %v", [plan_policy_assignment_not_scopes, baseline_policy_assignment_not_scopes])
}

# Compare the policy_assignment_parameters and fail if they are not equal.
# Needs a way to allow for changes to Subscription IDs within parameter values.
# violation[policy_assignment_parameters] {
# 	plan_policy_assignment_parameters != baseline_policy_assignment_parameters
# 	policy_assignment_parameters := sprintf("The policy_assignment_parameters planned values:\n \n %v \n \n are not equal to the policy_assignment_parameters baseline values:\n \n %v", [plan_policy_assignment_parameters, baseline_policy_assignment_parameters])
# }

# Compare the policy_assignment_policy_definition_id and fail if they are not equal.
violation[policy_assignment_policy_definition_id] {
	plan_policy_assignment_policy_definition_id != baseline_policy_assignment_policy_definition_id
	policy_assignment_policy_definition_id := sprintf("The policy_assignment_policy_definition_id planned values:\n \n %v \n \n are not equal to the policy_assignment_policy_definition_id baseline values:\n \n %v", [plan_policy_assignment_policy_definition_id, baseline_policy_assignment_policy_definition_id])
}

# Compare the policy_assignment_scope and fail if they are not equal.
violation[policy_assignment_scope] {
	plan_policy_assignment_scope != baseline_policy_assignment_scope
	policy_assignment_scope := sprintf("The policy_assignment_scope planned values:\n \n %v \n \n are not equal to the policy_assignment_scope baseline values:\n \n %v", [plan_policy_assignment_scope, baseline_policy_assignment_scope])
}

########################
# Library
########################

# Get the display name from all policy assignments in planned_values.json
baseline_policy_assignment_display_name[module_name] = policy_assignments {
	module := baseline.child_modules[_]
	module_name := module.address
	policy_assignments := [policy_assignment |
		module.resources[i].type == "azurerm_management_group_policy_assignment"
		policy_assignment := module.resources[i].values.display_name
	]
}

# Get the display name from all policy assignments in the terraform_plan.json
plan_policy_assignment_display_name[module_name] = policy_assignments {
	module := plan.child_modules[_]
	module_name := module.address
	policy_assignments := [policy_assignment |
		module.resources[r].type == "azurerm_management_group_policy_assignment"
		policy_assignment := module.resources[r].values.display_name
	]
}

# Get the name from all policy assignments in planned_values.json
baseline_policy_assignment_name[module_name] = policy_assignments {
	module := baseline.child_modules[_]
	module_name := module.address
	policy_assignments := [policy_assignment |
		module.resources[i].type == "azurerm_management_group_policy_assignment"
		policy_assignment := module.resources[i].values.name
	]
}

# Get the name from all policy assignments in the terraform_plan.json
plan_policy_assignment_name[module_name] = policy_assignments {
	module := plan.child_modules[_]
	module_name := module.address
	policy_assignments := [policy_assignment |
		module.resources[r].type == "azurerm_management_group_policy_assignment"
		policy_assignment := module.resources[r].values.name
	]
}

# Get the enforcement mode from all policy assignments in planned_values.json
baseline_policy_assignment_enforcement_mode[module_name] = policy_assignments {
	module := baseline.child_modules[_]
	module_name := module.address
	policy_assignments := [policy_assignment |
		module.resources[i].type == "azurerm_management_group_policy_assignment"
		policy_assignment := module.resources[i].values.enforce
	]
}

# Get the enforcement mode from all policy assignments in the terraform_plan.json
plan_policy_assignment_enforcement_mode[module_name] = policy_assignments {
	module := plan.child_modules[_]
	module_name := module.address
	policy_assignments := [policy_assignment |
		module.resources[r].type == "azurerm_management_group_policy_assignment"
		policy_assignment := module.resources[r].values.enforce
	]
}

# Get the identity from all policy assignments in planned_values.json
baseline_policy_assignment_identity[module_name] = policy_assignments {
	module := baseline.child_modules[_]
	module_name := module.address
	policy_assignments := [policy_assignment |
		module.resources[i].type == "azurerm_management_group_policy_assignment"
		policy_assignment := module.resources[i].values.identity
	]
}

# Get the identity from all policy assignments in the terraform_plan.json
plan_policy_assignment_identity[module_name] = policy_assignments {
	module := plan.child_modules[_]
	module_name := module.address
	policy_assignments := [policy_assignment |
		module.resources[r].type == "azurerm_management_group_policy_assignment"
		policy_assignment := module.resources[r].values.identity
	]
}

# Get the location from all policy assignments in planned_values.json
baseline_policy_assignment_location[module_name] = policy_assignments {
	module := baseline.child_modules[_]
	module_name := module.address
	policy_assignments := [policy_assignment |
		module.resources[i].type == "azurerm_management_group_policy_assignment"
		policy_assignment := module.resources[i].values.location
	]
}

# Get the location from all policy assignments in the terraform_plan.json
plan_policy_assignment_location[module_name] = policy_assignments {
	module := plan.child_modules[_]
	module_name := module.address
	policy_assignments := [policy_assignment |
		module.resources[r].type == "azurerm_management_group_policy_assignment"
		policy_assignment := module.resources[r].values.location
	]
}

# Get the not_scopes from all policy assignments in planned_values.json
baseline_policy_assignment_not_scopes[module_name] = policy_assignments {
	module := baseline.child_modules[_]
	module_name := module.address
	policy_assignments := [policy_assignment |
		module.resources[i].type == "azurerm_management_group_policy_assignment"
		policy_assignment := module.resources[i].values.not_scopes
	]
}

# Get the not_scopes from all policy assignments in the terraform_plan.json
plan_policy_assignment_not_scopes[module_name] = policy_assignments {
	module := plan.child_modules[_]
	module_name := module.address
	policy_assignments := [policy_assignment |
		module.resources[r].type == "azurerm_management_group_policy_assignment"
		policy_assignment := module.resources[r].values.not_scopes
	]
}

# Get the parameters from all policy assignments in planned_values.json
baseline_policy_assignment_parameters[module_name] = policy_assignments {
	module := baseline.child_modules[_]
	module_name := module.address
	policy_assignments := [policy_assignment |
		module.resources[i].type == "azurerm_management_group_policy_assignment"
		policy_assignment := module.resources[i].values.parameters
	]
}

# Get the parameters from all policy assignments in the terraform_plan.json
plan_policy_assignment_parameters[module_name] = policy_assignments {
	module := plan.child_modules[_]
	module_name := module.address
	policy_assignments := [policy_assignment |
		module.resources[r].type == "azurerm_management_group_policy_assignment"
		policy_assignment := module.resources[r].values.parameters
	]
}

# Get the policy_definition_id from all policy assignments in planned_values.json
baseline_policy_assignment_policy_definition_id[module_name] = policy_assignments {
	module := baseline.child_modules[_]
	module_name := module.address
	policy_assignments := [policy_assignment |
		module.resources[i].type == "azurerm_management_group_policy_assignment"
		policy_assignment := module.resources[i].values.policy_definition_id
	]
}

# Get the policy_definition_id from all policy assignments in the terraform_plan.json
plan_policy_assignment_policy_definition_id[module_name] = policy_assignments {
	module := plan.child_modules[_]
	module_name := module.address
	policy_assignments := [policy_assignment |
		module.resources[r].type == "azurerm_management_group_policy_assignment"
		policy_assignment := module.resources[r].values.policy_definition_id
	]
}

# Get the scope from all policy assignments in planned_values.json
baseline_policy_assignment_scope[module_name] = policy_assignments {
	module := baseline.child_modules[_]
	module_name := module.address
	policy_assignments := [policy_assignment |
		module.resources[i].type == "azurerm_management_group_policy_assignment"
		policy_assignment := module.resources[i].values.management_group_id
	]
}

# Get the scope from all policy assignments in the terraform_plan.json
plan_policy_assignment_scope[module_name] = policy_assignments {
	module := plan.child_modules[_]
	module_name := module.address
	policy_assignments := [policy_assignment |
		module.resources[r].type == "azurerm_management_group_policy_assignment"
		policy_assignment := module.resources[r].values.management_group_id
	]
}
