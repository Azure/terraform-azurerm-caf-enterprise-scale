terraform
# providers.tf

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0" # or the latest version you are using
    }
  }
}

provider "azurerm" {
  features {}

  alias           = "connectivity"
  subscription_id = var.subscription_id
}

provider "azurerm" {
  features {}

  alias           = "management"
  subscription_id = var.subscription_id
}

variable "subscription_id" {
  type = string
  default = env("ARM_SUBSCRIPTION_ID")
}