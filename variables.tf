# The following variables are used to configure the default
# Enterprise-scale Management Groups.
#
# Further information provided within the description block
# for each variable

variable "root_parent_id" {
  type        = string
  description = "The root_parent_id is used to specify where to set the root for all Landing Zone deployments. Usually the Tenant ID when deploying the core Enterprise-scale Landing Zones."

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_\\(\\)\\.]{1,36}$", var.root_parent_id))
    error_message = "Value must be a valid Management Group ID, consisting of alphanumeric characters, hyphens, underscores, periods and parentheses."
  }
}

variable "root_id" {
  type        = string
  description = "If specified, will set a custom Name (ID) value for the Enterprise-scale \"root\" Management Group, and append this to the ID for all core Enterprise-scale Management Groups."
  default     = "es"

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{2,10}$", var.root_id))
    error_message = "Value must be between 2 to 10 characters long, consisting of alphanumeric characters and hyphens."
  }
}

variable "root_name" {
  type        = string
  description = "If specified, will set a custom Display Name value for the Enterprise-scale \"root\" Management Group."
  default     = "Enterprise-Scale"

  validation {
    condition     = can(regex("^[A-Za-z][A-Za-z0-9- ._]{1,22}[A-Za-z0-9]?$", var.root_name))
    error_message = "Value must be between 2 to 24 characters long, start with a letter, end with a letter or number, and can only contain space, hyphen, underscore or period characters."
  }
}

variable "deploy_core_landing_zones" {
  type        = bool
  description = "If set to true, module will deploy the core Enterprise-scale Management Group hierarchy, including \"out of the box\" policies and roles."
  default     = true
}

variable "deploy_corp_landing_zones" {
  type        = bool
  description = "If set to true, module will deploy the \"Corp\" Management Group, including \"out of the box\" policies and roles."
  default     = false
}

variable "deploy_online_landing_zones" {
  type        = bool
  description = "If set to true, module will deploy the \"Online\" Management Group, including \"out of the box\" policies and roles."
  default     = false
}

variable "deploy_sap_landing_zones" {
  type        = bool
  description = "If set to true, module will deploy the \"SAP\" Management Group, including \"out of the box\" policies and roles."
  default     = false
}

variable "deploy_demo_landing_zones" {
  type        = bool
  description = "If set to true, module will deploy the demo \"Landing Zone\" Management Groups (\"Corp\", \"Online\", and \"SAP\") into the core Enterprise-scale Management Group hierarchy."
  default     = false
}

variable "deploy_management_resources" {
  type        = bool
  description = "If set to true, will enable the \"Management\" landing zone settings and add \"Management\" resources into the current Subscription context."
  default     = false
}

variable "configure_management_resources" {
  type = object({
    settings = object({
      log_analytics = object({
        enabled = bool
        config = object({
          retention_in_days                           = number
          enable_monitoring_for_arc                   = bool
          enable_monitoring_for_vm                    = bool
          enable_monitoring_for_vmss                  = bool
          enable_solution_for_agent_health_assessment = bool
          enable_solution_for_anti_malware            = bool
          enable_solution_for_azure_activity          = bool
          enable_solution_for_change_tracking         = bool
          enable_solution_for_service_map             = bool
          enable_solution_for_sql_assessment          = bool
          enable_solution_for_updates                 = bool
          enable_solution_for_vm_insights             = bool
          enable_sentinel                             = bool
        })
      })
      security_center = object({
        enabled = bool
        config = object({
          email_security_contact             = string
          enable_defender_for_acr            = bool
          enable_defender_for_app_services   = bool
          enable_defender_for_arm            = bool
          enable_defender_for_dns            = bool
          enable_defender_for_key_vault      = bool
          enable_defender_for_kubernetes     = bool
          enable_defender_for_oss_databases  = bool
          enable_defender_for_servers        = bool
          enable_defender_for_sql_servers    = bool
          enable_defender_for_sql_server_vms = bool
          enable_defender_for_storage        = bool
        })
      })
    })
    location = any
    tags     = any
    advanced = any
  })
  description = "If specified, will customize the \"Management\" landing zone settings and resources."
  default = {
    settings = {
      log_analytics = {
        enabled = true
        config = {
          retention_in_days                           = 30
          enable_monitoring_for_arc                   = true
          enable_monitoring_for_vm                    = true
          enable_monitoring_for_vmss                  = true
          enable_solution_for_agent_health_assessment = true
          enable_solution_for_anti_malware            = true
          enable_solution_for_azure_activity          = true
          enable_solution_for_change_tracking         = true
          enable_solution_for_service_map             = true
          enable_solution_for_sql_assessment          = true
          enable_solution_for_updates                 = true
          enable_solution_for_vm_insights             = true
          enable_sentinel                             = true
        }
      }
      security_center = {
        enabled = true
        config = {
          email_security_contact             = "security_contact@replace_me"
          enable_defender_for_acr            = true
          enable_defender_for_app_services   = true
          enable_defender_for_arm            = true
          enable_defender_for_dns            = true
          enable_defender_for_key_vault      = true
          enable_defender_for_kubernetes     = true
          enable_defender_for_oss_databases  = true
          enable_defender_for_servers        = true
          enable_defender_for_sql_servers    = true
          enable_defender_for_sql_server_vms = true
          enable_defender_for_storage        = true
        }
      }
    }
    location = null
    tags     = null
    advanced = null
  }
}

