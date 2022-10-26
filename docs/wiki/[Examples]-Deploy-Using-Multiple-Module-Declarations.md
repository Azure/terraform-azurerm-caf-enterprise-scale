<!-- markdownlint-disable first-line-h1 -->
## Overview

This page describes how to deploy your Azure landing zone using multiple declarations of the module.
This covers scenarios such as:

| Scenario | Description |
| :--- | :--- |
| Delegate responsibility using GitOps | Where an organization wants to use features such as CODEOWNERS to control who can approve changes to code for resources by type. |
| Split across multiple state files | Due to the number of resources needed to deploy an Azure landing zone, some customers may want to split deployment across multiple state files. |
| Simplify maintenance | Using multiple files to control the configuration of resources by scope makes it easier to see 

> **NOTE:**
> This approach is very similar to the strategy described in [Deploy Using Module Nesting][wiki_deploy_using_module_nesting].

This example is building on top of existing examples, including:

- [Deploy Custom Landing Zone Archetypes][wiki_deploy_custom_landing_zone_archetypes]
- [Deploy Connectivity Resources With Custom Settings][wiki_deploy_connectivity_resources_custom]
- [Deploy Management Resources With Custom Settings][wiki_deploy_management_resources_custom]

> IMPORTANT: Ensure the module version is set to the latest, and don't forget to run `terraform init` if upgrading to a later version of the module.

![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/Azure/terraform-azurerm-caf-enterprise-scale?style=flat&logo=github)

## Example root module

For this example, we recommend splitting the code across the following files (grouped by capability):

