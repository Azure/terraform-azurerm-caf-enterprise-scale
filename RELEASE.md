# [v3.1.2] HOTFIX: Update VPN gateway defaults, and DNS logic

## Overview

The `v3.1.2` release includes an important update to the default values for `azurerm_virtual_network_gateway` resources.

### New features

- Added logic to safely handle duplicate DNS zone values provided via the `configure_connectivity_resources.settings.dns.config.public_dns_zones` and `configure_connectivity_resources.settings.dns.config.private_dns_zones` inputs
- Updated default value for `configure_connectivity_resources.settings.hub_networks.*.config.virtual_network_gateway.config.advanced_vpn_settings.vpn_client_configuration.*.vpn_client_protocols` setting to `null`
- Updated default value for `configure_connectivity_resources.settings.hub_networks.*.config.virtual_network_gateway.config.advanced_vpn_settings.vpn_client_configuration.*.vpn_auth_types` setting to `null`
- Updated default value for `configure_connectivity_resources.settings.hub_networks.*.config.virtual_network_gateway.config.advanced_vpn_settings.bgp_settings.*.peering_addresses.*.apipa_addresses` setting to `null`

### Fixed issues

- Fix [577](https://github.com/Azure/Enterprise-Scale/issues/577) (duplicate key on private dns zones when upgrading Bug Report #577)

### Breaking changes

n/a

### Input variable changes

none

## For more information

**Full Changelog**: [v3.1.1...v3.1.2](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/compare/v3.1.1...v3.1.2)
