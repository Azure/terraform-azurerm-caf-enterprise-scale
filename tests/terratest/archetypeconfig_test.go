package terratest_test

import (
	"terratest"
	"testing"

	"github.com/Azure/terratest-terraform-fluent/check"
	"github.com/Azure/terratest-terraform-fluent/setuptest"
	"github.com/stretchr/testify/require"
)

const (
	moduleDir = "../../"
)

func TestArchetypeConfigOverrideEnforcementMode(t *testing.T) {
	test, err := setuptest.Dirs(moduleDir, "").
		WithVars(varsTestArchetypeConfigOverrideEnforcementMode()).
		InitPlanShowWithPrepFunc(t, terratest.AzureRm)
	defer test.Cleanup()
	require.NoError(t, err)

	// check enforcementmode override in non-root mg
	res := `azurerm_management_group_policy_assignment.enterprise_scale["/providers/Microsoft.Management/managementGroups/test-decommissioned/providers/Microsoft.Authorization/policyAssignments/Enforce-ALZ-Decomm"]`
	check.InPlan(test.PlanStruct).That(res).Key("enforce").HasValue(false).ErrorIsNil(t)

	// check enforcementmode override in root mg
	res = `azurerm_management_group_policy_assignment.enterprise_scale["/providers/Microsoft.Management/managementGroups/test/providers/Microsoft.Authorization/policyAssignments/Audit-UnusedResources"]`
	check.InPlan(test.PlanStruct).That(res).Key("enforce").HasValue(false).ErrorIsNil(t)
}

func varsTestArchetypeConfigOverrideEnforcementMode() map[string]any {
	return map[string]any{
		"root_parent_id":    "00000000-0000-0000-0000-000000000000",
		"root_name":         "test",
		"root_id":           "test",
		"default_location":  "eastus",
		"disable_telemetry": true,
		"archetype_config_overrides": map[string]any{
			"root": map[string]any{
				"enforcement_mode": map[string]any{
					"Audit-UnusedResources": false,
				},
			},
			"decommissioned": map[string]any{
				"enforcement_mode": map[string]any{
					"Enforce-ALZ-Decomm": false,
				},
			},
		},
	}
}

func varsTestArchetypeConfigDefaults() map[string]any {
	return map[string]any{
		"root_parent_id":    "00000000-0000-0000-0000-000000000000",
		"root_name":         "test",
		"root_id":           "test",
		"default_location":  "eastus",
		"disable_telemetry": true,
	}
}
