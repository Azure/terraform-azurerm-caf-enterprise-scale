<!-- markdownlint-disable first-line-h1 -->
## Overview

The `v3.0.0` release marks an important update to the module, aimed primarily at reducing code changes needed when upgrading to latest releases.
Previously, any change to the schema of input variables with complex object types would result in a breaking change if not updated in the customer code.
This has been made possible with the GA release of `optional()` types in Terraform v1.3.1.

As a result of this change, we have increased the minimum supported Terraform version to `v1.3.1`.

To support other changes (as listed below), we have also bumped the minimum supported `azurerm` provider version to `v3.35.0`.

### New features

- Added documentation for how to set parameters for Policy Assignments
- Updated GitHub Super-Linter to `v4.9.7` for static code analysis
- Updated the list of private DNS zones created by the module for private endpoints
- Removed deprecated policies for Arc monitoring (now included within VM monitoring built-in initiative)
- Added ability to set `sql_redirect_allowed` and `tls_certificate` properties on Azure Firewall policies
- Update logic for Azure Firewall public IPs to ensure correct availability zone mapping when only 2 zones are specified
- Added support for `optional()` types in input variables
- Updated policies with the latest fixes from the upstream [Azure/Enterprise-Scale](https://github.com/Azure/Enterprise-Scale) repository
- Updated tag evaluation for connectivity and management resources, so `default_tags` are now merged with scope-specific tags
- Updated the module upgrade guidance
- Updated `Deny-Public-IP` policy assignment to use the built-in policy for `Not allowed resource types`

### Fixed issues

- Fix [#445](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/445) (azurerm v4 compatibility)
- Fix [#359](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/359) (Specifying parameters in policy assignment loses Log Analytics ID)
- Fix [#186](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/186) (Policies incompatible with Terraform)
- Fix [#444](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/444) (Error received when running custom network connectivity deployment)
- Fix [#508](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/508) (Bug Report: Advanced VPN revoke_certifcate fails to apply)
- Fix [#513](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/513) (Feature Request: Azure Firewall: Specify TLS Certificate Location in Azure Keyvault)
- Fix [#447](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/447) (Azure Firewall - Availability Zones)
- Fix [#524](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/524) (Missing private DNS zone for private endpoint - Azure Data Health Data Services)
- Fix [#521](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/521) (Feature Request - ExpressRoute Gateway VPN_Type is Hardcoded, parameterise.)

### Breaking changes

- :warning: Updated the minimum supported Terraform version to `0.15.1`
- :warning: Updated the minimum supported `azurerm` provider version to `3.0.2`
- :warning: Terraform will replace the `Deny-Public-IP` policy assignment, resulting in loss of compliance history

> **IMPORTANT:** Please also carefully review the planned changes following an upgrade, as the introduction of `optional()` settings may result in unexpected changes from your current configuration where recommended new features are enabled by default.

## Required actions

> **IMPORTANT:** The introduction of `optional()` types should reduce the need to make changes to your code when upgrading, as long as you are happy with the default values specified for new inputs.
> Before running `terraform apply`, please carefully review the proposed plan to ensure you are happy with the proposed changes.

Anyone using this module should be aware of the following when planning to upgrade from release `v2.4.1` to `v3.0.0`:

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

- The following Policy Definition changes have been included in the `es_root` archetype definition:
  - `Deny-PublicIP` deprecated
  - `Deploy-DDoSProtection` updated
  - `Deploy-Diagnostics-AA` updated
  - `Deploy-Diagnostics-ACI` updated
  - `Deploy-Diagnostics-ACR` updated
  - `Deploy-Diagnostics-AnalysisService` updated
  - `Deploy-Diagnostics-ApiForFHIR` updated
  - `Deploy-Diagnostics-APIMgmt` updated
  - `Deploy-Diagnostics-ApplicationGateway` updated
  - `Deploy-Diagnostics-AVDScalingPlans` updated
  - `Deploy-Diagnostics-Bastion` updated
  - `Deploy-Diagnostics-CDNEndpoints` updated
  - `Deploy-Diagnostics-CognitiveServices` updated
  - `Deploy-Diagnostics-CosmosDB` updated
  - `Deploy-Diagnostics-Databricks` updated
  - `Deploy-Diagnostics-DataExplorerCluster` updated
  - `Deploy-Diagnostics-DataFactory` updated
  - `Deploy-Diagnostics-DLAnalytics` updated
  - `Deploy-Diagnostics-EventGridSub` updated
  - `Deploy-Diagnostics-EventGridSystemTopic` updated
  - `Deploy-Diagnostics-EventGridTopic` updated
  - `Deploy-Diagnostics-ExpressRoute` updated
  - `Deploy-Diagnostics-Firewall` updated
  - `Deploy-Diagnostics-FrontDoor` updated
  - `Deploy-Diagnostics-Function` updated
  - `Deploy-Diagnostics-HDInsight` updated
  - `Deploy-Diagnostics-iotHub` updated
  - `Deploy-Diagnostics-LoadBalancer` updated
  - `Deploy-Diagnostics-LogicAppsISE` updated
  - `Deploy-Diagnostics-MariaDB` updated
  - `Deploy-Diagnostics-MediaService` updated
  - `Deploy-Diagnostics-MlWorkspace` updated
  - `Deploy-Diagnostics-MySQL` updated
  - `Deploy-Diagnostics-NetworkSecurityGroups` updated
  - `Deploy-Diagnostics-NIC` updated
  - `Deploy-Diagnostics-PostgreSQL` updated
  - `Deploy-Diagnostics-PowerBIEmbedded` updated
  - `Deploy-Diagnostics-RedisCache` updated
  - `Deploy-Diagnostics-Relay` updated
  - `Deploy-Diagnostics-SignalR` updated
  - `Deploy-Diagnostics-SQLElasticPools` updated
  - `Deploy-Diagnostics-SQLMI` updated
  - `Deploy-Diagnostics-TimeSeriesInsights` updated
  - `Deploy-Diagnostics-TrafficManager` updated
  - `Deploy-Diagnostics-VirtualNetwork` updated
  - `Deploy-Diagnostics-VM` updated
  - `Deploy-Diagnostics-VMSS` updated
  - `Deploy-Diagnostics-VNetGW` updated
  - `Deploy-Diagnostics-WebServerFarm` updated
  - `Deploy-Diagnostics-Website` updated
  - `Deploy-Diagnostics-WVDAppGroup` updated
  - `Deploy-Diagnostics-WVDHostPools` updated
  - `Deploy-Diagnostics-WVDWorkspace` updated
  - `Deploy-Nsg-FlowLogs` deprecated
  - `Deploy-Nsg-FlowLogs-to-LA` deprecated
  - `Deploy-Sql-SecurityAlertPolicies` updated
  - `Deploy-Sql-Tde` updated

These will result in a change to the resources deployed by the module.

### Resource type: `azurerm_policy_set_definition`

- The following Policy Set Definition changes have been included in the `es_root` archetype definition:
  - `Deploy-MDFC-Config` updated

These will result in a change to the resources deployed by the module.

### Resource type: `azurerm_policy_assignment`

- The following Policy Assignment changes have been included in the `es_root` archetype definition:
  - `Deploy-LX-Arc-Monitoring` removed (now included within the `Deploy-VM-Monitoring` Policy Assignment)
  - `Deploy-WS-Arc-Monitoring` removed (now included within the `Deploy-VM-Monitoring` Policy Assignment)
  - `Deny-Public-IP` updated (custom policy definition replaced with built-in)

These will result in a change to the resources deployed by the module.

### Resource type: `azurerm_role_definition`

No changes.

### Resource type: `azurerm_role_assignment`

No changes.

### Management resources

Management resources will now inherit tags from the `default_tags` input variable, and combined with those set by `configure_management_resources.tags`.

No other changes are expected to management resources.

### Connectivity resources

Connectivity resources will now inherit tags from the `default_tags` input variable, and combined with those set by `configure_connectivity_resources.tags`.

The following changes were made to the `configure_connectivity_resources.settings.dns.config.enable_private_link_by_service` object:

- `azure_api_management` added
- `azure_arc` added
- `azure_batch_account` added
- `azure_bot_service_bot` added
- `azure_bot_service_token` added
- `azure_cache_for_redis_enterprise` added
- `azure_data_explorer` added
- `azure_data_health_data_services` added
- `azure_digital_twins` added
- `azure_hdinsights` added
- `azure_iot_dps` added
- `azure_key_vault_managed_hsm` added
- `azure_media_services` added
- `azure_migrate` added
- `azure_purview_account` added
- `azure_purview_studio` added
- `azure_synapse_analytics_dev` added
- `azure_synapse_analytics_sqlserver` removed
- `azure_synapse_studio` added
- `azure_web_apps_static_sites` added
- `microsoft_power_bi` added
- `signalr_webpubsub` added

> **NOTE:** Due to the introduction of `optional()` types, this will not require a code change unless you want to disable creation of the newly added private DNS zones controlled by these inputs.

Additional changes were made to the underlying DNS zone mapping to support the latest required configuration.
This may result in changes to the private DNS zones being managed by the module.

No other changes are expected to connectivity resources.

### :rocket: Advanced configuration

If you are using `create_duration_delay` or `destroy_duration_delay` custom inputs but have only partially defined the list of available resource types, you may observe a change in the default values being applied by the module. This is because the `optional()` type allows us to correctly merge custom and default values without a "fallback" value, as previously implemented.

For any customers using the `advanced` configuration blocks within `configure_connectivity_resources` and `configure_management_resources`, we have made a few updates to add new functionality.
These are not breaking changes and can be identified by reviewing the full change log [v2.4.1...v3.0.0](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/compare/v2.4.1...v3.0.0).

## Next steps

Take a look at the latest [User Guide](User-Guide) documentation and our [Examples](Examples) to understand the latest module configuration options, and review your implementation against the changes documented on this page.

## Need help?

If you're running into problems with the upgrade, please let us know via the [GitHub Issues](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues).
We will do our best to point you in the right direction.
