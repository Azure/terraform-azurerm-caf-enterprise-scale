<!-- markdownlint-disable first-line-h1 -->
## Overview

[**configure_connectivity_resources**](#overview) [*see validation for type*](#validation) (optional)

If specified, will customize the "connectivity" landing zone settings and resources.

## Default value

<!-- markdownlint-disable-next-line no-inline-html -->
<details><summary>Click to view code...</summary>

```hcl
{
  settings = {
    hub_networks = [
      {
        enabled = true
        config = {
          address_space                = ["10.100.0.0/16", ]
          location                     = ""
          link_to_ddos_protection_plan = false
          dns_servers                  = []
          bgp_community                = ""
          subnets                      = []
          virtual_network_gateway = {
            enabled = false
            config = {
              address_prefix           = "10.100.1.0/24"
              gateway_sku_expressroute = "ErGw2AZ"
              gateway_sku_vpn          = "VpnGw3"
              advanced_vpn_settings = {
                enable_bgp                       = null
                active_active                    = null
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
                zone_3 = true
              }
            }
          }
          spoke_virtual_network_resource_ids      = []
          enable_outbound_virtual_network_peering = false
          enable_hub_network_mesh_peering         = false
        }
      },
    ]
    vwan_hub_networks = [
      {
        enabled = false
        config = {
          address_prefix = "10.200.0.0/22"
          location       = ""
          sku            = ""
          routes         = []
          expressroute_gateway = {
            enabled = false
            config = {
              scale_unit = 1
            }
          }
          vpn_gateway = {
            enabled = false
            config = {
              bgp_settings       = []
              routing_preference = ""
              scale_unit         = 1
            }
          }
          azure_firewall = {
            enabled = false
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
                zone_3 = true
              }
            }
          }
          spoke_virtual_network_resource_ids        = []
          secure_spoke_virtual_network_resource_ids = []
          enable_virtual_hub_connections            = false
        }
      },
    ]
    ddos_protection_plan = {
      enabled = false
      config = {
        location = ""
      }
    }
    dns = {
      enabled = true
      config = {
        location = ""
        enable_private_link_by_service = {
          azure_api_management                 = true
          azure_app_configuration_stores       = true
          azure_arc                            = true
          azure_automation_dscandhybridworker  = true
          azure_automation_webhook             = true
          azure_backup                         = true
          azure_batch_account                  = true
          azure_bot_service_bot                = true
          azure_bot_service_token              = true
          azure_cache_for_redis                = true
          azure_cache_for_redis_enterprise     = true
          azure_container_registry             = true
          azure_cosmos_db_cassandra            = true
          azure_cosmos_db_gremlin              = true
          azure_cosmos_db_mongodb              = true
          azure_cosmos_db_sql                  = true
          azure_cosmos_db_table                = true
          azure_data_explorer                  = true
          azure_data_factory                   = true
          azure_data_factory_portal            = true
          azure_data_health_data_services      = true
          azure_data_lake_file_system_gen2     = true
          azure_database_for_mariadb_server    = true
          azure_database_for_mysql_server      = true
          azure_database_for_postgresql_server = true
          azure_digital_twins                  = true
          azure_event_grid_domain              = true
          azure_event_grid_topic               = true
          azure_event_hubs_namespace           = true
          azure_file_sync                      = true
          azure_hdinsights                     = true
          azure_iot_dps                        = true
          azure_iot_hub                        = true
          azure_key_vault                      = true
          azure_key_vault_managed_hsm          = true
          azure_kubernetes_service_management  = true
          azure_machine_learning_workspace     = true
          azure_managed_disks                  = true
          azure_media_services                 = true
          azure_migrate                        = true
          azure_monitor                        = true
          azure_purview_account                = true
          azure_purview_studio                 = true
          azure_relay_namespace                = true
          azure_search_service                 = true
          azure_service_bus_namespace          = true
          azure_site_recovery                  = true
          azure_sql_database_sqlserver         = true
          azure_synapse_analytics_dev          = true
          azure_synapse_analytics_sql          = true
          azure_synapse_studio                 = true
          azure_web_apps_sites                 = true
          azure_web_apps_static_sites          = true
          cognitive_services_account           = true
          microsoft_power_bi                   = true
          signalr                              = true
          signalr_webpubsub                    = true
          storage_account_blob                 = true
          storage_account_file                 = true
          storage_account_queue                = true
          storage_account_table                = true
          storage_account_web                  = true
        }
        private_link_locations                                 = []
        public_dns_zones                                       = []
        private_dns_zones                                      = []
        enable_private_dns_zone_virtual_network_link_on_hubs   = true
        enable_private_dns_zone_virtual_network_link_on_spokes = true
        virtual_network_resource_ids_to_link                   = []
      }
    }
  }
}
```

</details>

## Validation

Validation provided by schema:

<!-- markdownlint-disable-next-line no-inline-html -->
<details><summary>Click to view code...</summary>

```hcl
object({
  settings = optional(object({
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
              address_prefix           = optional(string, "")
              gateway_sku_expressroute = optional(string, "")
              gateway_sku_vpn          = optional(string, "")
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
                        name             = string
                        public_cert_data = string
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
              enable_dns_proxy              = optional(bool, true)
              dns_servers                   = optional(list(string), [])
              sku_tier                      = optional(string, "Standard")
              base_policy_id                = optional(string, "")
              private_ip_ranges             = optional(list(string), [])
              threat_intelligence_mode      = optional(string, "Alert")
              threat_intelligence_allowlist = optional(list(string), [])
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
          expressroute_gateway = optional(object({
            enabled = optional(bool, false)
            config = optional(object({
              scale_unit = optional(number, 1)
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
              threat_intelligence_allowlist = optional(list(string), [])
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
          azure_media_services                 = optional(bool, true)
          azure_migrate                        = optional(bool, true)
          azure_monitor                        = optional(bool, true)
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
  }), {})
  location = optional(string, "")
  tags     = optional(any, {})
  advanced = optional(any, {})
})
```

</details>

## Usage

Configure resources for the `connectivity` landing zone.
This is sub divided into configuration objects for the following:

- [Configure hub networks (Hub and Spoke)](#configure-hub-networks-hub-and-spoke)
- [Configure hub networks (Virtual WAN)](#configure-hub-networks-virtual-wan)
- [Configure DDoS protection plan](#configure-ddos-protection-plan)
- [Configure DNS](#configure-dns)
- [Additional settings](#additional-settings)

> **NOTE:**
> For consistency across the module, each configuration object includes an `enabled` attribute to enable and disable individual instances, and a `config` object to configure individual settings.
> This pattern is repeated for dependent resources (*such as virtual network gateways, firewalls, etc.*).
> For a specific dependent resource to be deployed, all parent `enabled` attributes must be set to `true`, including the `deploy_connectivity_resources` input variable.
> In some cases, other attributes must also be set for the resource to deploy.

### Configure hub networks (Hub and Spoke)

The `settings.hub_network[]` list allows defining zero or more hub networks based on a [traditional Azure networking topology (hub and spoke)][wiki_connectivity_resources_hub_and_spoke].
Each object added to the list creates a new hub network and associated resources.

> **NOTE**:
> When creating multiple hub networks, each `hub_network` must be configured to deploy to a unique `location` per module declaration.
> This is because the module uses the `location` field to ensure uniqueness of resource names.
> To deploy multiple hub networks to the same location, you must use multiple module declarations using a unique prefix (*typically set with the top-level `root_id` input variable*).

Each `hub_network` entry contains configuration settings for all hub network resources, including:

- Virtual network settings
- Virtual network gateway settings for ExpressRoute and VPN options
- Firewall settings
- etc.

For more information, see our guidance on configuring the [configure_connectivity_resources.settings.hub_networks][wiki_hub_networks_variable] input.

### Configure hub networks (Virtual WAN)

The `settings.vwan_hub_network[]` list allows defining zero or more hub networks based on a [Virtual WAN network topology (Microsoft-managed)][wiki_connectivity_resources_virtual_wan].
Each object added to the list creates a new hub network and associated resources.

> **NOTE**:
> When creating multiple hub networks, each `vwan_hub_network` must be configured to deploy to a unique `location` per module declaration.
> This is because the module uses the `location` field to ensure uniqueness of resource names.
> To deploy multiple hub networks to the same location, you must use multiple module declarations using a unique prefix (*typically set with the top-level `root_id` input variable*).

Each `vwan_hub_network` entry contains configuration settings for all hub network resources, including:

- Virtual hub settings
- Virtual network gateway settings for ExpressRoute and VPN options
- Firewall settings
- etc.

For more information, see our guidance on configuring the [configure_connectivity_resources.settings.vwan_hub_networks][wiki_vwan_hub_networks_variable] input.

### Configure DDoS protection plan

The `settings.ddos_protection_plan` object allows defining [DDoS protection plan settings][wiki_connectivity_resources_ddos] for the module.

The module can optionally [link virtual networks][wiki_link_virtual_networks] to the DDoS protection plan when using [hub_networks](#configure-hub-networks-hub-and-spoke).

For more information, see our guidance on configuring the [configure_connectivity_resources.settings.ddos_protection_plan][wiki_ddos_variable] input.

### Configure DNS

The `settings.dns` object allows defining [DNS settings][wiki_connectivity_resources_dns] for the module.

- Create DNS zones for Private Link by service
- Create location-specific DNS zones where needed for Private Link services
- Create custom private DNS zones
- Create custom public DNS zones
- Link DNS zones to hub and/or spoke virtual networks

For more information, see our guidance on configuring the [configure_connectivity_resources.settings.dns][wiki_dns_variable] input.

### Additional settings

The following additional settings can be used to set configuration on all connectivity resources:

#### `settings.location`

Set the location/region where the connectivity resources are created.
Changing this forces new resources to be created.

By default, leaving an empty value in the `location` field will deploy all connectivity resources in either the location inherited from the top-level variable `default_location`, or from a more specific `location` value if set at a lower scope.

Location can also be overridden for individual resources using the [advanced](#settingsadvanced) input.

#### `settings.tags`

Set additional tags for all connectivity resources.
Tags are appended to those inherited from the top-level variable `default_tags`.

```hcl
tags = {
  MyTag  = "MyValue"
  MyTag2 = "MyValue2"
}
```

> **NOTE:**
> The inherited tags will include those set by the module, unless [disable_base_module_tags][wiki_disable_base_module_tags] is set to `true`.

#### `settings.advanced`

The `advanced` block provides a way to manipulate almost any setting on any connectivity resource created by the module.
This is currently undocumented and only intended for experienced users.

> :warning: **WARNING**
>
> Although the `advanced` block has now evolved to a stable state, we recommend that customers use this with caution as it is not officially supported.
> The long awaited GA release of the `optional()` feature is expected in Terraform `v1.3`.
> This is likely to be used to supplement or replace the `advanced` input in release `v3.0.0` of the module.

See [Using the Advanced Block with connectivity resources][wiki_connectivity_advanced_block] page for more information.

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

[wiki_ddos_variable]:                        %5BVariables%5D-configure_connectivity_resources.settings.ddos_protection_plan "Wiki - configure_connectivity_resources settings ddos"
[wiki_dns_variable]:                         %5BVariables%5D-configure_connectivity_resources.settings.dns "Wiki - configure_connectivity_resources settings dns"
[wiki_hub_networks_variable]:                %5BVariables%5D-configure_connectivity_resources.settings.hub_networks "Wiki - configure_connectivity_resources settings hub_networks"
[wiki_vwan_hub_networks_variable]:           %5BVariables%5D-configure_connectivity_resources.settings.vwan_hub_networks "Wiki - configure_connectivity_resources settings vwan_hub_networks"
[wiki_link_virtual_networks]:                %5BVariables%5D-configure_connectivity_resources.settings.hub_networks#configlinktoddosprotectionplan "Wiki - configure_connectivity_resources settings hub_networks config linktoddosprotectionplan"
[wiki_disable_base_module_tags]:             %5BVariables%5D-disable_base_module_tags "Instructions for how to use the disable_base_module_tags variable."
[wiki_connectivity_advanced_block]:          %5BVariables%5D-configure_connectivity_resources_advanced "Using the advanced block with connectivity resources"
[wiki_connectivity_resources_hub_and_spoke]: %5BUser-Guide%5D-Connectivity-Resources#traditional-azure-networking-topology-hub-and-spoke "Wiki - Connectivity resources - Traditional Azure networking topology (hub and spoke)"
[wiki_connectivity_resources_virtual_wan]:   %5BUser-Guide%5D-Connectivity-Resources#virtual-wan-network-topology-microsoft-managed "Wiki - Connectivity resources - Virtual WAN network topology (Microsoft-managed)"
[wiki_connectivity_resources_ddos]:          %5BUser-Guide%5D-Connectivity-Resources#ddos-protection-plan "Wiki - Connectivity resources - DDoS Protection plan"
[wiki_connectivity_resources_dns]:           %5BUser-Guide%5D-Connectivity-Resources#dns "Wiki - Connectivity resources - DNS"
