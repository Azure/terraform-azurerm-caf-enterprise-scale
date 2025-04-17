# No resources deployed by this module so this file is here as an entry point only
# Please navigate the variables, locals and outputs to see how the data model is generated from the inputs


terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm" # Or your preferred azurerm source
      version = "~> 3.0"         # Or your preferred azurerm version
    }
    azapi = {
      source  = "azure/azapi"
      version = "~> 1.0"
    }
  }
}

provider "azurerm" {
  alias = "root"
  features {}
}

provider "azurerm" {
  alias = "subscription"
  features {}
  // ... other configuration if needed
}

# Remove this line:
# provider "azapi" {}