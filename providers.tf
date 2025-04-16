# providers.tf

provider "azurerm" {
  features {}

  alias           = "connectivity"
  subscription_id = getenv("ARM_SUBSCRIPTION_ID")
}

provider "azurerm" {
  features {}

  alias           = "management"
  subscription_id = getenv("ARM_SUBSCRIPTION_ID")
}