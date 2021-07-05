terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.63.0"
      configuration_aliases = [
        azurerm.connectivity,
        azurerm.management,
      ]
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias = "management"
  features {}
}

provider "azurerm" {
  alias = "connectivity"
  features {}
}
