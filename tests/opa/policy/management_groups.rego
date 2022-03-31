package main

import input.planned_values.root_module as plan
import data.root_module as baseline

########################
# Rules
########################
# Compare the management_group_display_name and fail if they are not equal.
violation[management_group_display_name] {
	plan_mgs_display_name != baseline_mgs_display_name
	management_group_display_name := sprintf("The management_group_display_name planned values:\n \n %v \n \n are not equal to the management_group_display_name baseline values:\n \n %v", [plan_mgs_display_name, baseline_mgs_display_name])
}

# Compare the management_group_name and fail if they are not equal.
violation[management_group_name] {
	plan_mgs_name != baseline_mgs_name
	management_group_name := sprintf("The management_group_name planned values:\n \n %v \n \n are not equal to the management_group_name baseline values:\n \n %v", [plan_mgs_name, baseline_mgs_name])
}

########################
# Library
########################

# Get the display name from all management groups in planned_values.json
baseline_mgs_display_name[module_name] = mgs {
	module := baseline.child_modules[_]
	module_name := module.address
	mgs := [mg |
		module.resources[i].type == "azurerm_management_group"
		mg := module.resources[i].values.display_name
	]
}

# Get the display name from all management groups in the terraform_plan.json
plan_mgs_display_name[module_name] = mgs {
	module := plan.child_modules[_]
	module_name := module.address
	mgs := [mg |
		module.resources[r].type == "azurerm_management_group"
		mg := module.resources[r].values.display_name
	]
}

# Get the name from all management groups in planned_values.json
baseline_mgs_name[module_name] = mgs {
	module := baseline.child_modules[_]
	module_name := module.address
	mgs := [mg |
		module.resources[i].type == "azurerm_management_group"
		mg := module.resources[i].values.name
	]
}

# Get the name from all management groups in the terraform_plan.json
plan_mgs_name[module_name] = mgs {
	module := plan.child_modules[_]
	module_name := module.address
	mgs := [mg |
		module.resources[r].type == "azurerm_management_group"
		mg := module.resources[r].values.name
	]
}
