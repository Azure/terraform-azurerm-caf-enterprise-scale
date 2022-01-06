## Core resources

This module is primarily designed to build your resource hierarchy, manage policies and set permissions.
As such, you can think of this as being the primary point of governance for your deployment to Azure.
By design, the Azure platform (not our module) will automatically assign `Owner` permissions to the creator of any Management Group.
This permission will be inherited by all child resources, including Management Groups, Subscriptions, Resource Groups and Resources.

To get started with the module for deploying "core resources", you only need access to a single Subscription (*for the Azure RM Provider to authenticate with Azure*).
No specific permissions are needed unless your Tenant has been configured to [Require permissions for creating new management groups][azure_hierarchy_require_authorization].
If enabled, the module requires the `Microsoft.Management/managementGroups/write` operation on the root management group to create new child management groups.
This operation is included in the recommended roles listed below so doesn't require additional configuration.

You also need to consider permissions needed for [Moving management groups and subscriptions][azure_hierarchy_moving] into the Enterprise-scale resource hierarchy, as summarised below:

- Management group write and Role Assignment write permissions on the child subscription or management group.
  - Built-in role example **Owner**
- Management group write access on the target parent management group.
  - Built-in role example: **Owner, Contributor, Management Group Contributor**
- Management group write access on the existing parent management group.
  - Built-in role example: **Owner, Contributor, Management Group Contributor**

All Subscriptions will inherit `Owner` permissions from the Management Group hierarchy for the identity used to run Terraform.
As the requirement for Role Assignment write permissions effectively gives this identity permissions to assign any other permissions, we do not recommend altering this configuration.
In most cases, we advise running this module within a secure CI/CD pipeline and monitoring the Activity Log for suspicious activity (using suitable [SIEM tooling][azure_sentinel]) to mitigate the risks associated with high privileged identities.

### Reduce scope of access control

To enable access to newly created Subscriptions whilst maintaining a security boundary from other parts of your hierarchy, consider provisioning a dedicated Management Group under the `Tenant Root Group` and configuring this as the [default Management Group][azure_hierarchy_set_default].
This Management Group should not be managed by this module, and should be configured with the [required permissions](#core-resources) for the identity deploying this module to access it.
By granting Terraform access to this Management Group, Terraform will be able to on-board new Subscriptions into the Enterprise-scale hierarchy without needing additional permissions on the `Tenant Root Group`.

### Brownfield deployments

For brownfield environments, you may also wish to manually move existing Subscriptions into a custom [default Management Group][azure_hierarchy_set_default] ([as above](#reduce-scope-of-access-control)) to enable on-boarding into the module, but always check the impact this will have on any existing policy and access control settings.

> For more information around this scenario, please refer to our guidance on [transitioning existing Azure environments to Enterprise-scale][azure_transition].

## Connectivity resources

In a standard deployment, the permissions necessary to deploy [Connectivity resources](#connectivity-resources) should be in place through the [Core resources](#core-resources) configuration.

If you have implemented a custom "least privilege" permissions model, you may need to consider the additional permissions needed to deploy [Connectivity resources](#connectivity-resources) in the Connectivity Subscription.
To ensure you have sufficient coverage of the resource types deployed by this module, we recommend assigning the [`Network Contributor`][azure_network_contributor] role.

Although the module should inherit the necessary permissions through the [Core resources](#core-resources) configuration, please note that the sequencing of resource creation assumes these permissions are already in place on the target Subscription.
Initial deployment may fail if the target Subscription hasn't already been moved into the target Management Group.

You may also need to add these permissions if running dedicated pipelines for [Core resources](#core-resources), [Connectivity resources](#connectivity-resources), and [Management resources](#management-resources).

## Management resources

In a standard deployment, the permissions necessary to deploy [Management resources](#management-resources) should be in place through the [Core resources](#core-resources) configuration.

If you have implemented a custom "least privilege" permissions model, you may need to consider the additional permissions needed to deploy [Management resources](#management-resources) in the Management Subscription.
To ensure you have sufficient coverage of the resource types deployed by this module, we recommend assigning the [`Log Analytics Contributor`][azure_log_analytics_contributor] role.

Although the module should inherit the necessary permissions through the [Core resources](#core-resources) configuration, please note that the sequencing of resource creation assumes these permissions are already in place on the target Subscription.
Initial deployment may fail if the target Subscription hasn't already been moved into the target Management Group.

You may also need to add these permissions if running dedicated pipelines for [Core resources](#core-resources), [Connectivity resources](#connectivity-resources), and [Management resources](#management-resources).


 [//]: # (************************)
 [//]: # (INSERT LINK LABELS BELOW)
 [//]: # (************************)

[azure_hierarchy_require_authorization]: https://docs.microsoft.com/azure/governance/management-groups/how-to/protect-resource-hierarchy#setting---require-authorization "Azure Hierarchy - Setting - Require authorization"
[azure_hierarchy_set_default]:           https://docs.microsoft.com/azure/governance/management-groups/how-to/protect-resource-hierarchy#setting---default-management-group "Setting a default Management Group"
[azure_hierarchy_moving]:                https://docs.microsoft.com/azure/governance/management-groups/overview#moving-management-groups-and-subscriptions "Moving management groups and subscriptions"
[azure_transition]:                      https://docs.microsoft.com/azure/cloud-adoption-framework/ready/enterprise-scale/transition "Transition existing Azure environments to enterprise-scale"
[azure_sentinel]:                        https://azure.microsoft.com/en-gb/services/azure-sentinel/ "Azure Sentinel - Intelligent security analytics for your entire enterprise."
[azure_network_contributor]:             https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#network-contributor "Azure built-in roles # Network Contributor"
[azure_log_analytics_contributor]:       https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#log-analytics-contributor "Azure built-in roles # Log Analytics Contributor"