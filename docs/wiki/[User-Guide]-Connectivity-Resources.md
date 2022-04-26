## Overview

The module enables deployment of [Network topology and connectivity][ESLZ-Connectivity] resources into the Subscription context set by the `azurerm.connectivity` provider alias.

![Enterprise-scale Connectivity Landing Zone Architecture][TFAES-Connectivity]

The module supports creating multiple hubs (one per specified location) in both a `Hub and Spoke` or `Virtual WAN` configuration.
There are also additional supporting resources deployed for DDoS Protection and DNS zones.
You can also create a combination of both topologies.

Each hub can be individually configured as needed.

> **NOTE:** The module currently only configures the networking hub, and dependent resources for the `Connectivity` Subscription.
> To ensure we achieve the right balance of managing resources via Terraform vs. Azure Policy, we are still working on how best to handle the creation of spoke Virtual Networks and Virtual Network Peering.
> Improving this story is our next priority on the product roadmap.

## Resource types

The following resource types are deployed and managed by this module when the Connectivity capabilities are enabled:

|     | Azure Resource | Terraform Resource |
| --- | -------------- | ------------------ |
| Resource Groups | [`Microsoft.Resources/resourceGroups`][arm_resource_group] | [`azurerm_resource_group`][azurerm_resource_group] |
| Virtual Networks | [`Microsoft.Network/virtualNetworks`][arm_virtual_network] | [`azurerm_virtual_network`][azurerm_virtual_network] |
| Subnets | [`Microsoft.Network/virtualNetworks/subnets`][arm_subnet] | [`azurerm_subnet`][azurerm_subnet] |
| Virtual Network Gateways | [`Microsoft.Network/virtualNetworkGateways`][arm_virtual_network_gateway] | [`azurerm_virtual_network_gateway`][azurerm_virtual_network_gateway] |
| Azure Firewalls | [`Microsoft.Network/azureFirewalls`][arm_firewall] | [`azurerm_firewall`][azurerm_firewall] |
| Azure Firewall Policies | [`Microsoft.Network/firewallPolicies`][arm_firewall_policy] | [`azurerm_firewall_policy`][azurerm_firewall_policy] |
| Public IP Addresses | [`Microsoft.Network/publicIPAddresses`][arm_public_ip] | [`azurerm_public_ip`][azurerm_public_ip] |
| Virtual Network Peerings | [`Microsoft.Network/virtualNetworks/virtualNetworkPeerings`][arm_virtual_network_peering] | [`azurerm_virtual_network_peering`][azurerm_virtual_network_peering] |
| Virtual WANs | [`Microsoft.Network/virtualWans`][arm_virtual_wan] | [`azurerm_virtual_wan`][azurerm_virtual_wan] |
| Virtual Hubs | [`Microsoft.Network/virtualHubs`][arm_virtual_hub] | [`azurerm_virtual_hub`][azurerm_virtual_hub] |
| Express Route Gateways | [`Microsoft.Network/expressRouteGateways`][arm_express_route_gateway] | [`azurerm_express_route_gateway`][azurerm_express_route_gateway] |
| VPN Gateways | [`Microsoft.Network/vpnGateways`][arm_vpn_gateway] | [`azurerm_vpn_gateway`][azurerm_vpn_gateway] |
| Azure Firewalls | [`Microsoft.Network/azureFirewalls`][arm_firewall] | [`azurerm_firewall`][azurerm_firewall] |
| Azure Firewall Policies | [`Microsoft.Network/firewallPolicies`][arm_firewall_policy] | [`azurerm_firewall_policy`][azurerm_firewall_policy] |
| Virtual Hub Connections | [`Microsoft.Network/virtualHubs/hubVirtualNetworkConnections`][arm_virtual_hub_connection] | [`azurerm_virtual_hub_connection`][azurerm_virtual_hub_connection] |
| DDoS Protection Plans | [`Microsoft.Network/ddosProtectionPlans`][arm_ddos_protection_plan] | [`azurerm_network_ddos_protection_plan`][azurerm_network_ddos_protection_plan] |
| DNS Zones | [`Microsoft.Network/dnsZones`][arm_dns_zone] | [`azurerm_dns_zone`][azurerm_dns_zone] |

## Next steps

Please refer to [Deploy Connectivity Examples][wiki_deploy_connectivity_resources] for examples showing how to use this capability.

 [//]: # (*****************************)
 [//]: # (INSERT IMAGE REFERENCES BELOW)
 [//]: # (*****************************)

[TFAES-Connectivity]: ./media/terraform-caf-enterprise-scale-connectivity.png "Diagram showing the Connectivity resources for Azure landing zones architecture deployed by this module."

 [//]: # (************************)
 [//]: # (INSERT LINK LABELS BELOW)
 [//]: # (************************)

[ESLZ-Connectivity]: https://docs.microsoft.com/azure/cloud-adoption-framework/ready/enterprise-scale/network-topology-and-connectivity

[arm_resource_group]:                 https://docs.microsoft.com/azure/templates/microsoft.resources/resourcegroups
[arm_virtual_network]:                https://docs.microsoft.com/azure/templates/microsoft.network/virtualnetworks
[arm_subnet]:                         https://docs.microsoft.com/azure/templates/microsoft.network/virtualnetworks/subnets
[arm_virtual_network_gateway]:        https://docs.microsoft.com/azure/templates/microsoft.network/virtualnetworkgateways
[arm_firewall]:                       https://docs.microsoft.com/azure/templates/microsoft.network/azurefirewalls
[arm_public_ip]:                      https://docs.microsoft.com/azure/templates/microsoft.network/publicipaddresses
[arm_ddos_protection_plan]:           https://docs.microsoft.com/azure/templates/microsoft.network/ddosprotectionplans
[arm_dns_zone]:                       https://docs.microsoft.com/azure/templates/microsoft.network/dnszones
[arm_virtual_network_peering]:        https://docs.microsoft.com/azure/templates/microsoft.network/virtualnetworks/virtualnetworkpeerings
[arm_virtual_wan]:                    https://docs.microsoft.com/azure/templates/microsoft.network/virtualWans
[arm_virtual_hub]:                    https://docs.microsoft.com/azure/templates/microsoft.network/virtualHubs
[arm_express_route_gateway]:          https://docs.microsoft.com/azure/templates/microsoft.network/expressRouteGateways
[arm_vpn_gateway]:                    https://docs.microsoft.com/azure/templates/microsoft.network/vpnGateways
[arm_firewall_policy]:                https://docs.microsoft.com/azure/templates/microsoft.network/firewallPolicies
[arm_virtual_hub_connection]:         https://docs.microsoft.com/azure/templates/microsoft.network/virtualHubs/hubVirtualNetworkConnections

[azurerm_resource_group]:               https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group
[azurerm_virtual_network]:              https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network
[azurerm_subnet]:                       https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet
[azurerm_virtual_network_gateway]:      https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway
[azurerm_firewall]:                     https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall
[azurerm_public_ip]:                    https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip
[azurerm_network_ddos_protection_plan]: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_ddos_protection_plan
[azurerm_dns_zone]:                     https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_zone
[azurerm_virtual_network_peering]:      https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering
[azurerm_virtual_wan]:                        https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_wan
[azurerm_virtual_hub]:                        https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_hub
[azurerm_express_route_gateway]:              https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/express_route_gateway
[azurerm_vpn_gateway]:                        https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/vpn_gateway
[azurerm_firewall_policy]:                    https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy
[azurerm_virtual_hub_connection]:             https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_hub_connection

[wiki_deploy_connectivity_resources]:         https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Connectivity-Resources "Wiki - Deploy Connectivity Resources"
