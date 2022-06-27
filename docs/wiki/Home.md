<!-- markdownlint-disable first-line-heading first-line-h1 -->
The [Azure landing zones Terraform module][alz_tf_registry] provides an opinionated approach for deploying and managing the core platform capabilities of [Azure landing zones architecture][alz_architecture] using Terraform, with a focus on the central resource hierarchy:

![Azure landing zone conceptual architecture][alz_tf_overview]

Depending on selected options, this module can deploy different sets of resources based on the following capabilities:

- [Core Resources][wiki_core_resources]
- [Management Resources][wiki_management_resources]
- [Connectivity Resources][wiki_connectivity_resources]
- [Identity Resources][wiki_identity_resources]

Please click on each of the above links for more details.

## Design areas

The module provides a consistent approach for deploying and managing resources relating to the following design areas:

- [Resource organization][alz_hierarchy]
  - Create the Management Group resource hierarchy
  - Assign Subscriptions to Management Groups
  - Create custom Policy Assignments, Policy Definitions and Policy Set Definitions (Initiatives)
- [Identity and access management][alz_identity]
  - Secure the identity subscription using Azure Policy
  - Create custom Role Assignments and Role Definitions
- [Management][alz_management]
  - Create a central Log Analytics workspace and Automation Account
  - Link Log Analytics workspace to the Automation Account
  - Deploy recommended Log Analytics Solutions
  - Enable Microsoft Defender for Cloud
- [Network topology and connectivity][alz_connectivity]
  - Create a centralized hub network
    - Traditional Azure networking topology (hub and spoke)
    - Virtual WAN network topology (Microsoft-managed)
  - Secure network design
    - Azure Firewall
    - DDoS Protection Standard
  - Hybrid connectivity
    - Azure Virtual Network Gateway
    - Azure ExpressRoute Gateway
  - Centrally managed DNS zones

## Next steps

Check out the [User Guide](User-Guide), or go straight to our [Examples](Examples).

 [//]: # (*****************************)
 [//]: # (INSERT IMAGE REFERENCES BELOW)
 [//]: # (*****************************)

[alz_tf_overview]: media/alz-tf-module-overview.png "A conceptual architecture diagram highlighting the design areas covered by the Azure landing zones Terraform module."

 [//]: # (************************)
 [//]: # (INSERT LINK LABELS BELOW)
 [//]: # (************************)

[alz_tf_registry]:  https://registry.terraform.io/modules/Azure/caf-enterprise-scale/azurerm/latest "Terraform Registry: Azure landing zones Terraform module"
[alz_architecture]: https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone#azure-landing-zone-conceptual-architecture
[alz_hierarchy]:    https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org
[alz_management]:   https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/management
[alz_connectivity]: https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/network-topology-and-connectivity
[alz_identity]:     https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access

[arm_management_group]:               https://docs.microsoft.com/azure/templates/microsoft.management/managementgroups
[arm_management_group_subscriptions]: https://docs.microsoft.com/azure/templates/microsoft.management/managementgroups/subscriptions
[arm_policy_assignment]:              https://docs.microsoft.com/azure/templates/microsoft.authorization/policyassignments
[arm_policy_definition]:              https://docs.microsoft.com/azure/templates/microsoft.authorization/policydefinitions
[arm_policy_set_definition]:          https://docs.microsoft.com/azure/templates/microsoft.authorization/policysetdefinitions
[arm_role_assignment]:                https://docs.microsoft.com/azure/templates/microsoft.authorization/roleassignments
[arm_role_definition]:                https://docs.microsoft.com/azure/templates/microsoft.authorization/roledefinitions
[arm_resource_group]:                 https://docs.microsoft.com/azure/templates/microsoft.resources/resourcegroups
[arm_log_analytics_workspace]:        https://docs.microsoft.com/azure/templates/microsoft.operationalinsights/workspaces
[arm_log_analytics_solution]:         https://docs.microsoft.com/azure/templates/microsoft.operationsmanagement/solutions
[arm_automation_account]:             https://docs.microsoft.com/azure/templates/microsoft.automation/automationaccounts
[arm_log_analytics_linked_service]:   https://docs.microsoft.com/azure/templates/microsoft.operationalinsights/workspaces/linkedservices

[azurerm_management_group]:             https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group
[azurerm_policy_assignment]:            https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_assignment
[azurerm_policy_definition]:            https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_definition
[azurerm_policy_set_definition]:        https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_set_definition
[azurerm_role_assignment]:              https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment
[azurerm_role_definition]:              https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition
[azurerm_resource_group]:               https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group
[azurerm_log_analytics_workspace]:      https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace
[azurerm_log_analytics_solution]:       https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_solution
[azurerm_automation_account]:           https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_account
[azurerm_log_analytics_linked_service]: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_linked_service

[wiki_core_resources]:         %5BUser-Guide%5D-Core-Resources "Wiki - Core Resources"
[wiki_management_resources]:   %5BUser-Guide%5D-Management-Resources "Wiki - Management Resources"
[wiki_connectivity_resources]: %5BUser-Guide%5D-Connectivity-Resources "Wiki - Connectivity Resources"
[wiki_identity_resources]:     %5BUser-Guide%5D-Identity-Resources "Wiki - Identity Resources"
