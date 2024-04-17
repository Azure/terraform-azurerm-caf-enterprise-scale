# Azure landing zone Terraform deployment with Zero Trust network principles (Hub and Spoke)

This guide will review how to deploy the Azure landing zone Terraform accelerator with a jump start on Zero Trust Networking Principles for Azure landing zones.

For more information on Zero Trust security model and principles visit [Secure networks with Zero Trust](https://learn.microsoft.com/security/zero-trust/deploy/networks).

Deploying Zero Trust network principles with the Terraform deployment will involve setting certain module variables to a value.  Some of these are already the default values, and do not need to be changed.  Others will need to be changed from their default values.

These variables reside in the [variables.tf](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/blob/main/variables.tf) file and can be provided at run time, or replaced/overridden for your deployment.

## Configure Connectivity resources

In the *configure_connectivity_resources* variable's *ddos_protection_plan* object,  you will set the following:

| Variable | Zero Trust Value | Default Value |
|---|---|---|
| `enabled` | `true`| `false` |

This will deploy a DDoS Protection Plan to use to protect your networking resources from DDoS Attacks.

Next, in the *configure_connectivity_resources* variable's *hub_networks* object,  you will set the following:

| Variable | Zero Trust Value | Default Value |
|---|---|---|
| `enabled` | `true`| `true`|
| `link_to_ddos_protection_plan` | `true`| `false` |

These settings will ensure that a hub network is deployed, and that it is liked to the DDoS Protection Plan.

Lastly, in the *configure_connectivity_resources* variable's *azure_firewall* object,  you will set the following:

| Variable | Zero Trust Value | Default Value |
|---|---|---|
| `enabled` | `true`| `false` |
| `sku_tier` | `premium` | `null` |

This will deploy an Azure Firewall in to your hub network, with the appropriate SKU to perform TLS inspection on traffic.

## Configure Identity resources

In the *configure_identity_resources* variable object, set the following:

| Variable | Zero Trust Value | Default Value |
|---|---|---|
| `enable_deny_public_ip` | `true` | `true` |
| `enable_deny_rdp_from_internet` | `true` | `true` |
| `enable_deny_subnet_without_nsg` | `true` | `true` |

This will set policy controls to ensure good network practices are in place, by preventing you from creating public IPs in the identity subscription, denying the creation of subnets without Network Security Groups, and by preventing inbound RDP from the internet to VMs in the identity subscription.

## Configure Defender

In the *configure_management_resources* variable's *security_center* object, set the following:

| Variable | Zero Trust Value | Default Value |
|---|---|---|
| `enable_defender_for_dns` | `true` | `true` |

This is not needed for Zero Trust Telemetry, but is a valuable setting to protect your organization from DNS injection.  Review [Defender for DNS](https://learn.microsoft.com/azure/defender-for-cloud/defender-for-dns-introduction) for more information.

## Reference setting files

The below reference filese can be used to declare the above variables as local values.  There are two input files that are needed - one for `configure_connectivity_resources` and another for  `configure_management_resources`.  These configurations can be used to illustrate the settings needed to deploy the Zero Trust principles.

### Reference `settings.connectivity.tf`

The below `settings.connectivity.tf` file can be used to declare these variables as local values, containing the custom inputs for the `configure_connectivity_resources` as described above.

Read more about customizing a connectivity deployment in the [Deploy Connectivity Resources with Custom Settings](%5BExamples%5D-Deploy-Connectivity-Resources-With-Custom-Settings) article.

```hcl
# Configure the connectivity resources settings.
locals {
  configure_connectivity_resources = {
    settings = {
      hub_networks = [
        {
          enabled = true
          config = {
            address_space                = ["10.100.0.0/2", ]
            location                     = "westus2"
            link_to_ddos_protection_plan = true
            dns_servers                  = []
            bgp_community                = ""
            subnets                      = []
            virtual_network_gateway = {
              enabled = true
              config = {
                address_prefix           = "10.100.1.0/24"
                gateway_sku_expressroute = "ErGw2AZ"
                gateway_sku_vpn          = ""
                advanced_vpn_settings = {
                  enable_bgp                       = null
                  active_active                    = null
                  private_ip_address_allocation    = ""
                  default_local_network_gateway_id = ""
                  vpn_client_configuration         = []
                  bgp_settings                     = []
                  custom_route                     = []
                }
              }
            }
            azure_firewall = {
              enabled = true
              config = {
                address_prefix                = "10.100.0.0/24"
                enable_dns_proxy              = true
                dns_servers                   = []
                sku_tier                      = ""
                base_policy_id                = ""
                private_ip_ranges             = []
                threat_intelligence_mode      = ""
                threat_intelligence_allowlist = {}
                availability_zones = {
                  zone_1 = true
                  zone_2 = true
                  zone_3 = true
                }
              }
            }
            spoke_virtual_network_resource_ids      = []
            enable_outbound_virtual_network_peering = true
            enable_hub_network_mesh_peering         = false
          }
        },
        {
          enabled = true
          config = {
            address_space                = ["10.101.0.0/16", ]
            location                     = "westeurope"
            link_to_ddos_protection_plan = true
            dns_servers                  = []
            bgp_community                = ""
            subnets                      = []
            virtual_network_gateway = {
              enabled = true
              config = {
                address_prefix           = "10.101.1.0/24"
                gateway_sku_expressroute = ""
                gateway_sku_vpn          = "VpnGw2AZ"
                advanced_vpn_settings = {
                  enable_bgp                       = null
                  active_active                    = null
                  private_ip_address_allocation    = ""
                  default_local_network_gateway_id = ""
                  vpn_client_configuration         = []
                  bgp_settings                     = []
                  custom_route                     = []
                }
              }
            }
            azure_firewall = {
              enabled = false
              config = {
                address_prefix                = ""
                enable_dns_proxy              = true
                dns_servers                   = []
                sku_tier                      = ""
                base_policy_id                = ""
                private_ip_ranges             = []
                threat_intelligence_mode      = ""
                threat_intelligence_allowlist = {}
                availability_zones = {
                  zone_1 = true
                  zone_2 = true
                  zone_3 = true
                }
              }
            }
            spoke_virtual_network_resource_ids      = []
            enable_outbound_virtual_network_peering = true
            enable_hub_network_mesh_peering         = false
          }
        },
      ]
      vwan_hub_networks = []
      ddos_protection_plan = {
        enabled = true
        config = {
          location = "northeurope"
        }
      }
      dns = {
        enabled = true
        config = {
          location = null
          enable_private_link_by_service = {
            azure_api_management                 = true
            azure_app_configuration_stores       = true
            azure_arc                            = true
            azure_automation_dscandhybridworker  = true
            azure_automation_webhook             = true
            azure_backup                         = true
            azure_batch_account                  = true
            azure_bot_service_bot                = true
            azure_bot_service_token              = true
            azure_cache_for_redis                = true
            azure_cache_for_redis_enterprise     = true
            azure_container_registry             = true
            azure_cosmos_db_cassandra            = true
            azure_cosmos_db_gremlin              = true
            azure_cosmos_db_mongodb              = true
            azure_cosmos_db_sql                  = true
            azure_cosmos_db_table                = true
            azure_data_explorer                  = true
            azure_data_factory                   = true
            azure_data_factory_portal            = true
            azure_data_health_data_services      = true
            azure_data_lake_file_system_gen2     = true
            azure_database_for_mariadb_server    = true
            azure_database_for_mysql_server      = true
            azure_database_for_postgresql_server = true
            azure_digital_twins                  = true
            azure_event_grid_domain              = true
            azure_event_grid_topic               = true
            azure_event_hubs_namespace           = true
            azure_file_sync                      = true
            azure_hdinsights                     = true
            azure_iot_dps                        = true
            azure_iot_hub                        = true
            azure_key_vault                      = true
            azure_key_vault_managed_hsm          = true
            azure_kubernetes_service_management  = true
            azure_machine_learning_workspace     = true
            azure_managed_disks                  = true
            azure_media_services                 = true
            azure_migrate                        = true
            azure_monitor                        = true
            azure_purview_account                = true
            azure_purview_studio                 = true
            azure_relay_namespace                = true
            azure_search_service                 = true
            azure_service_bus_namespace          = true
            azure_site_recovery                  = true
            azure_sql_database_sqlserver         = true
            azure_synapse_analytics_dev          = true
            azure_synapse_analytics_sql          = true
            azure_synapse_studio                 = true
            azure_web_apps_sites                 = true
            azure_web_apps_static_sites          = true
            cognitive_services_account           = true
            microsoft_power_bi                   = true
            signalr                              = true
            signalr_webpubsub                    = true
            storage_account_blob                 = true
            storage_account_file                 = true
            storage_account_queue                = true
            storage_account_table                = true
            storage_account_web                  = true
          }
          private_link_locations = [
            "northeurope",
            "westeurope",
          ]
          public_dns_zones                                       = []
          private_dns_zones                                      = []
          enable_private_dns_zone_virtual_network_link_on_hubs   = true
          enable_private_dns_zone_virtual_network_link_on_spokes = true
          virtual_network_resource_ids_to_link                   = []
        }
      }
    }

    location = var.connectivity_resources_location
    tags     = var.connectivity_resources_tags
    advanced = null
  }
}
```

### Reference `settings.management.tf`

The below `settings.management.tf` file can be used to declare these variables as local values, containing the custom inputs for the `configure_management_resources` input variables as described above.

Read more about customizing a connectivity deployment in the [Deploy Management Resources with Custom Settings](%5BExamples%5D-Deploy-Management-Resources-With-Custom-Settings) article.

```hcl
# Configure the management resources settings.
locals {
  configure_management_resources = {
    settings = {
      log_analytics = {
        enabled = true
        config = {
          retention_in_days                                 = var.log_retention_in_days
          enable_monitoring_for_vm                          = true
          enable_monitoring_for_vmss                        = true
          enable_solution_for_agent_health_assessment       = true
          enable_solution_for_anti_malware                  = true
          enable_solution_for_change_tracking               = true
          enable_solution_for_service_map                   = false
          enable_solution_for_sql_assessment                = false
          enable_solution_for_sql_vulnerability_assessment  = false
          enable_solution_for_sql_advanced_threat_detection = false
          enable_solution_for_updates                       = true
          enable_solution_for_vm_insights                   = true
          enable_solution_for_container_insights            = true
          enable_sentinel                                   = true
        }
      }
      security_center = {
        enabled = true
        config = {
          email_security_contact             = var.security_alerts_email_address
          enable_defender_for_apis                              = true
          enable_defender_for_app_services                      = true
          enable_defender_for_arm                               = true
          enable_defender_for_containers                        = true
          enable_defender_for_cosmosdbs                         = true
          enable_defender_for_cspm                              = true
          enable_defender_for_dns                               = true
          enable_defender_for_key_vault                         = true
          enable_defender_for_oss_databases                     = true
          enable_defender_for_servers                           = true
          enable_defender_for_servers_vulnerability_assessments = true
          enable_defender_for_sql_servers                       = true
          enable_defender_for_sql_server_vms                    = true
          enable_defender_for_storage                           = true
        }
      }
    }

    location = var.management_resources_location
    tags     = var.management_resources_tags
    advanced = null
  }
}
```
