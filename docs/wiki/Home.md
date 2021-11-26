# Terraform Module for Cloud Adoption Framework Enterprise-scale

The [Terraform Module for Cloud Adoption Framework Enterprise-scale][terraform-registry-caf-enterprise-scale] provides an opinionated approach for deploying and managing the core platform capabilities of [Cloud Adoption Framework enterprise-scale landing zone architecture][ESLZ-Architecture] using Terraform, with a focus on the central resource hierarchy:

![Enterprise-scale Landing Zone Architecture][TFAES-Overview]

Depending on selected options, this module can deploy different groups of resources as needed.

This is currently split logically into the following capabilities:

- [Core Resources][wiki_core_resources]
- [Management Resources][wiki_management_resources]
- [Connectivity Resources][wiki_connectivity_resources]
- [Identity Resources][wiki_identity_resources]

Please click on each of the above links for more details.

## Critical design areas

The module provides a consistent approach for deploying and managing resources relating to the following Enterprise-scale critical design areas:

- [Management Group and Subscription organisation][management-group-and-subscription-organization]
  - Create the Management Group resource hierarchy
  - Assign Subscriptions to Management Groups
  - Create custom Policy Assignments, Policy Definitions and Policy Set Definitions (Initiatives)
- [Identity and access management][identity-and-access-management]
  - Create custom Role Assignments and Role Definitions
- [Management and monitoring][management-and-monitoring]
  - Create a central Log Analytics workspace and Automation Account
  - Link Log Analytics workspace to the Automation Account
  - Deploy recommended Log Analytics Solutions
  - Enable Azure Defender
- [Network topology and connectivity][network-topology-and-connectivity]
  - Create a centralised hub for hybrid connectivity
  - Secure network using Azure Firewall
  - Centrally managed DNS zones

## Next steps

Check out the [User Guide](./User-Guide), or go straight to our [Examples](./Examples).

 [//]: # (*****************************)
 [//]: # (INSERT IMAGE REFERENCES BELOW)
 [//]: # (*****************************)

[TFAES-Overview]: ./media/terraform-caf-enterprise-scale-overview.png "Diagram showing the Cloud Adoption Framework Enterprise-scale Landing Zone architecture deployed by this module."

 [//]: # (************************)
 [//]: # (INSERT LINK LABELS BELOW)
 [//]: # (************************)

[ESLZ-Architecture]:                              https://docs.microsoft.com/azure/cloud-adoption-framework/ready/enterprise-scale/architecture "Enterprise-scale Reference Architecture"
[terraform-registry-caf-enterprise-scale]:        https://registry.terraform.io/modules/Azure/caf-enterprise-scale/azurerm/latest "Terraform Registry: Terraform Module for Cloud Adoption Framework Enterprise-scale"
[management-group-and-subscription-organization]: https://docs.microsoft.com/azure/cloud-adoption-framework/ready/enterprise-scale/management-group-and-subscription-organization "Cloud Adoption Framework: Management group and subscription organization"
[identity-and-access-management]:                 https://docs.microsoft.com/azure/cloud-adoption-framework/ready/enterprise-scale/identity-and-access-management "Cloud Adoption Framework: Identity and access management"
[management-and-monitoring]:                      https://docs.microsoft.com/azure/cloud-adoption-framework/ready/enterprise-scale/management-and-monitoring "Cloud Adoption Framework: Management and monitoring"
[network-topology-and-connectivity]:              https://docs.microsoft.com/azure/cloud-adoption-framework/ready/enterprise-scale/network-topology-and-connectivity "Cloud Adoption Framework: Network topology and connectivity"

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

[wiki_core_resources]:         ./%5BUser-Guide%5D-Core-Resources "Wiki - Core Resources"
[wiki_management_resources]:   ./%5BUser-Guide%5D-Management-Resources "Wiki - Management Resources"
[wiki_connectivity_resources]: ./%5BUser-Guide%5D-Connectivity-Resources "Wiki - Connectivity Resources"
[wiki_identity_resources]:     ./%5BUser-Guide%5D-Identity-Resources "Wiki - Identity Resources"
