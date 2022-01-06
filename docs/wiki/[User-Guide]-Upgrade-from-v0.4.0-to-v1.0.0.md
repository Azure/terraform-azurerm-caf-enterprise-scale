## Overview

As part of upgrade from release 0.4.0 to 1.0.0, the [Terraform Module for Cloud Adoption Framework Enterprise-scale][terraform-registry-caf-enterprise-scale] includes a minor breaking change due to the need to update the minimum supported `azurerm` provider version to `2.77.0`.

This update is mainly focused on adding the latest updates to custom Policy Definitions, documentation updates for the Wiki, and a couple of minor bug fixes. These changes help to keep this module up to date with the latest reference architecture published in the [Azure/Enterprise-Scale][azure/enterprise-scale] repository, and to support the latest releases of Terraform and the AzureRM Provider.

This also represents a significant milestone in the development of this module, as we aim to increase stability on the input variables and minimize breaking changes when adding new features.

## Required actions

Anyone using this module should be aware of the following when planning to upgrade from release 0.4.0 to 1.0.0:

1. The module now has a minimum supported `azurerm` provider version of `2.77.0`.

1. A select number of policies provided as part of this module will be redeployed.
Please carefully review the output of `terraform plan` to ensure there are no issues with any custom configuration within your root module.

1. If you are using a custom library, the following library template types will need checking for references to updated policies as listed in the [resource changes](#resource-changes) section below:
    1. Archetype Definitions
    1. Policy Assignments
    1. Policy Set Definitions

## Resource changes

The following changes have been made within the module which may cause issues when using custom archetype definitions:

- The following Policy Definition changes have been included in the `es_root` archetype definition:
  - `Deny-Databricks-NoPublicIp` added
  - `Deny-Databricks-Sku` added
  - `Deny-Databricks-VirtualNetwork` added
  - `Deny-MachineLearning-PublicNetworkAccess` added

- The following Policy Definitions have been updated:

- The following Policy Assignments templates have been added to the module but are not associated with any archetype definition and therefore not assigned by default:
  - `Deny-Private-DNS-Zones`

> NOTE: All references to resource names are **_Case Sensitive_**. Failure to use the correct case will result in an `Invalid index` error when running `terraform plan`, such as the following example:

```shell
Error: Invalid index

  on ../../modules/archetypes/locals.policy_definitions.tf line 82, in locals:
  82:       template    = local.archetype_policy_definitions_map[policy]
    |----------------
    | local.archetype_policy_definitions_map is object with 100 attributes

The given key does not identify an element in this collection value.
```

### Resource type: `azurerm_policy_definition`

The following Policy Definitions had `name` and `description` fields updated, which will result in an in-place update:
- `Audit-MachineLearning-PrivateEndpointId`
- `Deny-MachineLearning-Aks`
- `Deny-MachineLearning-Compute-SubnetId`
- `Deny-MachineLearning-Compute-VmSize`
- `Deny-MachineLearning-ComputeCluster-RemoteLoginPortPublicAccess`
- `Deny-MachineLearning-ComputeCluster-Scale`
- `Deny-MachineLearning-HbiWorkspace`
- `Deny-MachineLearning-PublicAccessWhenBehindVnet`
- `Deploy-VNET-HubSpoke`

### Management resources

An explicit dependency was added to ensure `azurerm_log_analytics_solution` resources have a dependency on `azurerm_log_analytics_linked_service` resources.
This increases reliability when running `terraform apply` or `terraform destroy`, preventing occurrences of errors similar to the following:

```shell
╷
│ Error: deleting Log Analytics Linked Service 'es-la/Automation' (Resource Group "es-mgmt"): operationalinsights.LinkedServicesClient#Delete: Failure sending request: StatusCode=0 -- Original Error: autorest/azure: Service returned an error. Status=<nil> Code="Conflict" Message="The link cannot be updated or deleted because it is linked to Update Management and/or ChangeTracking Solutions"
│ 
│ 
╵
```

### Connectivity resources

The Connectivity resources module has been updated to provide management for the `Deploy-Private-DNS-Zones` Policy Assignment.

The schema for `advanced` settings on `azurerm_private_dns_zone_virtual_network_link` resources has been updated to only allow setting `registration_enabled` on a single DNS zone.
This is to prevent the error:

```shell
Code="Conflict" Message="A virtual network can only be linked to 1 Private DNS zone(s) with auto-registration enabled; conflicting Private DNS zone is "..."
```

## Next steps

Take a look at the latest [User Guide](./User-Guide) documentation and our [Examples](./Examples) to understand the latest module configuration options, and review your implementation against the changes documented on this page.

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

[terraform-registry-caf-enterprise-scale]: https://registry.terraform.io/modules/Azure/caf-enterprise-scale/azurerm/latest "Terraform Registry: Terraform Module for Cloud Adoption Framework Enterprise-scale"
[azure/enterprise-scale]: https://github.com/Azure/Enterprise-Scale

[ESLZ-Management]:   https://docs.microsoft.com/azure/cloud-adoption-framework/ready/enterprise-scale/management-and-monitoring
[ESLZ-Connectivity]: https://docs.microsoft.com/azure/cloud-adoption-framework/ready/enterprise-scale/network-topology-and-connectivity
[ESLZ-Identity]:     https://docs.microsoft.com/azure/cloud-adoption-framework/ready/enterprise-scale/identity-and-access-management

[azurerm_management_group_policy_assignment]: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group_policy_assignment
[azurerm_policy_assignment]:                  https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_assignment

[wiki_provider_configuration]: ./%5BUser-Guide%5D-Provider-Configuration "Wiki - Provider Configuration"
