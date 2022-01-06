## Overview

As part of upgrade from release 0.1.2 to 0.2.0, the [Terraform Module for Cloud Adoption Framework Enterprise-scale][terraform-registry-caf-enterprise-scale] has updates to the included `Policy Definitions` and `Policy Set Definitions`.

This update helps to keep this module up to date with the latest reference architecture published in the [Azure/Enterprise-Scale][azure/enterprise-scale] repository.

## Required actions

Anyone using this module should be aware of the following when planning to upgrade from release 0.1.2 to 0.2.0:

1. A select number of policies and roles provided as part of this module will be redeployed. Please carefully review the output of `terraform plan` to ensure there are no issues with any custom configuration within your root module.
1. If you are using custom templates, you will need to verify references to policies defined within this module.
1. The following template types will need checking for references to policies as listed in the [resource changes](#resource-changes) section below:
   1. Archetype Definitions
   1. Policy Assignments
   1. Policy Set Definitions
1. This update adds new functionality to enable deployment of [Management and monitoring][ESLZ-Management] resources into the current Subscription context.

## Resource changes

The following changes have been made within the module which may cause issues when using custom archetype definitions:

- The `es_root` archetype definition has been updated to reflect the policy changes listed in the [resource changes](#resource-changes) section below.

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

The `Deploy-ASC-Defender` Policy Assignment has been updated to use the new `Deploy-ASC-Config` Policy Set Definition, replacing the original `Deploy-ASC-Standard` Policy Definition.
This Policy Assignment now has the following additional parameters:

- `emailSecurityContact` (required)
- `logAnalytics` (required)
- `pricingTierSqlServerVirtualMachines` (optional)

### Resource type: `azurerm_policy_definition`

| Policy Definition Name (v0.1.2) | Policy Definition Name (v0.2.0) | Notes     |
| :------------------------------ | :------------------------------ | :-------- |
| Deploy-ASC-Standard             |                                 | (removed) |
|                                 | Deploy-ASC-Defender-ACR         | (new)     |
|                                 | Deploy-ASC-Defender-AKS         | (new)     |
|                                 | Deploy-ASC-Defender-AKV         | (new)     |
|                                 | Deploy-ASC-Defender-AppSrv      | (new)     |
|                                 | Deploy-ASC-Defender-ARM         | (new)     |
|                                 | Deploy-ASC-Defender-DNS         | (new)     |
|                                 | Deploy-ASC-Defender-SA          | (new)     |
|                                 | Deploy-ASC-Defender-Sql         | (new)     |
|                                 | Deploy-ASC-Defender-SQLVM       | (new)     |
|                                 | Deploy-ASC-Defender-VMs         | (new)     |
|                                 | Deploy-ASC-SecurityContacts     | (new)     |
| Deploy-Diagnostics-PublicIP     |                                 | (removed) |

### Resource type: `azurerm_policy_set_definition`

| Policy Set Definition Name (v0.1.2) | Policy Set Definition Name (v0.2.0) | Notes |
| :---------------------------------- | :---------------------------------- | :---- |
|                                     | Deploy-ASC-Config                   | (new) |

## Next steps

> **IMPORTANT** If you are using custom archetype definitions, please ensure you update this to reflect the above changes.

Take a look at the latest [User Guide](./User-Guide) documentation and our [Examples](./Examples) to understand the latest module configuration options, and review your implementation against the changes documented on this page.

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"
[terraform-registry-caf-enterprise-scale]: https://registry.terraform.io/modules/Azure/caf-enterprise-scale/azurerm/latest "Terraform Registry: Terraform Module for Cloud Adoption Framework Enterprise-scale"
[azure/enterprise-scale]: https://github.com/Azure/Enterprise-Scale
[ESLZ-Management]: https://docs.microsoft.com/azure/cloud-adoption-framework/ready/enterprise-scale/management-and-monitoring
