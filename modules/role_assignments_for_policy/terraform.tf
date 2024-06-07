# Configure the minimum required providers supported by this module
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.85"
    }
  }
  required_version = "~> 1.7"
}
