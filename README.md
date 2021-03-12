# Terraform Module for Cloud Adoption Framework Enterprise-scale

<br>

> :warning: **WARNING**: Please note that the latest `0.1.0` release contains a number of changes which may impact your deployment.
> Please review the [Upgrade from v0.0.8 to v0.1.0][wiki_upgrade_from_v0_0_8_to_v0_1_0] guidance before upgrading.

<br>

[![Build Status](https://dev.azure.com/mscet/CAE-ESTF/_apis/build/status/Tests/E2E?branchName=main)](https://dev.azure.com/mscet/CAE-ESTF/_build/latest?definitionId=26&branchName=main)

## Documentation

For detailed information about how to use, configure and extend this module, please refer to the documentation on our Wiki:

- [Home][wiki_home]
- [User Guide][wiki_user_guide]
  - [Getting Started][wiki_getting_started]
  - [Module Variables][wiki_module_variables]
  - [Archetype Definitions][wiki_archetype_definitions]
  - [Upgrade from v0.0.8 to v0.1.0][wiki_upgrade_from_v0_0_8_to_v0_1_0]
- [Examples][wiki_examples]
  - [Deploy Default Configuration][wiki_deploy_default_configuration]
  - [Deploy Demo Landing Zone Archetypes][wiki_deploy_demo_landing_zone_archetypes]
  - [Deploy Custom Landing Zone Archetypes][wiki_deploy_custom_landing_zone_archetypes]
- [Frequently Asked Questions][wiki_frequently_asked_questions]
- [Troubleshooting][wiki_troubleshooting]
- [Contributing][wiki_contributing]
  - [Raising an Issue][wiki_raising_an_issue]
  - [Feature Requests][wiki_feature_requests]
  - [Contributing to Code][wiki_contributing_to_code]
  - [Contributing to Documentation][wiki_contributing_to_documentation]

## Overview

The [Terraform Module for Cloud Adoption Framework Enterprise-scale][terraform-registry-caf-enterprise-scale] provides an opinionated approach for delivering the core platform capabilities needed to start building Azure landing zones using Terraform.
This module deploys the foundations of the [Cloud Adoption Framework enterprise-scale landing zone architecture][ESLZ-Architecture], with a focus on the central resource hierarchy and governance:

![Enterprise-scale Landing Zone Architecture][TFAES-Overview]

## Resources

The following resource types are deployed and managed by this module:

|     | Azure Resource | Terraform Resource |
| --- | -------------- | ------------------ |
| Management Groups | [`Microsoft.Management/managementGroups`][arm_management_group] | [`azurerm_management_group`][azurerm_management_group] |
| Management Group Subscriptions | [`Microsoft.Management/managementGroups/subscriptions`][arm_management_group_subscriptions] | [`azurerm_management_group`][azurerm_management_group] |
| Policy Assignments | [`Microsoft.Authorization/policyAssignments`][arm_policy_assignment] | [`azurerm_policy_assignment`][azurerm_policy_assignment] |
| Policy Definitions | [`Microsoft.Authorization/policyDefinitions`][arm_policy_definition] | [`azurerm_policy_definition`][azurerm_policy_definition] |
| Policy Set Definitions | [`Microsoft.Authorization/policySetDefinitions`][arm_policy_set_definition] | [`azurerm_policy_set_definition`][azurerm_policy_set_definition] |
| Role Assignments | [`Microsoft.Authorization/roleAssignments`][arm_role_assignment] | [`azurerm_role_assignment`][azurerm_role_assignment] |
| Role Definitions | [`Microsoft.Authorization/roleDefinitions`][arm_role_definition] | [`azurerm_role_definition`][azurerm_role_definition] |

The exact number of resources created depends on the module configuration, but you can expect upwards of `100` resources to be created by this module for a default installation based on the example below.

## Terraform versions

This module has been tested using Terraform `0.13.2` onwards.
It is also tested against the AzureRM Provider `2.34.0` onwards. In some cases, individual versions of the AzureRM provider may cause errors.
If this happens, we advise upgrading to the latest version and checking our [troubleshooting][wiki_troubleshooting] guide before [raising an issue](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues).

This module has some known issues with the pre-release Terraform `0.15.x` versions which we plan to resolve in a future release.

## Usage

As a basic starting point, we recommend starting with the following configuration in your root module.

> :memo: For production use we highly recommend using the Terraform Registry and pinning to the latest stable version, as per the example below.
> Pinning to the `main` branch in GitHub will give you the latest updates quicker, but increases the likelihood of unplanned changes to your environment and unforeseen issues.

**File: `main.tf`**

```hcl
# Configure Terraform to set the required AzureRM provider
# version and features{} block.

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.34.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Get the current client configuration from the AzureRM provider.
# This is used to populate the root_parent_id variable with the
# current Tenant ID used as the ID for the "Tenant Root Group"
# Management Group.

data "azurerm_client_config" "current" {}

# Use variables to customise the deployment

variable "root_id" {
  type    = string
  default = "es"
}

variable "root_name" {
  type    = string
  default = "Enterprise-Scale"
}

# Declare the Terraform Module for Cloud Adoption Framework
# Enterprise-scale and provide a base configuration.

module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "0.1.0"

  root_parent_id = data.azurerm_client_config.current.tenant_id
  root_id        = var.root_id
  root_name      = var.root_name

}
```

> For additional guidance on how to customise your deployment using the advanced configuration options for this module, please refer to our [User Guide][wiki_user_guide] and the additional [examples][wiki_examples] in our documentation.

## License

[MIT License][TFAES-LICENSE]

## Contributing

[Contributing Guide][TFAES-CONTRIBUTING]


 [//]: # (*****************************)
 [//]: # (INSERT IMAGE REFERENCES BELOW)
 [//]: # (*****************************)

[TFAES-Overview]: https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/media/terraform-caf-enterprise-scale-overview.png "Diagram showing the Cloud Adoption Framework Enterprise-scale Landing Zone architecture deployed by this module."

 [//]: # (************************)
 [//]: # (INSERT LINK LABELS BELOW)
 [//]: # (************************)

[terraform-registry-caf-enterprise-scale]: https://registry.terraform.io/modules/Azure/caf-enterprise-scale/azurerm/latest "Terraform Registry: Terraform Module for Cloud Adoption Framework Enterprise-scale"
[ESLZ-Architecture]: https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/enterprise-scale/architecture

[arm_management_group]:               https://docs.microsoft.com/en-us/azure/templates/microsoft.management/managementgroups
[arm_management_group_subscriptions]: https://docs.microsoft.com/en-us/azure/templates/microsoft.management/managementgroups/subscriptions
[arm_policy_assignment]:              https://docs.microsoft.com/en-us/azure/templates/microsoft.authorization/policyassignments
[arm_policy_definition]:              https://docs.microsoft.com/en-us/azure/templates/microsoft.authorization/policydefinitions
[arm_policy_set_definition]:          https://docs.microsoft.com/en-us/azure/templates/microsoft.authorization/policysetdefinitions
[arm_role_assignment]:                https://docs.microsoft.com/en-us/azure/templates/microsoft.authorization/roleassignments
[arm_role_definition]:                https://docs.microsoft.com/en-us/azure/templates/microsoft.authorization/roledefinitions

[azurerm_management_group]:      https://www.terraform.io/docs/providers/azurerm/r/management_group.html
[azurerm_policy_assignment]:     https://www.terraform.io/docs/providers/azurerm/r/policy_assignment.html
[azurerm_policy_definition]:     https://www.terraform.io/docs/providers/azurerm/r/policy_definition.html
[azurerm_policy_set_definition]: https://www.terraform.io/docs/providers/azurerm/r/policy_set_definition.html
[azurerm_role_assignment]:       https://www.terraform.io/docs/providers/azurerm/r/role_assignment.html
[azurerm_role_definition]:       https://www.terraform.io/docs/providers/azurerm/r/role_definition.html

[TFAES-LICENSE]: https://github.com/Azure/terraform-azurerm-enterprise-scale/blob/main/LICENSE
[TFAES-CONTRIBUTING]: https://github.com/Azure/terraform-azurerm-enterprise-scale/blob/main/CONTRIBUTING
[TFAES-Library]: https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/tree/main/modules/terraform-azurerm-caf-enterprise-scale-archetypes/lib

[wiki_home]: https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/Home "Wiki - Home"
[wiki_user_guide]: https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/User-Guide "Wiki - User Guide"
[wiki_getting_started]: https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Getting-Started "Wiki - Getting Started"
[wiki_module_variables]: https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Module-Variables "Wiki - Module Variables"
[wiki_archetype_definitions]: https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Archetype-Definitions "Wiki - Archetype Definitions"
[wiki_upgrade_from_v0_0_8_to_v0_1_0]: https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Upgrade-from-v0.0.8-to-v0.1.0 "Wiki - Upgrade from v0.0.8 to v0.1.0"
[wiki_examples]: https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/Examples "Wiki - Examples"
[wiki_deploy_default_configuration]: https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Default-Configuration "Wiki - Deploy Default Configuration"
[wiki_deploy_demo_landing_zone_archetypes]: https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Demo-Landing-Zone-Archetypes "Wiki - Deploy Demo Landing Zone Archetypes"
[wiki_deploy_custom_landing_zone_archetypes]: https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Custom-Landing-Zone-Archetypes "Wiki - Deploy Custom Landing Zone Archetypes"
[wiki_frequently_asked_questions]: https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/Frequently-Asked-Questions "Wiki - Frequently Asked Questions"
[wiki_troubleshooting]: https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/Troubleshooting "Wiki - Troubleshooting"
[wiki_contributing]: https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/Contributing "Wiki - Contributing"
[wiki_raising_an_issue]: https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/Raising-an-Issue "Wiki - Raising an Issue"
[wiki_feature_requests]: https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/Feature-Requests "Wiki - Feature Requests"
[wiki_contributing_to_code]: https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/Contributing-to-Code "Wiki - Contributing to Code"
[wiki_contributing_to_documentation]: https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/Contributing-to-Documentation "Wiki - Contributing to Documentation"