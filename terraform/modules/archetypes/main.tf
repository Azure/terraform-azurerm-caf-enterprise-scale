terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.26.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~> 2.3.0"
    }
  }
}

provider "azurerm" {
  alias = "subscription"
  features {}
}

provider "azurerm" {
  alias = "management"
}

provider "azapi" {}

module "core_resources" {
  source  = "../core"

  root_parent_id              = var.root_parent_id
  root_parent_display_name    = var.root_parent_display_name
  root_id                     = var.root_id
  root_display_name           = var.root_display_name
  platform_id                 = var.platform_id
  platform_display_name       = var.platform_display_name
  connectivity_id             = var.connectivity_id
  connectivity_display_name   = var.connectivity_display_name
  identity_id                 = var.identity_id
  identity_display_name       = var.identity_display_name
  management_id               = var.management_id
  management_display_name     = var.management_display_name
  archetype_config            = var.archetype_config
  archetype_config_overrides  = var.archetype_config_overrides
  management_subscription_id = var.management_subscription_id
  default_location            = var.default_location
  deploy_root_keyvault        = var.deploy_root_keyvault
  enable_default_telemetry    = var.enable_default_telemetry
  subscription_display_names  = var.subscription_display_names
  subscription_ids           = var.subscription_ids
  use_existing_management_groups = var.use_existing_management_groups
}

module "connectivity_resources" {
  source  = "../connectivity"

  enabled = true
  root_id = var.root_id
  subscription_id = var.connectivity_subscription_id
  settings = {
    hub_networks = [
      {
        enabled = try(var.deploy_hub_vnet, true)
        config = {
          address_space = try(var.hub_address_prefixes, null)
          location = var.default_location
        }
      }
    ]
  }
  hub_name             = try(var.hub_name, "hub")
  deploy_hub_vnet      = var.deploy_hub_vnet
  hub_address_prefixes = try(var.hub_address_prefixes, null)


  providers = {
    azurerm              = azurerm.connectivity
    azurerm.subscription = azurerm.subscription
  }
}

module "identity_resources" {
  source  = "../identity"

  root_id                  = var.root_id
  enabled                  = true

  providers = {
    azurerm              = azurerm.identity
    azurerm.subscription = azurerm.subscription
  }
}

module "management_resources" {
  source  = "../management"

  subscription_id          = var.management_subscription_id
  root_id                  = var.root_id
  enabled                  = true

  providers = {
    azurerm = azurerm.management
  }
}

module "management_group_archetypes" {
  source  = "../archetypes"

  root_id                = var.root_id
  archetype_id           = "es_root"
  scope_id               = var.root_id
  management_subscription_id = var.management_subscription_id
  connectivity_subscription_id = var.connectivity_subscription_id
  default_location = var.default_location
  parameters = {
    for k, v in var.archetype_config.parameters : k => v
  }
  access_control = {
    for k, v in var.archetype_config.access_control : k => v
  }
  library_path = var.archetype_config.library_path

  providers = {
    azurerm              = azurerm.management
    azurerm.subscription = azurerm.subscription
  }
}