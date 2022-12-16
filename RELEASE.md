# [v3.1.0] Private DNS and policy updates

## Overview

The `v3.1.0` release includes a number of minor updates as listed below.

### New features

- Added `privatelink.kubernetesconfiguration.azure.com` to list of private DNS zones for `azure_arc` private endpoints
- Updated `Deploy-Diagnostics-LogAnalytics` policy set definition to use the latest built-in policy definitions for Azure Storage
- Updated parameters for the `Deploy-ASC-Monitoring` Policy Assignment
- Updated managed parameters set for the `Deploy-Private-DNS-Zones` Policy Assignment
- Removed the deprecated `ActivityLog` Azure Monitor solution

### Fixed issues

- Fix [#482](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/445) (Review and update private DNS zones for private endpoint #482)
- Fix [#528](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/528) (Validate parameters for Azure Security Benchmark in TF deployment #528)
- Fix [#553](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/553) (Remove Activity Log solution from Terraform RI #553)
- Fix [#544](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/544) (Missing assignment parameter values for "Configure Azure PaaS services to use private DNS zones" #544)

### Breaking changes

n/a

### Input variable changes

The following non-breaking changes have been made to the input variables. Although these don't need to be changed for the module to work, please review to ensure no unwanted resource changes, or code that is no-longer required.

- Removed `configure_management_resources.settings.log_analytics.config.enable_solution_for_azure_activity`

## For more information

**Full Changelog**: [v3.0.0...v3.1.0](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/compare/v3.0.0...v3.1.0)
