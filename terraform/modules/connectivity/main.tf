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
  backend "local" {}
}

# ---------------------------------------------------------------------------------------------------------------------
# PROVIDER CONFIGURATION
# Configuration for the AzureRM Provider
# ---------------------------------------------------------------------------------------------------------------------
provider "azurerm" {
  features {}
  subscription_id = var.root_parent_subscription_id
  alias           = "root"
}

provider "azurerm" {
  features {}
  subscription_id = var.connectivity_subscription_id
  alias           = "connectivity"
}

provider "azurerm" {
  features {}
  subscription_id = var.identity_subscription_id
  alias           = "identity"
}

provider "azurerm" {
  features {}
  subscription_id = var.management_subscription_id
  alias           = "management"
}

# ---------------------------------------------------------------------------------------------------------------------
# MODULE DEFINITION
# Define the module and specify the source and version.
# ---------------------------------------------------------------------------------------------------------------------

module "core_resources" {
  source  = "Azure/caf-terraform-landingzones-core"
  version = "6.2.1"

  # Input variables:
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
  default_location            = var.default_location
  deploy_root_keyvault        = var.deploy_root_keyvault
  enable_default_telemetry    = var.enable_default_telemetry
  subscription_display_names  = var.subscription_display_names
  subscription_ids            = var.subscription_ids
  use_existing_management_groups = var.use_existing_management_groups
}

module "connectivity_resources" {
  source  = "Azure/caf-terraform-landingzones-connectivity"
  version = "6.2.1"

  # Input variables:
  connectivity_subscription_id = var.connectivity_subscription_id
  location                     = var.default_location
  default_location             = var.default_location
  enable_default_telemetry     = var.enable_default_telemetry
  firewall_deployment         = var.firewall_deployment
  firewall_sku                 = var.firewall_sku
  firewall_threat_intelligence_mode = var.firewall_threat_intelligence_mode
  hub_address_prefixes         = var.hub_address_prefixes
  hub_dns_servers              = var.hub_dns_servers
  hub_name                     = var.hub_name
  resource_group_name          = module.core_resources.connectivity_resources.resource_group_name
  routetable_name              = "RouteTable"
  spoke_address_prefixes       = var.spoke_address_prefixes
  subscription_display_name  = lookup(var.subscription_display_names, "Connectivity", null)
  tags                         = var.tags
  virtual_network_name         = "vhub"

  providers = {
    azurerm              = azurerm.connectivity
    azurerm.subscription = azurerm.connectivity
  }
}

module "identity_resources" {
  source  = "Azure/caf-terraform-landingzones-identity"
  version = "6.2.1"

  # Input variables:
  default_location          = var.default_location
  enable_default_telemetry  = var.enable_default_telemetry
  identity_subscription_id  = var.identity_subscription_id
  location                  = var.default_location
  resource_group_name       = module.core_resources.identity_resources.resource_group_name
  subscription_display_name = lookup(var.subscription_display_names, "Identity", null)
  tags                      = var.tags

  providers = {
    azurerm              = azurerm.identity
    azurerm.subscription = azurerm.identity
  }
}

module "management_resources" {
  source  = "Azure/caf-terraform-landingzones-management"
  version = "6.2.1"

  # Input variables:
  configure_activity_log_alerts       = var.configure_activity_log_alerts
  configure_default_resource_locks    = var.configure_default_resource_locks
  default_location                    = var.default_location
  deploy_log_analytics                = var.deploy_log_analytics
  diagnostic_setting_name             = "default"
  enable_default_telemetry            = var.enable_default_telemetry
  location                            = var.default_location
  log_analytics_workspace_name        = "log-default-${var.default_location}"
  management_subscription_id          = var.management_subscription_id
  resource_group_name                 = module.core_resources.management_resources.resource_group_name
  subscription_display_name           = lookup(var.subscription_display_names, "Management", null)
  tags                                = var.tags
  use_existing_log_analytics_workspace = var.use_existing_log_analytics_workspace

  providers = {
    azurerm              = azurerm.management
    azurerm.subscription = azurerm.management
  }
}

module "management_group_archetypes" {
  source  = "Azure/caf-terraform-landingzones-archetypes"
  version = "6.2.1"

  # Input variables:
  archetype_config           = var.archetype_config
  archetype_config_overrides = var.archetype_config_overrides
  default_location           = var.default_location
  enable_default_telemetry   = var.enable_default_telemetry
  root_id                    = var.root_id
  root_parent_id             = var.root_parent_id
  subscription_ids           = var.subscription_ids

  providers = {
    azurerm              = azurerm.root
    azurerm.subscription = azurerm.root
  }
}