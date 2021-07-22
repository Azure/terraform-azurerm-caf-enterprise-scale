# Configure the connectivity resources settings.
locals {
  configure_connectivity_resources = {
    settings = {
      hub_networks = [
        {
          enabled = true
          config = {
            address_space                = ["10.100.0.0/16", ]
            location                     = var.location
            link_to_ddos_protection_plan = false
            dns_servers                  = []
            bgp_community                = ""
            subnets                      = []
            virtual_network_gateway = {
              enabled = true
              config = {
                address_prefix           = "10.100.1.0/24"
                gateway_sku_expressroute = "ErGw2AZ"
                gateway_sku_vpn          = "VpnGw2AZ"
              }
            }
            azure_firewall = {
              enabled = true
              config = {
                address_prefix   = "10.100.0.0/24"
                enable_dns_proxy = true
                availability_zones = {
                  zone_1 = true
                  zone_2 = true
                  zone_3 = true
                }
              }
            }
            spoke_virtual_network_resource_ids      = []
            enable_outbound_virtual_network_peering = false
          }
        },
      ]
      vwan_hub_networks = []
      ddos_protection_plan = {
        enabled = false
        config = {
          location = ""
        }
      }
      dns = {
        enabled = true
        config = {
          location = null
          enable_private_link_by_service = {
            azure_automation_webhook             = false
            azure_automation_dscandhybridworker  = false
            azure_sql_database_sqlserver         = false
            azure_synapse_analytics_sqlserver    = false
            azure_synapse_analytics_sql          = false
            storage_account_blob                 = true
            storage_account_table                = true
            storage_account_queue                = true
            storage_account_file                 = true
            storage_account_web                  = true
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
            azure_backup                         = true
            azure_site_recovery                  = true
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
          enable_private_dns_zone_virtual_network_link_on_hubs   = true
          enable_private_dns_zone_virtual_network_link_on_spokes = true
        }
      }
    }

    location = null
    tags     = null
    advanced = null
  }
}
