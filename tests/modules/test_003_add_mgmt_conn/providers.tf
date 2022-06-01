# The following locals are used to establish the subscription_id for each provider
locals {
  subscription_id_management   = coalesce(var.subscription_id_management, data.azurerm_client_config.current.subscription_id)
  subscription_id_connectivity = coalesce(var.subscription_id_connectivity, local.subscription_id_management)
}

provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias = "connectivity"
  features {}

  subscription_id = local.subscription_id_connectivity
}

provider "azurerm" {
  alias = "management"
  features {}

  subscription_id = local.subscription_id_management
}
