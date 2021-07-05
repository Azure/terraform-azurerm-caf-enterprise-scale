# Configure the minimum required providers supported by this module
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.63.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.7.0"
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
