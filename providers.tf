# The following locals are used to establish the subscription_id for each provider
locals {
  subscription_id_management   = coalesce(var.subscription_id_management, data.azurerm_client_config.current.subscription_id)
  subscription_id_connectivity = coalesce(var.subscription_id_connectivity, local.subscription_id_management)
}

provider "azurerm" {
  tenant_id = "7f01327e-9d29-46bb-915d-c67edf4dcf4e"
  subscription_id = "07f192e5-05e9-4c31-91a4-eabbd2be9099"
  features {}
}

provider "azurerm" {
  tenant_id = "7f01327e-9d29-46bb-915d-c67edf4dcf4e"
  alias = "connectivity"
  features {}

  subscription_id = local.subscription_id_connectivity
}

provider "azurerm" {
  alias = "management"
  tenant_id = "7f01327e-9d29-46bb-915d-c67edf4dcf4e"
  features {}

  subscription_id = local.subscription_id_management
}
