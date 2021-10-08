terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.77.0"
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
  alias = "connectivity"
  features {}
}

provider "azurerm" {
  alias = "management"
  features {}
}
