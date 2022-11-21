# [v3.0.0] Simplify inputs with `optional()` support and more

## Overview

The `v3.0.0` release marks an important update to the module, aimed primarily at reducing code changes needed when upgrading to latest releases.
Previously, any change to the schema of input variables with complex object types would result in a breaking change if not updated in the customer code.
This has been made possible with the GA release of `optional()` types in Terraform v1.3.0.

As a result of this change, we have increased the minimum supported Terraform version to `v1.3.0`.

To support other changes (as listed below), we have also bumped the minimum supported `azurerm` provider version to `v3.19.0`.

### New features

- Added documentation for how to set parameters for Policy Assignments
- Updated GitHub Super-Linter to `v4.9.7` for static code analysis
- Updated the list of private DNS zones created by the module for private endpoints
- Removed deprecated policies for Arc monitoring (now included within VM monitoring built-in initiative)
- Added ability to set `sql_redirect_allowed` and `tls_certificate` properties on Azure Firewall policies
- Update logic for Azure Firewall public IPs to ensure correct availability zone mapping
- Added support for `optional()` types in input variables
- Updated policies with the latest fixes from the upstream [Azure/Enterprise-Scale](https://github.com/Azure/Enterprise-Scale) repository

### Fixed issues

- Fix [#445](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/445) (azurerm v4 compatibility)
- Fix [#359](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/359) (Specifying parameters in policy assignment loses Log Analytics ID)
- Fix [#186](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/186) (Policies incompatible with Terraform)
- Fix [#444](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/444) (Error received when running custom network connectivity deployment)
- Fix [#508](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/508) (Bug Report: Advanced VPN revoke_certifcate fails to apply)
- Fix [#513](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/513) (Feature Request: Azure Firewall: Specify TLS Certificate Location in Azure Keyvault)
- Fix [#447](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/447) (Azure Firewall - Availability Zones)

### Breaking changes

- :warning: Updated the minimum supported Terraform version to `0.15.1`
- :warning: Updated the minimum supported `azurerm` provider version to `3.0.2`

> **IMPORTANT:** Please also carefully review the planned changes following an upgrade, as the introduction of `optional()` settings may result in unexpected changes from your current configuration where recommended new features are enabled by default.

## For more information

Please refer to the [Upgrade from v2.4.1 to v3.0.0](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Upgrade-from-v2.4.1-to-v3.0.0) page on our Wiki.

**Full Changelog**: [v2.4.1...v3.0.0](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/compare/v2.4.1...v3.0.0)
