# Configure the minimum required providers supported by this module
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.18.0"
      configuration_aliases = [
        azurerm.connectivity,
        azurerm.management,
      ]
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.7.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.1.0"
    }
  }
  /*backend "local" {
    path = "./tfstate/test_framework.tfstate"
  }*/
   
terraform {
  backend "azurerm" {
    resource_group_name      = "rg-tfstate-ohit"
    storage_account_name     = "tfstateohit"
    container_name           = "tfstorage"
    key                      = "terraform.tfstate"
  }
}
  required_version = ">= 0.15.1"
}
