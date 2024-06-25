# Azure landing zones Terraform module

[![Build Status](https://dev.azure.com/mscet/CAE-ALZ-Terraform/_apis/build/status/Tests/E2E?branchName=refs%2Ftags%2Fv6.0.0)](https://dev.azure.com/mscet/CAE-ALZ-Terraform/_build/latest?definitionId=26&branchName=refs%2Ftags%2Fv6.0.0)
![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/Azure/terraform-azurerm-caf-enterprise-scale?style=flat&logo=github)
[![Average time to resolve an issue](http://isitmaintained.com/badge/resolution/azure/terraform-azurerm-caf-enterprise-scale.svg)](http://isitmaintained.com/project/azure/terraform-azurerm-caf-enterprise-scale "Average time to resolve an issue")
[![Percentage of issues still open](http://isitmaintained.com/badge/open/azure/terraform-azurerm-caf-enterprise-scale.svg)](http://isitmaintained.com/project/azure/terraform-azurerm-caf-enterprise-scale "Percentage of issues still open")
[![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/Azure/terraform-azurerm-caf-enterprise-scale/badge)](https://scorecard.dev/viewer/?uri=github.com/Azure/terraform-azurerm-caf-enterprise-scale)

Detailed information about how to use, configure and extend this module can be found on our Wiki:

- [Home](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/Home )
- [User Guide](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/User-Guide)
- [Examples](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/Examples)
- [Frequently Asked Questions](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/Frequently-Asked-Questions)
- [Troubleshooting](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/Troubleshooting)

## ‼ Notice of upcoming breaking changes

We are planning to make some breaking changes to the module in the next release (Q4 2024).

- Module defaults will updated to deploy zone redundant SKUs by default - this applies to:
  - Firewall
  - Public IP
  - Virtual Network Gateway

We will publish guidance on how to avoid re-deployment of existing resources nearer the time.

## Overview

The [Azure landing zones Terraform module](https://registry.terraform.io/modules/Azure/caf-enterprise-scale/azurerm/latest) is designed to accelerate deployment of platform resources based on the [Azure landing zones conceptual architecture](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone#azure-landing-zone-conceptual-architecture) using Terraform.

![A conceptual architecture diagram highlighting the design areas covered by the Azure landing zones Terraform module.](https://raw.githubusercontent.com/wiki/Azure/terraform-azurerm-caf-enterprise-scale/media/alz-tf-module-overview.png)

This is currently split logically into the following capabilities within the module (*links to further guidance on the Wiki*):

| Module capability | Scope | Design area |
| :--- | :--- | :--- |
| [Core Resources](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Core-Resources) | Management group and subscription organization | [Resource organization](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org) |
| [Management Resources](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Management-Resources) | Management subscription | [Management](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/management) |
| [Connectivity Resources](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Connectivity-Resources) | Connectivity subscription | [Network topology and connectivity](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/network-topology-and-connectivity) |
| [Identity Resources](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Identity-Resources) | Identity subscription | [Identity and access management](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access) |

Using a very [simple initial configuration](#maintf), the module will deploy a management group hierarchy based on the above diagram.
This includes the recommended governance baseline, applied using Azure Policy and Access control (IAM) resources deployed at the management group scope.
The default configuration can be easily extended to meet differing requirements, and includes the ability to deploy platform resources in the `management` and `connectivity` subscriptions.

> **NOTE:** In addition to setting input variables to control which resources are deployed, the module requires setting a [Provider Configuration](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Provider-Configuration) block to enable deployment across multiple subscriptions.

Although resources are logically grouped to simplify operations, the modular design of the module also allows resources to be deployed using different Terraform workspaces.
This allows customers to address concerns around managing large state files, or assigning granular permissions to pipelines based on the principle of least privilege. (*more information coming soon in the Wiki*)

## Terraform versions

This module has been tested using Terraform `1.7.0` and AzureRM Provider `3.107.0` as a baseline, and various versions to up the latest at time of release.
In some cases, individual versions of the AzureRM provider may cause errors.
If this happens, we advise upgrading to the latest version and checking our [troubleshooting](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/Troubleshooting) guide before [raising an issue](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues).

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
      version = "~> 3.107"
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

variable "default_location" {
  type    = string
}

# Declare the Azure landing zones Terraform module
# and provide a base configuration.

module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "<version>" # change this to your desired version, https://www.terraform.io/language/expressions/version-constraints

  default_location = var.default_location

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

> **NOTE:** For additional guidance on how to customize your deployment using the advanced configuration options for this module, please refer to our [User Guide](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/User-Guide) and the additional [examples](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/Examples) in our documentation.

## Permissions

Please refer to our [Module Permissions](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Module-Permissions) guide on the Wiki.

## Examples

The following list outlines some of our most popular examples:

- [Examples - Level 100](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/Examples#advanced-level-100)
  - [Deploy Default Configuration](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Default-Configuration)
  - [Deploy Demo Landing Zone Archetypes](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Demo-Landing-Zone-Archetypes)
- [Examples - Level 200](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/Examples#advanced-level-200)
  - [Deploy Custom Landing Zone Archetypes](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Custom-Landing-Zone-Archetypes)
  - [Deploy Connectivity Resources](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Connectivity-Resources)
  - [Deploy Identity Resources](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Identity-Resources)
  - [Deploy Management Resources](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Management-Resources)
  - [Assign a Built-in Policy](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Assign-a-Built-in-Policy)
- [Examples - Level 300](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/Examples#advanced-level-300)
  - [Deploy Connectivity Resources With Custom Settings](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Connectivity-Resources-With-Custom-Settings)
  - [Deploy Identity Resources With Custom Settings](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Identity-Resources-With-Custom-Settings)
  - [Deploy Management Resources With Custom Settings](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Management-Resources-With-Custom-Settings)
  - [Expand Built-in Archetype Definitions](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Expand-Built-in-Archetype-Definitions)
  - [Create Custom Policies, Policy Sets and Assignments](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Create-Custom-Policies-Policy-Sets-and-Assignments)

For the complete list of our latest examples, please refer to our [Examples](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/Examples) page on the Wiki.

## Release notes

Please see the [releases](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/releases) page for the latest module updates.

## Upgrade guides

For upgrade guides from previous versions, please refer to the following links:

- [Upgrade from v5.2.1 to v6.0.0](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Upgrade-from-v5.2.1-to-v6.0.0)
- [Upgrade from v4.2.0 to v5.0.0](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Upgrade-from-v4.2.0-to-v5.0.0)
- [Upgrade from v3.3.0 to v4.0.0](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Upgrade-from-v3.3.0-to-v4.0.0)
- [Upgrade from v2.4.1 to v3.0.0](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Upgrade-from-v2.4.1-to-v3.0.0)
- [Upgrade from v1.1.4 to v2.0.0](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Upgrade-from-v1.1.4-to-v2.0.0)
- [Upgrade from v0.4.0 to v1.0.0](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Upgrade-from-v0.4.0-to-v1.0.0)
- [Upgrade from v0.3.3 to v0.4.0](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Upgrade-from-v0.3.3-to-v0.4.0)
- [Upgrade from v0.1.2 to v0.2.0](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Upgrade-from-v0.1.2-to-v0.2.0)
- [Upgrade from v0.0.8 to v0.1.0](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Upgrade-from-v0.0.8-to-v0.1.0)
