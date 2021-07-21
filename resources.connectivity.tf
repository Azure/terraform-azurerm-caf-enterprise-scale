resource "azurerm_resource_group" "connectivity" {
  for_each = local.azurerm_resource_group_connectivity

  provider = azurerm.connectivity

  # Mandatory resource attributes
  name     = each.value.template.name
  location = each.value.template.location
  tags     = each.value.template.tags
}

resource "azurerm_virtual_network" "connectivity" {
  for_each = local.azurerm_virtual_network_connectivity

  provider = azurerm.connectivity

  # Mandatory resource attributes
  name                = each.value.template.name
  resource_group_name = each.value.template.resource_group_name
  address_space       = each.value.template.address_space
  location            = each.value.template.location

  # Optional resource attributes
  bgp_community = each.value.template.bgp_community
  dns_servers   = each.value.template.dns_servers
  tags          = each.value.template.tags

  # Dynamic configuration blocks
  # Subnets excluded (use azurerm_subnet resource)
  dynamic "ddos_protection_plan" {
    for_each = each.value.template.ddos_protection_plan
    content {
      id     = ddos_protection_plan.value["id"]
      enable = ddos_protection_plan.value["enable"]
    }
  }

  # Set explicit dependencies
  depends_on = [
    azurerm_resource_group.connectivity,
    azurerm_network_ddos_protection_plan.connectivity,
  ]

}

resource "azurerm_subnet" "connectivity" {
  for_each = local.azurerm_subnet_connectivity

  provider = azurerm.connectivity

  # Mandatory resource attributes
  name                 = each.value.template.name
  resource_group_name  = each.value.template.resource_group_name
  virtual_network_name = each.value.template.virtual_network_name
  address_prefixes     = each.value.template.address_prefixes

  # Optional resource attributes
  enforce_private_link_endpoint_network_policies = each.value.template.enforce_private_link_endpoint_network_policies
  enforce_private_link_service_network_policies  = each.value.template.enforce_private_link_service_network_policies
  service_endpoints                              = each.value.template.service_endpoints
  service_endpoint_policy_ids                    = each.value.template.service_endpoint_policy_ids

  # Dynamic configuration blocks
  # Subnets excluded (use azurerm_subnet resource)
  dynamic "delegation" {
    for_each = each.value.template.delegation
    content {
      name = delegation.value["name"]

      dynamic "service_delegation" {
        for_each = delegation.value["service_delegation"]
        content {
          name    = service_delegation.value["name"]
          actions = try(service_delegation.value["actions"], null)
        }
      }
    }
  }

  # Set explicit dependencies
  depends_on = [
    azurerm_resource_group.connectivity,
    azurerm_virtual_network.connectivity,
    azurerm_network_ddos_protection_plan.connectivity,
  ]

}

resource "azurerm_network_ddos_protection_plan" "connectivity" {
  for_each = local.azurerm_network_ddos_protection_plan_connectivity

  provider = azurerm.connectivity

  # Mandatory resource attributes
  name                = each.value.template.name
  location            = each.value.template.location
  resource_group_name = each.value.template.resource_group_name

  # Optional resource attributes
  tags = each.value.template.tags

  # Set explicit dependencies
  depends_on = [
    azurerm_resource_group.connectivity,
  ]

}

resource "azurerm_public_ip" "connectivity" {
  for_each = local.azurerm_public_ip_connectivity

  provider = azurerm.connectivity

  # Mandatory resource attributes
  name                = each.value.template.name
  location            = each.value.template.location
  resource_group_name = each.value.template.resource_group_name
  allocation_method   = each.value.template.allocation_method

  # Optional resource attributes
  sku                     = each.value.template.sku
  availability_zone       = each.value.template.availability_zone
  ip_version              = each.value.template.ip_version
  idle_timeout_in_minutes = each.value.template.idle_timeout_in_minutes
  domain_name_label       = each.value.template.domain_name_label
  reverse_fqdn            = each.value.template.reverse_fqdn
  public_ip_prefix_id     = each.value.template.public_ip_prefix_id
  ip_tags                 = each.value.template.ip_tags
  tags                    = each.value.template.tags

  # Set explicit dependencies
  depends_on = [
    azurerm_resource_group.connectivity,
  ]

}

