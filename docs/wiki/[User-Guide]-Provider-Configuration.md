## Overview

As of release `v0.4.0`, the [Terraform Module for Cloud Adoption Framework Enterprise-scale][terraform-registry-caf-enterprise-scale] now uses multiple provider aliases to allow resources to be deployed directly to the intended Subscription, without the need to specify multiple instances of the module.

This change is intended to simplify deployments using a single pipeline to create all resources, as it is no longer necessary to share the configuration inputs across multiple instances of the module to achieve consistency between the resources created, and associated policies.

The module utilises 3 providers in total:

| Resource category | Provider |
| ----------------- | -------- |
| [Core][wiki_core_resources]                 | `azurerm` *(default)*  |
| [Connectivity][wiki_connectivity_resources] | `azurerm.connectivity` |
| [Management][wiki_management_resources]     | `azurerm.management`   |
| [Identity][wiki_identity_resources]         | *n/a (no resources)*   |

Regardless of how you plan to use the module, you must map your provider(s) to the module providers. Failure to do so will result in one or both of the following error when running `terraform init`:

```shell
╷
│ Error: No configuration for provider azurerm.connectivity
│
│   on main.tf line 13:
│   13: module "enterprise_scale" {
│
│ Configuration required for module.enterprise_scale.provider["registry.terraform.io/hashicorp/azurerm"].connectivity.
│ Add a provider named azurerm.connectivity to the providers map for module.enterprise_scale in the root module.
╵

╷
│ Error: No configuration for provider azurerm.management
│
│   on main.tf line 13:
│   13: module "enterprise_scale" {
│
│ Configuration required for module.enterprise_scale.provider["registry.terraform.io/hashicorp/azurerm"].management.
│ Add a provider named azurerm.management to the providers map for module.enterprise_scale in the root module.
╵
```

The following section covers typical configuration scenarios.

## Provider configuration examples

### Single Subscription deployment

The following example shows how you can map a single (default) provider from the root module using the providers object:

```hcl
# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used.

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.77.0"
    }
  }
}

# Declare a standard provider block using your preferred configuration.
# This will be used for all resource deployments.

provider "azurerm" {
  features {}
}

# Map each module provider to your default `azurerm` provider using the providers input object.

module "caf-enterprise-scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "1.1.0"

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm
    azurerm.management   = azurerm
  }

  # insert the required input variables here
}
```

