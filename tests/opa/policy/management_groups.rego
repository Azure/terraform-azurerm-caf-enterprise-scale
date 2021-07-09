package main

import data.child_modules

########################
# Rules
########################
# # # Compare the management_group_display_name and fail if they are not equal.
violation[management_group_display_name] {
	mgs_plan_display_name != mgs_change_display_name
	management_group_display_name := sprintf("The management_group_display_name planned values:\n \n %v \n \n are not equal to the management_group_display_name changed values:\n \n %v", [mgs_plan_display_name, mgs_change_display_name])
}

# # # Compare the management_group_name and fail if they are not equal.
violation[management_group_name] {
	mgs_plan_name != mgs_change_name
	management_group_name := sprintf("The management_group_name planned values:\n \n %v \n \n are not equal to the management_group_name changed values:\n \n %v", [mgs_plan_name, mgs_change_name])
}

########################
# Library
########################
# # # Get the display name from all management groups in planned_values.yml
mgs_plan_display_name[module_name] = mgs {
	module := child_modules[_]
	module_name := module.address
	mgs := [mg |
		module.resources[i].type == "azurerm_management_group"

		#module.resources[i].name == "level_1"
		mg := module.resources[i].values.display_name
	]
}

# # # Get the display name from all management groups in the opa.json
mgs_change_display_name[module_name] = mgs {
	module := input.resource_changes[_]
	module_name := module.module_address
	mgs := [mg |
		input.resource_changes[r].type == "azurerm_management_group"
		input.resource_changes[r].module_address == module.module_address
		mg := input.resource_changes[r].change.after.display_name
	]
}

# # # Get the name from all management groups in planned_values.yml
mgs_plan_name[module_name] = mgs {
	module := child_modules[_]
	module_name := module.address
	mgs := [mg |
		module.resources[i].type == "azurerm_management_group"
		mg := module.resources[i].values.name
	]
}

# # #Get the name from all management groups in the opa.json
mgs_change_name[module_name] = mgs {
	module := input.resource_changes[_]
	module_name := module.module_address
	mgs := [mg |
		input.resource_changes[r].type == "azurerm_management_group"
		input.resource_changes[r].module_address == module.module_address
		mg := input.resource_changes[r].change.after.name
	]
}
