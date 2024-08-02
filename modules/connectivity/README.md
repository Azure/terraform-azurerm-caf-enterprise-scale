<!-- BEGIN_TF_DOCS -->
# Connectivity sub-module

## Documentation
<!-- markdownlint-disable MD033 -->

## Requirements

No requirements.

## Modules

No modules.

<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD034 -->
## Required Inputs

The following input variables are required:

### <a name="input_enabled"></a> [enabled](#input\_enabled)

Description: Controls whether to manage the connectivity landing zone policies and deploy the connectivity resources into the current Subscription context.

Type: `bool`

### <a name="input_root_id"></a> [root\_id](#input\_root\_id)

Description: Specifies the ID of the Enterprise-scale root Management Group, used as a prefix for resources created by this module.

Type: `string`

### <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id)

Description: Specifies the Subscription ID for the Subscription containing all connectivity resources.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_custom_azure_backup_geo_codes"></a> [custom\_azure\_backup\_geo\_codes](#input\_custom\_azure\_backup\_geo\_codes)

Description: If specified, the custom\_azure\_backup\_geo\_codes variable will override or append Geo Codes (value) used to generate region-specific DNS zone names for Azure Backup private endpoints.  
For more information, please refer to: https://learn.microsoft.com/azure/backup/private-endpoints#when-using-custom-dns-server-or-host-files

Type: `map(string)`

Default: `{}`

### <a name="input_custom_privatelink_azurestaticapps_partitionids"></a> [custom\_privatelink\_azurestaticapps\_partitionids](#input\_custom\_privatelink\_azurestaticapps\_partitionids)

Description: As a uncertanty in the partition id for the azure static web app, this variable is used to specify the partition ids deployed for the azure static web app private DNS zones.  
For more information, please refer to: https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-dns#web and https://learn.microsoft.com/en-us/azure/static-web-apps/private-endpoint

Type: `list(number)`

Default:

```json
[
  1,
  2,
  3,
  4,
  5
]
```

### <a name="input_custom_settings_by_resource_type"></a> [custom\_settings\_by\_resource\_type](#input\_custom\_settings\_by\_resource\_type)

Description: If specified, allows full customization of common settings for all resources (by type) deployed by this module.

Type: `any`

Default: `{}`

### <a name="input_existing_ddos_protection_plan_resource_id"></a> [existing\_ddos\_protection\_plan\_resource\_id](#input\_existing\_ddos\_protection\_plan\_resource\_id)

Description: If specified, module will skip creation of DDoS Protection Plan and use existing.

Type: `string`

Default: `""`

### <a name="input_existing_virtual_wan_resource_group_name"></a> [existing\_virtual\_wan\_resource\_group\_name](#input\_existing\_virtual\_wan\_resource\_group\_name)

Description: If specified, module will skip creation of the Virtual WAN resource group and use existing. All Virtual Hubs created by the module will be created in the specified Virtual WAN resource group.

Type: `string`

Default: `""`

### <a name="input_existing_virtual_wan_resource_id"></a> [existing\_virtual\_wan\_resource\_id](#input\_existing\_virtual\_wan\_resource\_id)

Description: If specified, module will skip creation of the Virtual WAN and use existing. All Virtual Hubs created by the module will be associated with the specified Virtual WAN.

Type: `string`

Default: `""`

### <a name="input_location"></a> [location](#input\_location)

Description: Sets the default location used for resource deployments where needed.

Type: `string`

Default: `"eastus"`

### <a name="input_resource_group_per_virtual_hub_location"></a> [resource\_group\_per\_virtual\_hub\_location](#input\_resource\_group\_per\_virtual\_hub\_location)

Description: If set to true, module will place each Virtual Hub (and associated resources) in a location-specific Resource Group. Default behaviour is to colocate Virtual Hub resources in the same Resource Group as the Virtual WAN resource.

Type: `bool`

Default: `false`

### <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix)

Description: If specified, will set the resource name prefix for connectivity resources (default value determined from "var.root\_id").

Type: `string`

Default: `""`

### <a name="input_resource_suffix"></a> [resource\_suffix](#input\_resource\_suffix)

Description: If specified, will set the resource name suffix for connectivity resources.

Type: `string`

Default: `""`

### <a name="input_settings"></a> [settings](#input\_settings)

Description: If specified, will customize the "Connectivity" landing zone settings and resources.

Type:

