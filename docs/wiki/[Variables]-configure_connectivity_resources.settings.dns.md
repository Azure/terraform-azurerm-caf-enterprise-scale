<!-- markdownlint-disable first-line-h1 -->
## Overview

[**configure_connectivity_resources.settings.dns**](#overview) `object({})` [*see validation for detailed type*](#Validation) (optional)

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

- `azure_automation_webhook`
- `azure_automation_dscandhybridworker`
- `azure_sql_database_sqlserver`
- `azure_synapse_analytics_sqlserver`
- `azure_synapse_analytics_sql`
- `storage_account_blob`
- `storage_account_table`
- `storage_account_queue`
- `storage_account_file`
- `storage_account_web`
- `azure_data_lake_file_system_gen2`
- `azure_cosmos_db_sql`
- `azure_cosmos_db_mongodb`
- `azure_cosmos_db_cassandra`
- `azure_cosmos_db_gremlin`
- `azure_cosmos_db_table`
- `azure_database_for_postgresql_server`
- `azure_database_for_mysql_server`
- `azure_database_for_mariadb_server`
- `azure_key_vault`
- `azure_kubernetes_service_management`
- `azure_search_service`
- `azure_container_registry`
- `azure_app_configuration_stores`
- `azure_backup`
- `azure_site_recovery`
- `azure_event_hubs_namespace`
- `azure_service_bus_namespace`
- `azure_iot_hub`
- `azure_relay_namespace`
- `azure_event_grid_topic`
- `azure_event_grid_domain`
- `azure_web_apps_sites`
- `azure_machine_learning_workspace`
- `signalr`
- `azure_monitor`
- `cognitive_services_account`
- `azure_file_sync`
- `azure_data_factory`
- `azure_data_factory_portal`
- `azure_cache_for_redis`

#### `config.private_link_locations`

#### `config.public_dns_zones`

#### `config.private_dns_zones`

#### `config.enable_private_dns_zone_virtual_network_link_on_hubs`

#### `config.enable_private_dns_zone_virtual_network_link_on_spokes`

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

[this_page]: # "Link for the current page."
