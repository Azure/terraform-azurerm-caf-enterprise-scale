/* # The following locals are used to establish the subscription_id for each provider
locals {
  subscription_id_management   = coalesce(var.subscription_id_management, data.azurerm_client_config.current.subscription_id)
  subscription_id_connectivity = coalesce(var.subscription_id_connectivity, local.subscription_id_management)
}

provider "azurerm" {
  tenant_id = "7f01327e-9d29-46bb-915d-c67edf4dcf4e"
  subscription_id = "07f192e5-05e9-4c31-91a4-eabbd2be9099"
  features {}
}

provider "azurerm" {
  alias = "connectivity"
  tenant_id = "7f01327e-9d29-46bb-915d-c67edf4dcf4e"
  features {}

  subscription_id = local.subscription_id_connectivity
}

provider "azurerm" {
  alias = "management"
  tenant_id = "7f01327e-9d29-46bb-915d-c67edf4dcf4e"
  features {}

  subscription_id = local.subscription_id_management
}
/*

# When using multiple providers, you must add the required_providers block
# to declare the configuration_aliases under the Azure Provider, along with
# the source and version being used.

terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      version               = ">= 3.0.2"
      configuration_aliases = [
        azurerm.connectivity,
        azurerm.management,
      ]
    }
  }
}
*/
# Declare a standard provider block using your preferred configuration.
# This will be used for the deployment of all "Core resources".

provider "azurerm" {
 # tenant_id = "7f01327e-9d29-46bb-915d-c67edf4dcf4e"
subscription_id = "d164ebce-67e4-4ca4-85cb-6723292cf680"
  features {}
}

# Declare an aliased provider block using your preferred configuration.
# This will be used for the deployment of all "Connectivity resources" to the specified `subscription_id`.

provider "azurerm" {
  alias           = "connectivity"
 # tenant_id = "7f01327e-9d29-46bb-915d-c67edf4dcf4e"
 subscription_id = "2215c1a7-50bb-4600-b597-88216acfbeb2"
  features {}
}

# Declare a standard provider block using your preferred configuration.
# This will be used for the deployment of all "Management resources" to the specified `subscription_id`.

provider "azurerm" {
  alias           = "management"
  #tenant_id = "7f01327e-9d29-46bb-915d-c67edf4dcf4e"
  subscription_id = "ad0a120c-90cb-4850-914a-37e1fd7d689c"
  features {}
}
/*
# Map each module provider to their corresponding `azurerm` provider using the providers input object

module "caf-enterprise-scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "2.3.1"

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm.connectivity
    azurerm.management   = azurerm.management
  }

  # insert the required input variables here
} */
