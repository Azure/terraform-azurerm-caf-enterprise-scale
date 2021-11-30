## Overview

The module can be customized using the input variables listed below (click on each `input name` for more details).

To provide the depth of configuration options needed by the module without creating too many different input variables, we decided to use a number of complex `object({})` type variables.
Whilst these may look intimidating at first, these are all configured with default values and only need to be updated if you want to start customising the deployment.
In all cases, the default values can simply be copied into your configuration and edited as required.

> To make your code easier to maintain, we recommend using [Local Values][local_values] in your root module to store custom values, rather than putting these in-line within the module block.
> This helps to improve readability of the module block, and also makes these values re-usable when using multiple instances of the module to build out your Enterprise-scale platform on Azure.
> Only use [Input Variables][input_variables] for simple values which need to be changed across multiple deployments (e.g. environment-specific values).

## Required Inputs

These variables must be set in the `module` block when using this module.

<br>

[**root_parent_id**][root_parent_id] `string`

The root_parent_id is used to specify where to set the root for all Landing Zone deployments. Usually the Tenant ID when deploying the core Enterprise-scale Landing Zones.

<br>

## Optional Inputs

These variables have default values and don't have to be set to use this module. You may set these variables in the `module` block to override their default values.

<br>

[**archetype_config_overrides**][archetype_config_overrides] `any`

If specified, will set custom Archetype configurations to the default Enterprise-scale Management Groups.

Default: `{}`

<br>

<!-- markdownlint-disable-next-line MD013 -->
[**configure_connectivity_resources**][configure_connectivity_resources] `object({ settings = object({ hub_networks = list( object({ enabled = bool config = object({ address_space = list(string) location = string link_to_ddos_protection_plan = bool dns_servers = list(string) bgp_community = string subnets = list( object({ name = string address_prefixes = list(string) network_security_group_id = string route_table_id = string }) ) virtual_network_gateway = object({ enabled = bool config = object({ address_prefix = string # Only support adding a single address prefix for GatewaySubnet subnet gateway_sku_expressroute = string # If specified, will deploy the ExpressRoute gateway into the GatewaySubnet subnet gateway_sku_vpn = string # If specified, will deploy the VPN gateway into the GatewaySubnet subnet }) }) azure_firewall = object({ enabled = bool config = object({ address_prefix = string # Only support adding a single address prefix for AzureFirewallManagementSubnet subnet enable_dns_proxy = bool availability_zones = object({ zone_1 = bool zone_2 = bool zone_3 = bool }) }) }) spoke_virtual_network_resource_ids = list(string) enable_outbound_virtual_network_peering = bool }) }) ) vwan_hub_networks = list(object({})) ddos_protection_plan = object({ enabled = bool config = object({ location = string }) }) dns = object({ enabled = bool config = object({ location = string enable_private_link_by_service = object({ azure_automation_webhook = bool azure_automation_dscandhybridworker = bool azure_sql_database_sqlserver = bool azure_synapse_analytics_sqlserver = bool azure_synapse_analytics_sql = bool storage_account_blob = bool storage_account_table = bool storage_account_queue = bool storage_account_file = bool storage_account_web = bool azure_data_lake_file_system_gen2 = bool azure_cosmos_db_sql = bool azure_cosmos_db_mongodb = bool azure_cosmos_db_cassandra = bool azure_cosmos_db_gremlin = bool azure_cosmos_db_table = bool azure_database_for_postgresql_server = bool azure_database_for_mysql_server = bool azure_database_for_mariadb_server = bool azure_key_vault = bool azure_kubernetes_service_management = bool azure_search_service = bool azure_container_registry = bool azure_app_configuration_stores = bool azure_backup = bool azure_site_recovery = bool azure_event_hubs_namespace = bool azure_service_bus_namespace = bool azure_iot_hub = bool azure_relay_namespace = bool azure_event_grid_topic = bool azure_event_grid_domain = bool azure_web_apps_sites = bool azure_machine_learning_workspace = bool signalr = bool azure_monitor = bool cognitive_services_account = bool azure_file_sync = bool azure_data_factory = bool azure_data_factory_portal = bool azure_cache_for_redis = bool }) private_link_locations = list(string) public_dns_zones = list(string) private_dns_zones = list(string) enable_private_dns_zone_virtual_network_link_on_hubs = bool enable_private_dns_zone_virtual_network_link_on_spokes = bool }) }) }) location = any tags = any advanced = any })`

