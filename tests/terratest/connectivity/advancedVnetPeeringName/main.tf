terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.19.0"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

data "azurerm_client_config" "default" {}

locals {
  default_location       = "northeurope"
  spoke_vnet_resource_id = "/subscriptions/${data.azurerm_client_config.default.subscription_id}/resourceGroups/test-advancedVnetPeeringName/providers/Microsoft.Network/virtualNetworks/spoke-vnet"
}

resource "azurerm_resource_group" "test" {
  name     = "test-advancedVnetPeeringName"
  location = local.default_location
}

# This virtual network is the spoke to whihc we will create the peering
resource "azurerm_virtual_network" "test" {
  name                = "spoke-vnet"
  resource_group_name = azurerm_resource_group.test.name
  location            = azurerm_resource_group.test.location
  address_space       = ["10.99.0.0/16"]
}

# Configure ethe module to only deploy a hub network and a peering,
# using the advanced block to change the name of the peering
module "test_core" {
  source = "../../../../"
  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm
    azurerm.management   = azurerm
  }
  depends_on = [
    azurerm_virtual_network.test
  ]
  deploy_core_landing_zones     = false
  root_parent_id                = "none"
  disable_telemetry             = true
  deploy_connectivity_resources = true
  default_location              = local.default_location
  subscription_id_connectivity  = data.azurerm_client_config.default.subscription_id
  configure_connectivity_resources = {
    settings = {
      hub_networks = [
        {
          enabled = true
          config = {
            address_space = ["10.100.0.0/22", ]
            spoke_virtual_network_resource_ids = [
              local.spoke_vnet_resource_id
            ]
            enable_outbound_virtual_network_peering = true
          }
        }
      ]
      dns = {
        enabled = false
      }
    }
    advanced = var.test_advanced_name ? {
      custom_settings_by_resource_type = {
        azurerm_virtual_network_peering = {
          connectivity = {
            northeurope = {
              (local.spoke_vnet_resource_id) = {
                name = "test"
              }
            }
          }
        }
      }
    } : null
  }
}
