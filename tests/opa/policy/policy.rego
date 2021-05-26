package main

import data.child_modules

# # # Test index
# violation[msg] {
# 	mg_index := endswith(input.resource_changes[i].index, "myorg-1-landing-zones")
# 	mg_after_name := startswith(input.resource_changes[i].change.after.name, "myorg-1-landing-zones")
# 	mg_index != mg_after_name
# 	msg = sprintf("The value in `%v` is not `%v`", [mg_index, mg_after_name])
# }

# Verify index
violation[msg] {
	#value_1 := input.planned_values.root_module.child_modules[_].resources[_].type
	value_2 := child_modules[_].resources[_].type

	msg = sprintf("`%v`", [value_2])
}
