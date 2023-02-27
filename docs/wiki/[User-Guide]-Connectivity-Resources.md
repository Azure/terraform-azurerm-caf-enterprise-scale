<!-- markdownlint-disable first-line-h1 -->
## Overview

The module provides an option to enable deployment of [network topology and connectivity][alz_connectivity] resources from the [conceptual architecture for Azure landing zones][msdocs_alz_architecture] into the current subscription context. It also ensures that the specified subscription is placed in the right management group.

This capability enables deployment of multiple hub networks based on any combination of [traditional Azure networking topology (hub and spoke)](#traditional-azure-networking-topology-hub-and-spoke), and [Virtual WAN network topology (Microsoft-managed)](#virtual-wan-network-topology-microsoft-managed).

The module can also create and link [DDoS Protection](#ddos-protection-plan) Standard to Virtual Networks, and manage centralized public and private [DNS zones](#dns).

> **NOTE:**
> The module currently only configures the hub network(s), and other recommended resources for the `connectivity` Subscription.
> To ensure the right balance of managing resources via Terraform vs. Azure Policy, we are still working on how best to handle the creation and peering of spoke Virtual Networks.
> Improving this story is on our backlog for development.

## Resource types

### Traditional Azure networking topology (hub and spoke)

The module can optionally deploy one or more hub networks based on the [traditional Azure networking topology (hub and spoke)][msdocs_hub_and_spoke].

![Overview of the Azure landing zones connectivity resources using a traditional Azure networking topology (hub and spoke)][alz_hub_and_spoke_overview]

> **NOTE:**
> The module currently configures only the networking hub and dependent resources for the connectivity subscription.
> Although there's an option to enable outbound virtual network peering from hub to spoke, users still need to initiate peering from spoke to hub.
> This is due to limitations in how the AzureRM provider targets a specific subscription for deployment.

When you deploy resources based on a traditional Azure networking topology (hub and spoke), the module deploys and manages the following resource types (*depending on configuration*):

| Resource | Azure resource type | Terraform resource type |
| --- | --- | --- |
| Resource groups | [`Microsoft.Resources/resourceGroups`][arm_resource_group] | [`azurerm_resource_group`][azurerm_resource_group] |
| Virtual networks | [`Microsoft.Network/virtualNetworks`][arm_virtual_network] | [`azurerm_virtual_network`][azurerm_virtual_network] |
| Subnets | [`Microsoft.Network/virtualNetworks/subnets`][arm_subnet] | [`azurerm_subnet`][azurerm_subnet] |
| Virtual network gateways | [`Microsoft.Network/virtualNetworkGateways`][arm_virtual_network_gateway] | [`azurerm_virtual_network_gateway`][azurerm_virtual_network_gateway] |
| Azure firewalls | [`Microsoft.Network/azureFirewalls`][arm_firewall] | [`azurerm_firewall`][azurerm_firewall] |
| Public IP addresses | [`Microsoft.Network/publicIPAddresses`][arm_public_ip] | [`azurerm_public_ip`][azurerm_public_ip] |
| Virtual network peerings | [`Microsoft.Network/virtualNetworks/virtualNetworkPeerings`][arm_virtual_network_peering] | [`azurerm_virtual_network_peering`][azurerm_virtual_network_peering] |

For more information about how to use this capability, see the [Deploy Connectivity Resources][wiki_deploy_connectivity_resources] wiki page.

### Virtual WAN network topology (Microsoft-managed)

The module can optionally deploy one or more hub networks based on the [Virtual WAN network topology (Microsoft-managed)][msdocs_virtual_wan].

![Overview of the Azure landing zones connectivity resources using a Virtual WAN network topology (Microsoft-managed)][alz_virtual_wan_overview]

> **NOTE:**
> Due to the different capabilities of Virtual WAN network resources over traditional, peering for Virtual WAN spokes is bi-directional when using this capability.

When you deploy resources based on a Virtual WAN network topology (Microsoft-managed), the module deploys and manages the following resource types (*depending on configuration*):

| Resource | Azure resource type | Terraform resource type |
| --- | -------------- | ------------------ |
| Resource Groups | [`Microsoft.Resources/resourceGroups`][arm_resource_group] | [`azurerm_resource_group`][azurerm_resource_group] |
| Virtual WANs | [`Microsoft.Network/virtualWans`][arm_virtual_wan] | [`azurerm_virtual_wan`][azurerm_virtual_wan] |
| Virtual Hubs | [`Microsoft.Network/virtualHubs`][arm_virtual_hub] | [`azurerm_virtual_hub`][azurerm_virtual_hub] |
| Express Route Gateways | [`Microsoft.Network/expressRouteGateways`][arm_express_route_gateway] | [`azurerm_express_route_gateway`][azurerm_express_route_gateway] |
| VPN Gateways | [`Microsoft.Network/vpnGateways`][arm_vpn_gateway] | [`azurerm_vpn_gateway`][azurerm_vpn_gateway] |
| Azure Firewalls | [`Microsoft.Network/azureFirewalls`][arm_firewall] | [`azurerm_firewall`][azurerm_firewall] |
| Azure Firewall Policies | [`Microsoft.Network/firewallPolicies`][arm_firewall_policy] | [`azurerm_firewall_policy`][azurerm_firewall_policy] |
| Virtual Hub Connections | [`Microsoft.Network/virtualHubs/hubVirtualNetworkConnections`][arm_virtual_hub_connection] | [`azurerm_virtual_hub_connection`][azurerm_virtual_hub_connection] |

For more information about how to use this capability, see the [Deploy Virtual WAN Resources With Custom Settings][wiki_deploy_virtual_wan_resources] wiki page.

### DDoS Protection plan

The module can optionally deploy [DDoS Network Protection][about_ddos_network_protection], and link Virtual Networks to the plan if needed.

> **NOTE:**
> Due to platform limitations, DDoS protection plans can only be enabled for traditional virtual networks. Virtual Hub support is not currently available.

<!-- comment added to prevent linting error #MD028-no-blanks-blockquote-->

> **IMPORTANT:**
> The Azure landing zones guidance recommends enabling DDoS Network Protection to increase protection of your Azure platform. To prevent unexpected costs in non-production and MVP deployments, this capability is disabled in the Azure landing zones Terraform module due to the cost associated with this resource.
>
> For production environments, we strongly recommend enabling this capability.

When you enable deployment of deployment of DDoS protection plan resources, the module deploys and manages the following resource types (*depending on configuration*):

| Resource | Azure resource type | Terraform resource type |
| --- | --- | --- |
| Resource groups | [`Microsoft.Resources/resourceGroups`][arm_resource_group] | [`azurerm_resource_group`][azurerm_resource_group] |
| DDoS protection plans | [`Microsoft.Network/ddosProtectionPlans`][arm_ddos_protection_plan] | [`azurerm_network_ddos_protection_plan`][azurerm_network_ddos_protection_plan] |

### DNS

The module can optionally deploy [Private DNS zones to support Private Endpoints][about_dns_for_private_endpoint] and link them to hub and/or spoke Virtual Networks.
User-specified public and private DNS zones can also be deployed and linked as needed.

When you enable deployment of deployment of DNS resources, the module deploys and manages the following resource types (*depending on configuration*):

| Resource | Azure resource type | Terraform resource type |
| --- | -------------- | ------------------ |
| Resource Groups | [`Microsoft.Resources/resourceGroups`][arm_resource_group] | [`azurerm_resource_group`][azurerm_resource_group] |
| DNS Zones | [`Microsoft.Network/dnsZones`][arm_dns_zone] | [`azurerm_dns_zone`][azurerm_dns_zone] |
| Private DNS Zones | [`Microsoft.Network/privateDnsZones`][arm_private_dns_zone] | [`azurerm_private_dns_zone`][azurerm_private_dns_zone] |
| Private DNS Zone Virtual Network Link | [`Microsoft.Network/privatednszones/virtualnetworklinks`][arm_private_dns_zone_virtual_network_link] | [`azurerm_private_dns_zone_virtual_network_link`][azurerm_private_dns_zone_virtual_network_link] |

## Next steps

Please refer to the following for examples showing how to use this capability:

- [Deploy Connectivity Examples (Hub and Spoke)][wiki_deploy_connectivity_resources]
- [Deploy Connectivity Examples (Virtual WAN)][wiki_deploy_virtual_wan_resources]
- [Configure hub networks (Hub and Spoke)][wiki_configure_connectivity_resources_hubs]
- [Configure hub networks (Virtual WAN)][wiki_configure_connectivity_resources_virtual_hubs]
- [Configure DDoS Protection settings][wiki_configure_connectivity_resources_ddos]
- [Configure DNS settings][wiki_configure_connectivity_resources_dns]

<!-- Need to add examples for DDoS and DNS -->

 [//]: # (*****************************)
 [//]: # (INSERT IMAGE REFERENCES BELOW)
 [//]: # (*****************************)

[alz_hub_and_spoke_overview]: media/terraform-caf-enterprise-scale-connectivity.png "A conceptual architecture diagram focusing on the connectivity resources for an Azure landing zone using a traditional Azure networking topology (hub and spoke)."
[alz_virtual_wan_overview]:   media/terraform-caf-enterprise-scale-virtual-wan.png "A conceptual architecture diagram focusing on the connectivity resources for an Azure landing zone using a Virtual WAN network topology (Microsoft-managed)."

 [//]: # (************************)
 [//]: # (INSERT LINK LABELS BELOW)
 [//]: # (************************)

[msdocs_alz_architecture]: https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/#azure-landing-zone-conceptual-architecture "Conceptual architecture for Azure landing zones."
[msdocs_hub_and_spoke]:    https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology
[msdocs_virtual_wan]:      https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/virtual-wan-network-topology

[alz_connectivity]: https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/network-topology-and-connectivity "Network topology and connectivity for Azure landing zones on the Cloud Adoption Framework."

[about_ddos_network_protection]:  https://learn.microsoft.com/azure/ddos-protection/ddos-protection-overview
[about_dns_for_private_endpoint]: https://learn.microsoft.com/azure/private-link/private-endpoint-dns#azure-services-dns-zone-configuration

[arm_resource_group]:                        https://learn.microsoft.com/azure/templates/microsoft.resources/resourcegroups
[arm_virtual_network]:                       https://learn.microsoft.com/azure/templates/microsoft.network/virtualnetworks
[arm_subnet]:                                https://learn.microsoft.com/azure/templates/microsoft.network/virtualnetworks/subnets
[arm_virtual_network_gateway]:               https://learn.microsoft.com/azure/templates/microsoft.network/virtualnetworkgateways
[arm_firewall]:                              https://learn.microsoft.com/azure/templates/microsoft.network/azurefirewalls
[arm_public_ip]:                             https://learn.microsoft.com/azure/templates/microsoft.network/publicipaddresses
[arm_ddos_protection_plan]:                  https://learn.microsoft.com/azure/templates/microsoft.network/ddosprotectionplans
[arm_dns_zone]:                              https://learn.microsoft.com/azure/templates/microsoft.network/dnszones
[arm_private_dns_zone]:                      https://learn.microsoft.com/azure/templates/microsoft.network/privatednszones
[arm_private_dns_zone_virtual_network_link]: https://learn.microsoft.com/azure/templates/microsoft.network/privatednszones/virtualnetworklinks
[arm_virtual_network_peering]:               https://learn.microsoft.com/azure/templates/microsoft.network/virtualnetworks/virtualnetworkpeerings
[arm_virtual_wan]:                           https://learn.microsoft.com/azure/templates/microsoft.network/virtualWans
[arm_virtual_hub]:                           https://learn.microsoft.com/azure/templates/microsoft.network/virtualHubs
[arm_express_route_gateway]:                 https://learn.microsoft.com/azure/templates/microsoft.network/expressRouteGateways
[arm_vpn_gateway]:                           https://learn.microsoft.com/azure/templates/microsoft.network/vpnGateways
[arm_firewall_policy]:                       https://learn.microsoft.com/azure/templates/microsoft.network/firewallPolicies
[arm_virtual_hub_connection]:                https://learn.microsoft.com/azure/templates/microsoft.network/virtualHubs/hubVirtualNetworkConnections

[azurerm_resource_group]:                        https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group
[azurerm_virtual_network]:                       https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network
[azurerm_subnet]:                                https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet
[azurerm_virtual_network_gateway]:               https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway
[azurerm_firewall]:                              https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall
[azurerm_public_ip]:                             https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip
[azurerm_network_ddos_protection_plan]:          https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_ddos_protection_plan
[azurerm_dns_zone]:                              https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_zone
[azurerm_private_dns_zone]:                      https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone
[azurerm_private_dns_zone_virtual_network_link]: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link
[azurerm_virtual_network_peering]:               https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering
[azurerm_virtual_wan]:                           https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_wan
[azurerm_virtual_hub]:                           https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_hub
[azurerm_express_route_gateway]:                 https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/express_route_gateway
[azurerm_vpn_gateway]:                           https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/vpn_gateway
[azurerm_firewall_policy]:                       https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy
[azurerm_virtual_hub_connection]:                https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_hub_connection

[wiki_deploy_connectivity_resources]:                 https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Connectivity-Resources "Wiki - Deploy Connectivity Resources"
[wiki_deploy_virtual_wan_resources]:                  https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Virtual-WAN-Resources-With-Custom-Settings "Wiki: Deploy Virtual WAN Resources With Custom Settings"
[wiki_configure_connectivity_resources_hubs]:         https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BVariables%5D-configure_connectivity_resources#configure-hub-networks-hub-and-spoke "Instructions for how to use the configure_connectivity_resources variable to configure hub network settings."
[wiki_configure_connectivity_resources_virtual_hubs]: https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BVariables%5D-configure_connectivity_resources#configure-hub-networks-virtual-wan "Instructions for how to use the configure_connectivity_resources variable to configure virtual hub network settings."
[wiki_configure_connectivity_resources_ddos]:         https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BVariables%5D-configure_connectivity_resources#configure-ddos-protection-plan "Instructions for how to use the configure_connectivity_resources variable to configure DDoS protection plan settings."
[wiki_configure_connectivity_resources_dns]:          https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BVariables%5D-configure_connectivity_resources#configure-dns "Instructions for how to use the configure_connectivity_resources variable to configure DNS settings."
