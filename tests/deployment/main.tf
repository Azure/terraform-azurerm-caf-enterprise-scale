terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.34.0"
    }
  }
}

provider "azurerm" {
  features {}
}
