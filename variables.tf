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
variable "deploy_diagnostics_for_mg" {
  type        = bool
  description = "If set to true, will deploy Diagnostic Settings for management groups"
  default     = false
}

variable "configure_management_resources" {
  type = object({
    settings = optional(object({
      log_analytics = optional(object({
        enabled = optional(bool, true)
        config = optional(object({
          retention_in_days                                 = optional(number, 30)
          enable_monitoring_for_vm                          = optional(bool, true)
          enable_monitoring_for_vmss                        = optional(bool, true)
          enable_solution_for_agent_health_assessment       = optional(bool, true)
          enable_solution_for_anti_malware                  = optional(bool, true)
          enable_solution_for_change_tracking               = optional(bool, true)
          enable_solution_for_service_map                   = optional(bool, false)
          enable_solution_for_sql_assessment                = optional(bool, true)
          enable_solution_for_sql_vulnerability_assessment  = optional(bool, true)
          enable_solution_for_sql_advanced_threat_detection = optional(bool, true)
          enable_solution_for_updates                       = optional(bool, true)
          enable_solution_for_vm_insights                   = optional(bool, true)
          enable_solution_for_container_insights            = optional(bool, true)
          enable_sentinel                                   = optional(bool, true)
        }), {})
      }), {})
      security_center = optional(object({
        enabled = optional(bool, true)
        config = optional(object({
          email_security_contact                                = optional(string, "security_contact@replace_me")
          enable_defender_for_apis                              = optional(bool, true)
          enable_defender_for_app_services                      = optional(bool, true)
          enable_defender_for_arm                               = optional(bool, true)
          enable_defender_for_containers                        = optional(bool, true)
          enable_defender_for_cosmosdbs                         = optional(bool, true)
          enable_defender_for_cspm                              = optional(bool, true)
          enable_defender_for_dns                               = optional(bool, true)
          enable_defender_for_key_vault                         = optional(bool, true)
          enable_defender_for_oss_databases                     = optional(bool, true)
          enable_defender_for_servers                           = optional(bool, true)
          enable_defender_for_servers_vulnerability_assessments = optional(bool, true)
          enable_defender_for_sql_servers                       = optional(bool, true)
          enable_defender_for_sql_server_vms                    = optional(bool, true)
          enable_defender_for_storage                           = optional(bool, true)
        }), {})
      }), {})
    }), {})
    location = optional(string, "")
    tags     = optional(any, {})
    advanced = optional(any, {})
  })
  description = "If specified, will customize the \"Management\" landing zone settings and resources."
  default     = {}
}

variable "deploy_identity_resources" {
  type        = bool
  description = "If set to true, will enable the \"Identity\" landing zone settings."
  default     = false
}

variable "configure_identity_resources" {
  type = object({
    settings = optional(object({
      identity = optional(object({
        enabled = optional(bool, true)
        config = optional(object({
          enable_deny_public_ip             = optional(bool, true)
          enable_deny_rdp_from_internet     = optional(bool, true)
          enable_deny_subnet_without_nsg    = optional(bool, true)
          enable_deploy_azure_backup_on_vms = optional(bool, true)
        }), {})
      }), {})
    }), {})
  })
  description = "If specified, will customize the \"Identity\" landing zone settings."
  default     = {}
}

variable "deploy_connectivity_resources" {
  type        = bool
  description = "If set to true, will enable the \"Connectivity\" landing zone settings and add \"Connectivity\" resources into the current Subscription context."
  default     = false
}

