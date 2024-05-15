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
  sku                    = each.value.template.sku
  address_prefix         = each.value.template.address_prefix
  hub_routing_preference = each.value.template.hub_routing_preference
  virtual_wan_id         = each.value.template.virtual_wan_id
  tags                   = each.value.template.tags

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
  name                          = each.value.template.name
  resource_group_name           = each.value.template.resource_group_name
  location                      = each.value.template.location
  virtual_hub_id                = each.value.template.virtual_hub_id
  scale_units                   = each.value.template.scale_units
  allow_non_virtual_wan_traffic = each.value.template.allow_non_virtual_wan_traffic
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

resource "azurerm_firewall_policy" "virtual_wan" {
  for_each = local.azurerm_firewall_policy_virtual_wan

  provider = azurerm.connectivity

  # Mandatory resource attributes
  name                = each.value.template.name
  resource_group_name = each.value.template.resource_group_name
  location            = each.value.template.location

  # Optional resource attributes
  base_policy_id           = each.value.template.base_policy_id
  private_ip_ranges        = each.value.template.private_ip_ranges
  sku                      = each.value.template.sku
  tags                     = each.value.template.tags
  threat_intelligence_mode = each.value.template.threat_intelligence_mode

  # Dynamic configuration blocks
  dynamic "dns" {
    for_each = each.value.template.dns
    content {
      # Optional attributes
      proxy_enabled = lookup(dns.value, "proxy_enabled", null)
      servers       = lookup(dns.value, "servers", null)
    }
  }

  dynamic "identity" {
    for_each = each.value.template.identity
    content {
      # Mandatory attributes
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "insights" {
    for_each = each.value.template.insights
    content {
      # Mandatory attributes
      enabled                            = insights.value.enabled
      default_log_analytics_workspace_id = insights.value.default_log_analytics_workspace_id
      # Optional attributes
      retention_in_days = lookup(insights.value, "retention_in_days", null)
      # Dynamic configuration blocks
      dynamic "log_analytics_workspace" {
        for_each = lookup(insights.value, "log_analytics_workspace", local.empty_list)
        content {
          # Mandatory attributes
          id                = log_analytics_workspace.value["id"]
          firewall_location = log_analytics_workspace.value["firewall_location"]
        }
      }
    }
  }

  dynamic "intrusion_detection" {
    for_each = each.value.template.intrusion_detection
    content {
      # Optional attributes
      mode = lookup(intrusion_detection.value, "mode", null)
      # Dynamic configuration blocks
      dynamic "signature_overrides" {
        for_each = lookup(intrusion_detection.value, "signature_overrides", local.empty_list)
        content {
          # Optional attributes
          id    = lookup(signature_overrides.value, "id", null)
          state = lookup(signature_overrides.value, "state", null)
        }
      }
      dynamic "traffic_bypass" {
        for_each = lookup(intrusion_detection.value, "traffic_bypass", local.empty_list)
        content {
          # Mandatory attributes
          name     = traffic_bypass.value["name"]
          protocol = traffic_bypass.value["protocol"]
          # Optional attributes
          description           = lookup(traffic_bypass.value, "description", null)
          destination_addresses = lookup(traffic_bypass.value, "destination_addresses", null)
          destination_ip_groups = lookup(traffic_bypass.value, "destination_ip_groups", null)
          destination_ports     = lookup(traffic_bypass.value, "destination_ports", null)
          source_addresses      = lookup(traffic_bypass.value, "source_addresses", null)
          source_ip_groups      = lookup(traffic_bypass.value, "source_ip_groups", null)
        }
      }
    }
  }

  dynamic "threat_intelligence_allowlist" {
    # Ensure that the dynamic block is created only if the allowlist is defined
    for_each = length(keys(each.value.template.threat_intelligence_allowlist)) > 0 ? [each.value.template.threat_intelligence_allowlist] : []

    content {
      # Optional attributes
      fqdns        = lookup(threat_intelligence_allowlist.value, "fqdns", null)
      ip_addresses = lookup(threat_intelligence_allowlist.value, "ip_addresses", null)
    }
  }


  # Set explicit dependencies
  depends_on = [
    azurerm_resource_group.connectivity,
    azurerm_resource_group.virtual_wan,
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
    azurerm_firewall_policy.virtual_wan,
  ]

}

resource "azurerm_virtual_hub_connection" "virtual_wan" {
  for_each = local.azurerm_virtual_hub_connection

  provider = azurerm.connectivity

  # Mandatory resource attributes
  name                      = each.value.template.name
  virtual_hub_id            = each.value.template.virtual_hub_id
  remote_virtual_network_id = each.value.template.remote_virtual_network_id

  # Optional resource attributes
  internet_security_enabled = each.value.template.internet_security_enabled

  # Dynamic configuration blocks
  dynamic "routing" {
    for_each = each.value.template.routing
    content {
      # Optional attributes
      associated_route_table_id = lookup(routing.value, "associated_route_table_id", null)
      dynamic "propagated_route_table" {
        for_each = lookup(routing.value, "propagated_route_table", local.empty_list)
        content {
          # Optional attributes
          labels          = lookup(propagated_route_table.value, "labels", null)
          route_table_ids = lookup(propagated_route_table.value, "route_table_ids", null)
        }
      }
      dynamic "static_vnet_route" {
        for_each = lookup(routing.value, "static_vnet_route", local.empty_list)
        content {
          # Optional attributes
          name                = lookup(static_vnet_route.value, "name", null)
          address_prefixes    = lookup(static_vnet_route.value, "address_prefixes", null)
          next_hop_ip_address = lookup(static_vnet_route.value, "next_hop_ip_address", null)
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

resource "azurerm_virtual_hub_routing_intent" "virtual_wan" {
  for_each = local.azurerm_virtual_hub_routing_intent

  name           = each.value.template.name
  virtual_hub_id = each.value.template.virtual_hub_id

  dynamic "routing_policy" {
    for_each = each.value.template.routing_policy
    content {
      name         = routing_policy.value.name
      destinations = routing_policy.value.destinations
      next_hop     = routing_policy.value.next_hop
    }
  }

  # Set explicit dependencies
  depends_on = [
    azurerm_firewall.virtual_wan,
    azurerm_resource_group.connectivity,
    azurerm_resource_group.virtual_wan,
    azurerm_virtual_wan.virtual_wan,
    azurerm_virtual_hub.virtual_wan,
  ]
}
