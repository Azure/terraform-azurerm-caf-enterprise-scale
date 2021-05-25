#### https://stackoverflow.com/questions/61894593/open-policy-agent-satisfy-condition-for-all-array-items
package main

import data.configuration_values

# Check and count "level_1" management_groups
violation[msg] {
	mgs := [mg | input.resource_changes[i].name == "level_1"; mg := input.resource_changes[i].change.after.display_name]
	count(mgs) != configuration_values.mgs.level_1
	msg := sprintf("Expected %v `level_1` management_groups %v but there are %v", [configuration_values.mgs.level_1, mgs, count(mgs)])
}

# Check and count "level_2" management_groups
violation[msg] {
	mgs := [mg | input.resource_changes[i].name == "level_2"; mg := input.resource_changes[i].change.after.display_name]
	count(mgs) != configuration_values.mgs.level_2
	msg := sprintf("Expected %v `level_2` management_groups %v but there are %v", [configuration_values.mgs.level_2, mgs, count(mgs)])
}

# Check and count "level_3" management_groups
violation[msg] {
	mgs := [mg | input.resource_changes[i].name == "level_3"; mg := input.resource_changes[i].change.after.display_name]
	count(mgs) != configuration_values.mgs.level_3
	msg := sprintf("Expected %v `level_3` management_groups %v but there are %v", [configuration_values.mgs.level_3, mgs, count(mgs)])
}

# Check and count "level_4" management_groups
violation[msg] {
	mgs := [mg | input.resource_changes[i].name == "level_4"; mg := input.resource_changes[i].change.after.display_name]
	count(mgs) != configuration_values.mgs.level_4
	msg := sprintf("Expected %v `level_4` management_groups %v but there are %v", [configuration_values.mgs.level_4, mgs, count(mgs)])
}

# Check and count "level_5" management_groups
violation[msg] {
	mgs := [mg | input.resource_changes[i].name == "level_5"; mg := input.resource_changes[i].change.after.display_name]
	count(mgs) != configuration_values.mgs.level_5
	msg := sprintf("Expected %v `level_5` management_groups %v but there are %v", [configuration_values.mgs.level_5, mgs, count(mgs)])
}

# Check and count "level_6" management_groups
violation[msg] {
	mgs := [mg | input.resource_changes[i].name == "level_6"; mg := input.resource_changes[i].change.after.display_name]
	count(mgs) != configuration_values.mgs.level_6
	msg := sprintf("Expected %v `level_6` management_groups %v but there are %v", [configuration_values.mgs.level_6, mgs, count(mgs)])
}

###########################################
# Test index
violation[msg] {
	mg_index := endswith(input.resource_changes[i].index, "myorg-1-landing-zones")
	mg_after_name := startswith(input.resource_changes[i].change.after.name, "myorg-1-landing-zones")
	mg_index != mg_after_name
	msg = sprintf("The value in `%v` is not `%v`", [mg_index, mg_after_name])
}

# Verify index
violation[msg] {
	mg_after_name := input.resource_changes[i].change.after.name
	mg_index_name := input.resource_changes[i].index
	mg_index_valid := endswith(mg_index_name, mg_after_name)
	contains(input.resource_changes[i].type, "azurerm_management_group")
	mg_index_valid != true
	msg = sprintf("The index `%v` does not end with the name `%v`", [mg_index_name, mg_after_name])
}