resource "azurerm_virtual_network_gateway" "connectivity" {
  for_each = local.azurerm_virtual_network_gateway_connectivity

  provider = azurerm.connectivity

  # Mandatory resource attributes
  name                = each.value.template.name
  resource_group_name = each.value.template.resource_group_name
  location            = each.value.template.location
  type                = each.value.template.type

  # Optional resource attributes
  vpn_type                         = each.value.template.vpn_type
  enable_bgp                       = each.value.template.enable_bgp
  active_active                    = each.value.template.active_active
  private_ip_address_enabled       = each.value.template.private_ip_address_enabled
  default_local_network_gateway_id = each.value.template.default_local_network_gateway_id
  sku                              = each.value.template.sku
  generation                       = each.value.template.generation
  tags                             = each.value.template.tags

  # Dynamic configuration blocks
  dynamic "ip_configuration" {
    for_each = each.value.template.ip_configuration
    content {
      # Mandatory attributes
      subnet_id            = ip_configuration.value["subnet_id"]
      public_ip_address_id = ip_configuration.value["public_ip_address_id"]
      # Optional attributes
      name                          = try(ip_configuration.value["name"], null)
      private_ip_address_allocation = try(ip_configuration.value["private_ip_address_allocation"], null)
    }
  }

  dynamic "vpn_client_configuration" {
    for_each = each.value.template.vpn_client_configuration
    content {
      # Mandatory attributes
      address_space = vpn_client_configuration.value["address_space"]
      # Optional attributes
      aad_tenant            = try(vpn_client_configuration.value["aad_tenant"], null)
      aad_audience          = try(vpn_client_configuration.value["aad_audience"], null)
      aad_issuer            = try(vpn_client_configuration.value["aad_issuer"], null)
      radius_server_address = try(vpn_client_configuration.value["radius_server_address"], null)
      radius_server_secret  = try(vpn_client_configuration.value["radius_server_secret"], null)
      vpn_client_protocols  = try(vpn_client_configuration.value["vpn_client_protocols"], null)

      dynamic "root_certificate" {
        for_each = try(vpn_client_configuration.value["root_certificate"], local.empty_list)
        content {
          name             = root_certificate.value["name"]
          public_cert_data = root_certificate.value["public_cert_data"]
        }
      }

      dynamic "revoked_certificate" {
        for_each = try(vpn_client_configuration.value["revoked_certificate"], local.empty_list)
        content {
          name       = root_certificate.value["name"]
          thumbprint = root_certificate.value["thumbprint"]
        }
      }
    }
  }

  dynamic "bgp_settings" {
    for_each = each.value.template.bgp_settings
    content {
      # Optional attributes
      asn             = try(bgp_settings.value["asn"], null)
      peering_address = try(bgp_settings.value["peering_address"], null)
      peer_weight     = try(bgp_settings.value["private_ip_address_allocation"], null)

      dynamic "peering_addresses" {
        for_each = try(bgp_settings.value["peering_addresses"], null)
        content {
          ip_configuration_name = try(peering_addresses.value["ip_configuration_name"], null)
          apipa_addresses       = try(peering_addresses.value["apipa_addresses"], null)
          default_addresses     = try(peering_addresses.value["default_addresses"], null)
          tunnel_ip_addresses   = try(peering_addresses.value["tunnel_ip_addresses"], null)
        }
      }
    }
  }

  dynamic "custom_route" {
    for_each = each.value.template.custom_route
    content {
      # Optional attributes
      address_prefixes = try(custom_route.value["address_prefixes"], null)
    }
  }

  # Set explicit dependencies
  depends_on = [
    azurerm_resource_group.connectivity,
    azurerm_virtual_network.connectivity,
    azurerm_subnet.connectivity,
    azurerm_public_ip.connectivity,
    azurerm_network_ddos_protection_plan.connectivity,
  ]

}

