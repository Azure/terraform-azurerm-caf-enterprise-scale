## Considerations when deploying Enterprise Scale Landing Zones with Terraform

Enterprise Scale Landing Zones makes extensive use of Azure Policy to implement governance.
Sometimes, certain Azure Policies have compatibility issues or constraints with the Azure Terraform provider.
This page describes these considerations and provides recommendations where appropriate.

### Deny Subnet Without NSG

The reference architecture assigns the `Deny-Subnet-Without-NSG` policy to the Landing Zones management group.
In the event that a landing zone subscription is managed by Terraform, this policy have the following unwanted effect:

* Preventing Terraform from deploying `azurerm_subnet` resources due to the way that the Azure Terraform provider interacts with the Azure network resource provider.

#### Recommendation

Override the policy assignment and change the policy effect from `deny` to `audit`.

### Use of `DeployIfNotExists` and `Modify` Policy Effects

Terraform expects to be authoritative over the resources that it manages.
Any changes to the managed properties of Terraform managed resources in Azure will be rectified by Terraform during the next plan/apply cycle.

The reference architecture uses Azure policy with `DeployIfNotExists` and `modify` effects that can modify properties of the Terraform managed resources.

The combination of `DeployIfNotExists`/`modify` policy and Terraform can result in a loop, with resources being continuously remediated by Azure Policy, then reverted by Terraform, then again remediated by Policy.

> Notable exceptions to this are `DeployIfNotExists` policies that do not modify the in-scope resource. For example: Policies that deploy diagnostic settings.

#### Recommendation

* Create guidance for landing zone owners so that they understand the effects of these policies and can deploy resources in a compliant manner.
