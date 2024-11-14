<!-- markdownlint-disable first-line-h1 -->
## Overview

> **IMPORTANT:** The [management resources](#management-resources) section of this upgrade guide has been updated to reflect changes made in release `v2.1.0`.
> Please carefully check the version you are upgrading to when updating these settings.

The `v2.0.0` release marks another significant milestone in development of the [Azure landing zones Terraform module][terraform-registry-caf-enterprise-scale] (_formerly [Terraform Module for Cloud Adoption Framework Enterprise-scale][terraform-registry-caf-enterprise-scale]_).
The re-branding of this module reflects adoption of `Enterprise-scale` as the recommended architecture for building an `Azure landing zone`.

This release provides the ability to deploy and configure `Virtual WAN` resources as part of the `connectivity` capability of the module.
We have also included a number of fixes for other issues, and extended the existing `connectivity` capabilities for customers creating `Hub and Spoke` networks.

### New features

- Added support to create hub networks using Azure `Virtual WAN` in the connectivity Subscription
- Updated the policies included within the module based on those in the upstream Azure/Enterprise-Scale repository
- Improved Wiki documentation, providing more examples and clearer guidance
- Added module telemetry to help us better understand where to focus development efforts and improve customer experience
- Update branding from `Enterprise-scale` to `Azure landing zones` (further work required to complete this transition)
- Added `Azure Firewall Policy` resources to enable the `DNS Proxy` settings for `Azure Firewall` and simplify the configuration experience
- Extended configuration options for the `Virtual Network Gateway` resources used for `hub and spoke` networks
- The `threat_intel_mode` value for `azurerm_firewall` resources is now explicitly set with a default value of `Alert` to support the latest provider versions. This matches the previous "default" value of the old provider.
- Added new variable `asc_export_resource_group_name` to fix #342
- Added logic to automatically configure the `generation` value for VPN gateways without using the `advanced` object to fix #333
- Added input variables and logic to simplify configuring active-active mode for VPN gateways without using the `advanced` object to fix #232
- Added logic to suppress creation of Public IP resource(s) when a custom `ip_configuration` input is specified via the `advanced` block for the following resource types:
  - `azurerm_virtual_network_gateway` (ExpressRoute and VPN)
  - `azurerm_firewall`
- Added input variables for BGP configuration settings without using the `advanced` object to fix #334
- Added missing `vpn_auth_types` attribute for the `vpn_client_configuration` block on Virtual Network Gateway resources
- Updated Wiki docs to reflect the included changes where covered in documentation
- Updated test framework to provide coverage of the included fixes
- Updated test strategy to ensure working versions are included from `v0.15.1` (new minimum required to fix `Error: Output refers to sensitive values`) to latest `v1.1.x`

### Fixed issues

- Fix [#226](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/226) (Add capability for "Virtual WAN Networking" resources - Connectivity Subscription)
- Fix [#232](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/232) (can't create active-active vpngw)
- Fix [#254](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/254) (Create Wiki docs page for custom policy definition, set definition (initiative) and assignment)
- Fix [#264](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/264) (Update Policies For `v1.2.0` Release From Upstream)
- Fix [#266](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/266) (Adding a new policy assignment forces the existing policy role assignments to be recreated)
- Fix [#271](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/271) (Error: deleting Azure Firewall)
- Fix [#272](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/272) (Argument `management_group_name` deprecated in favour of `management_group_id`)
- Fix [#273](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/273) (`azurerm_role_assignment.policy_assignment` resources outputs missing)
- Fix [#274](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/274) (Add Firewall Policy resources for the Azure Firewall resources deployed by the module)
- Fix [#293](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/293) (Move FabricBot to Config-as-Code)
- Fix [#295](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/295) (Missing data policies)
- Fix [#305](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/305) (Add vwan settings to outputs)
- Fix [#309](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/309) (Bug Report - AzureRM provider 3.0.0 availability zones error)
- Fix [#319](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/319) (`azurerm_public_ip` prevents support of azurerm provider >= 3.0.0)
- Fix [#333](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/333) (VPN Gateway Generations)
- Fix [#334](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/334) (BGP configuration on VPN gateways)
- Fix [#336](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/336) (Feature Request - Add AZ Support for Azure Firewall in Secure vHub Model)
- Fix [#340](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/340) (Call to function "coalesce" failed: all arguments must have the same type.)
- Fix [#342](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/342) (Ability to rename ASC export resource group name)
- Work towards [#227](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/227) (Replace `try()` with `lookup()` where possible)

### Breaking changes

- :warning: Updated the minimum supported Terraform version to `0.15.1`
- :warning: Updated the minimum supported `azurerm` provider version to `3.0.2`
- :warning: Updated the required attributes for the `configure_management_resources` input variable to reflect recent policy updates for Microsoft Defender for Cloud
- :warning: Extended the required attributes for the `configure_connectivity_resources` input variable to enable new functionality

  > This will result in an error at `plan` until users update the input for `configure_connectivity_resources`.
  > Longer term objective is to reduce the number of mandatory attributes within the schema using the `optional()` type wrapper once released as GA.

- :warning: Updated preference to `Generation2` for supported VPN gateway SKUs, so some customers may have their VPN gateway redeployed to the new version. Instructions for how to override this added below.

> **IMPORTANT:** If you are using the `advanced` input for `configure_connectivity_resources` please take extra care to note the changes listed in [PR: Fix multiple issues #345](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/pull/345).
> A summary of these can be found below in the [Advanced configuration](#rocket-advanced-configuration) section.

## Required actions

Anyone using this module should be aware of the following when planning to upgrade from release `v1.1.4` to `v2.0.0`:

1. Please review the updates listed above, especially in regard to the [**Breaking changes**](#breaking-changes).

1. A select number of policies provided as part of this module have changed.
Please carefully review [Resource changes](#resource-changes) provided below and the output of `terraform plan` to ensure there are no issues with any custom configuration within your root module.

1. If you are using a custom library, the following library template types will need checking for references to updated policies as listed in the [resource changes](#resource-changes) section below:
    1. Archetype Definitions
    1. Policy Definitions
    1. Policy Set Definitions
    1. Policy Assignments

1. Before making changes to your configuration, we recommend to update the module version and run `terraform init -upgrade` followed by `terraform plan` to see what changes are needed in the code.
Fix any errors before reviewing the plan output to see whether any unexpected resource changes are going to happen.
Review the additional guidance below to better understand what is likely to need changing, and please don't hesitate to log a [GitHub Issue](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues) if you're unclear on any of the required steps.

> **IMPORTANT:** As with any Terraform upgrade, please carefully review the output of `terraform plan` to ensure there are no issues with any custom configuration within your root module or unexpected changes to your environment before applying.

## Resource changes

The following changes have been made within the module which should be reviewed carefully before running `terraform apply`:

### Resource type: `azurerm_policy_definition`

Terraform plan will identify a number of "_Objects have changed outside of Terraform_" due to changes in the latest provider versions.
This will result in multiple messages similar to the following for the `azurerm_policy_definition` resources:

```shell
  # module.enterprise_scale.azurerm_policy_definition.enterprise_scale["/providers/Microsoft.Management/managementGroups/myorg/providers/Microsoft.Authorization/policyDefinitions/Append-AppService-httpsonly"] has changed
  ~ resource "azurerm_policy_definition" "enterprise_scale" {
        id                  = "/providers/Microsoft.Management/managementGroups/myorg/providers/Microsoft.Authorization/policyDefinitions/Append-AppService-httpsonly"
      ~ management_group_id = "myorg" -> "/providers/Microsoft.Management/managementGroups/myorg"
        name                = "Append-AppService-httpsonly"
        # (7 unchanged attributes hidden)
    }
```

No action should be required regarding the above.

- The following Policy Definition changes have been included in the `es_root` archetype definition:
  - `Deny-Subnet-Without-Nsg` updated
  - `Deny-Subnet-Without-Udr` updated
  - `Deny-VNET-Peering-To-Non-Approved-VNETs` added

These will result in a change to the resources deployed by the module.

### Resource type: `azurerm_policy_set_definition`

Terraform plan will identify a number of "_Objects have changed outside of Terraform_" due to changes in the latest provider versions.
This will result in multiple messages similar to the following for the `azurerm_policy_set_definition` resources:

```shell
  # module.enterprise_scale.azurerm_policy_set_definition.enterprise_scale["/providers/Microsoft.Management/managementGroups/myorg/providers/Microsoft.Authorization/policySetDefinitions/Deny-PublicPaaSEndpoints"] has changed
  ~ resource "azurerm_policy_set_definition" "enterprise_scale" {
        id                  = "/providers/Microsoft.Management/managementGroups/myorg/providers/Microsoft.Authorization/policySetDefinitions/Deny-PublicPaaSEndpoints"
      ~ management_group_id = "myorg" -> "/providers/Microsoft.Management/managementGroups/myorg"
        name                = "Deny-PublicPaaSEndpoints"
        # (5 unchanged attributes hidden)

        # (10 unchanged blocks hidden)
    }
```

No action should be required regarding the above.

- The following Policy Set Definition changes have been included in the `es_root` archetype definition:
  - `Deploy-ASCDF-Config` replaced by `Deploy-MDFC-Config`

These will result in a change to the resources deployed by the module.

### Resource type: `azurerm_policy_assignment`

- The following Policy Assignment changes have been included in the `es_corp` archetype definition:
  - `Deny-DataB-Pip` added
  - `Deny-DataB-Sku` added
  - `Deny-DataB-Vnet` added

- The following Policy Assignment changes have been included in the `v` archetype definition:
  - `Deploy-ASCDF-Config` replaced by `Deploy-MDFC-Config`

These will result in a change to the resources deployed by the module.

### Resource type: `azurerm_role_definition`

- The following Role Definition changes have been included in the `es_root` archetype definition:
  - `Application-Owners` added
  - `Network-Management` added
  - `Security-Operations` added
  - `Subscription-Owner` added

### Resource type: `azurerm_role_assignment`

To address issue #266 (Adding a new policy assignment forces the existing policy role assignments to be recreated), the associated Role Assignments have been moved into a child module.

This will result in all `azurerm_role_assignment` to be recreated for Policy Assignments with a Managed Identity.

This isn't expected to have an impact on customers, but should be noted during the upgrade process.

### Management resources

To reflect the latest changes to policy for Microsoft Defender for Cloud (formerly Azure Security Center), we have had to update the `configure_management_resources` input object.

If you have set custom values for `configure_management_resources`, please update your code to reflect these changes.

The `settings.security_center.config.enable_defender_for_acr` and `settings.security_center.config.enable_defender_for_kubernetes` attributes have been removed, and are instead controlled by a single input for `settings.security_center.config.enable_defender_for_containers`.

If upgrading directly to `v2.1.0` onwards, please update your code with the following additional inputs:

- [settings.log_analytics.config.enable_solution_for_sql_vulnerability_assessment](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BVariables%5D-configure_management_resources#settingslog_analyticsenable_solution_for_sql_vulnerability_assessment)
- [settings.log_analytics.config.enable_solution_for_sql_advanced_threat_detection](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BVariables%5D-configure_management_resources#settingslog_analyticsenable_solution_for_sql_advanced_threat_detection)

All management resources which support tags will have the default tags updated unless these have been overridden within a custom configuration.
This will result in multiple resources detecting an `~ update in-place` action similar to the following:

```shell
  # module.enterprise_scale.azurerm_log_analytics_workspace.management["/subscriptions/23b6acec-2ae4-4b66-9f1f-120647cffe55/resourceGroups/myorg-mgmt/providers/Microsoft.OperationalInsights/workspaces/myorg-la"] will be updated in-place
  ~ resource "azurerm_log_analytics_workspace" "management" {
        id                         = "/subscriptions/23b6acec-2ae4-4b66-9f1f-120647cffe55/resourceGroups/myorg-mgmt/providers/Microsoft.OperationalInsights/workspaces/myorg-la"
        name                       = "myorg-la"
      ~ tags                       = {
          ~ "deployedBy" = "terraform/azure/caf-enterprise-scale/v1.1.4" -> "terraform/azure/caf-enterprise-scale/v2.0.0"
        }
        # (10 unchanged attributes hidden)
    }
```

No action should be required regarding the above.

### Connectivity resources

The big change is we've now enabled deployment of `Virtual WAN` hub networks.
This will have no impact on existing deployments, but to use this feature you will need to configure the existing `configure_connectivity_resources. settings.vwan_hub_networks` input which is now activated.

> More details on how to deploy and configure `Virtual WAN` hub networks will be added to the Wiki soon!
> **NOTE:** that we still only support creation of the hub network and not spokes due to provider limitations, however bi-directional peering can be created for `Virtual WAN` networks.

The `configure_connectivity_resources` input variable has been updated to improve ease of use when configuring VPN gateway and Azure Firewall settings in a `Hub and Spoke` network.

If you have set a custom value for `configure_connectivity_resources`, please review the additional details below and update your code to reflect the updated input variable schema.

To provide greater flexibility when configuring VPN gateways, a new `advanced_vpn_settings` object has been added under `settings.hub_networks[].config.virtual_network_gateway.config`.
This addition allows more VPN gateway settings to be configured through the module.

The following `advanced_vpn_settings` value will result in no configuration changes for customers who are already using module defaults:

```terraform
advanced_vpn_settings = {
  enable_bgp                       = null
  active_active                    = null
  private_ip_address_allocation    = ""
  default_local_network_gateway_id = ""
  vpn_client_configuration         = []
  bgp_settings                     = []
  custom_route                     = []
}
```

To provide greater flexibility when configuring the Azure Firewalls, the module now deploys a Firewall Policy for each Azure Firewall created by the module.
This addition activates the existing `enable_dns_proxy` setting, but also allows a number of other settings to be configured through the module.

The following attributes have been added under `settings.hub_networks[].config.azure_firewall.config`

- `dns_servers`
- `sku_tier`
- `base_policy_id`
- `private_ip_ranges`
- `threat_intelligence_mode`
- `threat_intelligence_allowlist`

The following values will result in no configuration changes for customers who are already using module defaults:

```terraform
dns_servers                   = []
sku_tier                      = ""
base_policy_id                = ""
private_ip_ranges             = []
threat_intelligence_mode      = ""
threat_intelligence_allowlist = {}
```

> **IMPORTANT:** If you have updated any connectivity resource settings using the `advanced` configuration object, you will need to update your code to move your settings into this input and ensure you are using the updated naming schema.

To provide better support across the range of available SKUs (by generation) for VPN gateways in a `Hub and Spoke` network, the module now automatically sets the `generation` attribute based on specified SKU.
To keep in line with recommendations from the product teams, the module will default to `Generation2` where supported by the SKU.
Customers who have already deployed a VPN gateway using a `Generation1` gateway will either need to redeploy the VPN gateway resource, or set the `generation` manually using the following advanced configuration:

```hcl
configure_connectivity_resources = {
  # Additional attributes redacted
  advanced = {
    custom_settings_by_resource_type = {
      azurerm_virtual_network_gateway = {
        connectivity_vpn = {
          (var.location) = {
            generation = "Generation1"
          }
        }
      }
    }
  }
}
```

### Telemetry resources

This release includes additional resources relating to telemetry.
For more information, please refer to the [Telemetry](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/blob/main/README.md#telemetry) guidance for more information.

### :rocket: Advanced configuration

Although not documented, we are aware that a number of customers have already worked out how to use the `advanced` configuration blocks within `configure_connectivity_resources` and `configure_management_resources`

:warning: This release brings a number of breaking changes to this functionality which must be carefully reviewed when upgrading from the previous release.

The following table outlines the changes which must be considered.
These are all within the scope of `configure_connectivity_resources.advanced.custom_settings_by_resource_type` (_which will be excluded from the attribute path for brevity_).

> These changes only effect `hub_networks` resources.

#### ExpressRoute Gateway resources

| `v1.1.4` advanced object path | `v2.0.0` advanced object path |
| :--- | :--- |
| `azurerm_virtual_network_gateway["expressroute"][location].name` | `azurerm_virtual_network_gateway["connectivity_expressroute"][location].name` |
| `azurerm_virtual_network_gateway["connectivity"]["ergw"][location].ip_configuration` | `azurerm_virtual_network_gateway["connectivity_expressroute"][location].ip_configuration` |
| `azurerm_virtual_network_gateway["connectivity"]["ergw"][location].vpn_type` | _removed as not applicable to ExpressRoute SKUs_ |
| `azurerm_virtual_network_gateway["connectivity"]["ergw"][location].enable_bgp` | _removed as not applicable to ExpressRoute SKUs_ |
| `azurerm_virtual_network_gateway["connectivity"]["ergw"][location].active_active` | _removed as not applicable to ExpressRoute SKUs_ |
| `azurerm_virtual_network_gateway["connectivity"]["ergw"][location].private_ip_address_enabled` | _removed as not applicable to ExpressRoute SKUs_ |
| `azurerm_virtual_network_gateway["connectivity"]["ergw"][location].default_local_network_gateway_id` | _removed as not applicable to ExpressRoute SKUs_ |
| `azurerm_virtual_network_gateway["connectivity"]["ergw"][location].generation` | _removed as not applicable to ExpressRoute SKUs_ |
| `azurerm_virtual_network_gateway["connectivity"]["ergw"][location].vpn_client_configuration` | _removed as not applicable to ExpressRoute SKUs_ |
| `azurerm_virtual_network_gateway["connectivity"]["ergw"][location].bgp_settings` | _removed as not applicable to ExpressRoute SKUs_ |
| `azurerm_virtual_network_gateway["connectivity"]["ergw"][location].custom_route` | _removed as not applicable to ExpressRoute SKUs_ |
| `azurerm_virtual_network_gateway["connectivity"]["ergw"][location].tags` | `azurerm_virtual_network_gateway["connectivity_expressroute"][location].tags` |
| `azurerm_public_ip["connectivity"]["ergw"][location].*` | `azurerm_public_ip["connectivity_expressroute"][location].*` |

#### VPN Gateway resources

| `v1.1.4` advanced object path | `v2.0.0` advanced object path |
| :--- | :--- |
| `azurerm_virtual_network_gateway["vpn"][location].name` | `azurerm_virtual_network_gateway["connectivity_vpn"][location].name` |
| `azurerm_virtual_network_gateway["connectivity"]["vpngw"][location].ip_configuration` | `azurerm_virtual_network_gateway["connectivity_vpn"][location].ip_configuration` |
| `azurerm_virtual_network_gateway["connectivity"]["vpngw"][location].vpn_type` | `azurerm_virtual_network_gateway["connectivity_vpn"][location].vpn_type` |
| `azurerm_virtual_network_gateway["connectivity"]["vpngw"][location].enable_bgp` | _moved to new_ `advanced_vpn_settings` _object_ |
| `azurerm_virtual_network_gateway["connectivity"]["vpngw"][location].active_active` | _moved to new_ `advanced_vpn_settings` _object_ |
| `azurerm_virtual_network_gateway["connectivity"]["vpngw"][location].private_ip_address_enabled` | _determined by_ `private_ip_address_allocation` _setting in new_ `advanced_vpn_settings` _object_ |
| `azurerm_virtual_network_gateway["connectivity"]["vpngw"][location].default_local_network_gateway_id` | _moved to new_ `advanced_vpn_settings` _object_ |
| `azurerm_virtual_network_gateway["connectivity"]["vpngw"][location].generation` | `azurerm_virtual_network_gateway["connectivity_vpn"][location].generation` |
| `azurerm_virtual_network_gateway["connectivity"]["vpngw"][location].vpn_client_configuration` | _moved to new_ `advanced_vpn_settings` _object_ |
| `azurerm_virtual_network_gateway["connectivity"]["vpngw"][location].bgp_settings` | _moved to new_ `advanced_vpn_settings` _object_ |
| `azurerm_virtual_network_gateway["connectivity"]["vpngw"][location].custom_route` | _moved to new_ `advanced_vpn_settings` _object_ |
| `azurerm_virtual_network_gateway["connectivity"]["vpngw"][location].tags` | `azurerm_virtual_network_gateway["connectivity_vpn"][location].tags` |
| `azurerm_public_ip["connectivity"]["vpngw"][location].*` | `azurerm_public_ip["connectivity_vpn"][location].*` |

#### Azure Firewall resources

| `v1.1.4` advanced object path | `v2.0.0` advanced object path |
| :--- | :--- |
| `azurerm_public_ip["connectivity"]["azfw"][location].*` | `azurerm_public_ip["connectivity_firewall"][location].*` |

> **NOTE:** In addition to the above, some new settings were added to advanced to enable resource names to be updated which could not be changed previously, but these are not documented here as would not result in a breaking change.

## Next steps

Take a look at the latest [User Guide](User-Guide) documentation and our [Examples](Examples) to understand the latest module configuration options, and review your implementation against the changes documented on this page.

## Need help?

If you're running into problems with the upgrade, please let us know via the [GitHub Issues](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues).
We will do our best to point you in the right direction.

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

[terraform-registry-caf-enterprise-scale]: https://registry.terraform.io/modules/Azure/caf-enterprise-scale/azurerm/latest "Terraform Registry: Azure landing zones Terraform module"
