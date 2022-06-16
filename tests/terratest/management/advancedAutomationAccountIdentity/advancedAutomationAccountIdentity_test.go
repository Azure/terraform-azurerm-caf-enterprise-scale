package advancedAutomationAccountIdentity

import (
	"fmt"
	"os"
	"testing"

	"github.com/Azure/terraform-azurerm-caf-enterprise-scale/tests/terratest/utils"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

type testcase struct {
	Name         string
	IdentityType string
	IdentityIds  []interface{}
	TFVars       map[string]interface{}
}

func TestManagementAdvancedAutomationAccountIdentity(t *testing.T) {
	require.NotEmptyf(t, os.Getenv("ARM_SUBSCRIPTION_ID"), "env var ARM_SUBSCRIPTION_ID is required")
	testCases := []testcase{
		{
			Name: "IdentityDisabled",
			TFVars: map[string]interface{}{
				"test_advanced_identity": false,
			},
		},
		{
			Name: "IdentityEnabled",
			TFVars: map[string]interface{}{
				"test_advanced_identity": true,
			},
			IdentityType: "SystemAssigned, UserAssigned",
			IdentityIds: []interface{}{
				"/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test/providers/Microsoft.ManagedIdentity/userAssignedIdentities/test-id"},
		},
	}
	dir := utils.GetTestDir(t)
	to := utils.GetDefaultTerraformOptions(t, dir)
	_, err := terraform.InitE(t, to)
	require.NoError(t, err)
	for i, tc := range testCases {
		t.Run(tc.Name, func(t *testing.T) {
			var testOpts terraform.Options = *to
			testOpts.PlanFilePath = fmt.Sprintf("%s/tfplan%d", dir, i)
			testOpts.Vars = tc.TFVars
			runTest(t, tc, &testOpts)
		})
	}
}

func runTest(t *testing.T, tc testcase, to *terraform.Options) {
	t.Parallel()
	_, err := terraform.PlanE(t, to)
	require.NoError(t, err)
	pl, err := terraform.ShowWithStructE(t, to)
	subId := os.Getenv("ARM_SUBSCRIPTION_ID")
	require.NoError(t, err)
	mapKey := fmt.Sprintf(
		"module.test_core.azurerm_automation_account.management[\"/subscriptions/%s/resourceGroups/es-mgmt/providers/Microsoft.Automation/automationAccounts/es-automation\"]",
		subId)
	terraform.RequirePlannedValuesMapKeyExists(t, pl, mapKey)
	planned := pl.ResourcePlannedValuesMap[mapKey]

	if !tc.TFVars["test_advanced_identity"].(bool) {
		require.Len(t, planned.AttributeValues["identity"], 0)
	}

	if tc.TFVars["test_advanced_identity"].(bool) {
		require.NotNil(t, planned.AttributeValues["identity"])
		ib := planned.AttributeValues["identity"].([]interface{})
		require.Len(t, ib, 1)
		assert.Equal(t, ib[0].(map[string]interface{})["type"], tc.IdentityType)
		ids := ib[0].(map[string]interface{})["identity_ids"].([]interface{})
		assert.Equal(t, ids, tc.IdentityIds)
	}
}
