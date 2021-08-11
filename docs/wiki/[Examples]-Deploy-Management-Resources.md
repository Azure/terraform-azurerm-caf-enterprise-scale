## Overview

This page describes how to deploy Enterprise-scale with the [Management resources][wiki_management_resources] created in the current Subscription context and using the default configuration settings.

In this example, we take a default configuration and make the following changes:

- Enable  `deploy_management_resources` which enable the creation of all Management resources. This includes:
  - Resource Group to contain all Management resources.
  - Log Analytics workspace to use for centralised logging.
  - Automation Account to enable additional capabilities as part of the included Solutions for Azure Monitor.
  - Recommended Solutions for Azure Monitor.
- Set the `subscription_id_management` value to ensure policies are updated with the correct values.

The module updates the `parameters` and `enforcement_mode` for a number of Policy Assignments, to enable features within Log Analytics and Sentinel including but not limited to:
- Enable monitoring for devices managed through Azure Arc;
- Enable monitoring for VMs;
- Enable monitoring for VMSS;
- Enable Azure Defender for various supported services;
- much more...

> IMPORTANT: Ensure the module version is set to the latest, and don't forget to run `terraform init` if upgrading to a later version of the module.

![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/Azure/terraform-azurerm-caf-enterprise-scale?style=flat-square)

## Example root module

To create the Management resources, `deploy_management_resources` must be set to `true`, and the `subscription_id_management` is also required.

To keep this example simple, the root module for this example is based on a single file:

**`main.tf`**

```hcl
# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used.

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.66.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# You can use the azurerm_client_config data resource to dynamically
# extract the current Tenant ID from your connection settings.

data "azurerm_client_config" "core" {}

# Call the caf-enterprise-scale module directly from the Terraform Registry
# pinning to the latest version

module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "0.4.0"

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm
    azurerm.management   = azurerm
  }

  root_parent_id = data.azurerm_client_config.core.tenant_id
  root_id        = "myorg"
  root_name      = "My Organization"

  deploy_management_resources    = true
  subscription_id_management     = data.azurerm_client_config.core.subscription_id

}
```

## **Deployed Management Groups**

![Deploy-Default-Configuration](./media/examples-deploy-default-configuration.png)

You have successfully created the default Management Group resource hierarchy, along with the recommended Azure Policy and Access control (IAM) settings for Enterprise-scale.

> TIP: The exact number of resources created depends on the module configuration, but you can expect upwards of 200 resources to be created by this module for a default installation.

## **Deployed Management resources**

*\<image coming soon\>*

You have also successfully created the default set of Management resources in your current Subscription context.

## Next steps

Go to our next example to learn how to deploy the [Management resources with custom settings][wiki_deploy_management_resources_custom].

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

[wiki_management_resources]:               ./%5BUser-Guide%5D-Management-Resources "Wiki - Management Resources"
[wiki_deploy_management_resources_custom]: ./%5BUser-Guide%5D-Deploy-Management-Resources-With-Custom-Settings "Wiki - Management Resources"
