package advancedVnetPeeringName

import (
	"fmt"
	"os"
	"testing"

	"github.com/Azure/terraform-azurerm-caf-enterprise-scale/tests/terratest/utils"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	uuidv5 "github.com/google/uuid"
)

type testcase struct {
	Name        string
	PeeringName string
	TFVars      map[string]interface{}
}

// TestAdvancedVnetPeeringName tests the standard vnet peering naming functionality
func TestConnectivityAdvancedVnetPeering(t *testing.T) {
	require.NotEmptyf(t, os.Getenv("ARM_SUBSCRIPTION_ID"), "env var ARM_SUBSCRIPTION_ID is required")
	subId := os.Getenv("ARM_SUBSCRIPTION_ID")
	spokeId := fmt.Sprintf(
		"/subscriptions/%s/resourceGroups/test-advancedVnetPeeringName/providers/Microsoft.Network/virtualNetworks/spoke-vnet",
		subId,
	)
	peeringSuffix := uuidv5.NewSHA1(uuidv5.NameSpaceURL, []byte(spokeId)).String()
	testCases := []testcase{
		{
			Name:        "StandardVnetPeeringNaming",
			PeeringName: fmt.Sprintf("peering-%s", peeringSuffix),
			TFVars:      map[string]interface{}{},
		},
		{
			Name:        "AdvancedVnetPeeringNaming",
			PeeringName: "test",
			TFVars: map[string]interface{}{
				"test_advanced_name": true,
			},
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
			runTest(t, tc.PeeringName, &testOpts)
		})
	}
}

// runTest runs the test case after init
func runTest(t *testing.T, peeringName string, to *terraform.Options) {
	t.Parallel()
	_, err := terraform.PlanE(t, to)
	require.NoError(t, err)
	pl, err := terraform.ShowWithStructE(t, to)
	subId := os.Getenv("ARM_SUBSCRIPTION_ID")
	require.NoError(t, err)
	peeringMapKey := fmt.Sprintf(
		"module.test_core.azurerm_virtual_network_peering.connectivity[\"/subscriptions/%s/resourceGroups/es-connectivity-northeurope/providers/Microsoft.Network/virtualNetworks/es-hub-northeurope/virtualNetworkPeerings/%s\"]",
		subId,
		peeringName)
	plannedPeering, ok := pl.ResourcePlannedValuesMap[peeringMapKey]
	if !ok {
		errmsg := fmt.Sprintf("Could not locate peering map key: %s in plan", peeringMapKey)
		assert.FailNow(t, errmsg)
	}
	plannedPeeringName, ok := plannedPeering.AttributeValues["name"]
	if !ok {
		errmsg := fmt.Sprintf("Could not locate peering attribute 'name': %s in plan", peeringName)
		assert.FailNow(t, errmsg)
	}
	assert.Equal(t, plannedPeeringName, peeringName)
	t.Logf("Peering name: '%s' is correct in plan", peeringName)
}
