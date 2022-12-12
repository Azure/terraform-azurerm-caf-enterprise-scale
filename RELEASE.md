# [v3.1.0] Private DNS and policy updates

## Overview

The `v3.1.0` release includes a number of minor updates as listed below.

### New features

- Added `privatelink.kubernetesconfiguration.azure.com` to list of private DNS zones for `azure_arc` private endpoints
- Updated `Deploy-Diagnostics-LogAnalytics` policy set definition to use the latest built-in policy definitions for Azure Storage
- Updated parameters for the `Deploy-ASC-Monitoring` Policy Assignment
- Updated managed parameters set for the `Deploy-Private-DNS-Zones` Policy Assignment

### Fixed issues

- Fix [#482](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/445) (Review and update private DNS zones for private endpoint #482)
- Fix [#528](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/528) (Validate parameters for Azure Security Benchmark in TF deployment #528)
- Fix [#544](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/544) (Missing assignment parameter values for "Configure Azure PaaS services to use private DNS zones" #544)

### Breaking changes

n/a

## For more information

**Full Changelog**: [v3.0.0...v3.1.0](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/compare/v3.0.0...v3.1.0)
