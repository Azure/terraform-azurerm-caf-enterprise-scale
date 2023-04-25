# Configure the connectivity resources settings.
locals {
  configure_connectivity_resources = {
    settings = {
      hub_networks = [
        {
          enabled = true
          config = {
            address_space                = ["10.100.0.0/22", ]
            location                     = var.primary_location
            link_to_ddos_protection_plan = false
            dns_servers                  = []
            bgp_community                = ""
            subnets                      = []
            virtual_network_gateway = {
              enabled = true
              config = {
                address_prefix           = "10.100.1.0/24"
                gateway_sku_expressroute = "ErGw1AZ"
                gateway_sku_vpn          = "VpnGw2AZ"
                advanced_vpn_settings = {
                  enable_bgp                       = true
                  active_active                    = true
                  private_ip_address_allocation    = "Dynamic"
                  default_local_network_gateway_id = ""
                  vpn_client_configuration         = []
                  bgp_settings                     = []
                  custom_route                     = []
                }
              }
            }
            azure_firewall = {
              enabled = true
              config = {
                address_prefix                = "10.100.0.0/24"
                enable_dns_proxy              = true
                dns_servers                   = []
                sku_tier                      = ""
                base_policy_id                = ""
                private_ip_ranges             = []
                threat_intelligence_mode      = ""
                threat_intelligence_allowlist = []
                availability_zones = {
                  zone_1 = true
                  zone_2 = true
                  zone_3 = false
                }
              }
            }
            spoke_virtual_network_resource_ids      = []
            enable_outbound_virtual_network_peering = false
            enable_hub_network_mesh_peering         = true
          }
        },
        {
          enabled = true
          config = {
            address_space = ["10.101.0.0/22", ]
            location      = var.secondary_location
            virtual_network_gateway = {
              enabled = true
              config = {
                address_prefix  = "10.101.1.0/24"
                gateway_sku_vpn = "VpnGw1"
              }
            }
            azure_firewall = {
              enabled = false
            }
            spoke_virtual_network_resource_ids      = []
            enable_outbound_virtual_network_peering = false
            enable_hub_network_mesh_peering         = true
          }
        },
        {
          enabled = true
          config = {
            address_space                = ["10.102.0.0/22", ]
            location                     = var.tertiary_location
            link_to_ddos_protection_plan = false
            dns_servers                  = []
            bgp_community                = ""
            subnets                      = []
            azure_firewall = {
              enabled = true
              config = {
                address_prefix                = "10.102.0.0/24"
                address_management_prefix     = "10.102.1.0/24"
                enable_dns_proxy              = true
                dns_servers                   = []
                sku_tier                      = "Basic"
                base_policy_id                = ""
                private_ip_ranges             = []
                threat_intelligence_mode      = ""
                threat_intelligence_allowlist = []
                availability_zones = {
                  zone_1 = true
                  zone_2 = true
                  zone_3 = false
                }
              }
            }
            spoke_virtual_network_resource_ids      = []
            enable_outbound_virtual_network_peering = false
            enable_hub_network_mesh_peering         = true
          }
        },
        # The following hub_network entry is used to ensure
        # correct operation of logic for creating virtual network
        # peerings and DNS links when in a disabled state.
        # Should not create any resources.
        {
          enabled = false
          config = {
            address_space                           = ["10.102.0.0/22", ]
            location                                = "fake_location"
            spoke_virtual_network_resource_ids      = ["/subscriptions/subId/fake_spoke_virtual_network_resource_id"]
            enable_outbound_virtual_network_peering = true
            enable_hub_network_mesh_peering         = true
          }
        },
      ]
      vwan_hub_networks = [
        {
          enabled = true
          config = {
            address_prefix = "10.200.0.0/22"
            location       = var.primary_location
            sku            = ""
            routes         = []
            expressroute_gateway = {
              enabled = true
              config = {
                scale_unit = 1
              }
            }
            vpn_gateway = {
              enabled = true
              config = {
                bgp_settings       = []
                routing_preference = ""
                scale_unit         = 1
              }
            }
            azure_firewall = {
              enabled = true
              config = {
                enable_dns_proxy              = false
                dns_servers                   = []
                sku_tier                      = "Standard"
                base_policy_id                = ""
                private_ip_ranges             = []
                threat_intelligence_mode      = ""
                threat_intelligence_allowlist = []
                availability_zones = {
                  zone_1 = true
                  zone_2 = true
                  zone_3 = false
                }
              }
            }
            spoke_virtual_network_resource_ids        = []
            secure_spoke_virtual_network_resource_ids = []
            enable_virtual_hub_connections            = true
          }
        },
        {
          enabled = true
          config = {
            address_prefix                            = "10.201.0.0/22"
            location                                  = var.secondary_location
            spoke_virtual_network_resource_ids        = []
            secure_spoke_virtual_network_resource_ids = []
            enable_virtual_hub_connections            = true
          }
        },
        # The following virtual_hub_network entry is used to ensure
        # correct operation of logic for creating virtual hub
        # connections and DNS links when in a disabled state.
        # Should not create any resources.
        {
          enabled = false
          config = {
            address_prefix                            = "10.202.0.0/22"
            location                                  = "fake_location"
            spoke_virtual_network_resource_ids        = ["/subscriptions/subId/fake_spoke_virtual_network_resource_id"]
            secure_spoke_virtual_network_resource_ids = ["/subscriptions/subId/fake_secure_spoke_virtual_network_resource_id"]
            enable_virtual_hub_connections            = true
          }
        },
      ]
      ddos_protection_plan = {
        enabled = false
      }
      dns = {
        enabled = true
        config = {
          enable_private_link_by_service = {
            # The following DNS zones are disabled in the test suite to test
            # functionality but also because these do not currently have
            # corresponding built-in policy definitions.
            azure_api_management                 = false
            azure_arc                            = false
            azure_backup                         = false
            azure_bot_service_bot                = false
            azure_bot_service_token              = false
            azure_cache_for_redis_enterprise     = false
            azure_data_explorer                  = false
            azure_data_health_data_services      = false
            azure_data_lake_file_system_gen2     = false
            azure_database_for_mariadb_server    = false
            azure_database_for_mysql_server      = false
            azure_database_for_postgresql_server = false
            azure_digital_twins                  = false
            azure_key_vault_managed_hsm          = false
            azure_kubernetes_service_management  = false
            azure_purview_account                = false
            azure_purview_studio                 = false
            azure_relay_namespace                = false
            azure_sql_database_sqlserver         = false
            azure_synapse_analytics_dev          = false
            azure_synapse_analytics_sql          = false
            azure_synapse_studio                 = false
            azure_web_apps_static_sites          = false
            microsoft_power_bi                   = false
          }
          private_link_locations = []
          public_dns_zones       = []
          private_dns_zones = [
            "privatelink.blob.core.windows.net", # To test de-duplication of custom specified DNS zones as per issue #577
          ]
          enable_private_dns_zone_virtual_network_link_on_hubs   = true
          enable_private_dns_zone_virtual_network_link_on_spokes = true
          virtual_network_resource_ids_to_link                   = []
        }
      }
    }
    advanced = {
      custom_settings_by_resource_type = {
        azurerm_firewall_policy = {
          connectivity = {
            (var.primary_location) = {
              sql_redirect_allowed = false
            }
          }
        }
      }
    }
  }
}
