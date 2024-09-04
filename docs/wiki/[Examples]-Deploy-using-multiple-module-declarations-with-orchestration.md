<!-- markdownlint-disable first-line-h1 -->
## Overview

This page provides an example of how you could deploy your Azure landing zone using multiple declarations of the module with an orchestration module to manage deployment within a single Terraform workspace.

When segregating a deployment across multiple module instances, it's important to understand how the module works and what inputs are needed.
All resources are created based on a data model which uses the configuration inputs to determine certain values.
These values are then shared across the different child modules to determine which resources to create, and how to configure policies.
Feature flags such as `deploy_connectivity_resources` are then used to control whether the module actually creates the resources, or just builds the data model for policy.
As such, it's important to keep consistent inputs across each module instance when separating capabilities across different module instances.
This is demonstrated in this example by the root (orchestration) module which ensure that the `core` module instance is populated with the same configuration data (by scope) as the `management` and `connectivity` modules instances.

If you want to use multiple Terraform workspaces, see our [Deploy using multiple module declarations with remote state][wiki_deploy_using_multiple_module_declarations_with_remote_state] example.

This covers scenarios such as:

| Scenario | Description |
| :--- | :--- |
| Delegate responsibility using GitOps | Where an organization wants to use features such as CODEOWNERS to control who can approve changes to code for resources by category. |
| Split across multiple state files | Due to the number of resources needed to deploy an Azure landing zone, some customers may want to split deployment across multiple state files. |
| Simplify maintenance | Using multiple files to control the configuration of resources by scope makes it easier to understand the relationship to resources being managed by that code. |

> **NOTE:**
> This approach is very similar to the strategy described in [Deploy Using Module Nesting][wiki_deploy_using_module_nesting].

This example builds on top of existing examples, including:

- [Deploy Custom Landing Zone Archetypes][wiki_deploy_custom_landing_zone_archetypes]
- [Deploy connectivity resources with custom settings][wiki_deploy_connectivity_resources_custom]
- [Deploy Management Resources With Custom Settings][wiki_deploy_management_resources_custom]

> **IMPORTANT:** Ensure the module version is set to the latest, and don't forget to run `terraform init` if upgrading to a later version of the module.

![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/Azure/terraform-azurerm-caf-enterprise-scale?style=flat&logo=github)

## Module composition

This example is composed of the following modules in a nested structure:

![Example root module composition](./media/400-multi-module-orchestration-composition.png)

We recommend splitting the code across the following files (_grouped by folder for each child module_):