variable "configure_connectivity_resources" {
  type = object({
    settings = optional(object({
      hub_networks = optional(list(
        object({
          enabled = optional(bool, true)
          config = object({
            address_space                = list(string)
            location                     = optional(string, "")
            link_to_ddos_protection_plan = optional(bool, false)
            dns_servers                  = optional(list(string), [])
            bgp_community                = optional(string, "")
            subnets = optional(list(
              object({
                name                      = string
                address_prefixes          = list(string)
                network_security_group_id = optional(string, "")
                route_table_id            = optional(string, "")
              })
            ), [])
            virtual_network_gateway = optional(object({
              enabled = optional(bool, false)
              config = optional(object({
                address_prefix           = optional(string, "")
                gateway_sku_expressroute = optional(string, "")
                gateway_sku_vpn          = optional(string, "")
                advanced_vpn_settings = optional(object({
                  enable_bgp                       = optional(bool, null)
                  active_active                    = optional(bool, null)
                  private_ip_address_allocation    = optional(string, "")
                  default_local_network_gateway_id = optional(string, "")
                  vpn_client_configuration = optional(list(
                    object({
                      address_space = list(string)
                      aad_tenant    = optional(string, null)
                      aad_audience  = optional(string, null)
                      aad_issuer    = optional(string, null)
                      root_certificate = optional(list(
                        object({
                          name             = string
                          public_cert_data = string
                        })
                      ), [])
                      revoked_certificate = optional(list(
                        object({
                          name       = string
                          thumbprint = string
                        })
                      ), [])
                      radius_server_address = optional(string, null)
                      radius_server_secret  = optional(string, null)
                      vpn_client_protocols  = optional(list(string), null)
                      vpn_auth_types        = optional(list(string), null)
                    })
                  ), [])
                  bgp_settings = optional(list(
                    object({
                      asn         = optional(number, null)
                      peer_weight = optional(number, null)
                      peering_addresses = optional(list(
                        object({
                          ip_configuration_name = optional(string, null)
                          apipa_addresses       = optional(list(string), null)
                        })
                      ), [])
                    })
                  ), [])
                  custom_route = optional(list(
                    object({
                      address_prefixes = optional(list(string), [])
                    })
                  ), [])
                }), {})
              }), {})
            }), {})
            azure_firewall = optional(object({
              enabled = optional(bool, false)
              config = optional(object({
                address_prefix                = optional(string, "")
                address_management_prefix     = optional(string, "")
                enable_dns_proxy              = optional(bool, true)
                dns_servers                   = optional(list(string), [])
                sku_tier                      = optional(string, "Standard")
                base_policy_id                = optional(string, "")
                private_ip_ranges             = optional(list(string), [])
                threat_intelligence_mode      = optional(string, "Alert")
                threat_intelligence_allowlist = optional(list(string), [])
                availability_zones = optional(object({
                  zone_1 = optional(bool, true)
                  zone_2 = optional(bool, true)
                  zone_3 = optional(bool, true)
                }), {})
              }), {})
            }), {})
            spoke_virtual_network_resource_ids      = optional(list(string), [])
            enable_outbound_virtual_network_peering = optional(bool, false)
            enable_hub_network_mesh_peering         = optional(bool, false)
          })
        })
      ), [])
      vwan_hub_networks = optional(list(
        object({
          enabled = optional(bool, true)
          config = object({
            address_prefix = string
            location       = string
            sku            = optional(string, "")
            routes = optional(list(
              object({
                address_prefixes    = list(string)
                next_hop_ip_address = string
              })
            ), [])
            routing_intent = optional(object({
              enabled = optional(bool, false)
              config = optional(object({
                routing_policies = optional(list(object({
                  name         = string
                  destinations = list(string)
                })), [])
              }), {})
            }), {})
            expressroute_gateway = optional(object({
              enabled = optional(bool, false)
              config = optional(object({
                scale_unit = optional(number, 1)
              }), {})
            }), {})
            vpn_gateway = optional(object({
              enabled = optional(bool, false)
              config = optional(object({
                bgp_settings = optional(list(
                  object({
                    asn         = number
                    peer_weight = number
                    instance_0_bgp_peering_address = optional(list(
                      object({
                        custom_ips = list(string)
                      })
                    ), [])
                    instance_1_bgp_peering_address = optional(list(
                      object({
                        custom_ips = list(string)
                      })
                    ), [])
                  })
                ), [])
                routing_preference = optional(string, "Microsoft Network")
                scale_unit         = optional(number, 1)
              }), {})
            }), {})
            azure_firewall = optional(object({
              enabled = optional(bool, false)
              config = optional(object({
                enable_dns_proxy              = optional(bool, true)
                dns_servers                   = optional(list(string), [])
                sku_tier                      = optional(string, "Standard")
                base_policy_id                = optional(string, "")
                private_ip_ranges             = optional(list(string), [])
                threat_intelligence_mode      = optional(string, "Alert")
                threat_intelligence_allowlist = optional(list(string), [])
                availability_zones = optional(object({
                  zone_1 = optional(bool, true)
                  zone_2 = optional(bool, true)
                  zone_3 = optional(bool, true)
                }), {})
              }), {})
            }), {})
            spoke_virtual_network_resource_ids        = optional(list(string), [])
            secure_spoke_virtual_network_resource_ids = optional(list(string), [])
            enable_virtual_hub_connections            = optional(bool, false)
          })
        })
      ), [])
      ddos_protection_plan = optional(object({
        enabled = optional(bool, false)
        config = optional(object({
          location = optional(string, "")
        }), {})
      }), {})
      dns = optional(object({
        enabled = optional(bool, true)
        config = optional(object({
          location = optional(string, "")
          enable_private_link_by_service = optional(object({
            azure_api_management                 = optional(bool, true)
            azure_app_configuration_stores       = optional(bool, true)
            azure_arc                            = optional(bool, true)
            azure_automation_dscandhybridworker  = optional(bool, true)
            azure_automation_webhook             = optional(bool, true)
            azure_backup                         = optional(bool, true)
            azure_batch_account                  = optional(bool, true)
            azure_bot_service_bot                = optional(bool, true)
            azure_bot_service_token              = optional(bool, true)
            azure_cache_for_redis                = optional(bool, true)
            azure_cache_for_redis_enterprise     = optional(bool, true)
            azure_container_registry             = optional(bool, true)
            azure_cosmos_db_cassandra            = optional(bool, true)
            azure_cosmos_db_gremlin              = optional(bool, true)
            azure_cosmos_db_mongodb              = optional(bool, true)
            azure_cosmos_db_sql                  = optional(bool, true)
            azure_cosmos_db_table                = optional(bool, true)
            azure_data_explorer                  = optional(bool, true)
            azure_data_factory                   = optional(bool, true)
            azure_data_factory_portal            = optional(bool, true)
            azure_data_health_data_services      = optional(bool, true)
            azure_data_lake_file_system_gen2     = optional(bool, true)
            azure_database_for_mariadb_server    = optional(bool, true)
            azure_database_for_mysql_server      = optional(bool, true)
            azure_database_for_postgresql_server = optional(bool, true)
            azure_digital_twins                  = optional(bool, true)
            azure_event_grid_domain              = optional(bool, true)
            azure_event_grid_topic               = optional(bool, true)
            azure_event_hubs_namespace           = optional(bool, true)
            azure_file_sync                      = optional(bool, true)
            azure_hdinsights                     = optional(bool, true)
            azure_iot_dps                        = optional(bool, true)
            azure_iot_hub                        = optional(bool, true)
            azure_key_vault                      = optional(bool, true)
            azure_key_vault_managed_hsm          = optional(bool, true)
            azure_kubernetes_service_management  = optional(bool, true)
            azure_machine_learning_workspace     = optional(bool, true)
            azure_managed_disks                  = optional(bool, true)
            azure_media_services                 = optional(bool, true)
            azure_migrate                        = optional(bool, true)
            azure_monitor                        = optional(bool, true)
            azure_purview_account                = optional(bool, true)
            azure_purview_studio                 = optional(bool, true)
            azure_relay_namespace                = optional(bool, true)
            azure_search_service                 = optional(bool, true)
            azure_service_bus_namespace          = optional(bool, true)
            azure_site_recovery                  = optional(bool, true)
            azure_sql_database_sqlserver         = optional(bool, true)
            azure_synapse_analytics_dev          = optional(bool, true)
            azure_synapse_analytics_sql          = optional(bool, true)
            azure_synapse_studio                 = optional(bool, true)
            azure_web_apps_sites                 = optional(bool, true)
            azure_web_apps_static_sites          = optional(bool, true)
            cognitive_services_account           = optional(bool, true)
            microsoft_power_bi                   = optional(bool, true)
            signalr                              = optional(bool, true)
            signalr_webpubsub                    = optional(bool, true)
            storage_account_blob                 = optional(bool, true)
            storage_account_file                 = optional(bool, true)
            storage_account_queue                = optional(bool, true)
            storage_account_table                = optional(bool, true)
            storage_account_web                  = optional(bool, true)
          }), {})
          private_link_locations                                 = optional(list(string), [])
          public_dns_zones                                       = optional(list(string), [])
          private_dns_zones                                      = optional(list(string), [])
          enable_private_dns_zone_virtual_network_link_on_hubs   = optional(bool, true)
          enable_private_dns_zone_virtual_network_link_on_spokes = optional(bool, true)
          virtual_network_resource_ids_to_link                   = optional(list(string), [])
        }), {})
      }), {})
    }), {})
    location = optional(string, "")
    tags     = optional(any, {})
    advanced = optional(any, {})
  })
  description = <<DESCRIPTION
If specified, will customize the \"Connectivity\" landing zone settings and resources.

Notes for the `configure_connectivity_resources` variable:

- `settings.hub_network_virtual_network_gateway.config.address_prefix`
  - Only support adding a single address prefix for GatewaySubnet subnet
- `settings.hub_network_virtual_network_gateway.config.gateway_sku_expressroute`
  - If specified, will deploy the ExpressRoute gateway into the GatewaySubnet subnet
- `settings.hub_network_virtual_network_gateway.config.gateway_sku_vpn`
  - If specified, will deploy the VPN gateway into the GatewaySubnet subnet
- `settings.hub_network_virtual_network_gateway.config.advanced_vpn_settings.private_ip_address_allocation`
  - Valid options are `""`, `"Static"` or `"Dynamic"`. Will set `private_ip_address_enabled` and `private_ip_address_allocation` as needed.
- `settings.azure_firewall.config.address_prefix`
  - Only support adding a single address prefix for AzureFirewallManagementSubnet subnet
DESCRIPTION
  default     = {}
}

