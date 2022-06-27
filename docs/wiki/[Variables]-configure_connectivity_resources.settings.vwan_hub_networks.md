<!-- markdownlint-disable first-line-h1 -->
## Overview

[**configure_connectivity_resources.settings.vwan_hub_networks**](#overview) `list(object({}))` [*see validation for detailed type*](#Validation) (optional)

For each configuration object added to the `configure_connectivity_resources.settings.vwan_hub_networks` list, the module will create a hub network and associated resources in the target location based on a [Virtual WAN network topology (Microsoft-managed)][wiki_connectivity_resources_virtual_wan].

## Default value

<!-- markdownlint-disable-next-line no-inline-html -->
<details><summary>Click to view code...</summary>

```hcl
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
}
```

</details>

## Validation

Validation provided by schema:

<!-- markdownlint-disable-next-line no-inline-html -->
<details><summary>Click to view code...</summary>

```hcl
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
```

</details>

## Usage

Configuration settings for resources created in the hub location.
These control which resources are created, and what settings are applied to those resources.

### `enabled`

The `enabled` (`bool`) input allows you to toggle whether to create this hub network instance, including all associated resources.
Set to `false` if you want to toggle individual hub network instances without removing the full configuration.

### `config`

The `config` (`object`) input allows you to set the following configuration items for each hub network:

#### `config.address_prefix`

The Address Prefix which should be used for this Virtual Hub.
The address prefix subnet cannot be smaller than a /24.
[Azure recommendation is to use a /23][msdocs_vhub_address_prefix].

For example, `10.0.0.0/23`

#### `config.location`

Set the location/region where the virtual hub and associated resources are created.
Changing this forces new resources to be created.

By default, a `vwan_hub_network` with an empty value in the `location` field will be deployed to the location inherited from either `configure_connectivity_resources.location`, or the top-level variable `default_location`, in order of precedence.

> **NOTE**:
> When creating multiple hub networks, each `hub_network` must be configured to deploy to a unique `location` per module declaration.
> This is because the module uses the `location` field to ensure uniqueness of resource names.
> To deploy multiple hub networks to the same location, you must use multiple module declarations using a unique prefix (*typically set with the top-level `root_id` input variable*).

#### `config.sku`

Set the [SKU][msdocs_virtual_hub_sku] of the virtual hub.
Allowed values are  `Basic` and `Standard`.
Changing this forces a new resource to be created.

#### `config.routes[]`

A list of optional `route` objects based on a [route][tf_reg_route] block as documented on the Terraform Registry.
Each object in the list configures a route to the virtual hub route table.

```hcl
routes = [
  {
    # Required attributes
    address_prefixes    = []
    next_hop_ip_address = ""
    # No optional attributes
  }
]
```

#### `config.expressroute_gateway`

Allows you to create and configure an ExpressRoute gateway associated with the virtual hub.

##### `config.expressroute_gateway.enabled`

The `enabled` (`bool`) input allows you to toggle whether to create the `expressroute_gateway` resources based on the values specified in the `config` object, as documented below.

##### `config.expressroute_gateway.config`

The `config` object contains configuration settings for the ExpressRoute gateway resources.

###### `config.expressroute_gateway.config.scale_unit`

The number of scale units with which to provision the ExpressRoute gateway.
Each scale unit is equal to 2Gbps, with support for up to 10 scale units (20Gbps).

#### `config.vpn_gateway`

Allows you to create and configure a VPN gateway associated with the virtual hub.

##### `config.vpn_gateway.enabled`

The `enabled` (`bool`) input allows you to toggle whether to create the `vpn_gateway` resources based on the values specified in the `config` object, as documented below.

##### `config.vpn_gateway.config`

The `config` object contains configuration settings for the VPN gateway resources.

###### `config.vpn_gateway.config.bgp_settings`

A list of optional `bgp_settings` objects based on a [bgp_settings][tf_reg_bgp_settings] block as documented on the Terraform Registry.
Each object in the list configures a BGP (Border Gateway Protocol) route in the VPN gateway route table.

```hcl
bgp_settings = [
  {
    # Required attributes
    asn         = ""
    peer_weight = ""
    # Insert optional attributes here
  }
]
```

###### `config.vpn_gateway.config.routing_preference`

Azure routing preference lets you to choose how your traffic routes between Azure and the internet.
You can choose to route traffic either via the Microsoft network (default value, `Microsoft Network`), or via the ISP network (public internet, set to `Internet`).
More context of the configuration can be found in the [Microsoft Docs][msdocs_vwan_s2s_gateway] to create a VPN Gateway.
Changing this forces a new resource to be created.

###### `config.vpn_gateway.config.scale_unit`

The Scale Unit for this VPN Gateway.
<!-- Defaults to 1. # This feature needs to be added to the module -->

#### `config.azure_firewall`

Allows you to create and configure an Azure Firewall associated with the virtual hub.

##### `config.azure_firewall.enabled`

The `enabled` (`bool`) input allows you to toggle whether to create the Azure Firewall resources based on the values specified in the `config` object, as documented below.

##### `config.azure_firewall.config`

The `config` object contains configuration settings for the Azure firewall resources.

###### `config.azure_firewall.config.enable_dns_proxy`

When enabled, the firewall listens on port 53 and forwards DNS requests to the configured DNS servers.
Typically used to allow name resolution for Azure Private DNS zones created by the module for Private Endpoints.

###### `config.azure_firewall.config.dns_servers`

Allows you to specify custom DNS servers for name resolution.
Leave value as an empty list `[]` to use the Default (Azure provided) DNS service.

###### `config.azure_firewall.config.sku_tier`

The SKU Tier of the Firewall and Firewall Policy.
Possible values are `Standard`, `Premium`.
Defaults to `Standard`.
Changing this forces a new Firewall Policy to be created.

###### `config.azure_firewall.config.base_policy_id`

The ID of the base Firewall Policy.
Used to enable configuration of a [rule hierarchy][azfw_policy_rule_hierarchy].

> **NOTE:** Azure Firewall Policies must be located in the same region to use this setting.

###### `config.azure_firewall.config.private_ip_ranges`

A list of private IP ranges to which traffic will not be SNAT.

###### `config.azure_firewall.config.threat_intelligence_mode`

The operation mode for Threat Intelligence.
Possible values are `Alert`, `Deny` and `Off`.
Defaults to `Alert`.

###### `config.azure_firewall.config.threat_intelligence_allowlist`

A list of optional `threat_intelligence_allowlist` objects based on a [threat_intelligence_allowlist][tf_reg_threat_intelligence_allowlist] block as documented on the Terraform Registry.
Each object in the list configures a BGP (Border Gateway Protocol) route in the VPN gateway route table.

```hcl
threat_intelligence_allowlist = [
  {
    # No required attributes
    # Insert optional attributes here
  }
]
```

###### `config.azure_firewall.config.availability_zones`

Used to control which zones to use when deploying Azure Firewall.
Setting all values to `false` will result in a non-zonal firewall being deployed.

```hcl
availability_zones = {
  zone_1 = true
  zone_2 = true
  zone_3 = true
}
```

#### `config.spoke_virtual_network_resource_ids`

List of Azure Resource IDs used to identify spoke Virtual Networks associated with the hub network.

#### `config.enable_virtual_hub_connections`

`bool` input to control whether the module will create virtual hub connections between the spoke networks identified by `spoke_virtual_network_resource_ids` and the current hub network instance.

> **NOTE:**
> Virtual hub connections are created as bi-directional by the Azure platform so require no further configuration for basic operation.

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

[this_page]: # "Link for the current page."

[msdocs_vhub_address_prefix]: https://docs.microsoft.com/azure/virtual-wan/virtual-wan-faq#what-is-the-recommended-hub-address-space-during-hub-creation "What is the recommended hub address space during hub creation?"
[msdocs_virtual_hub_sku]:     https://docs.microsoft.com/azure/virtual-wan/virtual-wan-about#basicstandard "Virtual WAN types"
[msdocs_vwan_s2s_gateway]:    https://docs.microsoft.com/azure/virtual-wan/virtual-wan-site-to-site-portal#gateway "Configure a site-to-site gateway"
[azfw_policy_rule_hierarchy]: https://docs.microsoft.com/azure/firewall-manager/rule-hierarchy "Use Azure Firewall policy to define a rule hierarchy."

[wiki_connectivity_resources_virtual_wan]: %5BUser-Guide%5D-Connectivity-Resources#virtual-wan-network-topology-microsoft-managed "Wiki - Connectivity Resources - Virtual WAN network topology (Microsoft-managed)"

[tf_reg_bgp_settings]:                  https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/vpn_gateway#bgp_settings "Documentation for bgp_settings blocks on the Terraform Registry."
[tf_reg_route]:                         https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_hub#route "Documentation for route blocks on the Terraform Registry."
[tf_reg_threat_intelligence_allowlist]: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy#threat_intelligence_allowlist  "Documentation for threat_intelligence_allowlist blocks on the Terraform Registry."