- root_module/
  - [main.tf](#maintf)
  - [variables.tf](#variablestf)
  - modules/
    - connectivity/
      - [main.tf](#modulesconnectivitymaintf)
      - [outputs.tf](#modulesconnectivityoutputstf)
      - [settings.connectivity.tf](#modulesconnectivitysettingsconnectivitytf)
      - [variables.tf](#modulesconnectivityvariablestf)
    - core/
      - [main.tf](#modulescoremaintf)
      - [settings.core.tf](#modulescoresettingscoretf)
      - [settings.identity.tf](#modulescoresettingsidentitytf)
      - [variables.tf](#modulescorevariablestf)
    - management/
      - [main.tf](#modulesmanagementmaintf)
      - [outputs.tf](#modulesmanagementoutputstf)
      - [settings.management.tf](#modulesmanagementsettingsmanagementtf)
      - [variables.tf](#modulesmanagementvariablestf)

> **NOTE:** You can find a copy of the code used in this example in the [examples/400-multi-with-orchestration](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/tree/main/examples/400-multi-with-orchestration) folder of the module repository.

This example will deploy everything using a single root module.
The root module acts as an orchestration module, and will group all ALZ module instances into a single Terraform workspace.
We have also reduced the number of files used in each module to make the modules easier to understand.

> **TIP:** The exact number of resources created depends on the module configuration, but you can expect around 425 resources to be created by this example.

## Example root module

### `main.tf`

The `main.tf` file is used as an orchestration module, defining references to multiple instances of the Azure landing zones Terraform module for connectivity, management and core resources.
To simplify the example, it also includes code to set the provider configuration, including pinning to a specific version (or range of versions) for the AzureRM Provider.
For production use, we recommend pinning to a specific version, and not using ranges.

This example includes logic allowing use of either a single or multiple platform Subscriptions for connectivity and management resources.
If an identity Subscription is specified, this will be moved to the identity management group but no resources will be deployed to this Subscription.

For more information about using the module with multiple providers, please refer to our guide for [multi-subscription deployments][wiki_provider_configuration_multi].

```hcl
# Configure Terraform to set the required AzureRM provider
# version and features{} block

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.107"
    }
  }
}

# Define the provider configuration

provider "azurerm" {
  features {}
}

# Get the current client configuration from the AzureRM provider

data "azurerm_client_config" "current" {}

# Logic to handle 1-3 platform subscriptions as available

locals {
  subscription_id_connectivity = coalesce(var.subscription_id_connectivity, local.subscription_id_management)
  subscription_id_identity     = coalesce(var.subscription_id_identity, local.subscription_id_management)
  subscription_id_management   = coalesce(var.subscription_id_management, data.azurerm_client_config.current.subscription_id)
}

# The following module declarations act to orchestrate the
# independently defined module instances for core,
# connectivity and management resources

module "connectivity" {
  source = "./modules/connectivity"

  connectivity_resources_tags  = var.connectivity_resources_tags
  enable_ddos_protection       = var.enable_ddos_protection
  primary_location             = var.primary_location
  root_id                      = var.root_id
  secondary_location           = var.secondary_location
  subscription_id_connectivity = local.subscription_id_connectivity
}

module "management" {
  source = "./modules/management"

  email_security_contact     = var.email_security_contact
  log_retention_in_days      = var.log_retention_in_days
  management_resources_tags  = var.management_resources_tags
  primary_location           = var.primary_location
  root_id                    = var.root_id
  subscription_id_management = local.subscription_id_management
}

module "core" {
  source = "./modules/core"

  configure_connectivity_resources = module.connectivity.configuration
  configure_management_resources   = module.management.configuration
  primary_location                 = var.primary_location
  root_id                          = var.root_id
  root_name                        = var.root_name
  secondary_location               = var.secondary_location
  subscription_id_connectivity     = local.subscription_id_connectivity
  subscription_id_identity         = local.subscription_id_identity
  subscription_id_management       = local.subscription_id_management
}

```

### `variables.tf`

The `variables.tf` file is used to declare a couple of example variables which are used to customize deployment of this root module across all capabilities.
Defaults are provided for simplicity, but these should be replaced or over-ridden with values suitable for your environment.

```hcl
# Use variables to customize the deployment

variable "root_id" {
  type        = string
  description = "Sets the value used for generating unique resource naming within the module."
  default     = "myorg"
}

variable "root_name" {
  type        = string
  description = "Sets the value used for the \"intermediate root\" management group display name."
  default     = "My Organization"
}

variable "primary_location" {
  type        = string
  description = "Sets the location for \"primary\" resources to be created in."
  default     = "northeurope"
}

variable "secondary_location" {
  type        = string
  description = "Sets the location for \"secondary\" resources to be created in."
  default     = "westeurope"
}

variable "subscription_id_connectivity" {
  type        = string
  description = "Subscription ID to use for \"connectivity\" resources."
  default     = ""
}

variable "subscription_id_identity" {
  type        = string
  description = "Subscription ID to use for \"identity\" resources."
  default     = ""
}

variable "subscription_id_management" {
  type        = string
  description = "Subscription ID to use for \"management\" resources."
  default     = ""
}

variable "email_security_contact" {
  type        = string
  description = "Set a custom value for the security contact email address."
  default     = "test.user@replace_me"
}

variable "log_retention_in_days" {
  type        = number
  description = "Set a custom value for how many days to store logs in the Log Analytics workspace."
  default     = 60
}

variable "enable_ddos_protection" {
  type        = bool
  description = "Controls whether to create a DDoS Network Protection plan and link to hub virtual networks."
  default     = false
}

variable "connectivity_resources_tags" {
  type        = map(string)
  description = "Specify tags to add to \"connectivity\" resources."
  default = {
    deployedBy = "terraform/azure/caf-enterprise-scale/examples/l400-multi"
    demo_type  = "Deploy connectivity resources using multiple module declarations"
  }
}

variable "management_resources_tags" {
  type        = map(string)
  description = "Specify tags to add to \"management\" resources."
  default = {
    deployedBy = "terraform/azure/caf-enterprise-scale/examples/l400-multi"
    demo_type  = "Deploy management resources using multiple module declarations"
  }
}

```

## Example connectivity module

### `modules/connectivity/main.tf`

The `modules/connectivity/main.tf` file contains a customized module declaration to create two hub networks and DNS resources in your connectivity Subscription.

It also includes the necessary Terraform and provider configuration, and an `azurerm_client_config` resource which is used to determine the Tenant ID and Subscription ID values for the context being used to create these resources.
This is used to ensure the deployment will target your `Tenant Root Group` by default, and to populate the `subscription_id_connectivity` input variable.

```hcl
# Configure Terraform to set the required AzureRM provider
# version and features{} block

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.107"
    }
  }
}

# Define the provider configuration

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id_connectivity
}

# Get the current client configuration from the AzureRM provider

data "azurerm_client_config" "current" {}

# Declare the Azure landing zones Terraform module
# and provide the connectivity configuration

module "alz" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "<version>" # change this to your desired version, https://www.terraform.io/language/expressions/version-constraints

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm
    azurerm.management   = azurerm
  }

  # Base module configuration settings
  root_parent_id = data.azurerm_client_config.current.tenant_id
  root_id        = var.root_id

  # Disable creation of the core management group hierarchy
  # as this is being created by the core module instance
  deploy_core_landing_zones = false

  # Configuration settings for connectivity resources
  deploy_connectivity_resources    = true
  configure_connectivity_resources = local.configure_connectivity_resources
  subscription_id_connectivity     = var.subscription_id_connectivity

}

```

### `modules/connectivity/outputs.tf`

The `modules/connectivity/outputs.tf` file contains modules outputs used when connecting the module instances together.

The `configuration` output is an important part of this example, as this is used to ensure the same values used to configure the connectivity resources is shared with the core module instance.
This ensures that managed parameters for policies deployed by the core module instance are configured with values correctly reflecting the resources deployed by this module instance.

```hcl
# Output a copy of configure_connectivity_resources for use
# by the core module instance

output "configuration" {
  description = "Configuration settings for the \"connectivity\" resources."
  value       = local.configure_connectivity_resources
}

```

### `modules/connectivity/settings.connectivity.tf`

The `modules/connectivity/settings.connectivity.tf` file is used to specify the configuration used for creating the required connectivity resources.

This is used as an input to the connectivity module instance, but is also shared with the core module instance to ensure consistent configuration between resources and policies.

```hcl
# Configure custom connectivity resources settings
locals {
  configure_connectivity_resources = {
    settings = {
      # Create two hub networks with hub mesh peering enabled
      # and link to DDoS protection plan if created
      hub_networks = [
        {
          config = {
            address_space                   = ["10.100.0.0/22", ]
            location                        = var.primary_location
            link_to_ddos_protection_plan    = var.enable_ddos_protection
            enable_hub_network_mesh_peering = true
          }
        },
        {
          config = {
            address_space                   = ["10.101.0.0/22", ]
            location                        = var.secondary_location
            link_to_ddos_protection_plan    = var.enable_ddos_protection
            enable_hub_network_mesh_peering = true
          }
        },
      ]
      # Do not create an Virtual WAN resources
      vwan_hub_networks = []
      # Enable DDoS protection plan in the primary location
      ddos_protection_plan = {
        enabled = var.enable_ddos_protection
      }
      # DNS will be deployed with default settings
      dns = {}
    }
    # Set the default location
    location = var.primary_location
    # Create a custom tags input
    tags = var.connectivity_resources_tags
  }
}

```

### `modules/connectivity/variables.tf`

The `modules/connectivity/variables.tf` file is used to declare a number of variables needed to configure this module.
These are populated from the orchestration module, so no default values are specified.

> **NOTE:** If using these modules without the orchestration module, you must either add a `defaultValue` for each variable, or specify each of these when running `terraform plan`.

```hcl
# Use variables to customize the deployment

variable "root_id" {
  type        = string
  description = "Sets the value used for generating unique resource naming within the module."
}

variable "primary_location" {
  type        = string
  description = "Sets the location for \"primary\" resources to be created in."
}

variable "secondary_location" {
  type        = string
  description = "Sets the location for \"secondary\" resources to be created in."
}

variable "subscription_id_connectivity" {
  type        = string
  description = "Subscription ID to use for \"connectivity\" resources."
}

variable "enable_ddos_protection" {
  type        = bool
  description = "Controls whether to create a DDoS Network Protection plan and link to hub virtual networks."
}

variable "connectivity_resources_tags" {
  type        = map(string)
  description = "Specify tags to add to \"connectivity\" resources."
}

```

## Example core module

### `modules/core/lib/archetype_definition_customer_online.json`

The `modules/core/lib/archetype_definition_customer_online.json` file is used to .

```json
{
  "customer_online": {
    "policy_assignments": [
      "Deny-Resource-Locations",
      "Deny-RSG-Locations"
    ],
    "policy_definitions": [],
    "policy_set_definitions": [],
    "role_definitions": [],
    "archetype_config": {
      "parameters": {
        "Deny-Resource-Locations": {
          "listOfAllowedLocations": [
            "eastus",
            "eastus2",
            "westus",
            "northcentralus",
            "southcentralus"
          ]
        },
        "Deny-RSG-Locations": {
          "listOfAllowedLocations": [
            "eastus",
            "eastus2",
            "westus",
            "northcentralus",
            "southcentralus"
          ]
        }
      },
      "access_control": {}
    }
  }
}
```

### `modules/core/main.tf`

The `modules/core/main.tf` file contains a customized module declaration to create the management group hierarchy and associated policies.

It also includes the necessary Terraform and provider configuration, and an `azurerm_client_config` resource which is used to determine the Tenant ID and Subscription ID values for the context being used to create these resources.
This is used to ensure the deployment will target your `Tenant Root Group` by default, and to populate the `subscription_id_xxxxx` input variables.

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

# Define the provider configuration

provider "azurerm" {
  features {}
}

# Get the current client configuration from the AzureRM provider.

data "azurerm_client_config" "current" {}

# Declare the Azure landing zones Terraform module
# and provide the core configuration.

module "alz" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "<version>" # change this to your desired version, https://www.terraform.io/language/expressions/version-constraints

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm
    azurerm.management   = azurerm
  }

  # Base module configuration settings
  root_parent_id = data.azurerm_client_config.current.tenant_id
  root_id        = var.root_id
  root_name      = var.root_name
  library_path   = "${path.module}/lib"

  # Enable creation of the core management group hierarchy
  # and additional custom_landing_zones
  deploy_core_landing_zones = true
  custom_landing_zones      = local.custom_landing_zones

  # Configuration settings for identity resources is
  # bundled with core as no resources are actually created
  # for the identity subscription
  deploy_identity_resources    = true
  configure_identity_resources = local.configure_identity_resources
  subscription_id_identity     = var.subscription_id_identity

  # The following inputs ensure that managed parameters are
  # configured correctly for policies relating to connectivity
  # resources created by the connectivity module instance and
  # to map the subscription to the correct management group,
  # but no resources are created by this module instance
  deploy_connectivity_resources    = false
  configure_connectivity_resources = var.configure_connectivity_resources
  subscription_id_connectivity     = var.subscription_id_connectivity

  # The following inputs ensure that managed parameters are
  # configured correctly for policies relating to management
  # resources created by the management module instance and
  # to map the subscription to the correct management group,
  # but no resources are created by this module instance
  deploy_management_resources    = false
  configure_management_resources = var.configure_management_resources
  subscription_id_management     = var.subscription_id_management

}

```

### `modules/core/settings.core.tf`

The `modules/core/settings.core.tf` file is used to specify the configuration used for creating the required core resources.

This is used as an input to the core module instance only, defining which additional management groups to create and to demonstrate some simple custom archetype configuration options.

```hcl
# Configure the custom landing zones to deploy in
# addition to the core resource hierarchy
locals {
  custom_landing_zones = {
    "${var.root_id}-online-example-1" = {
      display_name               = "${upper(var.root_id)} Online Example 1"
      parent_management_group_id = "${var.root_id}-landing-zones"
      subscription_ids           = []
      archetype_config = {
        archetype_id   = "customer_online"
        parameters     = {}
        access_control = {}
      }
    }
    "${var.root_id}-online-example-2" = {
      display_name               = "${upper(var.root_id)} Online Example 2"
      parent_management_group_id = "${var.root_id}-landing-zones"
      subscription_ids           = []
      archetype_config = {
        archetype_id = "customer_online"
        parameters = {
          Deny-Resource-Locations = {
            listOfAllowedLocations = [
              var.primary_location,
              var.secondary_location,
            ]
          }
          Deny-RSG-Locations = {
            listOfAllowedLocations = [
              var.primary_location,
              var.secondary_location,
            ]
          }
        }
        access_control = {}
      }
    }
  }
}

```

### `modules/core/settings.identity.tf`

The `modules/core/settings.identity.tf` file is used to specify the configuration used for configuring policies relating to the identity resources.

In this example we are setting the `Deny-Subnet-Without-Nsg` policy assignment `enforcementMode` to `DoNotEnforce`.

```hcl
# Configure custom identity resources settings
locals {
  configure_identity_resources = {
    settings = {
      identity = {
        config = {
          # Disable this policy as can conflict with Terraform
          enable_deny_subnet_without_nsg = false
        }
      }
    }
  }
}

```

### `modules/core/variables.tf`

The `modules/core/variables.tf` file is used to declare a number of variables needed to configure this module.
These are populated from the orchestration module, so no default values are specified.

> **NOTE:** If using these modules without the orchestration module, you must either add a `defaultValue` for each variable, or specify each of these when running `terraform plan`.

```hcl
# Use variables to customize the deployment

variable "root_id" {
  type        = string
  description = "Sets the value used for generating unique resource naming within the module."
}

variable "root_name" {
  type        = string
  description = "Sets the value used for the \"intermediate root\" management group display name."
}

variable "primary_location" {
  type        = string
  description = "Sets the location for \"primary\" resources to be created in."
}

variable "secondary_location" {
  type        = string
  description = "Sets the location for \"secondary\" resources to be created in."
}

variable "subscription_id_connectivity" {
  type        = string
  description = "Subscription ID to use for \"connectivity\" resources."
}

variable "subscription_id_identity" {
  type        = string
  description = "Subscription ID to use for \"identity\" resources."
}

variable "subscription_id_management" {
  type        = string
  description = "Subscription ID to use for \"management\" resources."
}

variable "configure_connectivity_resources" {
  type        = any
  description = "Configuration settings for \"connectivity\" resources."
}

variable "configure_management_resources" {
  type        = any
  description = "Configuration settings for \"management\" resources."
}

```

## Example management module

### `modules/management/main.tf`

The `modules/management/main.tf` file contains a customized module declaration to the Log Analytics workspace, Automation Account and Azure Monitor solutions in your management Subscription.

It also includes the necessary Terraform and provider configuration, and an `azurerm_client_config` resource which is used to determine the Tenant ID and Subscription ID values for the context being used to create these resources.
This is used to ensure the deployment will target your `Tenant Root Group` by default, and to populate the `subscription_id_management` input variable.

```hcl
# Configure Terraform to set the required AzureRM provider
# version and features{} block

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.107"
    }
  }
}

# Define the provider configuration

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id_management
}

# Get the current client configuration from the AzureRM provider

data "azurerm_client_config" "current" {}

# Declare the Azure landing zones Terraform module
# and provide the connectivity configuration.

module "alz" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "<version>" # change this to your desired version, https://www.terraform.io/language/expressions/version-constraints

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm
    azurerm.management   = azurerm
  }

  # Base module configuration settings
  root_parent_id = data.azurerm_client_config.current.tenant_id
  root_id        = var.root_id

  # Disable creation of the core management group hierarchy
  # as this is being created by the core module instance
  deploy_core_landing_zones = false

  # Configuration settings for management resources
  deploy_management_resources    = true
  configure_management_resources = local.configure_management_resources
  subscription_id_management     = var.subscription_id_management

}

```

### `modules/management/outputs.tf`

The `modules/management/outputs.tf` file contains modules outputs used when connecting the module instances together.

The `configuration` output is an important part of this example, as this is used to ensure the same values used to configure the management resources is shared with the core module instance.
This ensures that managed parameters for policies deployed by the core module instance are configured with values correctly reflecting the resources deployed by this module instance.

```hcl
# Output a copy of configure_management_resources for use
# by the core module instance

output "configuration" {
  description = "Configuration settings for the \"management\" resources."
  value       = local.configure_management_resources
}

```

### `modules/management/settings.management.tf`

The `modules/management/settings.management.tf` file is used to specify the configuration used for creating the required management resources.

This is used as an input to the management module instance, but is also shared with the core module instance to ensure consistent configuration between resources and policies.

```hcl
# Configure custom management resources settings
locals {
  configure_management_resources = {
    settings = {
      log_analytics = {
        config = {
          # Set a custom number of days to retain logs
          retention_in_days = var.log_retention_in_days
        }
      }
      security_center = {
        config = {
          # Configure a valid security contact email address
          email_security_contact = var.email_security_contact
        }
      }
    }
    # Set the default location
    location = var.primary_location
    # Create a custom tags input
    tags = var.management_resources_tags
  }
}

```

### `modules/management/variables.tf`

The `modules/management/variables.tf` file is used to declare a number of variables needed to configure this module.
These are populated from the orchestration module, so no default values are specified.

> **NOTE:** If using these modules without the orchestration module, you must either add a `defaultValue` for each variable, or specify each of these when running `terraform plan`.

```hcl
# Use variables to customize the deployment

variable "root_id" {
  type        = string
  description = "Sets the value used for generating unique resource naming within the module."
}

variable "primary_location" {
  type        = string
  description = "Sets the location for \"primary\" resources to be created in."
}

variable "subscription_id_management" {
  type        = string
  description = "Subscription ID to use for \"management\" resources."
}

variable "email_security_contact" {
  type        = string
  description = "Set a custom value for the security contact email address."
}

variable "log_retention_in_days" {
  type        = number
  description = "Set a custom value for how many days to store logs in the Log Analytics workspace."
}

variable "management_resources_tags" {
  type        = map(string)
  description = "Specify tags to add to \"management\" resources."
}

```

## Deploy resources

To simplify deployment, this example is deployed through a single root module.

From the root_module directory, simply run the following commands:

1. Ensure you have a connection correctly configured with permissions to Azure as per the [Module permissions][wiki_module_permissions] documentation
1. Initialize the Terraform workspace with the command `terraform init`
1. Generate a plan with the command `terraform plan -out=tfplan`
1. Review the output of the plan (use the command `terraform show -json ./tfplan` if you want to review the plan as a JSON file)
1. Start the deployment using the command `terraform apply ./tfplan` and follow the prompts
1. Once deployment is complete, review the created resources

## Next steps

Review the deployed resources to see how this compares to the examples we based this on (as listed [above](#overview)).

Consider how else you might further sub-divide your deployment.
For example, it's actually possible to implement a single hub per instance and still integrate them for peering.
You can also deploy DNS resources independently, whilst maintaining the ability to link the DNS zones to the hub virtual networks (and spokes).

To learn more about module configuration using input variables, please refer to the [Module Variables][wiki_module_variables] documentation.

Looking for further inspiration? Why not try some of our other [examples][wiki_examples]?

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

[wiki_deploy_connectivity_resources_custom]:                        %5BExamples%5D-Deploy-Multi-Region-Networking-With-Custom-Settings "Wiki - Deploy multi region networking with custom settings (Hub and Spoke)"
[wiki_deploy_custom_landing_zone_archetypes]:                       %5BExamples%5D-Deploy-Custom-Landing-Zone-Archetypes "Wiki - Deploy Custom landing zone archetypes"
[wiki_deploy_management_resources_custom]:                          %5BExamples%5D-Deploy-Virtual-WAN-Multi-Region-With-Custom-Settings "Wiki - Deploy multi region networking with custom settings (Virtual WAN)"
[wiki_deploy_using_module_nesting]:                                 %5BExamples%5D-Deploy-Using-Module-Nesting "Wiki - Deploy using module nesting"
[wiki_deploy_using_multiple_module_declarations_with_remote_state]: %5BExamples%5D-Deploy-using-module-declarations-with-remote-state "Wiki - Deploy using multiple module declarations with remote state"
[wiki_examples]:                                                    Examples "Wiki - Examples"
[wiki_module_permissions]:                                          %5BUser-Guide%5D-Module-Permissions "Wiki - Module permissions"
[wiki_module_variables]:                                            %5BUser-Guide%5D-Module-Variables "Wiki - Module variables"
[wiki_provider_configuration_multi]:                                %5BUser-Guide%5D-Provider-Configuration#multi-subscription-deployment "Wiki - Provider configuration - Multi subscription deployment"