variable "archetype_config_overrides" {
  type        = any
  description = <<DESCRIPTION
If specified, will set custom Archetype configurations for the core ALZ Management Groups.
Does not work for management groups specified by the 'custom_landing_zones' input variable.
To override the default configuration settings for any of the core Management Groups, add an entry to the archetype_config_overrides variable for each Management Group you want to customize.
To create a valid archetype_config_overrides entry, you must provide the required values in the archetype_config_overrides object for the Management Group you wish to re-configure.
To do this, simply create an entry similar to the root example below for one or more of the supported core Management Group IDs:

- root
- decommissioned
- sandboxes
- landing-zones
- platform
- connectivity
- management
- identity
- corp
- online
- sap

```terraform
map(
  object({
    archetype_id     = string
    enforcement_mode = map(bool)
    parameters       = map(any)
    access_control   = map(list(string))
  })
)
```

e.g.

```terraform
  archetype_config_overrides = {
    root = {
      archetype_id = "root"
      enforcement_mode = {
        "Example-Policy-Assignment" = true,
      }
      parameters = {
        Example-Policy-Assignment = {
          parameterStringExample = "value1",
          parameterBoolExample   = true,
          parameterNumberExample = 10,
          parameterListExample = [
            "listItem1",
            "listItem2",
          ]
          parameterObjectExample = {
            key1 = "value1",
            key2 = "value2",
          }
        }
      }
      access_control = {
        Example-Role-Definition = [
          "00000000-0000-0000-0000-000000000000", # Object ID of user/group/spn/mi from Microsoft Entra ID
          "11111111-1111-1111-1111-111111111111", # Object ID of user/group/spn/mi from Microsoft Entra ID
        ]
      }
    }
  }
```
DESCRIPTION
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
  description = <<DESCRIPTION
If specified, will deploy additional Management Groups alongside Enterprise-scale core Management Groups.
Although the object type for this input variable is set to `any`, the expected object is based on the following structure:

```terraform
variable "custom_landing_zones" {
  type = map(
    object({
      display_name               = string
      parent_management_group_id = string
      subscription_ids           = list(string)
      archetype_config = object({
        archetype_id   = string
        parameters     = map(any)
        access_control = map(list(string))
      })
    })
  )
```

The decision not to hard code the structure in the input variable `type` is by design, as it allows Terraform to handle the input as a dynamic object type.
This was necessary to allow the `parameters` value to be correctly interpreted.
Without this, Terraform would throw an error if each parameter value wasn't a consistent type, as it would incorrectly identify the input as a `tuple` which must contain consistent type structure across all entries.

> Note the id of the custom landing zone will be appended to `var.root_id`. The maximum length of the resulting name must be less than 90 characters.

The `custom_landing_zones` object is used to deploy additional Management Groups within the core Management Group hierarchy.
The main object parameters are `display_name`, `parent_management_group_id`, `subscription_ids`and `archetype_config`.

- `display_name` is the name assigned to the Management Group.

- `parent_management_group_id` is the name of the parent Management Group and must be a valid Management Group ID.

- `subscription_ids` is an object containing a list of Subscription IDs to assign to the current Management Group.

- `archetype_config` is used to configure the configuration applied to each Management Group. This object must contain valid entries for the `archetype_id` `parameters`, and `access_control` attributes.

The following example shows how you would add a simple Management Group under the `myorg-landing-zones` Management Group, where `root_id = "myorg"` and using the default_empty archetype definition.

```terraform
  custom_landing_zones = {
    myorg-customer-corp = {
      display_name               = "MyOrg Customer Corp"
      parent_management_group_id = "myorg-landing-zones"
      subscription_ids           = [
        "00000000-0000-0000-0000-000000000000",
        "11111111-1111-1111-1111-111111111111",
      ]
      archetype_config = {
        archetype_id   = "default_empty"
        parameters     = {}
        access_control = {}
      }
    }
  }
```
DESCRIPTION
  default     = {}

  validation {
    condition     = can([for k in keys(var.custom_landing_zones) : regex("^[a-zA-Z0-9-.]{2,89}$", k)]) || length(keys(var.custom_landing_zones)) == 0
    error_message = "The custom_landing_zones keys must be between 2 to 89 characters long and can only contain lowercase letters, numbers, periods, and hyphens."
  }
}

