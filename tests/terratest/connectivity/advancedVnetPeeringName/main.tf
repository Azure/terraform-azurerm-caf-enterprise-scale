terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {}
}

variable "test_advanced_name" {
  type = bool
  default = false
  description = "Enables the advanced block, changing the name of the peering"
}

data "azurerm_client_config" "default" {}

locals {
  default_location = "northeurope"
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
            address_space                = ["10.100.0.0/22", ]
            location                     = ""
            link_to_ddos_protection_plan = false
            dns_servers                  = []
            bgp_community                = ""
            subnets                      = []
            virtual_network_gateway = {
              enabled = false
              config = {
                address_prefix           = ""
                gateway_sku_expressroute = ""
                gateway_sku_vpn          = ""
                advanced_vpn_settings = {
                  enable_bgp                       = false
                  active_active                    = false
                  private_ip_address_allocation    = ""
                  default_local_network_gateway_id = ""
                  vpn_client_configuration         = []
                  bgp_settings                     = []
                  custom_route                     = []
                }
              }
            }
            azure_firewall = {
              enabled = false
              config = {
                address_prefix                = ""
                enable_dns_proxy              = false
                dns_servers                   = []
                sku_tier                      = ""
                base_policy_id                = ""
                private_ip_ranges             = []
                threat_intelligence_mode      = ""
                threat_intelligence_allowlist = []
                availability_zones = {
                  zone_1 = true
                  zone_2 = true
                  zone_3 = true
                }
              }
            }
            spoke_virtual_network_resource_ids = [
              local.spoke_vnet_resource_id
            ]
            enable_outbound_virtual_network_peering = true
          }
        }
      ]
      vwan_hub_networks = []
      ddos_protection_plan = {
        enabled = false
        config = {
          location = local.default_location
        }
      }
      dns = {
        enabled = false
        config = {
          location = null
          enable_private_link_by_service = {
            azure_automation_webhook             = false
            azure_automation_dscandhybridworker  = false
            azure_sql_database_sqlserver         = false
            azure_synapse_analytics_sqlserver    = false
            azure_synapse_analytics_sql          = false
            storage_account_blob                 = false
            storage_account_table                = false
            storage_account_queue                = false
            storage_account_file                 = false
            storage_account_web                  = false
            azure_data_lake_file_system_gen2     = false
            azure_cosmos_db_sql                  = false
            azure_cosmos_db_mongodb              = false
            azure_cosmos_db_cassandra            = false
            azure_cosmos_db_gremlin              = false
            azure_cosmos_db_table                = false
            azure_database_for_postgresql_server = false
            azure_database_for_mysql_server      = false
            azure_database_for_mariadb_server    = false
            azure_key_vault                      = false
            azure_kubernetes_service_management  = false
            azure_search_service                 = false
            azure_container_registry             = false
            azure_app_configuration_stores       = false
            azure_backup                         = false
            azure_site_recovery                  = false
            azure_event_hubs_namespace           = false
            azure_service_bus_namespace          = false
            azure_iot_hub                        = false
            azure_relay_namespace                = false
            azure_event_grid_topic               = false
            azure_event_grid_domain              = false
            azure_web_apps_sites                 = false
            azure_machine_learning_workspace     = false
            signalr                              = false
            azure_monitor                        = false
            cognitive_services_account           = false
            azure_file_sync                      = false
            azure_data_factory                   = false
            azure_data_factory_portal            = false
            azure_cache_for_redis                = false
          }
          private_link_locations                                 = []
          public_dns_zones                                       = []
          private_dns_zones                                      = []
          enable_private_dns_zone_virtual_network_link_on_hubs   = false
          enable_private_dns_zone_virtual_network_link_on_spokes = false
        }
      }
    }
    location = null
    tags     = null
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