For more detailed instructions, follow the [next steps](#next-steps) listed below or go straight to our [Examples](./Examples).

### Multi-Subscription deployment

Terraform is unable to deploy resources across multiple Subscriptions using a single `provider` configuration.

You must be authenticated to the Subscription where you want each set of resources to be deployed.

- You must always provide a base provider configuration for the "Core resources". Although no "Core resources" are deployed in this Subscription, it is used for authentication to the Azure API.

- When setting `deploy_connectivity_resources = true`, you must also ensure you map the `azurerm.connectivity` provider to authenticate against the same Subscription as specified in `subscription_id_connectivity`.

- When setting `deploy_management_resources = true`, you must also ensure you map the `azurerm.management` provider to authenticate against the same Subscription as specified in `subscription_id_management`.

Although this may bring additional complexity to the module, this also enables the module to deploy resources across multiple Subscriptions.
This is an important part of the [Cloud Adoption Framework enterprise-scale landing zone architecture][ESLZ-Architecture].

Details of how to [configure authentication settings][authenticating_to_azure] can be found in the AzureRM Provider documentation.

The following example shows how you might configure multiple `provider` blocks and map them to the module for a Multi-Subscription deployment:

```hcl
# When using multiple providers, you must add the required_providers block
# to declare the configuration_aliases under the Azure Provider, along with
# the source and version being used.

terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      version               = ">= 2.77.0"
      configuration_aliases = [
        azurerm.connectivity,
        azurerm.management,
      ]
    }
  }
}

# Declare a standard provider block using your preferred configuration.
# This will be used for the deployment of all "Core resources".

provider "azurerm" {
  features {}
}

# Declare an aliased provider block using your preferred configuration.
# This will be used for the deployment of all "Connectivity resources" to the specified `subscription_id`.

provider "azurerm" {
  alias           = "connectivity"
  subscription_id = "00000000-0000-0000-0000-000000000000"
  features {}
}

# Declare a standard provider block using your preferred configuration.
# This will be used for the deployment of all "Management resources" to the specified `subscription_id`.

provider "azurerm" {
  alias           = "management"
  subscription_id = "11111111-1111-1111-1111-111111111111"
  features {}
}

# Map each module provider to their corresponding `azurerm` provider using the providers input object

module "caf-enterprise-scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "1.1.0"

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm.connectivity
    azurerm.management   = azurerm.management
  }

  # insert the required input variables here
}
```

It may also be useful to make use of the [`azurerm_client_config`][azurerm_client_config] data source when working with multiple Subscriptions, as this allows you to extract values from each provider declaration for use elsewhere within the module.

In the following example, you can see how we use the [`azurerm_client_config`][azurerm_client_config] data source to populate values in the `root_parent_id`, `subscription_id_connectivity`, and `subscription_id_management` input variables.
These all use the same credentials, but are configured to target different Subscriptions.

```hcl
# Declare a standard provider block using your preferred configuration.
# This will target the "default" Subscription and be used for the deployment of all "Core resources".
provider "azurerm" {
  features {}
}

# Declare an aliased provider block using your preferred configuration.
# This will be used for the deployment of all "Connectivity resources" to the specified `subscription_id`.
provider "azurerm" {
  alias           = "connectivity"
  subscription_id = "00000000-0000-0000-0000-000000000000"
  features {}
}

# Declare a standard provider block using your preferred configuration.
# This will be used for the deployment of all "Management resources" to the specified `subscription_id`.
provider "azurerm" {
  alias           = "management"
  subscription_id = "11111111-1111-1111-1111-111111111111"
  features {}
}

# Obtain client configuration from the un-aliased provider
data "azurerm_client_config" "core" {
  provider = azurerm
}

# Obtain client configuration from the "management" provider
data "azurerm_client_config" "management" {
  provider = azurerm.management
}

# Obtain client configuration from the "connectivity" provider
data "azurerm_client_config" "connectivity" {
  provider = azurerm.connectivity
}

# Map each module provider to their corresponding `azurerm` provider using the providers input object
module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "1.1.0"

  providers = {
    azurerm              = azurerm
    azurerm.management   = azurerm.management
    azurerm.connectivity = azurerm.connectivity
  }

  # Set the required input variable `root_parent_id` using the Tenant ID from the un-aliased provider
  root_parent_id           = data.azurerm_client_config.core.tenant_id

  # Enable deployment of the management resources, using the management
  # aliased provider to populate the correct Subscription ID
  deploy_management_resources    = true
  subscription_id_management     = data.azurerm_client_config.management.subscription_id

  # Enable deployment of the connectivity resources, using the connectivity
  # aliased provider to populate the correct Subscription ID
  deploy_connectivity_resources    = true
  subscription_id_connectivity     = data.azurerm_client_config.connectivity.subscription_id

  # insert additional optional input variables here

}
```

For more detailed instructions, follow the [next steps](#next-steps) listed below or go straight to our [Examples](./Examples).

## Next steps

Learn how to use the [Module Variables](%5BUser-Guide%5D-Module-Variables) to customize the module configuration.

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

[ESLZ-Architecture]: https://docs.microsoft.com/azure/cloud-adoption-framework/ready/enterprise-scale/architecture "Cloud Adoption Framework enterprise-scale landing zone architecture"

[terraform-registry-caf-enterprise-scale]: https://registry.terraform.io/modules/Azure/caf-enterprise-scale/azurerm/latest "Terraform Registry: Terraform Module for Cloud Adoption Framework Enterprise-scale"
[authenticating_to_azure]:                 https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs#authenticating-to-azure "Terraform Registry: Azure Provider (Authenticating to Azure)"

[wiki_core_resources]:                        ./%5BUser-Guide%5D-Core-Resources "Wiki - Core Resources"
[wiki_management_resources]:                  ./%5BUser-Guide%5D-Management-Resources "Wiki - Management Resources"
[wiki_connectivity_resources]:                ./%5BUser-Guide%5D-Connectivity-Resources "Wiki - Connectivity Resources"
[wiki_identity_resources]:                    ./%5BUser-Guide%5D-Identity-Resources "Wiki - Identity Resources"

[azurerm_client_config]: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config "Data Source: azurerm_client_config"