# [v3.1.0] Private DNS, virtual hub and Azure Monitor updates

## Overview

The `v3.1.0` release includes a number of updates as listed below. These focus primarily on private DNS zones for private endpoints, virtual hub, and Azure Monitor.

### New features

- Added `privatelink.kubernetesconfiguration.azure.com` to list of private DNS zones for `azure_arc` private endpoints
- Added option to enable private DNS zone `privatelink.blob.core.windows.net` for Azure Managed Disks
- Added option to enable `internet_security_enabled` on `azurerm_virtual_hub_connection` resources for secure virtual hubs
- Added option to specify a list of virtual networks for linking to private DNS zones without association to a hub
- Updated `Deploy-Diagnostics-LogAnalytics` policy set definition to use the latest built-in policy definitions for Azure Storage
- Updated parameters for the `Deploy-ASC-Monitoring` Policy Assignment
- Updated managed parameters set for the `Deploy-Private-DNS-Zones` Policy Assignment
- Updated logic for DNS zone virtual network links to prevent disabled hubs from being included
- Updated logic for hub virtual network mesh peering to prevent disabled hubs from being included
- Updated default values for `optional()` connectivity inputs
- Removed the deprecated `ActivityLog` Azure Monitor solution
- Removed sensitive value filtering for Log Analytics workspace resources
- Removed location from `azureBatchPrivateDnsZoneId` parameter for `Deploy-Private-DNS-Zones` policy assignment

### Fixed issues

- Fix [#482](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/445) (Review and update private DNS zones for private endpoint #482)
- Fix [#491](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/491) (Feature Request - vwan hub connections - Internet_Security_Enabled should be a variable. #491)
- Fix [#528](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/528) (Validate parameters for Azure Security Benchmark in TF deployment #528)
- Fix [#542](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/542) (Bug Report - enable_private_dns_zone_virtual_network_link_on_hubs = true failing on disabled hub #542)
- Fix [#549](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/549) (Feature Request: Deploy private dns zones and link them to an existing vnet #549)
- Fix [#553](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/553) (Remove Activity Log solution from Terraform RI #553)
- Fix [#544](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/544) (Missing assignment parameter values for "Configure Azure PaaS services to use private DNS zones" #544)
- Fix [#556](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/556) (Unexpected behaviour: Radius IP required when using AAD for VPN gateway #556)
- Close [#499](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/499) (Bug Report Terraform plan fails due to sensitive values in azurerm_automation_account output #499)

### Breaking changes

n/a

### Input variable changes

The following non-breaking changes have been made to the input variables. Although these don't need to be changed for the module to work, please review to prevent unwanted resource changes and to remove code that is no-longer required.

- Added `configure_connectivity_resources.settings.dns.config.enable_private_link_by_service.azure_managed_disks`
- Added `configure_connectivity_resources.settings.dns.config.virtual_network_resource_ids_to_link`
- Added `configure_connectivity_resources.settings.vwan_hub_networks.*.config.secure_spoke_virtual_network_resource_ids`
- Removed `configure_management_resources.settings.log_analytics.config.enable_solution_for_azure_activity`

## For more information

**Full Changelog**: [v3.0.0...v3.1.0](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/compare/v3.0.0...v3.1.0)
