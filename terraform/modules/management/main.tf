# Configure required providers for this module
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
      configuration_aliases = [azurerm.management, azurerm.subscription]
    }
    azapi = {source = "azure/azapi", version = "~>1.0"}
  }
}
# No resources deployed by this module so this file is here as an entry point only
# Please navigate the variables, locals and outputs to see how the data model is generated from the inputs