package main

import data.child_modules

########################
# Rules
########################

# # # Compare the policy_set_definition_management_group_name and fail if they are not equal.
violation[policy_set_definition_management_group_name] {
	plc_set_def_plan_management_group_name != plc_set_def_change_management_group_name
	policy_set_definition_management_group_name := sprintf("The policy_set_definition_management_group_name planned values:\n \n %v \n \n are not equal to the policy_set_definition_management_group_name changed values:\n \n %v", [plc_set_def_plan_management_group_name, plc_set_def_change_management_group_name])
}

# # # Compare the policy_set_definition_metadata and fail if they are not equal.
violation[policy_set_definition_metadata] {
	plc_set_def_plan_metadata != plc_set_def_change_metadata
	policy_set_definition_metadata := sprintf("The policy_set_definition_metadata planned values:\n \n %v \n \n are not equal to the policy_set_definition_metadata changed values:\n \n %v", [plc_set_def_plan_metadata, plc_set_def_change_metadata])
}

# # # Compare the policy_set_definition_parameters and fail if they are not equal.
violation[policy_set_definition_parameters] {
	plc_set_def_plan_parameters != plc_set_def_change_parameters
	policy_set_definition_parameters := sprintf("The policy_set_definition_parameters planned values:\n \n %v \n \n are not equal to the policy_set_definition_parameters changed values:\n \n %v", [plc_set_def_plan_parameters, plc_set_def_change_parameters])
}

# # # Compare the policy_set_definition_policy_definition_group and fail if they are not equal.
violation[policy_set_definition_policy_definition_group] {
	plc_set_def_plan_policy_definition_group != plc_set_def_change_policy_definition_group
	policy_set_definition_policy_definition_group := sprintf("The policy_set_definition_policy_definition_group planned values:\n \n %v \n \n are not equal to the policy_set_definition_policy_definition_group changed values:\n \n %v", [plc_set_def_plan_policy_definition_group, plc_set_def_change_policy_definition_group])
}

# # # Compare the policy_set_definition_reference and fail if they are not equal.
violation[policy_set_definition_reference] {
	plc_set_def_plan_definition_reference != plc_set_def_change_definition_reference
	policy_set_definition_reference := sprintf("The policy_set_definition_reference planned values:\n \n %v \n \n are not equal to the policy_set_definition_reference changed values:\n \n %v", [plc_set_def_plan_definition_reference, plc_set_def_change_definition_reference])
}

########################
# Library
########################

# # # Get the management_group_name from all policy set definitions in planned_values.yml
plc_set_def_plan_management_group_name[module_name] = plcs {
	module := child_modules[_]
	module_name := module.address
	plcs := [plc |
		module.resources[i].type == "azurerm_policy_set_definition"
		plc := module.resources[i].values.management_group_name
	]
}

# # # Get the management_group_name from all policy set definitions in the opa.json
plc_set_def_change_management_group_name[module_name] = plcs {
	module := input.resource_changes[_]
	module_name := module.module_address
	plcs := [plc |
		input.resource_changes[r].type == "azurerm_policy_set_definition"
		input.resource_changes[r].module_address == module.module_address
		plc := input.resource_changes[r].change.after.management_group_name
	]
}

# # # Get the metadata from all policy set definitions in planned_values.yml
plc_set_def_plan_metadata[module_name] = plcs {
	module := child_modules[_]
	module_name := module.address
	plcs := [plc |
		module.resources[i].type == "azurerm_policy_set_definition"
		plc := module.resources[i].values.metadata
	]
}

# # # Get the metadata from all policy set definitions in the opa.json
plc_set_def_change_metadata[module_name] = plcs {
	module := input.resource_changes[_]
	module_name := module.module_address
	plcs := [plc |
		input.resource_changes[r].type == "azurerm_policy_set_definition"
		input.resource_changes[r].module_address == module.module_address
		plc := input.resource_changes[r].change.after.metadata
	]
}

# # # Get the parameters from all policy set definitions in planned_values.yml
plc_set_def_plan_parameters[module_name] = plcs {
	module := child_modules[_]
	module_name := module.address
	plcs := [plc |
		module.resources[i].type == "azurerm_policy_set_definition"
		plc := module.resources[i].values.parameters
	]
}

# # # Get the parameters from all policy set definitions in the opa.json
plc_set_def_change_parameters[module_name] = plcs {
	module := input.resource_changes[_]
	module_name := module.module_address
	plcs := [plc |
		input.resource_changes[r].type == "azurerm_policy_set_definition"
		input.resource_changes[r].module_address == module.module_address
		plc := input.resource_changes[r].change.after.parameters
	]
}

# # # Get the policy_definition_group from all policy set definitions in planned_values.yml
plc_set_def_plan_policy_definition_group[module_name] = plcs {
	module := child_modules[_]
	module_name := module.address
	plcs := [plc |
		module.resources[i].type == "azurerm_policy_set_definition"
		plc := module.resources[i].values.policy_definition_group
	]
}

# # # Get the policy_definition_group from all policy set definitions in the opa.json
plc_set_def_change_policy_definition_group[module_name] = plcs {
	module := input.resource_changes[_]
	module_name := module.module_address
	plcs := [plc |
		input.resource_changes[r].type == "azurerm_policy_set_definition"
		input.resource_changes[r].module_address == module.module_address
		plc := input.resource_changes[r].change.after.policy_definition_group
	]
}

# # # Get the policy_definition_reference from all policy set definitions in planned_values.yml
plc_set_def_plan_definition_reference[module_name] = plcs {
	module := child_modules[_]
	module_name := module.address
	plcs := [plc |
		module.resources[i].type == "azurerm_policy_set_definition"
		plc := module.resources[i].values.policy_definition_reference
	]
}

# # # Get the policy_definition_reference from all policy set definitions in the opa.json
plc_set_def_change_definition_reference[module_name] = plcs {
	module := input.resource_changes[_]
	module_name := module.module_address
	plcs := [plc |
		input.resource_changes[r].type == "azurerm_policy_set_definition"
		input.resource_changes[r].module_address == module.module_address
		plc := input.resource_changes[r].change.after.policy_definition_reference
	]
}