variable "deploy_identity_resources" {
  type        = bool
  description = "If set to true, will enable the \"Identity\" landing zone settings."
  default     = false
}

variable "configure_identity_resources" {
  type = object({
    settings = object({
      identity = object({
        enabled = bool
        config = object({
          enable_deny_public_ip             = bool
          enable_deny_rdp_from_internet     = bool
          enable_deny_subnet_without_nsg    = bool
          enable_deploy_azure_backup_on_vms = bool
        })
      })
    })
  })
  description = "If specified, will customize the \"Identity\" landing zone settings."
  default = {
    settings = {
      identity = {
        enabled = true
        config = {
          enable_deny_public_ip             = true
          enable_deny_rdp_from_internet     = true
          enable_deny_subnet_without_nsg    = true
          enable_deploy_azure_backup_on_vms = true
        }
      }
    }
  }
}

variable "deploy_connectivity_resources" {
  type        = bool
  description = "If set to true, will enable the \"Connectivity\" landing zone settings and add \"Connectivity\" resources into the current Subscription context."
  default     = false
}

variable "configure_connectivity_resources" {
  type = object({
    settings = object({
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
                address_prefix           = string # Only support adding a single address prefix for GatewaySubnet subnet
                gateway_sku_expressroute = string # If specified, will deploy the ExpressRoute gateway into the GatewaySubnet subnet
                gateway_sku_vpn          = string # If specified, will deploy the VPN gateway into the GatewaySubnet subnet
              })
            })
            azure_firewall = object({
              enabled = bool
              config = object({
                address_prefix   = string # Only support adding a single address prefix for AzureFirewallManagementSubnet subnet
                enable_dns_proxy = bool
                availability_zones = object({
                  zone_1 = bool
                  zone_2 = bool
                  zone_3 = bool
                })
              })
            })
            spoke_virtual_network_resource_ids      = list(string)
            enable_outbound_virtual_network_peering = bool
          })
        })
      )
      vwan_hub_networks = list(object({}))
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
    location = any
    tags     = any
    advanced = any
  })
  description = "If specified, will customize the \"Connectivity\" landing zone settings and resources."
  default = {
    settings = {
      hub_networks = [
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
              }
            }
            azure_firewall = {
              enabled = false
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
            spoke_virtual_network_resource_ids      = []
            enable_outbound_virtual_network_peering = false
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
    location = null
    tags     = null
    advanced = null
  }
}

variable "archetype_config_overrides" {
  type        = any
  description = "If specified, will set custom Archetype configurations to the default Enterprise-scale Management Groups."
  default     = {}
}

variable "subscription_id_overrides" {
  type        = map(list(string))
  description = "If specified, will be used to assign subscription_ids to the default Enterprise-scale Management Groups."
  default     = {}
}

variable "subscription_id_connectivity" {
  type        = string
  description = "If specified, identifies the Platform subscription for \"Connectivity\" for resource deployment and correct placement in the Management Group hierarchy."
  default     = ""

  validation {
    condition     = can(regex("^[a-z0-9-]{36}$", var.subscription_id_connectivity)) || var.subscription_id_connectivity == ""
    error_message = "Value must be a valid Subscription ID (GUID)."
  }
}