variable "library_path" {
  type        = string
  description = "If specified, sets the path to a custom library folder for archetype artefacts."
  default     = ""
}

variable "template_file_variables" {
  type        = any
  description = "If specified, provides the ability to define custom template variables used when reading in template files from the built-in and custom library_path."
  default     = {}
}

variable "default_location" {
  type        = string
  description = "Must be specified, e.g `eastus`. Will set the Azure region in which region bound resources will be deployed. Please see: https://azure.microsoft.com/en-gb/global-infrastructure/geographies/"
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
  type = object({
    azurerm_management_group      = optional(string, "30s")
    azurerm_policy_assignment     = optional(string, "30s")
    azurerm_policy_definition     = optional(string, "30s")
    azurerm_policy_set_definition = optional(string, "30s")
    azurerm_role_assignment       = optional(string, "0s")
    azurerm_role_definition       = optional(string, "60s")
  })
  description = "Used to tune terraform apply when faced with errors caused by API caching or eventual consistency. Sets a custom delay period after creation of the specified resource type."
  default     = {}

  validation {
    condition     = can([for v in values(var.create_duration_delay) : regex("^[0-9]{1,6}(s|m|h)$", v)])
    error_message = "The create_duration_delay values must be a string containing the duration in numbers (1-6 digits) followed by the measure of time represented by s (seconds), m (minutes), or h (hours)."
  }
}

