terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.63.0"
    }
  }
}

provider "azurerm" {
  alias = "management"
  features {}
}

provider "azurerm" {
  alias = "connectivity"
  features {}
}
