# Configure the connectivity resources settings.
locals {
  configure_connectivity_resources = {
    settings = {
      hub_networks = [
        {
          enabled = true
          config = {
            address_space                   = ["10.100.0.0/16", ]
            location                        = var.location
            enable_ddos_protection_standard = false
            dns_servers                     = []
            bgp_community                   = ""
            subnets                         = []
            virtual_network_gateway = {
              enabled = true
              config = {
                address_prefix           = "10.100.1.0/24"
                gateway_sku_expressroute = "ErGw2AZ"
                gateway_sku_vpn          = "VpnGw2AZ"
              }
            }
            azure_firewall = {
              enabled = true
              config = {
                address_prefix   = "10.100.0.0/24"
                enable_dns_proxy = true
                availability_zones = {
                  zone_1 = true
                  zone_2 = true
                  zone_3 = true
                }
              }
            }
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
        enabled = false
        config = {
          location          = ""
          public_dns_zones  = []
          private_dns_zones = []
        }
      }
    }

    location = null
    tags = null
    advanced = null
  }
}
