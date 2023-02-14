<!-- markdownlint-disable first-line-h1 -->
## Overview

The module provides an option to enable deployment of [management and monitoring][alz_management] resources from the [conceptual architecture for Azure landing zones][msdocs_alz_architecture] into the specified subscription, as described on the [Provider Configuration][wiki_provider_configuration] wiki page.
The module also ensures that the specified subscription is placed in the right management group.

This brings the benefit of being able to manage the full lifecycle of these resources using Terraform, with native integration into the corresponding Policy Assignments to ensure full policy compliance.

![Overview of the Azure landing zones management resources][alz_management_overview]

## Resource types

When you enable deployment of management resources, the module deploys and manages the following resource types (*depending on configuration*):

| Resource | Azure resource type | Terraform resource type |
| --- | --- | --- |
| Resource groups | [`Microsoft.Resources/resourceGroups`][arm_resource_group] | [`azurerm_resource_group`][azurerm_resource_group] |
| Log Analytics workspace | [`Microsoft.OperationalInsights/workspaces`][arm_log_analytics_workspace] | [`azurerm_log_analytics_workspace`][azurerm_log_analytics_workspace] |
| Log Analytics solutions | [`Microsoft.OperationsManagement/solutions`][arm_log_analytics_solution] | [`azurerm_log_analytics_solution`][azurerm_log_analytics_solution] |
| Automation account | [`Microsoft.Automation/automationAccounts`][arm_automation_account] | [`azurerm_automation_account`][azurerm_automation_account] |
| Log Analytics linked service | [`Microsoft.OperationalInsights/workspaces /linkedServices`][arm_log_analytics_linked_service] | [`azurerm_log_analytics_linked_service`][azurerm_log_analytics_linked_service] |

In addition to deploying the above resources, the module provides native integration into the corresponding policy assignments to ensure full policy compliance.

## Next steps

Please refer to [Deploy Management Resources][wiki_deploy_management_resources] for examples showing how to use this capability.

 [//]: # (*****************************)
 [//]: # (INSERT IMAGE REFERENCES BELOW)
 [//]: # (*****************************)

[alz_management_overview]: media/terraform-caf-enterprise-scale-management.png "A conceptual architecture diagram focusing on the management resources for an Azure landing zone."

 [//]: # (************************)
 [//]: # (INSERT LINK LABELS BELOW)
 [//]: # (************************)

[msdocs_alz_architecture]: https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/#azure-landing-zone-conceptual-architecture "Conceptual architecture for Azure landing zones."

[alz_management]: https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/management "Management and monitoring for Azure landing zones on the Cloud Adoption Framework."

[arm_resource_group]:                 https://learn.microsoft.com/azure/templates/microsoft.resources/resourcegroups
[arm_log_analytics_workspace]:        https://learn.microsoft.com/azure/templates/microsoft.operationalinsights/workspaces
[arm_log_analytics_solution]:         https://learn.microsoft.com/azure/templates/microsoft.operationsmanagement/solutions
[arm_automation_account]:             https://learn.microsoft.com/azure/templates/microsoft.automation/automationaccounts
[arm_log_analytics_linked_service]:   https://learn.microsoft.com/azure/templates/microsoft.operationalinsights/workspaces/linkedservices

[azurerm_resource_group]:               https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group
[azurerm_log_analytics_workspace]:      https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace
[azurerm_log_analytics_solution]:       https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_solution
[azurerm_automation_account]:           https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_account
[azurerm_log_analytics_linked_service]: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_linked_service

[wiki_deploy_management_resources]: https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Management-Resources "Wiki - Deploy Management Resources"
[wiki_provider_configuration]:      https://github.com/krowlandson/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Provider-Configuration "Wiki - Provider configuration"
