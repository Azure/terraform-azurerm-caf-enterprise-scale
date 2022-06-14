package advancedVnetPeeringName

import (
	"fmt"
	"os"
	"testing"

	"github.com/Azure/terraform-azurerm-caf-enterprise-scale/tests/terratest/utils"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

// TestAdvancedVnetPeeringName tests the advanced block vnet peering name functionality
func TestConnectivityAdvancedVnetPeeringNameNotSet(t *testing.T) {
	var peeringname string = "peering-134dd88d-86f2-5006-9401-698a1f46852e"
	to := utils.GetDefaultTerraformOptions(t)
	runTest(t, peeringname, to)
}

func TestConnectivityAdvancedVnetPeeringNameSet(t *testing.T) {
	var peeringname string = "test"
	to := utils.GetDefaultTerraformOptions(t)
	to.Vars["test_advanced_name"] = true
	runTest(t, peeringname, to)
}

func runTest(t *testing.T, peeringName string, to *terraform.Options) {
	pl, err := terraform.InitAndPlanAndShowWithStructE(t, to)
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