```hcl
object({
    hub_networks = optional(list(
      object({
        enabled = optional(bool, true)
        config = object({
          address_space                = list(string)
          location                     = optional(string, "")
          link_to_ddos_protection_plan = optional(bool, false)
          dns_servers                  = optional(list(string), [])
          bgp_community                = optional(string, "")
          subnets = optional(list(
            object({
              name                      = string
              address_prefixes          = list(string)
              network_security_group_id = optional(string, "")
              route_table_id            = optional(string, "")
            })
          ), [])
          virtual_network_gateway = optional(object({
            enabled = optional(bool, false)
            config = optional(object({
              address_prefix              = optional(string, "")
              gateway_sku_expressroute    = optional(string, "")
              gateway_sku_vpn             = optional(string, "")
              remote_vnet_traffic_enabled = optional(bool, false)
              virtual_wan_traffic_enabled = optional(bool, false)
              advanced_vpn_settings = optional(object({
                enable_bgp                       = optional(bool, null)
                active_active                    = optional(bool, null)
                private_ip_address_allocation    = optional(string, "")
                default_local_network_gateway_id = optional(string, "")
                vpn_client_configuration = optional(list(
                  object({
                    address_space = list(string)
                    aad_tenant    = optional(string, null)
                    aad_audience  = optional(string, null)
                    aad_issuer    = optional(string, null)
                    root_certificate = optional(list(
                      object({
                        name             = string
                        public_cert_data = string
                      })
                    ), [])
                    revoked_certificate = optional(list(
                      object({
                        name       = string
                        thumbprint = string
                      })
                    ), [])
                    radius_server_address = optional(string, null)
                    radius_server_secret  = optional(string, null)
                    vpn_client_protocols  = optional(list(string), null)
                    vpn_auth_types        = optional(list(string), null)
                  })
                ), [])
                bgp_settings = optional(list(
                  object({
                    asn         = optional(number, null)
                    peer_weight = optional(number, null)
                    peering_addresses = optional(list(
                      object({
                        ip_configuration_name = optional(string, null)
                        apipa_addresses       = optional(list(string), null)
                      })
                    ), [])
                  })
                ), [])
                custom_route = optional(list(
                  object({
                    address_prefixes = optional(list(string), [])
                  })
                ), [])
              }), {})
            }), {})
          }), {})
          azure_firewall = optional(object({
            enabled = optional(bool, false)
            config = optional(object({
              address_prefix                = optional(string, "")
              address_management_prefix     = optional(string, "")
              enable_dns_proxy              = optional(bool, true)
              dns_servers                   = optional(list(string), [])
              sku_tier                      = optional(string, "Standard")
              base_policy_id                = optional(string, "")
              private_ip_ranges             = optional(list(string), [])
              threat_intelligence_mode      = optional(string, "Alert")
              threat_intelligence_allowlist = optional(map(list(string)), {})
              availability_zones = optional(object({
                zone_1 = optional(bool, true)
                zone_2 = optional(bool, true)
                zone_3 = optional(bool, true)
              }), {})
            }), {})
          }), {})
          spoke_virtual_network_resource_ids      = optional(list(string), [])
          enable_outbound_virtual_network_peering = optional(bool, false)
          enable_hub_network_mesh_peering         = optional(bool, false)
        })
      })
    ), [])
    vwan_hub_networks = optional(list(
      object({
        enabled = optional(bool, true)
        config = object({
          address_prefix = string
          location       = string
          sku            = optional(string, "")
          routes = optional(list(
            object({
              address_prefixes    = list(string)
              next_hop_ip_address = string
            })
          ), [])
          routing_intent = optional(object({
            enabled = optional(bool, false)
            config = optional(object({
              routing_policies = optional(list(object({
                name         = string
                destinations = list(string)
              })), [])
            }), {})
          }), {})
          expressroute_gateway = optional(object({
            enabled = optional(bool, false)
            config = optional(object({
              scale_unit                    = optional(number, 1)
              allow_non_virtual_wan_traffic = optional(bool, false)
            }), {})
          }), {})
          vpn_gateway = optional(object({
            enabled = optional(bool, false)
            config = optional(object({
              bgp_settings = optional(list(
                object({
                  asn         = number
                  peer_weight = number
                  instance_0_bgp_peering_address = optional(list(
                    object({
                      custom_ips = list(string)
                    })
                  ), [])
                  instance_1_bgp_peering_address = optional(list(
                    object({
                      custom_ips = list(string)
                    })
                  ), [])
                })
              ), [])
              routing_preference = optional(string, "Microsoft Network")
              scale_unit         = optional(number, 1)
            }), {})
          }), {})
          azure_firewall = optional(object({
            enabled = optional(bool, false)
            config = optional(object({
              enable_dns_proxy              = optional(bool, true)
              dns_servers                   = optional(list(string), [])
              sku_tier                      = optional(string, "Standard")
              base_policy_id                = optional(string, "")
              private_ip_ranges             = optional(list(string), [])
              threat_intelligence_mode      = optional(string, "Alert")
              threat_intelligence_allowlist = optional(map(list(string)), {})
              availability_zones = optional(object({
                zone_1 = optional(bool, true)
                zone_2 = optional(bool, true)
                zone_3 = optional(bool, true)
              }), {})
            }), {})
          }), {})
          spoke_virtual_network_resource_ids        = optional(list(string), [])
          secure_spoke_virtual_network_resource_ids = optional(list(string), [])
          enable_virtual_hub_connections            = optional(bool, false)
        })
      })
    ), [])
    ddos_protection_plan = optional(object({
      enabled = optional(bool, false)
      config = optional(object({
        location = optional(string, "")
      }), {})
    }), {})
    dns = optional(object({
      enabled = optional(bool, true)
      config = optional(object({
        location = optional(string, "")
        enable_private_link_by_service = optional(object({
          azure_api_management                 = optional(bool, true)
          azure_app_configuration_stores       = optional(bool, true)
          azure_arc                            = optional(bool, true)
          azure_arc_guest_configuration        = optional(bool, true)
          azure_arc_hybrid_resource_provider   = optional(bool, true)
          azure_arc_kubernetes                 = optional(bool, true)
          azure_automation_dscandhybridworker  = optional(bool, true)
          azure_automation_webhook             = optional(bool, true)
          azure_backup                         = optional(bool, true)
          azure_batch_account                  = optional(bool, true)
          azure_bot_service_bot                = optional(bool, true)
          azure_bot_service_token              = optional(bool, true)
          azure_cache_for_redis                = optional(bool, true)
          azure_cache_for_redis_enterprise     = optional(bool, true)
          azure_container_registry             = optional(bool, true)
          azure_cosmos_db_cassandra            = optional(bool, true)
          azure_cosmos_db_gremlin              = optional(bool, true)
          azure_cosmos_db_mongodb              = optional(bool, true)
          azure_cosmos_db_sql                  = optional(bool, true)
          azure_cosmos_db_table                = optional(bool, true)
          azure_data_explorer                  = optional(bool, true)
          azure_data_factory                   = optional(bool, true)
          azure_data_factory_portal            = optional(bool, true)
          azure_data_health_data_services      = optional(bool, true)
          azure_data_lake_file_system_gen2     = optional(bool, true)
          azure_database_for_mariadb_server    = optional(bool, true)
          azure_database_for_mysql_server      = optional(bool, true)
          azure_database_for_postgresql_server = optional(bool, true)
          azure_databricks                     = optional(bool, true)
          azure_digital_twins                  = optional(bool, true)
          azure_event_grid_domain              = optional(bool, true)
          azure_event_grid_topic               = optional(bool, true)
          azure_event_hubs_namespace           = optional(bool, true)
          azure_file_sync                      = optional(bool, true)
          azure_hdinsights                     = optional(bool, true)
          azure_iot_dps                        = optional(bool, true)
          azure_iot_hub                        = optional(bool, true)
          azure_key_vault                      = optional(bool, true)
          azure_key_vault_managed_hsm          = optional(bool, true)
          azure_kubernetes_service_management  = optional(bool, true)
          azure_machine_learning_workspace     = optional(bool, true)
          azure_managed_disks                  = optional(bool, true)
          azure_managed_grafana                = optional(bool, true)
          azure_media_services                 = optional(bool, true)
          azure_migrate                        = optional(bool, true)
          azure_monitor                        = optional(bool, true)
          azure_openai_service                 = optional(bool, true)
          azure_purview_account                = optional(bool, true)
          azure_purview_studio                 = optional(bool, true)
          azure_relay_namespace                = optional(bool, true)
          azure_search_service                 = optional(bool, true)
          azure_service_bus_namespace          = optional(bool, true)
          azure_site_recovery                  = optional(bool, true)
          azure_sql_database_sqlserver         = optional(bool, true)
          azure_synapse_analytics_dev          = optional(bool, true)
          azure_synapse_analytics_sql          = optional(bool, true)
          azure_synapse_studio                 = optional(bool, true)
          azure_virtual_desktop                = optional(bool, true)
          azure_web_apps_sites                 = optional(bool, true)
          azure_web_apps_static_sites          = optional(bool, true)
          cognitive_services_account           = optional(bool, true)
          microsoft_power_bi                   = optional(bool, true)
          signalr                              = optional(bool, true)
          signalr_webpubsub                    = optional(bool, true)
          storage_account_blob                 = optional(bool, true)
          storage_account_file                 = optional(bool, true)
          storage_account_queue                = optional(bool, true)
          storage_account_table                = optional(bool, true)
          storage_account_web                  = optional(bool, true)
        }), {})
        private_link_locations                                 = optional(list(string), [])
        public_dns_zones                                       = optional(list(string), [])
        private_dns_zones                                      = optional(list(string), [])
        enable_private_dns_zone_virtual_network_link_on_hubs   = optional(bool, true)
        enable_private_dns_zone_virtual_network_link_on_spokes = optional(bool, true)
        virtual_network_resource_ids_to_link                   = optional(list(string), [])
      }), {})
    }), {})
  })
```

Default: `{}`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: If specified, will set the default tags for all resources deployed by this module where supported.

Type: `map(string)`

Default: `{}`

## Resources

No resources.

## Outputs

The following outputs are exported:

### <a name="output_configuration"></a> [configuration](#output\_configuration)

Description: Returns the configuration settings for resources to deploy for the connectivity solution.

### <a name="output_debug"></a> [debug](#output\_debug)

Description: Returns the debug output for the module.

<!-- markdownlint-enable -->
<!-- END_TF_DOCS -->