- Common
  - [terraform.tf](#terraformtf)
  - [variables.tf](#variablestf)
  - [clients.tf](#clientstf)
- Core
  - [main.core.tf](#maincoretf)
  - [variables.core.tf](#variablescoretf)
  - [settings.core.tf](#settingscoretf)
- Connectivity
  - [main.connectivity.tf](#mainconnectivitytf)
  - [variables.connectivity.tf](#variablesconnectivitytf)
  - [settings.connectivity.tf](#settingsconnectivitytf)
- Management
  - [main.management.tf](#mainmanagementtf)
  - [variables.management.tf](#variablesmanagementtf)
  - [settings.management.tf](#settingsmanagementtf)

In this example we will deploy everything using a single root module.
This will group all resources into a single Terraform configuration, using a single backend and state.
To deploy across multiple root modules, simply copy the `Common` files into each root module along with the required capability-specific files.

> TIP: The exact number of resources created depends on the module configuration, but you can expect upwards of 300 resources to be created by the module for this example.

### `terraform.tf`

The `terraform.tf` file is used to set the provider configuration, including pinning to a specific version (or range of versions) for the AzureRM Provider. For production use, we recommend pinning to a specific version, and not using ranges.

This example is bootstrapped to enable deployment to dedicated subscriptions for connectivity and management resources.
For more information about using the module with multiple providers, please refer to our guide for [multi-subscription deployments][wiki_provider_configuration_multi].

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

provider "azurerm" {
  features {}

  alias = "connectivity"
  subscription_id = coalesce(
    var.subscription_id_connectivity,
    data.azurerm_client_config.core.subscription_id,
  )
}

provider "azurerm" {
  features {}

  alias = "management"
  subscription_id = coalesce(
    var.subscription_id_management,
    data.azurerm_client_config.core.subscription_id,
  )
}

# Get the client configuration from the default AzureRM provider.
# This is used to populate the root_parent_id variable with the
# current Tenant ID, used as the ID for the "Tenant Root Group"
# Management Group.
# This also acts as a fallback value for the "connectivity" and
# "management" aliased providers.

data "azurerm_client_config" "core" {}

```

### `variables.tf`

The `variables.tf` file is used to declare a couple of example variables which are used to customize deployment of this root module across all capabilities.
Defaults are provided for simplicity, but these should be replaced or over-ridden with values suitable for your environment.

```hcl
# Use variables to customize the deployment

variable "root_id" {
  type    = string
  default = "myorg"
}

variable "location" {
  type    = string
  default = "eastus"
}

variable "subscription_id_connectivity" {
  type        = string
  description = "If specified, will be used to configure the connectivity aliased provider and will move the specified subscription into the \"connectivity\" management group."
  default     = ""
}

variable "subscription_id_management" {
  type        = string
  description = "If specified, will be used to configure the management aliased provider and will move the specified subscription into the \"management\" management group."
  default     = ""
}
```

### `variables.core.tf`

The `variables.core.tf` file is used to declare a couple of example variables which are used to customize deployment of this root module for the core capability.
Defaults are provided for simplicity, but these should be replaced or over-ridden with values suitable for your environment.

```hcl
# Use variables to customize the deployment

variable "root_name" {
  type    = string
  default = "My Organization"
}

```

### `variables.connectivity.tf`

The `variables.connectivity.tf` file is used to declare a couple of example variables which are used to customize deployment of this root module for the connectivity capability.
Defaults are provided for simplicity, but these should be replaced or over-ridden with values suitable for your environment.

```hcl
# Use variables to customize the deployment

variable "deploy_connectivity_resources" {
  type    = bool
  default = true
}

variable "connectivity_resources_location" {
  type    = string
  default = "uksouth"
}

variable "connectivity_resources_tags" {
  type = map(string)
  default = {
    demo_type = "deploy_connectivity_resources_custom"
  }
}

```

### `variables.management.tf`

The `variables.management.tf` file is used to declare a couple of example variables which are used to customize deployment of this root module for the management capability.
Defaults are provided for simplicity, but these should be replaced or over-ridden with values suitable for your environment.

```hcl
# Use variables to customize the deployment

variable "deploy_management_resources" {
  type    = bool
  default = true
}

variable "log_retention_in_days" {
  type    = number
  default = 50
}

variable "security_alerts_email_address" {
  type    = string
  default = "my_valid_security_contact@replace_me" # Replace this value with your own email address.
}

variable "management_resources_location" {
  type    = string
  default = "uksouth"
}

variable "management_resources_tags" {
  type = map(string)
  default = {
    demo_type = "deploy_management_resources_custom"
  }
}

```

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

[wiki_provider_configuration]:                             %5BUser-Guide%5D-Provider-Configuration "Wiki - Provider Configuration"
[wiki_provider_configuration_multi]:                       %5BUser-Guide%5D-Provider-Configuration#multi-subscription-deployment "Wiki - Provider Configuration - Multi Subscription Deployment"
[wiki_archetype_definitions]:                              %5BUser-Guide%5D-Archetype-Definitions "Wiki - Archetype Definitions"
[wiki_core_resources]:                                     %5BUser-Guide%5D-Core-Resources "Wiki - Core Resources"

[wiki_examples]:                                           Examples "Wiki - Examples"
[wiki_deploy_default_configuration]:                       %5BExamples%5D-Deploy-Default-Configuration "Wiki - Deploy Default Configuration"
[wiki_deploy_demo_landing_zone_archetypes]:                %5BExamples%5D-Deploy-Demo-Landing-Zone-Archetypes "Wiki - Deploy Demo Landing Zone Archetypes"
[wiki_deploy_custom_landing_zone_archetypes]:              %5BExamples%5D-Deploy-Custom-Landing-Zone-Archetypes "Wiki - Deploy Custom Landing Zone Archetypes"
[wiki_deploy_management_resources]:                        %5BExamples%5D-Deploy-Management-Resources "Wiki - Deploy Management Resources"
[wiki_deploy_management_resources_custom]:                 %5BExamples%5D-Deploy-Management-Resources-With-Custom-Settings "Wiki - Deploy Management Resources With Custom Settings"
[wiki_deploy_connectivity_resources]:                      %5BExamples%5D-Deploy-Connectivity-Resources "Wiki - Deploy Connectivity Resources (Hub and Spoke)"
[wiki_deploy_connectivity_resources_custom]:               %5BExamples%5D-Deploy-Connectivity-Resources-With-Custom-Settings "Wiki - Deploy Connectivity Resources With Custom Settings (Hub and Spoke)"
[wiki_deploy_virtual_wan_resources]:                       %5BExamples%5D-Deploy-Virtual-WAN-Resources "Wiki - Deploy Connectivity Resources (Virtual WAN)"
[wiki_deploy_virtual_wan_resources_custom]:                %5BExamples%5D-Deploy-Virtual-WAN-Resources-With-Custom-Settings "Wiki - Deploy Connectivity Resources With Custom Settings (Virtual WAN)"
[wiki_deploy_identity_resources]:                          %5BExamples%5D-Deploy-Identity-Resources "Wiki - Deploy Identity Resources"
[wiki_deploy_identity_resources_custom]:                   %5BExamples%5D-Deploy-Identity-Resources-With-Custom-Settings "Wiki - Deploy Identity Resources With Custom Settings"
[wiki_deploy_using_module_nesting]:                        %5BExamples%5D-Deploy-Using-Module-Nesting "Wiki - Deploy Using Module Nesting"
[wiki_expand_built_in_archetype_definitions]:              %5BExamples%5D-Expand-Built-in-Archetype-Definitions "Wiki - Expand Built-in Archetype Definitions"
[wiki_override_module_role_assignments]:                   %5BExamples%5D-Override-Module-Role-Assignments "Wiki - Override Module Role Assignments"
[wiki_create_custom_policies_policy_sets_and_assignments]: %5BExamples%5D-Create-Custom-Policies-Policy-Sets-and-Assignments "Wiki - Create Custom Policies, Policy Sets and Assignments"
[wiki_assign_a_built_in_policy]:                           %5BExamples%5D-Assign-a-Built-in-Policy "Wiki - Assign a Built-in Policy"
[wiki_create_and_assign_custom_rbac_roles]:                %5BExamples%5D-Create-and-Assign-Custom-RBAC-Roles "Wiki - Create and Assign Custom RBAC Roles"
