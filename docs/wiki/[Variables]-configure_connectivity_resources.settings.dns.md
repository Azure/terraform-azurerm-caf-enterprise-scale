<!-- markdownlint-disable first-line-h1 -->
## Overview

[**configure_connectivity_resources.settings.dns**](#overview) `object({})` [*see validation for detailed type*](#validation) (optional)

The `configure_connectivity_resources.settings.dns` object provides configuration settings to control creation of DNS resources in the target location.

## Default value

<!-- markdownlint-disable-next-line no-inline-html -->
<details><summary>Click to view code...</summary>

```hcl
{
  enabled = true
  config = {
    location = ""
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
    private_link_locations                                 = []
    public_dns_zones                                       = []
    private_dns_zones                                      = []
    enable_private_dns_zone_virtual_network_link_on_hubs   = true
    enable_private_dns_zone_virtual_network_link_on_spokes = true
    virtual_network_resource_ids_to_link                   = []
  }
}
```

</details>

## Validation

Validation provided by schema:

<!-- markdownlint-disable-next-line no-inline-html -->
<details><summary>Click to view code...</summary>

```hcl
optional(object({
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
```

</details>

## Usage

Configuration settings for DNS resources created by the module.
These control which resources are created, and what settings are applied to those resources.

### `enabled`

The `enabled` (`bool`) input allows you to toggle whether to the configured DNS resources.

### `config`

The `config` (`object`) input allows you to set the following configuration items for each hub network:

#### `config.location`

Set the location/region where the DNS resources are created.
Changing this forces new resources to be created.

By default, leaving an empty value in the `location` field will deploy the (non-global) DNS resources to the location inherited from either `configure_connectivity_resources.location`, or the top-level variable `default_location`, in order of precedence.

#### `config.enable_private_link_by_service`

Enable deployment of private DNS zones for private link by service.

The following services are currently supported by the module:

- `azure_api_management`
- `azure_app_configuration_stores`
- `azure_arc`
- `azure_automation_dscandhybridworker`
- `azure_automation_webhook`
- `azure_backup`
- `azure_batch_account`
- `azure_bot_service_bot`
- `azure_bot_service_token`
- `azure_cache_for_redis`
- `azure_cache_for_redis_enterprise`
- `azure_container_registry`
- `azure_cosmos_db_cassandra`
- `azure_cosmos_db_gremlin`
- `azure_cosmos_db_mongodb`
- `azure_cosmos_db_sql`
- `azure_cosmos_db_table`
- `azure_data_explorer`
- `azure_data_factory`
- `azure_data_factory_portal`
- `azure_data_health_data_services`
- `azure_data_lake_file_system_gen2`
- `azure_database_for_mariadb_server`
- `azure_database_for_mysql_server`
- `azure_database_for_postgresql_server`
- `azure_digital_twins`
- `azure_event_grid_domain`
- `azure_event_grid_topic`
- `azure_event_hubs_namespace`
- `azure_file_sync`
- `azure_hdinsights`
- `azure_iot_dps`
- `azure_iot_hub`
- `azure_key_vault`
- `azure_key_vault_managed_hsm`
- `azure_kubernetes_service_management`
- `azure_machine_learning_workspace`
- `azure_managed_disks`
- `azure_media_services`
- `azure_migrate`
- `azure_monitor`
- `azure_purview_account`
- `azure_purview_studio`
- `azure_relay_namespace`
- `azure_search_service`
- `azure_service_bus_namespace`
- `azure_site_recovery`
- `azure_sql_database_sqlserver`
- `azure_synapse_analytics_dev`
- `azure_synapse_analytics_sql`
- `azure_synapse_studio`
- `azure_web_apps_sites`
- `azure_web_apps_static_sites`
- `cognitive_services_account`
- `microsoft_power_bi`
- `signalr`
- `signalr_webpubsub`
- `storage_account_blob`
- `storage_account_file`
- `storage_account_queue`
- `storage_account_table`
- `storage_account_web`

> **NOTE:** Some services use the same underlying DNS namespace.
> The module will automatically remove duplicate namespaces, but you may find certain setting combination changes result in no-changes to the created private DNS zones.
> The longer term intent is to have these "per-service" controls hooked into the corresponding policy assignments, ensuring only the enabled service types are targeted.

<!-- markdownlint-disable-next-line no-blanks-blockquote -->
> If you need to enable private link for `Azure SQL Managed Instance (Microsoft.Sql/managedInstances)` resources using the `privatelink.{dnsPrefix}.database.windows.net` namespace, please add these using the [config.private_dns_zones](#configprivate_dns_zones) attribute so you can specify the required `dnsPrefix` value(s).

<!-- markdownlint-disable-next-line no-blanks-blockquote -->
> If you need to enable private link for `Azure Static Web Apps (Microsoft.Web/staticSites) / staticSites` resources using the `privatelink.{partitionId}.azurestaticapps.net` namespace, please add these using the [config.private_dns_zones](#configprivate_dns_zones) attribute so you can specify the required `partitionId` value(s).

For more information, please refer to the [Azure Private Endpoint DNS configuration][msdocs_private_endpoint_dns] documentation.

#### `config.private_link_locations`

Set custom location(s) for private link services which require private DNS zones set per location / region.

Currently this applies to the following services:

| Private link service | Private DNS zone name |
| --- | --- |
| `azure_backup` | `privatelink.{region}.backup.windowsazure.us` |
| `azure_data_explorer` | `privatelink.{region}.kusto.windows.net` |
| `azure_kubernetes_service_management` | `privatelink.{region}.azmk8s.io` |

#### `config.public_dns_zones`

Add custom namespaces to create additional public DNS zones using the module.

#### `config.private_dns_zones`

Add custom namespaces to create additional private DNS zones using the module.

#### `config.enable_private_dns_zone_virtual_network_link_on_hubs`

Set to true to link all private DNS zones to all hub virtual networks created by the module.

#### `config.enable_private_dns_zone_virtual_network_link_on_spokes`

Set to true to link all private DNS zones to all spoke virtual networks associated to hub virtual networks created by the module.

#### `config.virtual_network_resource_ids_to_link`

Specify a list of additional virtual network IDs to link to all private DNS zones which are not already associated with hub_networks or virtual_hub_networks through the `config.spoke_virtual_network_resource_ids` inputs.

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

[msdocs_private_endpoint_dns]: https://learn.microsoft.com/azure/private-link/private-endpoint-dns "Azure Private Endpoint DNS configuration"
