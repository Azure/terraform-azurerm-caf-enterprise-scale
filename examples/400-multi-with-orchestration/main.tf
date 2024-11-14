# Configure Terraform to set the required AzureRM provider
# version and features{} block

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.107"
    }
  }
}

# Define the provider configuration

provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias           = "connectivity"
  subscription_id = local.subscription_id_connectivity
  features {}
}

# Get the current client configuration from the AzureRM provider

data "azurerm_client_config" "current" {}

# Logic to handle 1-3 platform subscriptions as available

locals {
  subscription_id_connectivity = coalesce(var.subscription_id_connectivity, local.subscription_id_management)
  subscription_id_identity     = coalesce(var.subscription_id_identity, local.subscription_id_management)
  subscription_id_management   = coalesce(var.subscription_id_management, data.azurerm_client_config.current.subscription_id)
}

# The following module declarations act to orchestrate the
# independently defined module instances for core,
# connectivity and management resources

module "connectivity" {
  source = "./modules/connectivity"

  connectivity_resources_tags  = var.connectivity_resources_tags
  enable_ddos_protection       = var.enable_ddos_protection
  primary_location             = var.primary_location
  root_id                      = var.root_id
  secondary_location           = var.secondary_location
  subscription_id_connectivity = local.subscription_id_connectivity
}

module "management" {
  source = "./modules/management"

  email_security_contact     = var.email_security_contact
  log_retention_in_days      = var.log_retention_in_days
  management_resources_tags  = var.management_resources_tags
  primary_location           = var.primary_location
  root_id                    = var.root_id
  subscription_id_management = local.subscription_id_management
}

module "core" {
  source = "./modules/core"

  configure_connectivity_resources = module.connectivity.configuration
  configure_management_resources   = module.management.configuration
  primary_location                 = var.primary_location
  root_id                          = var.root_id
  root_name                        = var.root_name
  secondary_location               = var.secondary_location
  subscription_id_connectivity     = local.subscription_id_connectivity
  subscription_id_identity         = local.subscription_id_identity
  subscription_id_management       = local.subscription_id_management
  template_file_variables = {
    userAssignedIdentities = {
      "Deploy-VMSS-Monitoring" = [
        "/subscriptions/${local.subscription_id_connectivity}/resourceGroups/${azurerm_resource_group.uami.name}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${azurerm_user_assigned_identity.uami1.name}"
      ]
    }
  }
}

resource "azurerm_resource_group" "uami" {
  provider = azurerm.connectivity
  name     = "rg-uami-01"
  location = var.primary_location
}

resource "azurerm_user_assigned_identity" "uami1" {
  provider            = azurerm.connectivity
  location            = azurerm_resource_group.uami.location
  name                = "uami-01"
  resource_group_name = azurerm_resource_group.uami.name
}
