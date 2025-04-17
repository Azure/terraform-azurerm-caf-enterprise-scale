# providers.tf

terraform {
  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "2.3.0"
    }
  }
}

provider "azapi" {}

provider "azurerm" {
  features {}

  alias           = "connectivity"
  subscription_id = getenv("ARM_SUBSCRIPTION_ID")
}

provider "azurerm" {
  features {}

  alias           = "management"
  subscription_id = getenv("ARM_SUBSCRIPTION_ID")
}