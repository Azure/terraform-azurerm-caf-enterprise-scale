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
      azure_iot_hub                        = true
      azure_key_vault                      = true
      azure_key_vault_managed_hsm          = true
      azure_kubernetes_service_management  = true
      azure_machine_learning_workspace     = true
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
  }
}
```

</details>

## Validation

Validation provided by schema:

<!-- markdownlint-disable-next-line no-inline-html -->
<details><summary>Click to view code...</summary>

```hcl
object({
  enabled = bool
  config = object({
    location = string
    enable_private_link_by_service = object({
      azure_automation_webhook             = bool
      azure_automation_dscandhybridworker  = bool
      azure_sql_database_sqlserver         = bool
      azure_synapse_studio                 = bool
      azure_synapse_analytics_dev          = bool
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
      azure_purview                        = bool
      azure_purview_studio                 = bool
      azure_batch_account                  = bool
      azure_key_vault_managed_hsm                    = bool
      azure_cache_for_redis_enterprise     = bool
      azure_digital_twins                  = bool
      azure_hdinsights                     = bool
      azure_media_services                 = bool
      azure_migrate                        = bool
      azure_arc                            = bool
      azure_api_management                 = bool
      azure_data_explorer                  = bool
      microsoft_power_bi                   = bool
      azure_bot_service                    = bool
    })
    private_link_locations                                 = list(string)
    public_dns_zones                                       = list(string)
    private_dns_zones                                      = list(string)
    enable_private_dns_zone_virtual_network_link_on_hubs   = bool
    enable_private_dns_zone_virtual_network_link_on_spokes = bool
  })
})
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
- `azure_iot_hub`
- `azure_key_vault`
- `azure_key_vault_managed_hsm`
- `azure_kubernetes_service_management`
- `azure_machine_learning_workspace`
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
- `storage_account_blob`
- `storage_account_file`
- `storage_account_queue`
- `storage_account_table`
- `storage_account_web`

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

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

[msdocs_private_endpoint_dns]: https://learn.microsoft.com/azure/private-link/private-endpoint-dns "Azure Private Endpoint DNS configuration"
