terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ""
    }
  }
}

provider "azurerm" {
  features {}
}
