# Configure the minimum required providers supported by this module
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      "<version>" # change this to your desired version, https://www.terraform.io/language/expressions/version-constraints
    }
  }

  required_version = ">= 1.3.1"
}
