# No resources deployed by this module so this file is here as an entry point only
# Please navigate the variables, locals and outputs to see how the data model is generated from the inputs

# Need to consider remediation steps for Landing Zones once deploy_management_resources has been run, for example:
# - remediate_vm_monitoring   = bool
# - remediate_vmss_monitoring = bool


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
  alias = "management"
  features {}
}

provider "azurerm" {
  alias = "subscription"
  features {}
  subscription_id = var.subscription_id_management
}

provider "azapi" {}