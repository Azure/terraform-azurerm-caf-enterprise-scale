# Configure the Azure provider to allow for multiple subscription or tenant deployments
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
      configuration_aliases = [azurerm.connectivity, azurerm.subscription]
    }
    azapi = {
        source = "Azure/azapi"
        version = ">=1.4.0"
    }
  }
}
# No resources deployed by this module so this file is here as an entry point only
# Please navigate the variables, locals and outputs to see how the data model is generated from the inputs