## Overview

From release `v0.4.0` onwards, the module includes new functionality to enable deployment of [Network topology and connectivity][ESLZ-Connectivity] resources into the current Subscription context.
This is currently limited to the Hub & Spoke network topology, but the addition of Virtual WAN capabilities is on our roadmap (date TBC).

![Enterprise-scale Connectivity Landing Zone Architecture][TFAES-Connectivity]

> **NOTE:** The module currently only configures the networking hub, and dependent resources for the `Connectivity` Subscription.
> To ensure we achieve the right balance of managing resources via Terraform vs. Azure Policy, we are still working on how best to handle the creation of spoke Virtual Networks and Virtual Network Peering.
> Improving this story is our next priority on the product roadmap.

## Resource types

The following resource types are deployed and managed by this module when the Connectivity resources capabilities are enabled:

|     | Azure Resource | Terraform Resource |
| --- | -------------- | ------------------ |
| Resource Groups | [`Microsoft.Resources/resourceGroups`][arm_resource_group] | [`azurerm_resource_group`][azurerm_resource_group] |
| Virtual Networks | [`Microsoft.Network/virtualNetworks`][arm_virtual_network] | [`azurerm_virtual_network`][azurerm_virtual_network] |
| Subnets | [`Microsoft.Network/virtualNetworks/subnets`][arm_subnet] | [`azurerm_subnet`][azurerm_subnet] |
| Virtual Network Gateways | [`Microsoft.Network/virtualNetworkGateways`][arm_virtual_network_gateway] | [`azurerm_virtual_network_gateway`][azurerm_virtual_network_gateway] |
| Azure Firewalls | [`Microsoft.Network/azureFirewalls`][arm_firewall] | [`azurerm_firewall`][azurerm_firewall] |
| Public IP Addresses | [`Microsoft.Network/publicIPAddresses`][arm_public_ip] | [`azurerm_public_ip`][azurerm_public_ip] |
| DDoS Protection Plans | [`Microsoft.Network/ddosProtectionPlans`][arm_ddos_protection_plan] | [`azurerm_network_ddos_protection_plan`][azurerm_network_ddos_protection_plan] |
| DNS Zones (pending) | [`Microsoft.Network/dnsZones`][arm_dns_zone] | [`azurerm_dns_zone`][azurerm_dns_zone] |
| Virtual Network Peerings (pending) | [`Microsoft.Network/virtualNetworks/virtualNetworkPeerings`][arm_virtual_network_peering] | [`azurerm_virtual_network_peering`][azurerm_virtual_network_peering] |

## Next steps

Please refer to [Deploy Connectivity Examples][wiki_deploy_connectivity_resources] for examples showing how to use this capability.

 [//]: # (*****************************)
 [//]: # (INSERT IMAGE REFERENCES BELOW)
 [//]: # (*****************************)

[TFAES-Connectivity]: ./media/terraform-caf-enterprise-scale-connectivity.png "Diagram showing the Connectivity resources for Cloud Adoption Framework Enterprise-scale Landing Zone architecture deployed by this module."

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

[azurerm_resource_group]:               https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group
[azurerm_virtual_network]:              https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network
[azurerm_subnet]:                       https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet
[azurerm_virtual_network_gateway]:      https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway
[azurerm_firewall]:                     https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall
[azurerm_public_ip]:                    https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip
[azurerm_network_ddos_protection_plan]: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_ddos_protection_plan
[azurerm_dns_zone]:                     https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_zone
[azurerm_virtual_network_peering]:      https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering

[wiki_deploy_connectivity_resources]:         https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Connectivity-Resources "Wiki - Deploy Connectivity Resources"
