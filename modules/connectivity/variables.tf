# The following variables are used to determine the archetype
# definition to use and create the required resources.
#
# Further information provided within the description block
# for each variable

variable "enabled" {
  type        = bool
  description = "Controls whether to manage the connectivity landing zone policies and deploy the connectivity resources into the current Subscription context."
}

variable "root_id" {
  type        = string
  description = "Specifies the ID of the Enterprise-scale root Management Group, used as a prefix for resources created by this module."

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{2,10}$", var.root_id))
    error_message = "Value must be between 2 to 10 characters long, consisting of alphanumeric characters and hyphens."
  }
}

variable "subscription_id" {
  type        = string
  description = "Specifies the Subscription ID for the Subscription containing all connectivity resources."

  validation {
    condition     = can(regex("^[a-z0-9-]{36}$", var.subscription_id)) || var.subscription_id == ""
    error_message = "Value must be a valid Subscription ID (GUID)."
  }
}

variable "location" {
  type        = string
  description = "Sets the default location used for resource deployments where needed."
  default     = "eastus"
}

variable "tags" {
  type        = map(string)
  description = "If specified, will set the default tags for all resources deployed by this module where supported."
  default     = {}
}

variable "settings" {
  type = object({
    hub_networks = list(
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
    )
    vwan_hub_networks = list(
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
    )
    ddos_protection_plan = object({
      enabled = bool
      config = object({
        location = string
      })
    })
    dns = object({
      enabled = bool
      config = object({
        location = string
        enable_private_link_by_service = object({
          azure_automation_webhook             = bool
          azure_automation_dscandhybridworker  = bool
          azure_sql_database_sqlserver         = bool
          azure_synapse_analytics_sqlserver    = bool
          azure_synapse_analytics_sql          = bool
          storage_account_blob                 = bool
          storage_account_table                = bool
          storage_account_queue                = bool
          storage_account_file                 = bool
          storage_account_web                  = bool
          azure_data_lake_file_system_gen2     = bool
          azure_cosmos_db_sql                  = bool
          azure_cosmos_db_mongodb              = bool
          azure_cosmos_db_cassandra            = bool
          azure_cosmos_db_gremlin              = bool
          azure_cosmos_db_table                = bool
          azure_database_for_postgresql_server = bool
          azure_database_for_mysql_server      = bool
          azure_database_for_mariadb_server    = bool
          azure_key_vault                      = bool
          azure_kubernetes_service_management  = bool
          azure_search_service                 = bool
          azure_container_registry             = bool
          azure_app_configuration_stores       = bool
          azure_backup                         = bool
          azure_site_recovery                  = bool
          azure_event_hubs_namespace           = bool
          azure_service_bus_namespace          = bool
          azure_iot_hub                        = bool
          azure_relay_namespace                = bool
          azure_event_grid_topic               = bool
          azure_event_grid_domain              = bool
          azure_web_apps_sites                 = bool
          azure_machine_learning_workspace     = bool
          signalr                              = bool
          azure_monitor                        = bool
          cognitive_services_account           = bool
          azure_file_sync                      = bool
          azure_data_factory                   = bool
          azure_data_factory_portal            = bool
          azure_cache_for_redis                = bool
        })
        private_link_locations                                 = list(string)
        public_dns_zones                                       = list(string)
        private_dns_zones                                      = list(string)
        enable_private_dns_zone_virtual_network_link_on_hubs   = bool
        enable_private_dns_zone_virtual_network_link_on_spokes = bool
      })
    })
  })
  description = "If specified, will customize the \"Connectivity\" landing zone settings and resources."
  default = {
    hub_networks      = []
    vwan_hub_networks = []
    ddos_protection_plan = {
      enabled = false
      config = {
        location = ""
      }
    }
    dns = {
      enabled = true
      config = {
        location = ""
        enable_private_link_by_service = {
          azure_automation_webhook             = true
          azure_automation_dscandhybridworker  = true
          azure_sql_database_sqlserver         = true
          azure_synapse_analytics_sqlserver    = true
          azure_synapse_analytics_sql          = true
          storage_account_blob                 = true
          storage_account_table                = true
          storage_account_queue                = true
          storage_account_file                 = true
          storage_account_web                  = true
          azure_data_lake_file_system_gen2     = true
          azure_cosmos_db_sql                  = true
          azure_cosmos_db_mongodb              = true
          azure_cosmos_db_cassandra            = true
          azure_cosmos_db_gremlin              = true
          azure_cosmos_db_table                = true
          azure_database_for_postgresql_server = true
          azure_database_for_mysql_server      = true
          azure_database_for_mariadb_server    = true
          azure_key_vault                      = true
          azure_kubernetes_service_management  = true
          azure_search_service                 = true
          azure_container_registry             = true
          azure_app_configuration_stores       = true
          azure_backup                         = true
          azure_site_recovery                  = true
          azure_event_hubs_namespace           = true
          azure_service_bus_namespace          = true
          azure_iot_hub                        = true
          azure_relay_namespace                = true
          azure_event_grid_topic               = true
          azure_event_grid_domain              = true
          azure_web_apps_sites                 = true
          azure_machine_learning_workspace     = true
          signalr                              = true
          azure_monitor                        = true
          cognitive_services_account           = true
          azure_file_sync                      = true
          azure_data_factory                   = true
          azure_data_factory_portal            = true
          azure_cache_for_redis                = true
        }
        private_link_locations                                 = []
        public_dns_zones                                       = []
        private_dns_zones                                      = []
        enable_private_dns_zone_virtual_network_link_on_hubs   = true
        enable_private_dns_zone_virtual_network_link_on_spokes = true
      }
    }
  }
}

