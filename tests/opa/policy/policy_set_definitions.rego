package main

import input.planned_values.root_module as plan
import data.root_module as baseline

########################
# Rules
########################

# Compare the policy_set_definition_name and fail if they are not equal.
violation[policy_set_definition_display_name] {
	plan_policy_set_definition_display_name != baseline_policy_set_definition_display_name
	policy_set_definition_display_name := sprintf("The policy_set_definition_name planned values:\n \n %v \n \n are not equal to the policy_set_definition_name baseline values:\n \n %v", [plan_policy_set_definition_display_name, baseline_policy_set_definition_display_name])
}

# Compare the policy_set_definition_name and fail if they are not equal.
violation[policy_set_definition_name] {
	plan_policy_set_definition_name != baseline_policy_set_definition_name
	policy_set_definition_name := sprintf("The policy_set_definition_name planned values:\n \n %v \n \n are not equal to the policy_set_definition_name baseline values:\n \n %v", [plan_policy_set_definition_name, baseline_policy_set_definition_name])
}

# Compare the policy_set_definition_management_group_id and fail if they are not equal.
violation[policy_set_definition_management_group_id] {
	plan_policy_set_definition_management_group_id != baseline_policy_set_definition_management_group_id
	policy_set_definition_management_group_id := sprintf("The policy_set_definition_management_group_id planned values:\n \n %v \n \n are not equal to the policy_set_definition_management_group_id changed values:\n \n %v", [plan_policy_set_definition_management_group_id, baseline_policy_set_definition_management_group_id])
}

# Compare the policy_set_definition_metadata and fail if they are not equal.
violation[policy_set_definition_metadata] {
	plan_policy_set_definition_metadata != baseline_policy_set_definition_metadata
	policy_set_definition_metadata := sprintf("The policy_set_definition_metadata planned values:\n \n %v \n \n are not equal to the policy_set_definition_metadata changed values:\n \n %v", [plan_policy_set_definition_metadata, baseline_policy_set_definition_metadata])
}

# Compare the policy_set_definition_parameters and fail if they are not equal.
violation[policy_set_definition_parameters] {
	plan_policy_set_definition_parameters != baseline_policy_set_definition_parameters
	policy_set_definition_parameters := sprintf("The policy_set_definition_parameters planned values:\n \n %v \n \n are not equal to the policy_set_definition_parameters changed values:\n \n %v", [plan_policy_set_definition_parameters, baseline_policy_set_definition_parameters])
}

# Compare the policy_set_definition_policy_definition_group and fail if they are not equal.
violation[policy_set_definition_policy_definition_group] {
	plan_policy_set_definition_policy_definition_group != baseline_policy_set_definition_policy_definition_group
	policy_set_definition_policy_definition_group := sprintf("The policy_set_definition_policy_definition_group planned values:\n \n %v \n \n are not equal to the policy_set_definition_policy_definition_group changed values:\n \n %v", [plan_policy_set_definition_policy_definition_group, baseline_policy_set_definition_policy_definition_group])
}

# Compare the policy_set_definition_reference and fail if they are not equal.
violation[policy_set_definition_reference] {
	plan_policy_set_definition_definition_reference != baseline_policy_set_definition_definition_reference
	policy_set_definition_reference := sprintf("The policy_set_definition_reference planned values:\n \n %v \n \n are not equal to the policy_set_definition_reference changed values:\n \n %v", [plan_policy_set_definition_definition_reference, baseline_policy_set_definition_definition_reference])
}

########################
# Library
########################

# Get the display_name from all policy set definitions in planned_values.json
baseline_policy_set_definition_display_name[module_name] = policy_set_definitions {
	module := baseline.child_modules[_]
	module_name := module.address
	policy_set_definitions := [policy_definition |
		module.resources[i].type == "azurerm_policy_set_definition"
		policy_definition := module.resources[i].values.display_name
	]
}

# Get the display_name from all policy set definitions in the terraform_plan.json
plan_policy_set_definition_display_name[module_name] = policy_set_definitions {
	module := plan.child_modules[_]
	module_name := module.address
	policy_set_definitions := [policy_definition |
		module.resources[r].type == "azurerm_policy_set_definition"
		policy_definition := module.resources[r].values.display_name
	]
}

# Get the name from all policy set definitions in planned_values.json
baseline_policy_set_definition_name[module_name] = policy_set_definitions {
	module := baseline.child_modules[_]
	module_name := module.address
	policy_set_definitions := [policy_definition |
		module.resources[i].type == "azurerm_policy_set_definition"
		policy_definition := module.resources[i].values.name
	]
}

