terraform {
  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "2.3.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.26.0" # Consider specifying a more precise version
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = getenv("ARM_SUBSCRIPTION_ID") # Or a variable: var.subscription_id
}

provider "azapi" {}

provider "azurerm" {
  features {}

  alias           = "connectivity"
  subscription_id = getenv("ARM_SUBSCRIPTION_ID_CONNECTIVITY") # Or a specific variable
}

provider "azurerm" {
  features {}

  alias           = "management"
  subscription_id = getenv("ARM_SUBSCRIPTION_ID_MANAGEMENT") # Or a specific variable
}