variable "subscription_id_identity" {
  type        = string
  description = "If specified, identifies the Platform subscription for \"Identity\" for resource deployment and correct placement in the Management Group hierarchy."
  default     = ""

  validation {
    condition     = can(regex("^[a-z0-9-]{36}$", var.subscription_id_identity)) || var.subscription_id_identity == ""
    error_message = "Value must be a valid Subscription ID (GUID)."
  }
}

variable "subscription_id_management" {
  type        = string
  description = "If specified, identifies the Platform subscription for \"Management\" for resource deployment and correct placement in the Management Group hierarchy."
  default     = ""

  validation {
    condition     = can(regex("^[a-z0-9-]{36}$", var.subscription_id_management)) || var.subscription_id_management == ""
    error_message = "Value must be a valid Subscription ID (GUID)."
  }
}

variable "custom_landing_zones" {
  type        = any
  description = "If specified, will deploy additional Management Groups alongside Enterprise-scale core Management Groups."
  default     = {}

  validation {
    condition     = can([for k in keys(var.custom_landing_zones) : regex("^[a-z0-9-]{2,36}$", k)]) || length(keys(var.custom_landing_zones)) == 0
    error_message = "The custom_landing_zones keys must be between 2 to 36 characters long and can only contain lowercase letters, numbers and hyphens."
  }
}

variable "library_path" {
  type        = string
  description = "If specified, sets the path to a custom library folder for archetype artefacts."
  default     = ""
}

variable "template_file_variables" {
  type        = map(any)
  description = "If specified, provides the ability to define custom template variables used when reading in template files from the built-in and custom library_path."
  default     = {}
}

variable "default_location" {
  type        = string
  description = "If specified, will set the Azure region in which region bound resources will be deployed. Please see: https://azure.microsoft.com/en-gb/global-infrastructure/geographies/"
  default     = "eastus"
}

variable "default_tags" {
  type        = map(string)
  description = "If specified, will set the default tags for all resources deployed by this module where supported."
  default     = {}
}

variable "disable_base_module_tags" {
  type        = bool
  description = "If set to true, will remove the base module tags applied to all resources deployed by the module which support tags."
  default     = false
}

variable "create_duration_delay" {
  type        = map(string)
  description = "Used to tune terraform apply when faced with errors caused by API caching or eventual consistency. Sets a custom delay period after creation of the specified resource type."
  default = {
    azurerm_management_group      = "30s"
    azurerm_policy_assignment     = "30s"
    azurerm_policy_definition     = "30s"
    azurerm_policy_set_definition = "30s"
    azurerm_role_assignment       = "0s"
    azurerm_role_definition       = "60s"
  }

  validation {
    condition     = can([for v in values(var.create_duration_delay) : regex("^[0-9]{1,6}(s|m|h)$", v)])
    error_message = "The create_duration_delay values must be a string containing the duration in numbers (1-6 digits) followed by the measure of time represented by s (seconds), m (minutes), or h (hours)."
  }
}

variable "destroy_duration_delay" {
  type        = map(string)
  description = "Used to tune terraform deploy when faced with errors caused by API caching or eventual consistency. Sets a custom delay period after destruction of the specified resource type."
  default = {
    azurerm_management_group      = "0s"
    azurerm_policy_assignment     = "0s"
    azurerm_policy_definition     = "0s"
    azurerm_policy_set_definition = "0s"
    azurerm_role_assignment       = "0s"
    azurerm_role_definition       = "0s"
  }

  validation {
    condition     = can([for v in values(var.destroy_duration_delay) : regex("^[0-9]{1,6}(s|m|h)$", v)])
    error_message = "The destroy_duration_delay values must be a string containing the duration in numbers (1-6 digits) followed by the measure of time represented by s (seconds), m (minutes), or h (hours)."
  }
}

variable "custom_policy_roles" {
  type        = map(list(string))
  description = "If specified, the custom_policy_roles variable overrides which Role Definition ID(s) (value) to assign for Policy Assignments with a Managed Identity, if the assigned \"policyDefinitionId\" (key) is included in this variable."
  default     = {}
}
