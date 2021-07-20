## Overview

As part of upgrade from release 0.3.3 to 0.4.0, the [Terraform Module for Cloud Adoption Framework Enterprise-scale][terraform-registry-caf-enterprise-scale] includes a number of breaking changes.

This update provides a number of new features, helps keep this module up to date with the latest reference architecture published in the [Azure/Enterprise-Scale][azure/enterprise-scale] repository, and to support the latest releases of Terraform and the AzureRM Provider.

## Required actions

Anyone using this module should be aware of the following when planning to upgrade from release 0.3.3 to 0.4.0:

1. A select number of policies and roles provided as part of this module will be redeployed.
Please carefully review the output of `terraform plan` to ensure there are no issues with any custom configuration within your root module.

1. The following library template types will need checking for references to policies as listed in the [resource changes](#resource-changes) section below:
    1. Archetype Definitions
    1. Policy Assignments
    1. Policy Set Definitions

1. All Policy Assignments (and associated Role Assignments where a Managed Identity is required for policies with DeployIfNotExists or Modify effects) will be recreated to support moving these from the [`azurerm_policy_assignment` (deprecated)][azurerm_policy_assignment] to [`azurerm_management_group_policy_assignment`][azurerm_management_group_policy_assignment] resource types.

1. Adds provider configuration within the module, allowing creation of resources across multiple Subscriptions. This impacts existing [Management and monitoring][ESLZ-Management] resources.
To avoid the need to re-create these resources, please review the [management resources](#management-resources) section below.
Please also review the [provider configuration][wiki_provider_configuration] page for more detail on how you should configure this in your module declaration.

1. Adds new functionality to enable deployment of [Network topology and connectivity][ESLZ-Connectivity] resources into the connectivity Subscription context.
Currently based on the hub & spoke deployment model.

1. Adds new functionality to manage Policy Assignments as part of delivering the [Identity and access management][ESLZ-Identity]

## Resource changes

The following changes have been made within the module which may cause issues when using custom archetype definitions:

- The following Policy Definitions have been added to the `es_root` archetype definition:
  - `Audit-MachineLearning-PrivateEndpointId`
  - `Deny-MachineLearning-Aks`
  - `Deny-MachineLearning-Compute-SubnetId`
  - `Deny-MachineLearning-Compute-VmSize`
  - `Deny-MachineLearning-ComputeCluster-RemoteLoginPortPublicAccess`
  - `Deny-MachineLearning-ComputeCluster-Scale`
  - `Deny-MachineLearning-HbiWorkspace`
  - `Deny-MachineLearning-PublicAccessWhenBehindVnet`
  - `Deploy-Default-Udr`

- The following Policy Assignments have been added to the `es_identity` archetype definition:
  - `Deny-Public-IP`
  - `Deny-RDP-From-Internet`
  - `Deny-Subnet-Without-Nsg`
  - `Deploy-VM-Backup`

> NOTE: All references to resource names are **_Case Sensitive_**. Failure to use the correct case will result in an `Invalid index` error when running `terraform plan`, such as the following example:

```shell
Error: Invalid index

  on ../../modules/archetypes/locals.policy_definitions.tf line 82, in locals:
  82:       template    = local.archetype_policy_definitions_map[policy]
    |----------------
    | local.archetype_policy_definitions_map is object with 100 attributes

The given key does not identify an element in this collection value.
```

### Resource type: `azurerm_policy_assignment`

The following new Policy Assignments are included in this update:
- `Deny-Public-IP`

### Resource type: `azurerm_policy_definition`

The following new Policy Definitions are included in this update:
- `Audit-MachineLearning-PrivateEndpointId`
- `Deny-MachineLearning-Aks`
- `Deny-MachineLearning-Compute-SubnetId`
- `Deny-MachineLearning-Compute-VmSize`
- `Deny-MachineLearning-ComputeCluster-RemoteLoginPortPublicAccess`
- `Deny-MachineLearning-ComputeCluster-Scale`
- `Deny-MachineLearning-HbiWorkspace`
- `Deny-MachineLearning-PublicAccessWhenBehindVnet`
- `Deploy-Default-Udr`

The following Policy Definition changes are included in this update:
- `Append-AppService-latestTLS` has been updated from `Indexed` to `All` for the `mode` attribute.
- `Deny-Subnet-Without-Udr` now includes a new `excludedSubnets` parameter to allow exclusions (default value = `["AzureBastionSubnet"]`).

### Management resources

As part of enabling support for multiple providers within the module to allow resources to be deployed to multiple Subscriptions within a single module declaration, it has been necessary to rename some resources within the module. These are all resources relating to the management solution within the module.

The following resources have been renamed:

| v0.3.x | v0.4.x |
| --- | --- |
| azurerm_automation_account.enterprise_scale[\*] | azurerm_automation_account.management[\*] |
| azurerm_log_analytics_linked_service.enterprise_scale[\*] | azurerm_log_analytics_linked_service.management[\*] |
| azurerm_log_analytics_solution.enterprise_scale[\*] | azurerm_log_analytics_solution.management[\*] |
| azurerm_log_analytics_workspace.enterprise_scale[\*] | azurerm_log_analytics_workspace.management[\*] |
| azurerm_resource_group.enterprise_scale[\*] | azurerm_resource_group.management[\*] |

This was necessary to allow the module to support deploying resources into different Subscriptions using dedicated providers for the `core`, `management`, and `connectivity` capabilities.

> **NOTE:** The `identity` capability doesn't deploy any resources, as it configures Azure Policy on the Identity Management Group only. As such, `identity` doesn't have a dedicated provider.

To prevent the need to redeploy these resources, you can simply run the `terraform state mv` command to move each updated resource within the state file before running `terraform plan` and `terraform apply` using the updated module version.

The following PowerShell script can be used to assist with this process, using a RegEx pattern to extract a list of the resources which should be updated, and then moving them to the target name:

```powershell
[regex]$pattern = "(?<=module.([^.]+).(azurerm_resource_group|azurerm_log_analytics_workspace|azurerm_automation_account|azurerm_log_analytics_linked_service|azurerm_log_analytics_solution).)enterprise_scale"

[array]$(terraform state list) | ForEach-Object {
    if ($pattern.IsMatch($_)) {
        $newName = $pattern.Replace($_, "management")
        Write-Host "Found resource to move..."
        Write-Host " - Current resource name : $($_)"
        Write-Host " - New resource name     : $($newName)"
        # Comment out the following line to check the script is proposing the expected resource moves.
        terraform state mv $($_ -replace '"', '\"') $($newName -replace '"', '\"')
    }
}
```

> **IMPORTANT:** Whilst every effort has been made to ensure this script works correctly in a test environment, it may behave differently in your environment.
> Therefore we strongly recommend to backup your Terraform State files before attempting to run/use this script.
> As described in the MIT license associated with this repository, this script is provided as-is with no warranty or liability associated with its use.

Unfortunately it is not possible to take this approach with the [`azurerm_policy_assignment` (deprecated)][azurerm_policy_assignment] resources, as these are being changed to a different resource type. As such, these resources will be redeployed as part of the upgrade process.

## Next steps

Take a look at the latest [User Guide](./User-Guide) documentation and our [Examples](./Examples) to understand the latest module configuration options, and review your implementation against the changes documented on this page.

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

[terraform-registry-caf-enterprise-scale]: https://registry.terraform.io/modules/Azure/caf-enterprise-scale/azurerm/latest "Terraform Registry: Terraform Module for Cloud Adoption Framework Enterprise-scale"
[azure/enterprise-scale]: https://github.com/Azure/Enterprise-Scale

[ESLZ-Management]:   https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/enterprise-scale/management-and-monitoring
[ESLZ-Connectivity]: https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/enterprise-scale/network-topology-and-connectivity
[ESLZ-Identity]:     https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/enterprise-scale/identity-and-access-management

[azurerm_management_group_policy_assignment]: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group_policy_assignment
[azurerm_policy_assignment]:                  https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_assignment

[wiki_provider_configuration]: ./%5BUser-Guide%5D-Provider-Configuration "Wiki - Provider Configuration"