If specified, will customize the \"Connectivity\" landing zone settings and resources.

Default:

```hcl
{
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
```

<br>

[**configure_identity_resources**][configure_identity_resources] `object({ settings = object({ identity = object({ enabled = bool config = object({ enable_deny_public_ip = bool enable_deny_rdp_from_internet = bool enable_deny_subnet_without_nsg = bool enable_deploy_azure_backup_on_vms = bool }) }) }) })`

If specified, will customize the \"Identity\" landing zone settings.

Default:

```hcl
{
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
```

<br>

<!-- markdownlint-disable-next-line MD013 -->
[**configure_management_resources**][configure_management_resources] `object({ settings = object({ log_analytics = object({ enabled = bool config = object({ retention_in_days = number enable_monitoring_for_arc = bool enable_monitoring_for_vm = bool enable_monitoring_for_vmss = bool enable_solution_for_agent_health_assessment = bool enable_solution_for_anti_malware = bool enable_solution_for_azure_activity = bool enable_solution_for_change_tracking = bool enable_solution_for_service_map = bool enable_solution_for_sql_assessment = bool enable_solution_for_updates = bool enable_solution_for_vm_insights = bool enable_sentinel = bool }) }) security_center = object({ enabled = bool config = object({ email_security_contact = string enable_defender_for_acr = bool enable_defender_for_app_services = bool enable_defender_for_arm = bool enable_defender_for_dns = bool enable_defender_for_key_vault = bool enable_defender_for_kubernetes = bool enable_defender_for_oss_databases = bool enable_defender_for_servers = bool enable_defender_for_sql_servers = bool enable_defender_for_sql_server_vms = bool enable_defender_for_storage = bool }) }) }) location = any tags = any advanced = any })`

If specified, will customize the \"Management\" landing zone settings and resources.

Default:

```hcl
{
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
```

<br>

[**create_duration_delay**][create_duration_delay] `map(string)`

Used to tune `terraform apply` when faced with errors caused by API caching or eventual consistency. Sets a custom delay period after creation of the specified resource type.

Default:

```hcl
{
  azurerm_management_group      = "30s"
  azurerm_policy_assignment     = "30s"
  azurerm_policy_definition     = "30s"
  azurerm_policy_set_definition = "30s"
  azurerm_role_assignment       = "0s"
  azurerm_role_definition       = "60s"
}
```

<br>

[**custom_landing_zones**][custom_landing_zones] `any`

If specified, will deploy additional Management Groups alongside Enterprise-scale core Management Groups.

Default: `{}`

<br>

[**custom_policy_roles**][custom_policy_roles] `map(list(string))`

If specified, the custom_policy_roles variable overrides which Role Definition ID(s) (value) to assign for Policy Assignments with a Managed Identity, if the assigned \"policyDefinitionId\" (key) is included in this variable.

Default: `{}`

<br>

[**default_location**][default_location] `string`

If specified, will use set the default location used for resource deployments where needed. #check_value will use set the default == is wording right?

Default: `"eastus"`

<br>

[**default_tags**][default_tags] `map(string)`

If specified, will set the default tags for all resources deployed by this module where supported.

Default: `{}`

<br>

[**deploy_connectivity_resources**][deploy_core_landing_zones] `bool`

If set to true, will deploy the \"Connectivity\" landing zone settings and add resources into the current Subscription context.

Default: `false`

<br>

[**deploy_core_landing_zones**][deploy_core_landing_zones] `bool`

If set to true, will include the core Enterprise-scale Management Group hierarchy.

