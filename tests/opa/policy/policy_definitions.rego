package main

import data.child_modules

########################
# Rules
########################

# # # Some rules are commented out to prevent Azure Pipelines runner running out of memory (error code 137)

# # # # Compare the policy_definition_name and fail if they are not equal.
# violation[policy_definition_name] {
# 	plc_def_plan_name != plc_def_change_name
# 	policy_definition_name := sprintf("The policy_definition_name planned values:\n \n %v \n \n are not equal to the policy_definition_name changed values:\n \n %v", [plc_def_plan_name, plc_def_change_name])
# }

# # # # Compare the policy_definition_management_group_name and fail if they are not equal.
# violation[policy_definition_management_group_name] {
# 	plc_def_plan_management_group_name != plc_def_change_management_group_name
# 	policy_definition_management_group_name := sprintf("The policy_definition_management_group_name planned values:\n \n %v \n \n are not equal to the policy_definition_management_group_name changed values:\n \n %v", [plc_def_plan_management_group_name, plc_def_change_management_group_name])
# }

# # # # Compare the policy_definition_metadata and fail if they are not equal.
# violation[policy_definition_metadata] {
# 	plc_def_plan_metadata != plc_def_change_metadata
# 	policy_definition_metadata := sprintf("The policy_definition_metadata planned values:\n \n %v \n \n are not equal to the policy_definition_metadata changed values:\n \n %v", [plc_def_plan_metadata, plc_def_change_metadata])
# }

# # # # Compare the policy_definition_parameters and fail if they are not equal.
# violation[policy_definition_parameters] {
# 	plc_def_plan_parameters != plc_def_change_parameters
# 	policy_definition_parameters := sprintf("The policy_definition_parameters planned values:\n \n %v \n \n are not equal to the policy_definition_parameters changed values:\n \n %v", [plc_def_plan_parameters, plc_def_change_parameters])
# }

# # # # Compare the policy_definition_policy_rule and fail if they are not equal.
# violation[policy_definition_policy_rule] {
# 	plc_def_plan_policy_rule != plc_def_change_policy_rule
# 	policy_definition_policy_rule := sprintf("The policy_definition_policy_rule planned values:\n \n %v \n \n are not equal to the policy_definition_policy_rule changed values:\n \n %v", [plc_def_plan_policy_rule, plc_def_change_policy_rule])
# }

########################
# Library
########################
# # # Get the name from all policy definitions in planned_values.yml
plc_def_plan_name[module_name] = pl_defs {
	module := child_modules[_]
	module_name := module.address
	pl_defs := [pl_def |
		module.resources[i].type == "azurerm_policy_definition"
		pl_def := module.resources[i].values.name
	]
}

# # # Get the name from all policy definitions in the opa.json
plc_def_change_name[module_name] = pl_defs {
	module := input.resource_changes[_]
	module_name := module.module_address
	pl_defs := [pl_def |
		input.resource_changes[r].type == "azurerm_policy_definition"
		input.resource_changes[r].module_address == module.module_address
		pl_def := input.resource_changes[r].change.after.name
	]
}

# # # Get the management_group_name from all policy definitions in planned_values.yml
plc_def_plan_management_group_name[module_name] = pl_defs {
	module := child_modules[_]
	module_name := module.address
	pl_defs := [pl_def |
		module.resources[i].type == "azurerm_policy_definition"
		pl_def := module.resources[i].values.management_group_name
	]
}

# # # Get the management_group_name from all policy definitions in the opa.json
plc_def_change_management_group_name[module_name] = pl_defs {
	module := input.resource_changes[_]
	module_name := module.module_address
	pl_defs := [pl_def |
		input.resource_changes[r].type == "azurerm_policy_definition"
		input.resource_changes[r].module_address == module.module_address
		pl_def := input.resource_changes[r].change.after.management_group_name
	]
}

# # # Get the metadata from all policy definitions in planned_values.yml
plc_def_plan_metadata[module_name] = pl_defs {
	module := child_modules[_]
	module_name := module.address
	pl_defs := [pl_def |
		module.resources[i].type == "azurerm_policy_definition"
		pl_def := module.resources[i].values.metadata
	]
}

# # # Get the metadata from all policy definitions in the opa.json
plc_def_change_metadata[module_name] = pl_defs {
	module := input.resource_changes[_]
	module_name := module.module_address
	pl_defs := [pl_def |
		input.resource_changes[r].type == "azurerm_policy_definition"
		input.resource_changes[r].module_address == module.module_address
		pl_def := input.resource_changes[r].change.after.metadata
	]
}

# # # Get the parameters from all policy definitions in planned_values.yml
plc_def_plan_parameters[module_name] = pl_defs {
	module := child_modules[_]
	module_name := module.address
	pl_defs := [pl_def |
		module.resources[i].type == "azurerm_policy_definition"
		pl_def := module.resources[i].values.parameters
	]
}

# # # Get the parameters from all policy definitions in the opa.json
plc_def_change_parameters[module_name] = pl_defs {
	module := input.resource_changes[_]
	module_name := module.module_address
	pl_defs := [pl_def |
		input.resource_changes[r].type == "azurerm_policy_definition"
		input.resource_changes[r].module_address == module.module_address
		pl_def := input.resource_changes[r].change.after.parameters
	]
}

# # # Get the policy_rule from all policy definitions in planned_values.yml
plc_def_plan_policy_rule[module_name] = pl_defs {
	module := child_modules[_]
	module_name := module.address
	pl_defs := [pl_def |
		module.resources[i].type == "azurerm_policy_definition"
		pl_def := module.resources[i].values.policy_rule
	]
}

# # # Get the policy_rule from all policy definitions in the opa.json
plc_def_change_policy_rule[module_name] = pl_defs {
	module := input.resource_changes[_]
	module_name := module.module_address
	pl_defs := [pl_def |
		input.resource_changes[r].type == "azurerm_policy_definition"
		input.resource_changes[r].module_address == module.module_address
		pl_def := input.resource_changes[r].change.after.policy_rule
	]
}
