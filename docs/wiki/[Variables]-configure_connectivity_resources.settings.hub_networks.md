<!-- markdownlint-disable first-line-h1 -->
## Overview

[**configure_connectivity_resources.settings.hub_networks**](#overview) `list(object({}))` [*see validation for detailed type*](#Validation) (optional)

For each configuration object added to the `configure_connectivity_resources.settings.hub_networks` list, the module will create a hub network and associated resources in the target location based on a [traditional Azure networking topology (hub and spoke)][wiki_connectivity_resources_hub_and_spoke].

## Default value

<!-- markdownlint-disable-next-line no-inline-html -->
<details><summary>Click to view code...</summary>

```hcl
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

#### `config.address_space`

List of IP Address ranges in CIDR (prefix) notation for the Virtual Network.
Must be a valid entry for a Virtual Network `address_space` input.

#### `config.location`

Set the location/region where the hub network and associated resources are created.
Changing this forces new resources to be created.

By default, a `hub_network` with an empty value in the `location` field will be deployed to the location inherited from either `configure_connectivity_resources.location`, or the top-level variable `default_location`, in order of precedence.

> **NOTE**:
> When creating multiple hub networks, each `hub_network` must be configured to deploy to a unique `location` per module declaration.
> This is because the module uses the `location` field to ensure uniqueness of resource names.
> To deploy multiple hub networks to the same location, you must use multiple module declarations using a unique prefix (*typically set with the top-level `root_id` input variable*).

#### `config.link_to_ddos_protection_plan`

The `link_to_ddos_protection_plan` (`bool`) input controls whether to link the hub network to the DDoS protection plan managed by the module.

For this to work, the `ddos_protection_plan.enabled` value must be set to `true`.

#### `config.dns_servers`

Specify a list of custom DNS server IP addresses.

#### `config.bgp_community`

Specify the BGP community attribute for the Virtual Network in format `<as-number>:<community-value>`.

#### `config.subnets`

List of subnet configuration objects, used to extend the Virtual Network with custom subnets.

##### `config.subnets[].name`

Specify the name of the subnet to create.
Changing this forces a new resource to be created.

- Must be unique within the Virtual Network.
- Should not be one of the following which are created automatically be the module as required:
  - `GatewaySubnet`
  - `AzureFirewallSubnet`

##### `config.subnets[].address_prefixes`

The address prefixes to use for the subnet.

##### `config.subnets[].network_security_group_id`

Resource ID of an existing Network Security Group (NSG) to attach to the Subnet.

> **IMPORTANT:**
> Feature pending development

##### `config.subnets[].route_table_id`

Resource ID of an existing Route Table (UDR) to attach to the Subnet.

> **IMPORTANT:**
> Feature pending development

#### `config.virtual_network_gateway`

Allows you to create and configure an ExpressRoute and/or VPN gateway in the hub network.

##### `config.virtual_network_gateway.enabled`

The `enabled` (`bool`) input allows you to toggle whether to create the `virtual_network_gateway` resources based on the values specified in the `config` object, as documented below.

##### `config.virtual_network_gateway.config`

The `config` object contains configuration settings for the virtual network gateway resources.

###### `config.virtual_network_gateway.config.address_prefix`

Specifies the IP address prefix to assign to the `GatewaySubnet` subnet.
`config.virtual_network_gateway.enabled` must also be set to `true` for this resource to be created.

If no value is assigned, the `GatewaySubnet` subnet will not be created in the hub network.

###### `config.virtual_network_gateway.config.gateway_sku_expressroute`

To create a Virtual Network Gateway for use with ExpressRoute, specify a [supported SKU][virtual_network_gateway_sku] for an ExpressRoute Gateway.
Leaving this value as an empty string `""` will result in no ExpressRoute Gateway being created.
`config.virtual_network_gateway.enabled` must also be set to `true` for this resource to be created.

The SKU value will automatically determine whether the ExpressRoute Gateway and dependant resources (e.g. Public IP) will be deployed across zones or not.

> **NOTE:** Take care to ensure you specify a SKU supported by the location specified in the hub network configuration.
> For example, locations without support for Availability Zones do not support SKUs for zonal gateways.

###### `config.virtual_network_gateway.config.gateway_sku_vpn`

To create a Virtual Network Gateway for use with VPN connectivity, specify a [supported SKU][virtual_network_gateway_sku] for a VPN Gateway.
Leaving this value as an empty string `""` will result in no VPN Gateway being created.
`config.virtual_network_gateway.enabled` must also be set to `true` for this resource to be created.

The `sku` value will automatically determine whether the VPN Gateway and dependant resources (e.g. Public IP) will be deployed across zones or not.

If `sku` is set to `Basic`, [enable_bgp](#configvirtualnetworkgatewayconfigadvancedvpnsettingsenablebgp) is not supported.
The module will automatically set this value to `null` to prevent resource creation errors.

> **NOTE:** Take care to ensure you specify a `sku` supported by the location specified in the hub network configuration.
> For example, locations without support for Availability Zones do not support SKUs for zonal gateways.

###### `config.virtual_network_gateway.config.advanced_vpn_settings`

Allows you to specify the VPN configuration for the virtual network gateway.
The settings map to the [`azurerm_virtual_network_gateway`][azurerm_virtual_network_gateway] resource in the Azure provider.

###### `config.virtual_network_gateway.config.advanced_vpn_settings.enable_bgp`

If `true`, BGP (Border Gateway Protocol) will be enabled for this virtual network gateway.

###### `config.virtual_network_gateway.config.advanced_vpn_settings.active_active`

If `true`, an active-active virtual network gateway will be created.
An active-active gateway requires a `HighPerformance` or an `UltraPerformance` sku.

If `false`, an active-standby gateway will be created.

###### `config.virtual_network_gateway.config.advanced_vpn_settings.private_ip_address_allocation`

If `true`, a private IP will be enabled on this gateway for connections.
Changing this forces a new resource to be created.

###### `config.virtual_network_gateway.config.advanced_vpn_settings.default_local_network_gateway_id`

The ID of the local network gateway through which outbound Internet traffic from the virtual network in which the gateway is created will be routed (*forced tunnelling*).
Refer to the [Azure documentation on forced tunnelling][msdocs_forced_tunnelling].
If not specified, forced tunnelling is disabled.

###### `config.virtual_network_gateway.config.advanced_vpn_settings.vpn_client_configuration`

A list of optional `vpn_client_configuration` objects based on a [vpn_client_configuration][tf_reg_vpn_client_configuration] block as documented on the Terraform Registry.
Each object in the list configures the Virtual Network Gateway to accept IPSec point-to-site connections.

```hcl
vpn_client_configuration = [
  {
    # Required attributes
    address_space = []
    # Insert optional attributes here
  }
]
```

###### `config.virtual_network_gateway.config.advanced_vpn_settings.bgp_settings`

A list of optional `bgp_settings` objects based on a [bgp_settings][tf_reg_bgp_settings] block as documented on the Terraform Registry.
In this block the BGP specific settings can be defined.

```hcl
bgp_settings = [
  {
    # No required attributes
    # Insert optional attributes here
  }
]
```

###### `config.virtual_network_gateway.config.advanced_vpn_settings.custom_route`

A list of optional `custom_route` objects based on a [custom_route][tf_reg_custom_route] block as documented on the Terraform Registry.
In this block the custom route settings can be defined, specifying a list of address blocks reserved for this virtual network in CIDR notation.

```hcl
custom_route = [
  {
    # No required attributes
    # Insert optional attributes here
  }
]
```

#### `config.azure_firewall`

Allows you to create and configure an Azure Firewall in the hub network.

##### `config.azure_firewall.enabled`

The `enabled` (`bool`) input allows you to toggle whether to create the Azure Firewall resources based on the values specified in the `config` object, as documented below.

##### `config.azure_firewall.config`

The `config` object contains configuration settings for the Azure firewall resources.

###### `config.azure_firewall.config.address_prefix`

Specifies the IP address prefix to assign to the `AzureFirewallSubnet` subnet.
`config.azure_firewall.enabled` must also be set to `true` for this resource to be created.

If no value is assigned, the `AzureFirewallSubnet` subnet will not be created in the hub network.

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

> **NOTE:**
> Some locations/regions in Azure do not support Availability Zones or have limited support.
>
> - For locations with no support, you must set all values to `false`.
> - For locations limited to only 2 zones, you must set `zone_3 = false`.

#### `config.spoke_virtual_network_resource_ids`

List of Azure Resource IDs used to identify spoke Virtual Networks associated with the hub network.

#### `config.enable_outbound_virtual_network_peering`

`bool` input to control whether the module will create Virtual Network peerings between the spoke networks identified by `spoke_virtual_network_resource_ids` and the current hub network instance.

> **IMPORTANT:**
> Virtual Network peerings need to be created in both directions, from hub-to-spoke and spoke-to-hub.
> Because [virtualNetworkPeerings][msdocs_virtualNetworkPeerings] are child resources of a [virtualNetworks][msdocs_virtualNetworks] resource, they must be created in the same Subscription.
> Due to an `azurerm` provider authentication limitation, it's not currently possible create resources in another Subscription without configuring multiple "statically defined" providers.
> This prevents us from creating the spoke-to-hub-peering.
>
> We are working on a solution for this using the recently released [AzAPI provider][tf_reg_azapi] which allows a single provider to deploy resources into multiple subscriptions using a [parent_id][tf_reg_azapi_parent_id] input.

#### `config.enable_hub_network_mesh_peering`

`bool` input to control whether the module will create fully meshed Virtual Network peerings between the hub networks that have this setting enabled.

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

[this_page]: # "Link for the current page."

[virtual_network_gateway_sku]:     https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway#sku "Supported SKUs for the virtual_network_gateway resource."
[azfw_policy_rule_hierarchy]:      https://docs.microsoft.com/azure/firewall-manager/rule-hierarchy "Use Azure Firewall policy to define a rule hierarchy."
[azurerm_virtual_network_gateway]: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway

[wiki_connectivity_resources_hub_and_spoke]: %5BUser-Guide%5D-Connectivity-Resources#traditional-azure-networking-topology-hub-and-spoke "Wiki - Connectivity Resources - Traditional Azure networking topology (hub and spoke)"

[msdocs_forced_tunnelling]:      https://docs.microsoft.com/azure/vpn-gateway/vpn-gateway-forced-tunneling-rm "Azure documentation on forced tunnelling"
[msdocs_virtualNetworkPeerings]: https://docs.microsoft.com/azure/templates/microsoft.network/virtualnetworks/virtualnetworkpeerings "Microsoft.Network virtualNetworks/virtualNetworkPeerings"
[msdocs_virtualNetworks]:        https://docs.microsoft.com/azure/templates/microsoft.network/virtualnetworks "Microsoft.Network virtualNetworks"

[tf_reg_vpn_client_configuration]:      https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway#vpn_client_configuration "Documentation for vpn_client_configuration blocks on the Terraform Registry."
[tf_reg_bgp_settings]:                  https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway#bgp_settings "Documentation for bgp_settings blocks on the Terraform Registry."
[tf_reg_custom_route]:                  https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway#address_prefixes "Documentation for custom_route blocks on the Terraform Registry (links to address_prefixes)."
[tf_reg_azapi]:                         https://registry.terraform.io/providers/Azure/azapi/latest/docs "Documentation for the AzAPI provider on the Terraform Registry."
[tf_reg_azapi_parent_id]:               https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/azapi_resource#parent_id "Documentation for parent_id input variable of the AzAPI provider on the Terraform Registry."
[tf_reg_threat_intelligence_allowlist]: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy#threat_intelligence_allowlist  "Documentation for threat_intelligence_allowlist blocks on the Terraform Registry."