Default: `true`

<br>

[**deploy_corp_landing_zones**][deploy_corp_landing_zones] `bool`

If set to true, module will deploy the "Corp" Management Group, including "out of the box" policies and roles.

Default: `false`

<br>

[**deploy_demo_landing_zones**][deploy_demo_landing_zones] `bool`

If set to true, will include the demo "Landing Zone" Management Groups.

Default: `false`

<br>

[**deploy_identity_resources**][deploy_identity_resources] `bool`

If set to true, will deploy the \"Identity\" landing zone settings.

Default: `false`

<br>

[**deploy_management_resources**][deploy_management_resources] `bool`

If set to true, will deploy the \"Management\" landing zone settings and add resources into the current Subscription context.

Default: `false`

<br>

[**deploy_online_landing_zones**][deploy_online_landing_zones] `bool`

If set to true, module will deploy the "Online" Management Group, including "out of the box" policies and roles.

Default: `false`

<br>

[**deploy_sap_landing_zones**][deploy_sap_landing_zones] `bool`

If set to true, module will deploy the "SAP" Management Group, including "out of the box" policies and roles.

Default: `false`

<br>

[**destroy_duration_delay**][destroy_duration_delay] `map(string)`

Used to tune terraform deploy when faced with errors caused by API caching or eventual consistency. Sets a custom delay period after destruction of the specified resource type. ##check_value tune terraform deploy == terraform destroy?

Default:

```hcl
{
  azurerm_management_group      = "0s"
  azurerm_policy_assignment     = "0s"
  azurerm_policy_definition     = "0s"
  azurerm_policy_set_definition = "0s"
  azurerm_role_assignment       = "0s"
  azurerm_role_definition       = "0s"
}
```

<br>

[**disable_base_module_tags**][disable_base_module_tags] `bool`

If set to true, will remove the base module tags applied to all resources deployed by the module which support tags.

Default: `false`

<br>

[**library_path**][library_path] `string`

If specified, sets the path to a custom library folder for archetype artefacts. #check_value artefacts == is it artifacts? Update the code vars code

Default: `""`

<br>

[**root_id**][root_id] `string`

If specified, will set a custom Name (ID) value for the Enterprise-scale "root" Management Group, and append this to the ID for all core Enterprise-scale Management Groups.

Default: `"es"`

<br>

[**root_name**][root_name] `string`

If specified, will set a custom DisplayName value for the Enterprise-scale "root" Management Group.

Default: `"Enterprise-Scale"`

<br>

[**subscription_id_connectivity**][subscription_id_connectivity] `string`

If specified, identifies the Platform subscription for \"Connectivity\" for resource deployment and correct placement in the Management Group hierarchy.

Default: `""`

<br>

[**subscription_id_identity**][subscription_id_identity] `string`

If specified, identifies the Platform subscription for \"Identity\" for resource deployment and correct placement in the Management Group hierarchy.

Default: `""`

<br>

[**subscription_id_management**][subscription_id_management] `string`

If specified, identifies the Platform subscription for \"Management\" for resource deployment and correct placement in the Management Group hierarchy.

Default: `""`

<br>

[**subscription_id_overrides**][subscription_id_overrides] `map(list(string))`

If specified, will be used to assign subscription_ids to the default Enterprise-scale Management Groups.

Default: `{}`

<br>

[**template_file_variables**][template_file_variables] `map(any)`

If specified, provides the ability to define custom template variables used when reading in template files from the built-in and custom library_path.

Default: `{}`

<br>

A summary of these variables can also be found on the [Inputs][estf-inputs] tab of the module entry in Terraform Registry.

## Next steps

Now you understand how to customize your deployment using the input variables, check out our [Examples](./Examples).

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

[estf-inputs]: https://registry.terraform.io/modules/Azure/caf-enterprise-scale/azurerm/latest?tab=inputs "Terraform Registry: Terraform Module for Cloud Adoption Framework Enterprise-scale - Inputs"