variable "resource_prefix" {
  type        = string
  description = "If specified, will set the resource name prefix for connectivity resources (default value determined from \"var.root_id\")."
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{2,10}$", var.resource_prefix)) || var.resource_prefix == ""
    error_message = "Value must be between 2 to 10 characters long, consisting of alphanumeric characters and hyphens."
  }
}

variable "resource_suffix" {
  type        = string
  description = "If specified, will set the resource name suffix for connectivity resources."
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{2,36}$", var.resource_suffix)) || var.resource_suffix == ""
    error_message = "Value must be between 2 to 36 characters long, consisting of alphanumeric characters and hyphens."
  }

}

variable "existing_ddos_protection_plan_resource_id" {
  type        = string
  description = "If specified, module will skip creation of DDoS Protection Plan and use existing."
  default     = ""
}

variable "existing_virtual_wan_resource_id" {
  type        = string
  description = "If specified, module will skip creation of the Virtual WAN and use existing. All Virtual Hubs created by the module will be associated with the specified Virtual WAN."
  default     = ""
}

variable "resource_group_per_virtual_hub_location" {
  type        = bool
  description = "If set to true, module will place each Virtual Hub (and associated resources) in a location-specific Resource Group. Default behaviour is to colocate Virtual Hub resources in the same Resource Group as the Virtual WAN resource."
  default     = false
}

variable "custom_azure_backup_geo_codes" {
  type        = map(string)
  description = <<DESCRIPTION
If specified, the custom_azure_backup_geo_codes variable will override or append Geo Codes (value) used to generate region-specific DNS zone names for Azure Backup private endpoints.
For more information, please refer to: https://docs.microsoft.com/azure/backup/private-endpoints#when-using-custom-dns-server-or-host-files
DESCRIPTION
  default     = {}
}

variable "custom_settings_by_resource_type" {
  type        = any
  description = "If specified, allows full customization of common settings for all resources (by type) deployed by this module."
  default     = {}

  validation {
    condition = (
      can([for k in keys(var.custom_settings_by_resource_type) : contains([
        "azurerm_dns_zone",
        "azurerm_express_route_gateway",
        "azurerm_firewall_policy",
        "azurerm_firewall",
        "azurerm_network_ddos_protection_plan",
        "azurerm_private_dns_zone_virtual_network_link",
        "azurerm_private_dns_zone",
        "azurerm_public_ip",
        "azurerm_resource_group",
        "azurerm_subnet",
        "azurerm_virtual_hub_connection",
        "azurerm_virtual_hub",
        "azurerm_virtual_network_gateway",
        "azurerm_virtual_network_peering",
        "azurerm_virtual_network",
        "azurerm_virtual_wan",
        "azurerm_vpn_gateway",
      ], k)]) ||
      var.custom_settings_by_resource_type == {} ||
      var.custom_settings_by_resource_type == null
    )
    error_message = "Invalid key specified. Please check the list of allowed resource types supported by the connectivity module for caf-enterprise-scale."
  }
}
