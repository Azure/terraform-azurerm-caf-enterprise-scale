## Overview

[**configure_connectivity_resources**](#overview) [*see validation for type*](#Validation) (optional)

If specified, will customize the "Connectivity" landing zone settings and resources.

## Default value

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

## Validation

Validation provided by schema:

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
              address_prefix           = string # Only support adding a single address prefix for GatewaySubnet subnet
              gateway_sku_expressroute = string # If specified, will deploy the ExpressRoute gateway into the GatewaySubnet subnet
              gateway_sku_vpn          = string # If specified, will deploy the VPN gateway into the GatewaySubnet subnet
              advanced_vpn_settings = object({
                enable_bgp                       = bool
                active_active                    = bool
                private_ip_address_allocation    = string # Valid options are "", "Static" or "Dynamic". Will set `private_ip_address_enabled` and `private_ip_address_allocation` as needed.
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
              address_prefix                = string # Only support adding a single address prefix for AzureFirewallManagementSubnet subnet
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

## Usage

Configure resources for the `connectivity` Landing Zone, including:

- Hub network(s) for a traditional hub and spoke network topology.
- Hub network(s) for an Azure Virtual WAN network topology.
- DDoS Protection Plan.
- Public and private Azure DNS zones, including DNS for Private Endpoints.

### Configure hub networks (Hub and Spoke)

Define zero or more hub networks as a list of objects, each containing configuration values covering an address space, DDOS protection plan, DNS servers, BGP community, subnets, virtual network gateway, Azure firewall, spoke virtual network resources and outbound virtual network peering.

```hcl
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
    }
  },
]
```

Each entry in the `hub_network` list will create a new set of resources based on the configured values.
Each entry includes an `enable` (`bool`) control to allow the configuration to be enabled and disabled, and a `config` (`object`) which contains the configuration settings for each hub network.

> **IMPORTANT**: When creating multiple hub networks, each must use a uniquely defined `location`.

#### `settings.hub_networks[].enable`

The `enable` (`bool`) input allows you to toggle whether to create this hub network instance, including all associated resources. Set to `false` if you want to toggle individual hub network instances without removing the full configuration.

#### `settings.hub_networks[].config`

The `config` (`object`) input allows you to set the following configuration items for each hub network:

##### `settings.hub_networks[].config.address_space`

List of IP Address ranges in CIDR (prefix) notation for the Virtual Network.
Must be a valid entry for a Virtual Network `address_space` input.

##### `settings.hub_networks[].config.location`

Set the location/region where the hub network and associated resources are created.
Changing this forces new resources to be created.
By default, a `hub_network` with an empty value in the `location` field will be deployed to the location inherited from either `configure_connectivity_resources.location`, or the top-level variable `default_location`, in order of precedence.

##### `settings.hub_networks[].config.link_to_ddos_protection_plan`

The `link_to_ddos_protection_plan` (`bool`) input controls whether to link the hub network to the DDoS Protection plan managed by the module.

For this to work, the `ddos_protection_plan.enabled` value must be set to `true`.

##### `settings.hub_networks[].config.dns_servers`

Specify a list of custom DNS server IP addresses.

##### `settings.hub_networks[].config.bgp_community`

Specify the BGP community attribute for the Virtual Network in format `<as-number>:<community-value>`.

##### `settings.hub_networks[].config.subnets`

List of subnet configuration objects, used to extend the Virtual Network with custom subnets.

Each entry within this list must contain the following configuration `object()`:

```hcl
object({
  name                      = string
  address_prefixes          = list(string)
  network_security_group_id = string
  route_table_id            = string
})
```

###### `settings.hub_networks[].config.subnets[].name`

Specify the name of the subnet to create.
Changing this forces a new resource to be created.

- Must be unique within the Virtual Network.
- Should not be one of the following which are created automatically be the module as required:
  - `GatewaySubnet`
  - `AzureFirewallSubnet`

###### `settings.hub_networks[].config.subnets[].address_prefixes`

The address prefixes to use for the subnet.

###### `settings.hub_networks[].config.subnets[].network_security_group_id`

Resource ID of an existing Network Security Group (NSG) to attach to the Subnet.

###### `settings.hub_networks[].config.subnets[].route_table_id`

Resource ID of an existing Route Table (UDR) to attach to the Subnet.

As an example, a two-subnet configuration would look like:
```hcl
[
  {
    name = "mysubnet"
    address_prefixes = [
      "192.168.1.0/24",
      "192.168.2.0/24
    ]
    network_security_group_id = ""
    route_table_id = ""
  },
  {
    name = "mysubnet2"
    address_prefixes = [
      "192.168.3.0/24",
      "192.168.4.0/24
    ]
    network_security_group_id = ""
    route_table_id = ""
  }
]
```

##### `settings.hub_networks[].config.virtual_network_gateway`

Allows you to create and configure an ExpressRoute and/or VPN gateway in the hub network.

Must contain the following configuration `object()`:

```hcl
object({
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
```

###### `settings.hub_networks[].config.subnets[].virtual_network_gateway.enabled`

The `enabled` (`bool`) input allows you to toggle whether to create the `virtual_network_gateway` resources based on the values specified in the `config` (`object()`), as documented below.

###### `settings.hub_networks[].config.subnets[].virtual_network_gateway.config.address_prefix`

Specifies the IP address prefix to assign to the `GatewaySubnet` subnet.
`settings.hub_networks[].config.subnets[].virtual_network_gateway.enabled` must also be set to `true` for this resource to be created.

###### `settings.hub_networks[].config.subnets[].virtual_network_gateway.config.gateway_sku_expressroute`

To create a Virtual Network Gateway for use with ExpressRoute, specify a [supported SKU][virtual_network_gateway_sku] for an ExpressRoute Gateway.
Leaving this value as an empty string `""` will result in no ExpressRoute Gateway being created.
`settings.hub_networks[].config.subnets[].virtual_network_gateway.enabled` must also be set to `true` for this resource to be created.

The SKU value will automatically determine whether the ExpressRoute Gateway and dependant resources (e.g. Public IP) will be deployed across zones or not.

> **NOTE**: Take care to ensure you specify a SKU supported by the location specified in the hub network configuration.
> For example, locations without support for Availability Zones do not support SKUs for zonal gateways.

###### `settings.hub_networks[].config.subnets[].virtual_network_gateway.config.gateway_sku_vpn`

To create a Virtual Network Gateway for use with VPN connectivity, specify a [supported SKU][virtual_network_gateway_sku] for a VPN Gateway.
Leaving this value as an empty string `""` will result in no VPN Gateway being created.
`settings.hub_networks[].config.subnets[].virtual_network_gateway.enabled` must also be set to `true` for this resource to be created.

The SKU value will automatically determine whether the VPN Gateway and dependant resources (e.g. Public IP) will be deployed across zones or not.

> **NOTE**: Take care to ensure you specify a SKU supported by the location specified in the hub network configuration.
> For example, locations without support for Availability Zones do not support SKUs for zonal gateways.

###### settings.hub_networks[].config.subnets[].virtual_network_gateway.advanced_vpn_settings`

Allows you to specify the VPN configuration for the virtual network gateway.
The settings map to the [`azurerm_virtual_network_gateway`][azurerm_virtual_network_gateway] resource in the Azure provider.

**`settings.hub_networks[].config.subnets[].virtual_network_gateway.advanced_vpn_settings.enable_bgp`**

If `true`, BGP (Border Gateway Protocol) will be enabled for this virtual network gateway.

**`settings.hub_networks[].config.subnets[].virtual_network_gateway.advanced_vpn_settings.active_active`**

If `true`, an active-active virtual network gateway will be created. An active-active gateway requires a `HighPerformance` or an `UltraPerformance` sku. If false, an active-standby gateway will be created.

##### `settings.hub_networks[].config.azure_firewall`

Allows you to create and configure an Azure Firewall in the hub network.

Must contain the following configuration `object()`:

```hcl
object({
  enabled = bool
  config = object({
    address_prefix                = string
    enable_dns_proxy              = bool
    dns_servers                   = []
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
```

###### `settings.hub_networks[].config.subnets[].azure_firewall.enabled`

The `enable` (`bool`) input allows you to toggle whether to create the Azure Firewall resources based on the values specified in the `config` (`object()`), as documented below.

###### `settings.hub_networks[].config.subnets[].azure_firewall.config.address_prefix`

Specifies the IP address prefix to assign to the `AzureFirewallSubnet` subnet.
`settings.hub_networks[].config.subnets[].azure_firewall.enabled` must also be set to `true` for this resource to be created.

###### `settings.hub_networks[].config.subnets[].azure_firewall.config.enable_dns_proxy`

When enabled, the firewall listens on port 53 and forwards DNS requests to the configured DNS servers.
Typically used to allow name resolution for Azure Private DNS zones created by the module for Private Endpoints.

###### `settings.hub_networks[].config.subnets[].azure_firewall.config.dns_servers`

Allows you to specify custom DNS servers for name resolution.
Leave value as an empty list `[]` to use the Default (Azure provided) DNS service.

###### `settings.hub_networks[].config.subnets[].azure_firewall.config.sku_tier`

The SKU Tier of the Firewall and Firewall Policy.
Possible values are `Standard`, `Premium`.
Defaults to `Standard`.
Changing this forces a new Firewall Policy to be created.

###### `settings.hub_networks[].config.subnets[].azure_firewall.config.base_policy_id`

The ID of the base Firewall Policy.
Used to enable configuration of a [rule hierarchy][azfw_policy_rule_hierarchy].

> **NOTE:** Azure Firewall Policies must be located in the same region to use this setting.

###### `settings.hub_networks[].config.subnets[].azure_firewall.config.private_ip_ranges`

A list of private IP ranges to which traffic will not be SNAT.

###### `settings.hub_networks[].config.subnets[].azure_firewall.config.threat_intelligence_mode`

The operation mode for Threat Intelligence.
Possible values are `Alert`, `Deny` and `Off`.
Defaults to `Alert`.

###### `settings.hub_networks[].config.subnets[].azure_firewall.config.threat_intelligence_allowlist`

A list of `fqdns` and `ip_addresses` that will be skipped for threat detection.
Must be constructed in the following format:

```hcl
  threat_intelligence_allowlist = [
    {
      fqdns        = [] # Add list of FQDNs that will be skipped for threat detection.
      ip_addresses = [] # Add list of IP Addresses that will be skipped for threat detection.
    }
  ]
```

###### `settings.hub_networks[].config.subnets[].azure_firewall.config.availability_zones`

Used to control which zones to use when deploying Azure Firewall.
Setting all values to `false` will result in a non-zonal firewall being deployed.

> **NOTE**: Some locations/regions in Azure do not support Availability Zones.
> For these locations, you must set all values to `false`.

##### `settings.hub_networks[].config.spoke_virtual_network_resource_ids`

List of [Azure] resource IDs used to identify spoke Virtual Networks associated with the hub network.

##### `settings.hub_networks[].config.enable_outbound_virtual_network_peering`

`bool` input to control whether the module will create Virtual Network peerings between the spoke networks identified by `spoke_virtual_network_resource_ids` and the current hub network instance.

### Configure hub networks (Virtual WAN)

Define zero or more VWAN hub networks as a list of objects, each containing configuration values covering an address space, expressroute gateway, vpn gateway and Azure firewall.

```terraform
vwan_hub_networks = [
  {
    enabled = true
    config = {
      address_prefix = "10.0.0.0/23"
      location       = "westeurope"
      sku            = "Standard"
      routes = [
        {
          address_prefixes = [
            "192.168.0.0/16"
          ]
          next_hop_ip_address = "10.0.1.4"
        }
      ]
      expressroute_gateway {
        enabled = true
        config = {
          scale_unit = 1
        }
      }
      vpn_gateway = {
        enabled = true
        config = {
          bgp_settings = [
            {
              asn         = 12345
              peer_weight = 10
              instance_0_bgp_peering_address = [
                {
                  custom_ips = [
                    ""
                  ]
                }
              ]
              instance_1_bgp_peering_address = [
                {
                  custom_ips = [
                    ""
                  ]
                }
              ]
            }
          ]
          routing_preference = "Microsoft Network"
          scale_unit         = 1
        }
      }
      azure_firewall = {
        enabled = true
        config = {
          enable_dns_proxy = true
          dns_servers      = []
          sku_tier         = "Standard"
        }
      }
      spoke_virtual_network_resource_ids = [
        ""
      ]
      enable_virtual_hub_connections     = true
    }
  }
]
```

#### `settings.vwan_hub_networks[].enable`

The `enable` (`bool`) input allows you to toggle whether to create this VWAN hub network instance, including all associated resources. Set to `false` if you want to toggle individual hub network instances without removing the full configuration.

#### `settings.vwan_hub_networks[].config`

The `config` (`object`) input allows you to set the following configuration items for each VWAN hub network:

##### `settings.vwan_hub_networks[].config.address_prefix`

The Address Prefix which should be used for this Virtual Hub.
The address prefix subnet cannot be smaller than a /24.
We recommend using a /23.

E.g. `10.0.0.0/23`

##### `settings.vwan_hub_networks[].config.location`

Set the location/region where the hub network and associated resources are created.
Changing this forces new resources to be created.
By default, a `vwan_hub_network` with an empty value in the `location` field will be deployed to the location inherited from either `configure_connectivity_resources.location`, or the top-level variable `default_location`, in order of precedence.

##### `settings.vwan_hub_networks[].config.sku`

Set the [SKU](https://docs.microsoft.com/azure/virtual-wan/virtual-wan-about#basicstandard) of the VWAN hub.
Allowed values are  `Basic` and `Standard`.

##### `settings.vwan_hub_networks[].config.routes[]`

A list of route objects used to define static routes for this virtual hub.
An empty list will result in no static routes being created.

###### `settings.vwan_hub_networks[].config.routes[].address_prefixes[]`

A list of address prefixes to be used for the route.

E.g. `192.168.0.0/16`

###### `settings.vwan_hub_networks[].config.routes[].next_hop_ip_address`

The IP address of the next hop for the route.

e.g. `10.0.1.4`

### Configure DDoS Protection Plan

Optionally enable a DDoS Protection Plan, and set the location.

```hcl
ddos_protection_plan = {
  enabled = false
  config = {
    location = ""
  }
}
```

### Configure DNS

Optionally enable DNS resources for Private Link Services, Private DNS zones and Public DNS zones

```hcl
{
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
```

- Enable Private Link by service: for each of the Private Link services, enable or disable DNS resolution
- Private Link locations: list of reference to Private Link locations
- Private DNS Zones: list of references to Private DNS zones to include
- Public DNS Zones: list of references to Public DNS zones to include

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

[this_page]: # "Link for the current page."

[virtual_network_gateway_sku]: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway#sku "Supported SKUs for the virtual_network_gateway resource."
[azfw_policy_rule_hierarchy]: https://docs.microsoft.com/azure/firewall-manager/rule-hierarchy "Use Azure Firewall policy to define a rule hierarchy."
[azurerm_virtual_network_gateway]: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway
