# Configure the provider for this module, allowing it to have a different config than the root module
terraform {
  required_providers {
    azurerm = {      
      source = "hashicorp/azurerm"
      version = ">= 3.0, <= 4.26.0"
    }
  }
}

provider "azurerm" {
  alias   = "connectivity"
  features {}
}

# No resources deployed by this module so this file is here as an entry point only
# Please navigate the variables, locals and outputs to see how the data model is generated from the inputs
# No resources deployed by this module so this file is here as an entry point only
# Please navigate the variables, locals and outputs to see how the data model is generated from the inputs