variable "destroy_duration_delay" {
  type = object({
    azurerm_management_group      = optional(string, "0s")
    azurerm_policy_assignment     = optional(string, "0s")
    azurerm_policy_definition     = optional(string, "0s")
    azurerm_policy_set_definition = optional(string, "0s")
    azurerm_role_assignment       = optional(string, "0s")
    azurerm_role_definition       = optional(string, "0s")
  })
  description = "Used to tune terraform deploy when faced with errors caused by API caching or eventual consistency. Sets a custom delay period after destruction of the specified resource type."
  default     = {}

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

variable "disable_telemetry" {
  type        = bool
  description = "If set to true, will disable telemetry for the module. See https://aka.ms/alz-terraform-module-telemetry."
  default     = false
}

variable "strict_subscription_association" {
  type        = bool
  description = "If set to true, subscriptions associated to management groups will be exclusively set by the module and any added by another process will be removed. If set to false, the module will will only enforce association of the specified subscriptions and those added to management groups by other processes will not be removed. Default is false as this works better with subscription vending."
  default     = false
}

variable "policy_non_compliance_message_enabled" {
  type        = bool
  description = "If set to false, will disable non-compliance messages altogether."
  default     = true
}

variable "policy_non_compliance_message_not_supported_definitions" {
  type        = list(string)
  description = "If set, overrides the list of built-in policy definition that do not support non-compliance messages."
  default = [
    "/providers/Microsoft.Authorization/policyDefinitions/1c6e92c9-99f0-4e55-9cf2-0c234dc48f99",
    "/providers/Microsoft.Authorization/policyDefinitions/1a5b4dca-0b6f-4cf5-907c-56316bc1bf3d",
    "/providers/Microsoft.Authorization/policyDefinitions/95edb821-ddaf-4404-9732-666045e056b4"
  ]
}

variable "policy_non_compliance_message_default_enabled" {
  type        = bool
  description = "If set to true, will enable the use of the default custom non-compliance messages for policy assignments if they are not provided."
  default     = true
}

variable "policy_non_compliance_message_default" {
  type        = string
  description = "If set overrides the default non-compliance message used for policy assignments."
  default     = "This resource {enforcementMode} be compliant with the assigned policy."
  validation {
    condition     = var.policy_non_compliance_message_default != null && length(var.policy_non_compliance_message_default) > 0
    error_message = "The policy_non_compliance_message_default value must not be null or empty."
  }
}

variable "policy_non_compliance_message_enforcement_placeholder" {
  type        = string
  description = "If set overrides the non-compliance message placeholder used in message templates."
  default     = "{enforcementMode}"
  validation {
    condition     = var.policy_non_compliance_message_enforcement_placeholder != null && length(var.policy_non_compliance_message_enforcement_placeholder) > 0
    error_message = "The policy_non_compliance_message_enforcement_placeholder value must not be null or empty."
  }
}

variable "policy_non_compliance_message_enforced_replacement" {
  type        = string
  description = "If set overrides the non-compliance replacement used for enforced policy assignments."
  default     = "must"
  validation {
    condition     = var.policy_non_compliance_message_enforced_replacement != null && length(var.policy_non_compliance_message_enforced_replacement) > 0
    error_message = "The policy_non_compliance_message_enforced_replacement value must not be null or empty."
  }
}

variable "policy_non_compliance_message_not_enforced_replacement" {
  type        = string
  description = "If set overrides the non-compliance replacement used for unenforced policy assignments."
  default     = "should"
  validation {
    condition     = var.policy_non_compliance_message_not_enforced_replacement != null && length(var.policy_non_compliance_message_not_enforced_replacement) > 0
    error_message = "The policy_non_compliance_message_not_enforced_replacement value must not be null or empty."
  }
}

variable "resource_custom_timeouts" {
  type = object({
    azurerm_private_dns_zone = optional(object({
      create = optional(string, null)
      update = optional(string, null)
      read   = optional(string, null)
      delete = optional(string, null)
    }), {})
    azurerm_private_dns_zone_virtual_network_link = optional(object({
      create = optional(string, null)
      update = optional(string, null)
      read   = optional(string, null)
      delete = optional(string, null)
    }), {})
  })
  description = <<DESCRIPTION
Optional - Used to tune terraform deploy when faced with errors caused by API limits.

For each supported resource type, there is a child object that specifies the create, update, and delete timeouts.
Each of these arguments takes a string representation of a duration, such as "60m" for 60 minutes, "10s" for ten seconds, or "2h" for two hours.
If a timeout is not specified, the default value for the resource will be used.

e.g.

```hcl
resource_custom_timeouts = {
  azurerm_private_dns_zone = {
    create = "1h"
    update = "1h30m"
    delete = "30m"
    read   = "30s"
  }
}
```
DESCRIPTION
  default     = {}
}
