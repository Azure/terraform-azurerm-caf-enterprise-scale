resource "azurerm_resource_group" "virtual_wan" {
  for_each = local.azurerm_resource_group_virtual_wan

  provider = azurerm.connectivity

  # Mandatory resource attributes
  name     = each.value.template.name
  location = each.value.template.location
  tags     = each.value.template.tags
}

resource "azurerm_virtual_wan" "virtual_wan" {
  for_each = local.azurerm_virtual_wan_virtual_wan

  provider = azurerm.connectivity

  # Mandatory resource attributes
  name                = each.value.template.name
  resource_group_name = each.value.template.resource_group_name
  location            = each.value.template.location

  # Optional resource attributes
  disable_vpn_encryption            = each.value.template.disable_vpn_encryption
  allow_branch_to_branch_traffic    = each.value.template.allow_branch_to_branch_traffic
  office365_local_breakout_category = each.value.template.office365_local_breakout_category
  type                              = each.value.template.type
  tags                              = each.value.template.tags

  # Set explicit dependencies
  depends_on = [
    azurerm_resource_group.connectivity,
    azurerm_resource_group.virtual_wan,
  ]

}

resource "azurerm_virtual_hub" "virtual_wan" {
  for_each = local.azurerm_virtual_hub_virtual_wan

  provider = azurerm.connectivity

  # Mandatory resource attributes
  name                = each.value.template.name
  resource_group_name = each.value.template.resource_group_name
  location            = each.value.template.location

  # Optional resource attributes
  sku            = each.value.template.sku
  address_prefix = each.value.template.address_prefix
  virtual_wan_id = each.value.template.virtual_wan_id
  tags           = each.value.template.tags

  # Dynamic configuration blocks
  dynamic "route" {
    for_each = each.value.template.route
    content {
      # Mandatory attributes
      address_prefixes    = route.value["address_prefixes"]
      next_hop_ip_address = route.value["next_hop_ip_address"]
    }
  }

  # Set explicit dependencies
  depends_on = [
    azurerm_resource_group.connectivity,
    azurerm_resource_group.virtual_wan,
    azurerm_virtual_wan.virtual_wan,
  ]

}

resource "azurerm_express_route_gateway" "virtual_wan" {
  for_each = local.azurerm_express_route_gateway_virtual_wan

  provider = azurerm.connectivity

  # Mandatory resource attributes
  name                = each.value.template.name
  resource_group_name = each.value.template.resource_group_name
  location            = each.value.template.location
  virtual_hub_id      = each.value.template.virtual_hub_id
  scale_units         = each.value.template.scale_units

  # Optional resource attributes
  tags = each.value.template.tags

  # Set explicit dependencies
  depends_on = [
    azurerm_resource_group.connectivity,
    azurerm_resource_group.virtual_wan,
    azurerm_virtual_wan.virtual_wan,
    azurerm_virtual_hub.virtual_wan,
  ]

}

resource "azurerm_vpn_gateway" "virtual_wan" {
  for_each = local.azurerm_vpn_gateway_virtual_wan

  provider = azurerm.connectivity

  # Mandatory resource attributes
  name                = each.value.template.name
  resource_group_name = each.value.template.resource_group_name
  location            = each.value.template.location
  virtual_hub_id      = each.value.template.virtual_hub_id

  # Optional resource attributes
  routing_preference = each.value.template.routing_preference
  scale_unit         = each.value.template.scale_unit
  tags               = each.value.template.tags

  # Dynamic configuration blocks
  dynamic "bgp_settings" {
    for_each = each.value.template.bgp_settings
    content {
      # Mandatory attributes
      asn         = bgp_settings.value["asn"]
      peer_weight = bgp_settings.value["peer_weight"]
      # Dynamic configuration blocks
      dynamic "instance_0_bgp_peering_address" {
        for_each = bgp_settings.value["instance_0_bgp_peering_address"]
        content {
          custom_ips = instance_0_bgp_peering_address.value["custom_ips"]
        }
      }
      dynamic "instance_1_bgp_peering_address" {
        for_each = bgp_settings.value["instance_1_bgp_peering_address"]
        content {
          custom_ips = instance_1_bgp_peering_address.value["custom_ips"]
        }
      }
    }
  }

  # Set explicit dependencies
  depends_on = [
    azurerm_resource_group.connectivity,
    azurerm_resource_group.virtual_wan,
    azurerm_virtual_wan.virtual_wan,
    azurerm_virtual_hub.virtual_wan,
  ]

}

resource "azurerm_firewall" "virtual_wan" {
  for_each = local.azurerm_firewall_virtual_wan

  provider = azurerm.connectivity

  # Mandatory resource attributes
  name                = each.value.template.name
  resource_group_name = each.value.template.resource_group_name
  location            = each.value.template.location

  # Optional resource attributes
  sku_name           = each.value.template.sku_name
  sku_tier           = each.value.template.sku_tier
  firewall_policy_id = each.value.template.firewall_policy_id
  dns_servers        = each.value.template.dns_servers
  private_ip_ranges  = each.value.template.private_ip_ranges
  threat_intel_mode  = each.value.template.threat_intel_mode
  zones              = each.value.template.zones
  tags               = each.value.template.tags

  # Dynamic configuration blocks
  dynamic "ip_configuration" {
    for_each = each.value.template.ip_configuration
    content {
      # Mandatory attributes
      name                 = ip_configuration.value["name"]
      public_ip_address_id = ip_configuration.value["public_ip_address_id"]
      # Optional attributes
      subnet_id = try(ip_configuration.value["subnet_id"], null)
    }
  }

  dynamic "management_ip_configuration" {
    for_each = each.value.template.management_ip_configuration
    content {
      # Mandatory attributes
      name                 = management_ip_configuration.value["name"]
      public_ip_address_id = management_ip_configuration.value["public_ip_address_id"]
      # Optional attributes
      subnet_id = try(management_ip_configuration.value["subnet_id"], null)
    }
  }

  dynamic "virtual_hub" {
    for_each = each.value.template.virtual_hub
    content {
      # Mandatory attributes
      virtual_hub_id = virtual_hub.value["virtual_hub_id"]
      # Optional attributes
      public_ip_count = try(virtual_hub.value["public_ip_count"], null)
    }
  }

  # Set explicit dependencies
  depends_on = [
    azurerm_resource_group.connectivity,
    azurerm_resource_group.virtual_wan,
    azurerm_virtual_wan.virtual_wan,
    azurerm_virtual_hub.virtual_wan,
  ]

}

# resource "azurerm_virtual_network_peering" "virtual_wan" {
#   for_each = local.azurerm_virtual_network_peering_virtual_wan

#   provider = azurerm.connectivity

#   # Mandatory resource attributes
#   name                      = each.value.template.name
#   resource_group_name       = each.value.template.resource_group_name
#   virtual_network_name      = each.value.template.virtual_network_name
#   remote_virtual_network_id = each.value.template.remote_virtual_network_id

#   # Optional resource attributes
#   allow_virtual_network_access = each.value.template.allow_virtual_network_access
#   allow_forwarded_traffic      = each.value.template.allow_forwarded_traffic
#   allow_gateway_transit        = each.value.template.allow_gateway_transit
#   use_remote_gateways          = each.value.template.use_remote_gateways

#   # Set explicit dependencies
#   depends_on = [
#     azurerm_resource_group.connectivity,
#     azurerm_virtual_network.connectivity,
#   ]

# }
