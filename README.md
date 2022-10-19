# Azure landing zones Terraform module

[![Build Status](https://dev.azure.com/mscet/CAE-ALZ-Terraform/_apis/build/status/Tests/E2E?branchName=refs%2Ftags%2Fv2.4.1)](https://dev.azure.com/mscet/CAE-ALZ-Terraform/_build/latest?definitionId=26&branchName=refs%2Ftags%2Fv2.4.1)
![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/Azure/terraform-azurerm-caf-enterprise-scale?style=flat&logo=github)

Detailed information about how to use, configure and extend this module can be found on our Wiki:

- [Home][wiki_home]
- [User Guide][wiki_user_guide]
- [Examples][wiki_examples]
- [Frequently Asked Questions][wiki_frequently_asked_questions]
- [Troubleshooting][wiki_troubleshooting]
- [Contributing][wiki_contributing]

## Overview

The [Azure landing zones Terraform module][alz_tf_registry] is designed to accelerate deployment of platform resources based on the [Azure landing zones conceptual architecture][alz_architecture] using Terraform.

![A conceptual architecture diagram highlighting the design areas covered by the Azure landing zones Terraform module.][alz_tf_overview]

This is currently split logically into the following capabilities within the module (*links to further guidance on the Wiki*):

| Module capability | Scope | Design area |
| :--- | :--- | :--- |
| [Core Resources][wiki_core_resources] | Management group and subscription organization | [Resource organization][alz_hierarchy] |
| [Management Resources][wiki_management_resources] | Management subscription | [Management][alz_management] |
| [Connectivity Resources][wiki_connectivity_resources] | Connectivity subscription | [Network topology and connectivity][alz_connectivity] |
| [Identity Resources][wiki_identity_resources] | Identity subscription | [Identity and access management][alz_identity] |

Using a very [simple initial configuration](#maintf), the module will deploy a management group hierarchy based on the above diagram.
This includes the recommended governance baseline, applied using Azure Policy and Access control (IAM) resources deployed at the management group scope.
The default configuration can be easily extended to meet differing requirements, and includes the ability to deploy platform resources in the `management` and `connectivity` subscriptions.

> **NOTE:** In addition to setting input variables to control which resources are deployed, the module requires setting a [Provider Configuration][wiki_provider_configuration] block to enable deployment across multiple subscriptions.

Although resources are logically grouped to simplify operations, the modular design of the module also allows resources to be deployed using different Terraform workspaces.
This allows customers to address concerns around managing large state files, or assigning granular permissions to pipelines based on the principle of least privilege. (*more information coming soon in the Wiki*)

## Terraform versions

This module has been tested using Terraform `0.15.1` and AzureRM Provider `3.18.0` as a baseline, and various versions to up the latest at time of release.
In some cases, individual versions of the AzureRM provider may cause errors.
If this happens, we advise upgrading to the latest version and checking our [troubleshooting][wiki_troubleshooting] guide before [raising an issue](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues).

## Usage

We recommend starting with the following configuration in your root module to learn what resources are created by the module and how it works.

This will deploy the core components only.

> **NOTE:** For production use we highly recommend using the Terraform Registry and pinning to the latest stable version, as per the example below.
> Pinning to the `main` branch in GitHub will give you the latest updates quicker, but increases the likelihood of unplanned changes to your environment and unforeseen issues.

### `main.tf`

```hcl
# Configure Terraform to set the required AzureRM provider
# version and features{} block.

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.18.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Get the current client configuration from the AzureRM provider.
# This is used to populate the root_parent_id variable with the
# current Tenant ID used as the ID for the "Tenant Root Group"
# management group.

data "azurerm_client_config" "core" {}

# Use variables to customize the deployment

variable "root_id" {
  type    = string
  default = "es"
}

variable "root_name" {
  type    = string
  default = "Enterprise-Scale"
}

# Declare the Azure landing zones Terraform module
# and provide a base configuration.

module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "2.4.1"

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm
    azurerm.management   = azurerm
  }

  root_parent_id = data.azurerm_client_config.core.tenant_id
  root_id        = var.root_id
  root_name      = var.root_name

}
```

> **NOTE:** For additional guidance on how to customize your deployment using the advanced configuration options for this module, please refer to our [User Guide][wiki_user_guide] and the additional [examples][wiki_examples] in our documentation.

## Permissions

Please refer to our [Module Permissions][wiki_module_permissions] guide on the Wiki.

## Examples

The following list outlines some of our most popular examples:

- [Examples - Level 100][wiki_examples_level_100]
  - [Deploy Default Configuration][wiki_deploy_default_configuration]
  - [Deploy Demo Landing Zone Archetypes][wiki_deploy_demo_landing_zone_archetypes]
- [Examples - Level 200][wiki_examples_level_200]
  - [Deploy Custom Landing Zone Archetypes][wiki_deploy_custom_landing_zone_archetypes]
  - [Deploy Connectivity Resources][wiki_deploy_connectivity_resources]
  - [Deploy Identity Resources][wiki_deploy_identity_resources]
  - [Deploy Management Resources][wiki_deploy_management_resources]
  - [Assign a Built-in Policy][wiki_assign_a_built_in_policy]
- [Examples - Level 300][wiki_examples_level_300]
  - [Deploy Connectivity Resources With Custom Settings][wiki_deploy_connectivity_resources_custom]
  - [Deploy Identity Resources With Custom Settings][wiki_deploy_identity_resources_custom]
  - [Deploy Management Resources With Custom Settings][wiki_deploy_management_resources_custom]
  - [Expand Built-in Archetype Definitions][wiki_expand_built_in_archetype_definitions]
  - [Create Custom Policies, Policy Sets and Assignments][wiki_create_custom_policies_policy_sets_and_assignments]

For the complete list of our latest examples, please refer to our [Examples][wiki_examples] page on the Wiki.

## Release notes

Please see the [releases][repo_releases] page for the latest module updates.

## Upgrade guides

For upgrade guides from previous versions, please refer to the following links:

- [Upgrade from v1.1.4 to v2.0.0][wiki_upgrade_from_v1_1_4_to_v2_0_0]
- [Upgrade from v0.4.0 to v1.0.0][wiki_upgrade_from_v0_4_0_to_v1_0_0]
- [Upgrade from v0.3.3 to v0.4.0][wiki_upgrade_from_v0_3_3_to_v0_4_0]
- [Upgrade from v0.1.2 to v0.2.0][wiki_upgrade_from_v0_1_2_to_v0_2_0]
- [Upgrade from v0.0.8 to v0.1.0][wiki_upgrade_from_v0_0_8_to_v0_1_0]

## Telemetry

> **NOTE:** The following statement is applicable from release v2.0.0 onwards

When you deploy one or more modules using the Azure landing zones Terraform module, Microsoft can identify the installation of said module/s with the deployed Azure resources.
Microsoft can correlate these resources used to support the software.
Microsoft collects this information to provide the best experiences with their products and to operate their business.
The telemetry is collected through customer usage attribution.
The data is collected and governed by [Microsoft's privacy policies][msft_privacy_policy].

If you don't wish to send usage data to Microsoft, details on how to turn it off can be found [here][wiki_disable_telemetry].

## License

- [MIT License][alz_license]

## Contributing

- [Contributing][wiki_contributing]
  - [Raising an Issue][wiki_raising_an_issue]
  - [Feature Requests][wiki_feature_requests]
  - [Contributing to Code][wiki_contributing_to_code]
  - [Contributing to Documentation][wiki_contributing_to_documentation]

 [//]: # (*****************************)
 [//]: # (INSERT IMAGE REFERENCES BELOW)
 [//]: # (*****************************)

[alz_tf_overview]: https://raw.githubusercontent.com/wiki/Azure/terraform-azurerm-caf-enterprise-scale/media/alz-tf-module-overview.png "A conceptual architecture diagram highlighting the design areas covered by the Azure landing zones Terraform module."

 [//]: # (************************)
 [//]: # (INSERT LINK LABELS BELOW)
 [//]: # (************************)

[msft_privacy_policy]: https://www.microsoft.com/trustcenter  "Microsoft's privacy policy"

[alz_tf_registry]:  https://registry.terraform.io/modules/Azure/caf-enterprise-scale/azurerm/latest "Terraform Registry: Azure landing zones Terraform module"
[alz_architecture]: https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone#azure-landing-zone-conceptual-architecture
[alz_hierarchy]:    https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org
[alz_management]:   https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/management
[alz_connectivity]: https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/network-topology-and-connectivity
[alz_identity]:     https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access
[alz_license]:      https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/blob/main/LICENSE
[repo_releases]:    https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/releases "Release notes"

<!--
The following link references should be copied from `_sidebar.md` in the `./docs/wiki/` folder.
Replace `./` with `https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/` when copying to here.
-->

[wiki_home]:                                  https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/Home "Wiki - Home"
[wiki_user_guide]:                            https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/User-Guide "Wiki - User Guide"
[wiki_getting_started]:                       https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Getting-Started "Wiki - Getting Started"
[wiki_module_permissions]:                    https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Module-Permissions "Wiki - Module Permissions"
[wiki_module_variables]:                      https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Module-Variables "Wiki - Module Variables"
[wiki_module_releases]:                       https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Module-Releases "Wiki - Module Releases"
[wiki_provider_configuration]:                https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Provider-Configuration "Wiki - Provider Configuration"
[wiki_archetype_definitions]:                 https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Archetype-Definitions "Wiki - Archetype Definitions"
[wiki_core_resources]:                        https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Core-Resources "Wiki - Core Resources"
[wiki_management_resources]:                  https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Management-Resources "Wiki - Management Resources"
[wiki_connectivity_resources]:                https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Connectivity-Resources "Wiki - Connectivity Resources"
[wiki_identity_resources]:                    https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Identity-Resources "Wiki - Identity Resources"
[wiki_upgrade_from_v0_0_8_to_v0_1_0]:         https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Upgrade-from-v0.0.8-to-v0.1.0 "Wiki - Upgrade from v0.0.8 to v0.1.0"
[wiki_upgrade_from_v0_1_2_to_v0_2_0]:         https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Upgrade-from-v0.1.2-to-v0.2.0 "Wiki - Upgrade from v0.1.2 to v0.2.0"
[wiki_upgrade_from_v0_3_3_to_v0_4_0]:         https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Upgrade-from-v0.3.3-to-v0.4.0 "Wiki - Upgrade from v0.3.3 to v0.4.0"
[wiki_upgrade_from_v0_4_0_to_v1_0_0]:         https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Upgrade-from-v0.4.0-to-v1.0.0 "Wiki - Upgrade from v0.4.0 to v1.0.0"
[wiki_upgrade_from_v1_1_4_to_v2_0_0]:         https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Upgrade-from-v1.1.4-to-v2.0.0 "Wiki - Upgrade from v1.1.4 to v2.0.0"
[wiki_examples]:                              https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/Examples "Wiki - Examples"
[wiki_examples_level_100]:                    https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/Examples#advanced-level-100 "Wiki - Examples"
[wiki_examples_level_200]:                    https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/Examples#advanced-level-200 "Wiki - Examples"
[wiki_examples_level_300]:                    https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/Examples#advanced-level-300 "Wiki - Examples"
[wiki_deploy_default_configuration]:          https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Default-Configuration "Wiki - Deploy Default Configuration"
[wiki_deploy_demo_landing_zone_archetypes]:   https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Demo-Landing-Zone-Archetypes "Wiki - Deploy Demo Landing Zone Archetypes"
[wiki_deploy_custom_landing_zone_archetypes]: https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Custom-Landing-Zone-Archetypes "Wiki - Deploy Custom Landing Zone Archetypes"
[wiki_deploy_management_resources]:           https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Management-Resources "Wiki - Deploy Management Resources"
[wiki_deploy_management_resources_custom]:    https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Management-Resources-With-Custom-Settings "Wiki - Deploy Management Resources With Custom Settings"
[wiki_deploy_connectivity_resources]:         https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Connectivity-Resources "Wiki - Deploy Connectivity Resources"
[wiki_deploy_connectivity_resources_custom]:  https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Connectivity-Resources-With-Custom-Settings "Wiki - Deploy Connectivity Resources With Custom Settings"
[wiki_deploy_identity_resources]:             https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Identity-Resources "Wiki - Deploy Identity Resources"
[wiki_deploy_identity_resources_custom]:      https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Identity-Resources-With-Custom-Settings "Wiki - Deploy Identity Resources With Custom Settings"
[wiki_deploy_using_module_nesting]:           https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Using-Module-Nesting "Wiki - Deploy Using Module Nesting"
[wiki_frequently_asked_questions]:            https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/Frequently-Asked-Questions "Wiki - Frequently Asked Questions"
[wiki_troubleshooting]:                       https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/Troubleshooting "Wiki - Troubleshooting"
[wiki_contributing]:                          https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/Contributing "Wiki - Contributing"
[wiki_raising_an_issue]:                      https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/Raising-an-Issue "Wiki - Raising an Issue"
[wiki_feature_requests]:                      https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/Feature-Requests "Wiki - Feature Requests"
[wiki_contributing_to_code]:                  https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/Contributing-to-Code "Wiki - Contributing to Code"
[wiki_contributing_to_documentation]:         https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/Contributing-to-Documentation "Wiki - Contributing to Documentation"
[wiki_expand_built_in_archetype_definitions]: https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Expand-Built-in-Archetype-Definitions "Wiki - Expand Built-in Archetype Definitions"
[wiki_override_module_role_assignments]:      https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Override-Module-Role-Assignments "Wiki - Override Module Role Assignments"
[wiki_create_custom_policies_policy_sets_and_assignments]: https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Create-Custom-Policies-Policy-Sets-and-Assignments "Wiki - Create Custom Policies, Policy Sets and Assignments"
[wiki_assign_a_built_in_policy]: https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Assign-a-Built-in-Policy "Wiki - Assign a Built-in Policy"
[wiki_disable_telemetry]:                     https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BVariables%5D-disable_telemetry "Wiki - Disable telemetry"
[wiki_create_and_assign_custom_rbac_roles]:                     https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BVariables%5D-Create-and-Assign-Custom-RBAC-Roles "Wiki - Create and Assign Custom RBAC Roles"
