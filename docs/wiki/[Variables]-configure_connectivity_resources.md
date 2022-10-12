<!-- markdownlint-disable first-line-h1 -->
## Overview

[**configure_connectivity_resources**](#overview) [*see validation for type*](#Validation) (optional)

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
          spoke_virtual_network_resource_ids = []
          enable_virtual_hub_connections     = false
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
          azure_automation_webhook             = true
          azure_automation_dscandhybridworker  = true
          azure_sql_database_sqlserver         = true
          azure_synapse_analytics_sqlserver    = true
          azure_synapse_analytics_sql          = true
          storage_account_blob                 = true
          storage_account_table                = true
          storage_account_queue                = true
          storage_account_file                 = true
          storage_account_web                  = true
          azure_data_lake_file_system_gen2     = true
          azure_cosmos_db_sql                  = true
          azure_cosmos_db_mongodb              = true
          azure_cosmos_db_cassandra            = true
          azure_cosmos_db_gremlin              = true
          azure_cosmos_db_table                = true
          azure_database_for_postgresql_server = true
          azure_database_for_mysql_server      = true
          azure_database_for_mariadb_server    = true
          azure_key_vault                      = true
          azure_kubernetes_service_management  = true
          azure_search_service                 = true
          azure_container_registry             = true
          azure_app_configuration_stores       = true
          azure_backup                         = true
          azure_site_recovery                  = true
          azure_event_hubs_namespace           = true
          azure_service_bus_namespace          = true
          azure_iot_hub                        = true
          azure_relay_namespace                = true
          azure_event_grid_topic               = true
          azure_event_grid_domain              = true
          azure_web_apps_sites                 = true
          azure_machine_learning_workspace     = true
          signalr                              = true
          azure_monitor                        = true
          cognitive_services_account           = true
          azure_file_sync                      = true
          azure_data_factory                   = true
          azure_data_factory_portal            = true
          azure_cache_for_redis                = true
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
```

</details>

## Validation

Validation provided by schema:

<!-- markdownlint-disable-next-line no-inline-html -->
<details><summary>Click to view code...</summary>

```hcl
object({
  settings = object({
    hub_networks = list(
      object({
        enabled = bool
        config = object({
          address_space                = list(string)
          location                     = string
          link_to_ddos_protection_plan = bool
          dns_servers                  = list(string)
          bgp_community                = string
          subnets = list(
            object({
              name                      = string
              address_prefixes          = list(string)
              network_security_group_id = string
              route_table_id            = string
            })
          )
          virtual_network_gateway = object({
            enabled = bool
            config = object({
              address_prefix           = string
              gateway_sku_expressroute = string
              gateway_sku_vpn          = string
              advanced_vpn_settings = object({
                enable_bgp                       = bool
                active_active                    = bool
                private_ip_address_allocation    = string
                default_local_network_gateway_id = string
                vpn_client_configuration = list(
                  object({
                    address_space = list(string)
                    aad_tenant    = string
                    aad_audience  = string
                    aad_issuer    = string
                    root_certificate = list(
                      object({
                        name             = string
                        public_cert_data = string
                      })
                    )
                    revoked_certificate = list(
                      object({
                        name             = string
                        public_cert_data = string
                      })
                    )
                    radius_server_address = string
                    radius_server_secret  = string
                    vpn_client_protocols  = list(string)
                    vpn_auth_types        = list(string)
                  })
                )
                bgp_settings = list(
                  object({
                    asn         = number
                    peer_weight = number
                    peering_addresses = list(
                      object({
                        ip_configuration_name = string
                        apipa_addresses       = list(string)
                      })
                    )
                  })
                )
                custom_route = list(
                  object({
                    address_prefixes = list(string)
                  })
                )
              })
            })
          })
          azure_firewall = object({
            enabled = bool
            config = object({
              address_prefix                = string
              enable_dns_proxy              = bool
              dns_servers                   = list(string)
              sku_tier                      = string
              base_policy_id                = string
              private_ip_ranges             = list(string)
              threat_intelligence_mode      = string
              threat_intelligence_allowlist = list(string)
              availability_zones = object({
                zone_1 = bool
                zone_2 = bool
                zone_3 = bool
              })
            })
          })
          spoke_virtual_network_resource_ids      = list(string)
          enable_outbound_virtual_network_peering = bool
          enable_hub_network_mesh_peering         = bool
        })
      })
    )
    vwan_hub_networks = list(
      object({
        enabled = bool
        config = object({
          address_prefix = string
          location       = string
          sku            = string
          routes = list(
            object({
              address_prefixes    = list(string)
              next_hop_ip_address = string
            })
          )
          expressroute_gateway = object({
            enabled = bool
            config = object({
              scale_unit = number
            })
          })
          vpn_gateway = object({
            enabled = bool
            config = object({
              bgp_settings = list(
                object({
                  asn         = number
                  peer_weight = number
                  instance_0_bgp_peering_address = list(
                    object({
                      custom_ips = list(string)
                    })
                  )
                  instance_1_bgp_peering_address = list(
                    object({
                      custom_ips = list(string)
                    })
                  )
                })
              )
              routing_preference = string
              scale_unit         = number
            })
          })
          azure_firewall = object({
            enabled = bool
            config = object({
              enable_dns_proxy              = bool
              dns_servers                   = list(string)
              sku_tier                      = string
              base_policy_id                = string
              private_ip_ranges             = list(string)
              threat_intelligence_mode      = string
              threat_intelligence_allowlist = list(string)
              availability_zones = object({
                zone_1 = bool
                zone_2 = bool
                zone_3 = bool
              })
            })
          })
          spoke_virtual_network_resource_ids = list(string)
          enable_virtual_hub_connections     = bool
        })
      })
    )
    ddos_protection_plan = object({
      enabled = bool
      config = object({
        location = string
      })
    })
    dns = object({
      enabled = bool
      config = object({
        location = string
        enable_private_link_by_service = object({
          azure_automation_webhook             = bool
          azure_automation_dscandhybridworker  = bool
          azure_sql_database_sqlserver         = bool
          azure_synapse_analytics_sqlserver    = bool
          azure_synapse_analytics_sql          = bool
          storage_account_blob                 = bool
          storage_account_table                = bool
          storage_account_queue                = bool
          storage_account_file                 = bool
          storage_account_web                  = bool
          azure_data_lake_file_system_gen2     = bool
          azure_cosmos_db_sql                  = bool
          azure_cosmos_db_mongodb              = bool
          azure_cosmos_db_cassandra            = bool
          azure_cosmos_db_gremlin              = bool
          azure_cosmos_db_table                = bool
          azure_database_for_postgresql_server = bool
          azure_database_for_mysql_server      = bool
          azure_database_for_mariadb_server    = bool
          azure_key_vault                      = bool
          azure_kubernetes_service_management  = bool
          azure_search_service                 = bool
          azure_container_registry             = bool
          azure_app_configuration_stores       = bool
          azure_backup                         = bool
          azure_site_recovery                  = bool
          azure_event_hubs_namespace           = bool
          azure_service_bus_namespace          = bool
          azure_iot_hub                        = bool
          azure_relay_namespace                = bool
          azure_event_grid_topic               = bool
          azure_event_grid_domain              = bool
          azure_web_apps_sites                 = bool
          azure_machine_learning_workspace     = bool
          signalr                              = bool
          azure_monitor                        = bool
          cognitive_services_account           = bool
          azure_file_sync                      = bool
          azure_data_factory                   = bool
          azure_data_factory_portal            = bool
          azure_cache_for_redis                = bool
        })
        private_link_locations                                 = list(string)
        public_dns_zones                                       = list(string)
        private_dns_zones                                      = list(string)
        enable_private_dns_zone_virtual_network_link_on_hubs   = bool
        enable_private_dns_zone_virtual_network_link_on_spokes = bool
      })
    })
  })
  location = any
  tags     = any
  advanced = any
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

[this_page]: # "Link for the current page."

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

[tf_discuss_optional]: https://discuss.hashicorp.com/t/request-for-feedback-optional-object-type-attributes-with-defaults-in-v1-3-alpha/40550 "Optional object type attributes with defaults in v1.3 alpha"