# Get the name from all policy set definitions in the terraform_plan.json
plan_policy_set_definition_name[module_name] = policy_set_definitions {
	module := plan.child_modules[_]
	module_name := module.address
	policy_set_definitions := [policy_definition |
		module.resources[r].type == "azurerm_policy_set_definition"
		policy_definition := module.resources[r].values.name
	]
}

# Get the management_group_id from all policy set definitions in planned_values.json
baseline_policy_set_definition_management_group_id[module_name] = policy_set_definitions {
	module := baseline.child_modules[_]
	module_name := module.address
	policy_set_definitions := [policy_set_definition |
		module.resources[i].type == "azurerm_policy_set_definition"
		policy_set_definition := module.resources[i].values.management_group_id
	]
}

# Get the management_group_id from all policy set definitions in the terraform_plan.json
plan_policy_set_definition_management_group_id[module_name] = policy_set_definitions {
	module := plan.child_modules[_]
	module_name := module.address
	policy_set_definitions := [policy_set_definition |
		module.resources[r].type == "azurerm_policy_set_definition"
		policy_set_definition := module.resources[r].values.management_group_id
	]
}

# Get the metadata from all policy set definitions in planned_values.json
baseline_policy_set_definition_metadata[module_name] = policy_set_definitions {
	module := baseline.child_modules[_]
	module_name := module.address
	policy_set_definitions := [policy_set_definition |
		module.resources[i].type == "azurerm_policy_set_definition"
		policy_set_definition := module.resources[i].values.metadata
	]
}

# Get the metadata from all policy set definitions in the terraform_plan.json
plan_policy_set_definition_metadata[module_name] = policy_set_definitions {
	module := plan.child_modules[_]
	module_name := module.address
	policy_set_definitions := [policy_set_definition |
		module.resources[r].type == "azurerm_policy_set_definition"
		policy_set_definition := module.resources[r].values.metadata
	]
}

# Get the parameters from all policy set definitions in planned_values.json
baseline_policy_set_definition_parameters[module_name] = policy_set_definitions {
	module := baseline.child_modules[_]
	module_name := module.address
	policy_set_definitions := [policy_set_definition |
		module.resources[i].type == "azurerm_policy_set_definition"
		policy_set_definition := module.resources[i].values.parameters
	]
}

# Get the parameters from all policy set definitions in the terraform_plan.json
plan_policy_set_definition_parameters[module_name] = policy_set_definitions {
	module := plan.child_modules[_]
	module_name := module.address
	policy_set_definitions := [policy_set_definition |
		module.resources[r].type == "azurerm_policy_set_definition"
		policy_set_definition := module.resources[r].values.parameters
	]
}

# Get the policy_definition_group from all policy set definitions in planned_values.json
baseline_policy_set_definition_policy_definition_group[module_name] = policy_set_definitions {
	module := baseline.child_modules[_]
	module_name := module.address
	policy_set_definitions := [policy_set_definition |
		module.resources[i].type == "azurerm_policy_set_definition"
		policy_set_definition := module.resources[i].values.policy_definition_group
	]
}

# Get the policy_definition_group from all policy set definitions in the terraform_plan.json
plan_policy_set_definition_policy_definition_group[module_name] = policy_set_definitions {
	module := plan.child_modules[_]
	module_name := module.address
	policy_set_definitions := [policy_set_definition |
		module.resources[r].type == "azurerm_policy_set_definition"
		policy_set_definition := module.resources[r].values.policy_definition_group
	]
}

# Get the policy_definition_reference from all policy set definitions in planned_values.json
baseline_policy_set_definition_definition_reference[module_name] = policy_set_definitions {
	module := baseline.child_modules[_]
	module_name := module.address
	policy_set_definitions := [policy_set_definition |
		module.resources[i].type == "azurerm_policy_set_definition"
		policy_set_definition := module.resources[i].values.policy_definition_reference
	]
}

# Get the policy_definition_reference from all policy set definitions in the terraform_plan.json
plan_policy_set_definition_definition_reference[module_name] = policy_set_definitions {
	module := plan.child_modules[_]
	module_name := module.address
	policy_set_definitions := [policy_set_definition |
		module.resources[r].type == "azurerm_policy_set_definition"
		policy_set_definition := module.resources[r].values.policy_definition_reference
	]
}
