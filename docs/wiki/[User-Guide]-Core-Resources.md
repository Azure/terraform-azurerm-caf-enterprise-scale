<!-- markdownlint-disable first-line-h1 -->
## Overview

The core capability of this module deploys the foundations of the [conceptual architecture for Azure landing zones][msdocs_alz_architecture], with a focus on the central [resource organization][alz_resourceorg].

![Overview of the Azure landing zones core resources][alz_core_overview]

## Resource types

The following resource types are deployed and managed by this module when using the core capabilities:

| Resource | Azure resource type | Terraform resource type |
| --- | --- | --- |
| Management groups | [`Microsoft.Management/managementGroups`][arm_management_group] | [`azurerm_management_group`][azurerm_management_group] |
| Management group subscriptions | [`Microsoft.Management/managementGroups/subscriptions`][arm_management_group_subscriptions]  | [`azurerm_management_group`][azurerm_management_group] Or [`azurerm_management_group_subscription_association`][azurerm_management_group_subscription_association] |
| Policy assignments | [`Microsoft.Authorization/policyAssignments`][arm_policy_assignment] | [`azurerm_management_group_policy_assignment`][azurerm_management_group_policy_assignment] |
| Policy definitions | [`Microsoft.Authorization/policyDefinitions`][arm_policy_definition] | [`azurerm_policy_definition`][azurerm_policy_definition] |
| Policy set definitions | [`Microsoft.Authorization/policySetDefinitions`][arm_policy_set_definition] | [`azurerm_policy_set_definition`][azurerm_policy_set_definition] |
| Role assignments | [`Microsoft.Authorization/roleAssignments`][arm_role_assignment] | [`azurerm_role_assignment`][azurerm_role_assignment] |
| Role definitions | [`Microsoft.Authorization/roleDefinitions`][arm_role_definition] | [`azurerm_role_definition`][azurerm_role_definition] |

The exact number of resources that the module creates depends on the module configuration. For a [default configuration][wiki_deploy_default_configuration], you can expect the module to create approximately `180` resources.

> **NOTE:** None of these resources are deployed at the subscription scope, but Terraform still requires a subscription to establish an authenticated session with Azure.
> For more information on authenticating with Azure, refer to the [Azure Provider: Authenticating to Azure][azurerm_auth] documentation.

## Next Steps

Please refer to [Deploy Default Configuration][wiki_deploy_default_configuration] for examples showing how to use this capability.

 [//]: # (*****************************)
 [//]: # (INSERT IMAGE REFERENCES BELOW)
 [//]: # (*****************************)

[alz_core_overview]: media/terraform-caf-enterprise-scale-core.png "Diagram showing the core Azure landing zones architecture deployed by this module."

 [//]: # (************************)
 [//]: # (INSERT LINK LABELS BELOW)
 [//]: # (************************)

[msdocs_alz_architecture]: https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/#azure-landing-zone-conceptual-architecture "Conceptual architecture for Azure landing zones."

[alz_resourceorg]: https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org "Resource organization for Azure landing zones on the Cloud Adoption Framework."

[arm_management_group]:               https://learn.microsoft.com/azure/templates/microsoft.management/managementgroups
[arm_management_group_subscriptions]: https://learn.microsoft.com/azure/templates/microsoft.management/managementgroups/subscriptions
[arm_policy_assignment]:              https://learn.microsoft.com/azure/templates/microsoft.authorization/policyassignments
[arm_policy_definition]:              https://learn.microsoft.com/azure/templates/microsoft.authorization/policydefinitions
[arm_policy_set_definition]:          https://learn.microsoft.com/azure/templates/microsoft.authorization/policysetdefinitions
[arm_role_assignment]:                https://learn.microsoft.com/azure/templates/microsoft.authorization/roleassignments
[arm_role_definition]:                https://learn.microsoft.com/azure/templates/microsoft.authorization/roledefinitions

[azurerm_management_group]:                          https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group
[azurerm_management_group_subscription_association]: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group_subscription_association
[azurerm_management_group_policy_assignment]:        https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group_policy_assignment
[azurerm_policy_definition]:                         https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_definition
[azurerm_policy_set_definition]:                     https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_set_definition
[azurerm_role_assignment]:                           https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment
[azurerm_role_definition]:                           https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition

[wiki_deploy_default_configuration]: %5BExamples%5D-Deploy-Default-Configuration "Wiki - Deploy Default Configuration"

[azurerm_auth]: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs#authenticating-to-azure "Authenticate to Azure when using the AzureRM provider."
