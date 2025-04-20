terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0, <= 4.26.0"
    }
  }
}

provider "azurerm" {
    alias = "management"
    features {}
    }

# Need to consider remediation steps for Landing Zones once deploy_management_resources has been run, for example:
# - remediate_vm_monitoring   = bool
# - remediate_vmss_monitoring = bool