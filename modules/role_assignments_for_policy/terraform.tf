# Configure the minimum required providers supported by this module
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      verison = ">= 3.19.0"
    }
  }

  required_version = ">= 1.3.1"
}