[local_values]:    https://www.terraform.io/docs/language/values/locals.html "Local Values"
[input_variables]: https://www.terraform.io/docs/language/values/variables.html "Input Variables"

[root_parent_id]:                   ./%5BVariables%5D-root_parent_id "Instructions for how to use the root_parent_id variable."
[archetype_config_overrides]:       ./%5BVariables%5D-archetype_config_overrides "Instructions for how to use the archetype_config_overrides variable."
[configure_connectivity_resources]: ./%5BVariables%5D-configure_connectivity_resources "Instructions for how to use the configure_connectivity_resources variable."
[configure_identity_resources]:     ./%5BVariables%5D-configure_identity_resources "Instructions for how to use the configure_identity_resources variable."
[configure_management_resources]:   ./%5BVariables%5D-configure_management_resources "Instructions for how to use the configure_management_resources variable."
[create_duration_delay]:            ./%5BVariables%5D-create_duration_delay "Instructions for how to use the create_duration_delay variable."
[custom_landing_zones]:             ./%5BVariables%5D-custom_landing_zones "Instructions for how to use the custom_landing_zones variable."
[custom_policy_roles]:              ./%5BVariables%5D-custom_policy_roles "Instructions for how to use the custom_policy_roles variable."
[default_location]:                 ./%5BVariables%5D-default_location "Instructions for how to use the default_location variable."
[default_tags]:                     ./%5BVariables%5D-default_tags "Instructions for how to use the default_tags variable."
[deploy_core_landing_zones]:        ./%5BVariables%5D-deploy_core_landing_zones "Instructions for how to use the deploy_core_landing_zones variable."
[deploy_corp_landing_zones]:        ./%5BVariables%5D-deploy_corp_landing_zones "Instructions for how to use the deploy_corp_landing_zones variable."
[deploy_demo_landing_zones]:        ./%5BVariables%5D-deploy_demo_landing_zones "Instructions for how to use the deploy_demo_landing_zones variable."
[deploy_connectivity_resources]:    ./%5BVariables%5D-deploy_connectivity_resources "Instructions for how to use the deploy_connectivity_resources variable."
[deploy_identity_resources]:        ./%5BVariables%5D-deploy_identity_resources "Instructions for how to use the deploy_identity_resources variable."
[deploy_management_resources]:      ./%5BVariables%5D-deploy_management_resources "Instructions for how to use the deploy_management_resources variable."
[deploy_online_landing_zones]:      ./%5BVariables%5D-deploy_online_landing_zones "Instructions for how to use the deploy_online_landing_zones variable."
[deploy_sap_landing_zones]:         ./%5BVariables%5D-deploy_sap_landing_zones "Instructions for how to use the deploy_sap_landing_zones variable."
[destroy_duration_delay]:           ./%5BVariables%5D-destroy_duration_delay "Instructions for how to use the destroy_duration_delay variable."
[disable_base_module_tags]:         ./%5BVariables%5D-disable_base_module_tags "Instructions for how to use the disable_base_module_tags variable."
[library_path]:                     ./%5BVariables%5D-library_path "Instructions for how to use the library_path variable."
[root_id]:                          ./%5BVariables%5D-root_id "Instructions for how to use the root_id variable."
[root_name]:                        ./%5BVariables%5D-root_name "Instructions for how to use the root_name variable."
[subscription_id_connectivity]:     ./%5BVariables%5D-subscription_id_connectivity "Instructions for how to use the subscription_id_connectivity variable."
[subscription_id_identity]:         ./%5BVariables%5D-subscription_id_identity "Instructions for how to use the subscription_id_identity variable."
[subscription_id_management]:       ./%5BVariables%5D-subscription_id_management "Instructions for how to use the subscription_id_management variable."
[subscription_id_overrides]:        ./%5BVariables%5D-subscription_id_overrides "Instructions for how to use the subscription_id_overrides variable."
[template_file_variables]:          ./%5BVariables%5D-template_file_variables "Instructions for how to use the template_file_variables variable."
