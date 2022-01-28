terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.83.0"
      configuration_aliases = [
        azurerm.connectivity,
        azurerm.management,
      ]
    }
  }
  backend "local" {
    path = "../tfstate/test_framework.tfstate"
  }
}