resource "azurerm_firewall" "connectivity" {
  for_each = local.azurerm_firewall_connectivity

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
    azurerm_virtual_network.connectivity,
    azurerm_subnet.connectivity,
    azurerm_public_ip.connectivity,
    azurerm_network_ddos_protection_plan.connectivity,
  ]

}

resource "azurerm_private_dns_zone" "connectivity" {
  for_each = local.azurerm_private_dns_zone_connectivity

  provider = azurerm.connectivity

  # Mandatory resource attributes
  name                = each.value.template.name
  resource_group_name = each.value.template.resource_group_name

  # Optional resource attributes
  tags = each.value.template.tags

  # Dynamic configuration blocks
  dynamic "soa_record" {
    for_each = each.value.template.soa_record
    content {
      # Mandatory attributes
      email = soa_record.value["email"]
      # Optional attributes
      expire_time  = try(soa_record.value["expire_time"], null)
      minimum_ttl  = try(soa_record.value["minimum_ttl"], null)
      refresh_time = try(soa_record.value["refresh_time"], null)
      retry_time   = try(soa_record.value["retry_time"], null)
      ttl          = try(soa_record.value["ttl"], null)
      tags         = try(soa_record.value["tags"], each.value.template.tags)
    }
  }

  # Set explicit dependencies
  depends_on = [
    azurerm_resource_group.connectivity,
  ]

}

resource "azurerm_dns_zone" "connectivity" {
  for_each = local.azurerm_dns_zone_connectivity

  provider = azurerm.connectivity

  # Mandatory resource attributes
  name                = each.value.template.name
  resource_group_name = each.value.template.resource_group_name

  # Optional resource attributes
  tags = each.value.template.tags

  # Dynamic configuration blocks
  dynamic "soa_record" {
    for_each = each.value.template.soa_record
    content {
      # Mandatory attributes
      email     = soa_record.value["email"]
      host_name = soa_record.value["host_name"]
      # Optional attributes
      expire_time   = try(soa_record.value["expire_time"], null)
      minimum_ttl   = try(soa_record.value["minimum_ttl"], null)
      refresh_time  = try(soa_record.value["refresh_time"], null)
      retry_time    = try(soa_record.value["retry_time"], null)
      serial_number = try(soa_record.value["serial_number"], null)
      ttl           = try(soa_record.value["ttl"], null)
      tags          = try(soa_record.value["tags"], each.value.template.tags)
    }
  }

  # Set explicit dependencies
  depends_on = [
    azurerm_resource_group.connectivity,
  ]

}

resource "azurerm_private_dns_zone_virtual_network_link" "connectivity" {
  for_each = local.azurerm_private_dns_zone_virtual_network_link_connectivity

  provider = azurerm.connectivity

  # Mandatory resource attributes
  name                  = each.value.template.name
  resource_group_name   = each.value.template.resource_group_name
  private_dns_zone_name = each.value.template.private_dns_zone_name
  virtual_network_id    = each.value.template.virtual_network_id

  # Optional resource attributes
  registration_enabled = each.value.template.registration_enabled
  tags                 = each.value.template.tags

  # Set explicit dependencies
  depends_on = [
    azurerm_resource_group.connectivity,
    azurerm_virtual_network.connectivity,
    azurerm_private_dns_zone.connectivity,
  ]

}

resource "azurerm_virtual_network_peering" "connectivity" {
  for_each = local.azurerm_virtual_network_peering_connectivity

  provider = azurerm.connectivity

  # Mandatory resource attributes
  name                      = each.value.template.name
  resource_group_name       = each.value.template.resource_group_name
  virtual_network_name      = each.value.template.virtual_network_name
  remote_virtual_network_id = each.value.template.remote_virtual_network_id

  # Optional resource attributes
  allow_virtual_network_access = each.value.template.allow_virtual_network_access
  allow_forwarded_traffic      = each.value.template.allow_forwarded_traffic
  allow_gateway_transit        = each.value.template.allow_gateway_transit
  use_remote_gateways          = each.value.template.use_remote_gateways

  # Set explicit dependencies
  depends_on = [
    azurerm_resource_group.connectivity,
    azurerm_virtual_network.connectivity,
  ]

}
