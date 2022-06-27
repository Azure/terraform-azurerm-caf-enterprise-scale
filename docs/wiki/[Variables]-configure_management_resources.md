<!-- markdownlint-disable first-line-h1 -->
## Overview

[**configure_management_resources**](#overview) [*see validation for type*](#Validation) (optional)

If specified, will customize the "management" landing zone settings and resources.

## Default value

<!-- markdownlint-disable-next-line no-inline-html -->
<details><summary>Click to view code...</summary>

```hcl
{
  settings = {
    log_analytics = {
      enabled = true
      config = {
        retention_in_days                                 = 30
        enable_monitoring_for_arc                         = true
        enable_monitoring_for_vm                          = true
        enable_monitoring_for_vmss                        = true
        enable_solution_for_agent_health_assessment       = true
        enable_solution_for_anti_malware                  = true
        enable_solution_for_azure_activity                = true
        enable_solution_for_change_tracking               = true
        enable_solution_for_service_map                   = true
        enable_solution_for_sql_assessment                = true
        enable_solution_for_sql_vulnerability_assessment  = true
        enable_solution_for_sql_advanced_threat_detection = true
        enable_solution_for_updates                       = true
        enable_solution_for_vm_insights                   = true
        enable_sentinel                                   = true
      }
    }
    security_center = {
      enabled = true
      config = {
        email_security_contact             = "security_contact@replace_me"
        enable_defender_for_app_services   = true
        enable_defender_for_arm            = true
        enable_defender_for_containers     = true
        enable_defender_for_dns            = true
        enable_defender_for_key_vault      = true
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

</details>

## Validation

Validation provided by schema:

<!-- markdownlint-disable-next-line no-inline-html -->
<details><summary>Click to view code...</summary>

```hcl
object({
  settings = object({
    log_analytics = object({
      enabled = bool
      config = object({
        retention_in_days                                 = number
        enable_monitoring_for_arc                         = bool
        enable_monitoring_for_vm                          = bool
        enable_monitoring_for_vmss                        = bool
        enable_solution_for_agent_health_assessment       = bool
        enable_solution_for_anti_malware                  = bool
        enable_solution_for_azure_activity                = bool
        enable_solution_for_change_tracking               = bool
        enable_solution_for_service_map                   = bool
        enable_solution_for_sql_assessment                = bool
        enable_solution_for_sql_vulnerability_assessment  = bool
        enable_solution_for_sql_advanced_threat_detection = bool
        enable_solution_for_updates                       = bool
        enable_solution_for_vm_insights                   = bool
        enable_sentinel                                   = bool
      })
    })
    security_center = object({
      enabled = bool
      config = object({
        email_security_contact             = string
        enable_defender_for_app_services   = bool
        enable_defender_for_arm            = bool
        enable_defender_for_containers     = bool
        enable_defender_for_dns            = bool
        enable_defender_for_key_vault      = bool
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
```

</details>

## Usage

Configure resources for the `management` landing zone.
This is sub divided into configuration objects for the following:

- [Configure Log Analytics](#configure-log-analytics)
- [Configure Microsoft Defender for Cloud (including Azure Sentinel)](#configure-microsoft-defender-for-cloud)
- [Additional settings](#additional-settings)

### Configure Log Analytics

Define the creation of a central Log Analytics workspace and the associated monitoring solutions.

```hcl
log_analytics = {
  enabled = true
  config = {
    retention_in_days                                 = 30
    enable_monitoring_for_arc                         = true
    enable_monitoring_for_vm                          = true
    enable_monitoring_for_vmss                        = true
    enable_solution_for_agent_health_assessment       = true
    enable_solution_for_anti_malware                  = true
    enable_solution_for_azure_activity                = true
    enable_solution_for_change_tracking               = true
    enable_solution_for_service_map                   = true
    enable_solution_for_sql_assessment                = true
    enable_solution_for_sql_vulnerability_assessment  = true
    enable_solution_for_sql_advanced_threat_detection = true
    enable_solution_for_updates                       = true
    enable_solution_for_vm_insights                   = true
    enable_sentinel                                   = true
  }
}
```

This object allows you to configure the data retention period and the deployed Log Analytics solutions.

#### `settings.log_analytics.enabled`

The `enabled` (`bool`) input allows you to toggle whether to create the Log Analytics workspace.
Note that this is required for many of the Azure Policy assignments to function properly.
For example, the deploy diagnostic settings policies require a Log Analytics workspace as an assignment parameter.

#### `settings.log_analytics.config`

The `config` (`object`) input allows you to set the following configuration items for the Log Analytics workspace:

##### `settings.log_analytics.config.retention_in_days`

The number of days to retain data in the Log Analytics workspace.
See [changing the retention period][la_retention_period] in the Log Analytics documentation.

##### `settings.log_analytics.config.enable_monitoring_for_arc`

Enables the following Azure Policy assignments at your intermediate root management group scope:

- Configure Log Analytics extension on Azure Arc enabled Windows servers
- Configure Log Analytics extension on Azure Arc enabled Linux servers

##### `settings.log_analytics.config.enable_monitoring_for_vm`

Enables the following Azure Policy Initiative assignments at your intermediate root management group scope:

- Enable Azure Monitor for VMs

##### `settings.log_analytics.config.enable_monitoring_for_vmss`

Enables the following Azure Policy Initiative assignment at your intermediate root management group scope:

- Enable Azure Monitor for Virtual Machine Scale Sets

##### `settings.log_analytics.enable_solution_for_agent_health_assessment`

Deploys the following `azurerm_log_analytics_solution` to the deployed `azurerm_log_analytics_workspace`:

- [AgentHealthAssessment][agent_health_overview]

##### `settings.log_analytics.enable_solution_for_anti_malware`

Deploys the following `azurerm_log_analytics_solution` to the deployed `azurerm_log_analytics_workspace`:

- AntiMalware

##### `settings.log_analytics.enable_solution_for_azure_activity`

Deploys the following `azurerm_log_analytics_solution` to the deployed `azurerm_log_analytics_workspace`:

- AzureActivity

##### `settings.log_analytics.enable_solution_for_change_tracking`

Deploys the following `azurerm_log_analytics_solution` to the deployed `azurerm_log_analytics_workspace`:

- [ChangeTracking][change_tracking_overview]

##### `settings.log_analytics.enable_solution_for_service_map`

Deploys the following `azurerm_log_analytics_solution` to the deployed `azurerm_log_analytics_workspace`:

- [ServiceMap][service_map_overview]

##### `settings.log_analytics.enable_solution_for_sql_assessment`

Deploys the following `azurerm_log_analytics_solution` to the deployed `azurerm_log_analytics_workspace`:

- [SQLAssessment][sql_assessment_overview]

##### `settings.log_analytics.enable_solution_for_sql_vulnerability_assessment`

Deploys the following `azurerm_log_analytics_solution` to the deployed `azurerm_log_analytics_workspace`:

- [SQLVulnerabilityAssessment][sql_vulnerability_assessment_overview]

> **NOTE:** To work as expected, the `SQLVulnerabilityAssessment` solution relies on data from [Microsoft Defender for SQL][microsoft_defender_for_sql].
> To enabled this, please refer to the [enable_defender_for_sql_servers](#settingssecuritycenterenabledefenderforsqlservers) setting.

##### `settings.log_analytics.enable_solution_for_sql_advanced_threat_detection`

Deploys the following `azurerm_log_analytics_solution` to the deployed `azurerm_log_analytics_workspace`:

- [SQLAdvancedThreatProtection][sql_advanced_threat_detection_overview]

> **NOTE:** To work as expected, the `SQLAdvancedThreatProtection` solution relies on data from [Microsoft Defender for SQL][microsoft_defender_for_sql].
> To enabled this, please refer to the [enable_defender_for_sql_servers](#settingssecuritycenterenabledefenderforsqlservers) setting.

##### `settings.log_analytics.enable_solution_for_updates`

Deploys the following `azurerm_log_analytics_solution` to the deployed `azurerm_log_analytics_workspace`, as well as an associated `azurerm_automation_account`:

- [Updates][updates_overview]

##### `settings.log_analytics.enable_solution_for_vm_insights`

Deploys the following `azurerm_log_analytics_solution` to the deployed `azurerm_log_analytics_workspace`:

- [VMInsights][vm_insights_overview]

##### `settings.log_analytics.enable_sentinel`

Deploys the following `azurerm_log_analytics_solution` to the deployed `azurerm_log_analytics_workspace`:

- Security
- SecurityInsights

See the [Azure Sentinel overview page][sentinel_overview] for more information.

### Configure Microsoft Defender for Cloud

Deploy [Microsoft Defender for Cloud][microsoft_defender_for_cloud] pricing tiers (previously Azure Defender and Azure Security Center) through Azure Policy assignment.

```hcl
security_center = {
  enabled = true
  config = {
    email_security_contact             = "security_contact@replace_me"
    enable_defender_for_app_services   = true
    enable_defender_for_arm            = true
    enable_defender_for_containers     = true
    enable_defender_for_dns            = true
    enable_defender_for_key_vault      = true
    enable_defender_for_oss_databases  = true
    enable_defender_for_servers        = true
    enable_defender_for_sql_servers    = true
    enable_defender_for_sql_server_vms = true
    enable_defender_for_storage        = true
  }
}
```

#### `settings.security_center.enabled`

Enables or disables the `EnforcementMode` of the `Deploy-MDFC-Config` policy assignment at the organizational root management group.

#### `settings.security_center.config`

The `config` (`object`) input allows you to set the following configuration items:

##### `settings.security_center.email_security_contact`

Specifies the email address to be used as the security contact in Microsoft Defender for Cloud.

##### `settings.security_center.enable_defender_for_app_services`

Enables the the Standard pricing tier for `AppServices` using the "Configure Azure Defender for App Service to be enabled" policy.
This is deployed to all in-scope subscriptions using the `DeployIfNotExists` policy effect.

##### `settings.security_center.enable_defender_for_arm`

Enables the the Standard pricing tier for `Arm` using the "Configure Azure Defender for Resource Manager to be enabled" policy.
This is deployed to all in-scope subscriptions using the `DeployIfNotExists` policy effect.

##### `settings.security_center.enable_defender_for_containers`

Enables Microsoft Defender for Cloud for all in-scope Azure Kubernetes Service clusters using the "Configure Microsoft Defender for Containers to be enabled" policy.
This is deployed to all in-scope clusters using the `DeployIfNotExists` policy effect.

##### `settings.security_center.enable_defender_for_dns`

Enables the the Standard pricing tier for `Dns` using the "Configure Azure Defender for DNS to be enabled" policy.
This is deployed to all in-scope subscriptions using the `DeployIfNotExists` policy effect.

##### `settings.security_center.enable_defender_for_key_vault`

Enables the the Standard pricing tier for `KeyVaults` using the "Configure Azure Defender for Key Vaults to be enabled" policy.
This is deployed to all in-scope subscriptions using the `DeployIfNotExists` policy effect.

##### `settings.security_center.enable_defender_for_oss_databases`

Enables the the Standard pricing tier for `OpenSourceRelationalDatabases` using the "Configure Azure Defender for open-source relational databases to be enabled" policy.
This is deployed to all in-scope subscriptions using the `DeployIfNotExists` policy effect.

##### `settings.security_center.enable_defender_for_servers`

Enables the the Standard pricing tier for `VirtualMachines` using the "Configure Azure Defender for servers to be enabled" policy.
This is deployed to all in-scope subscriptions using the `DeployIfNotExists` policy effect.

##### `settings.security_center.enable_defender_for_sql_servers`

Enables the the Standard pricing tier for `SqlServers` (Azure SQL instances) using the "Configure Azure Defender for Azure SQL database to be enabled" policy.
This is deployed to all in-scope subscriptions using the `DeployIfNotExists` policy effect.

##### `settings.security_center.enable_defender_for_sql_server_vms`

Enables the the Standard pricing tier for `SqlServerVirtualMachines` using the "Configure Azure Defender for SQL servers on machines to be enabled" policy.
This is deployed to all in-scope subscriptions using the `DeployIfNotExists` policy effect.

##### `settings.security_center.enable_defender_for_storage`

Enables the the Standard pricing tier for `StorageAccounts` using the "Configure Azure Defender for Storage to be enabled" policy.
This is deployed to all in-scope subscriptions using the `DeployIfNotExists` policy effect.

### Additional settings

The following additional settings can be used to set configuration on all management resources:

#### `settings.location`

Set the location/region where the management resources are created.
Changing this forces new resources to be created.

By default, leaving an empty value in the `location` field will deploy all management resources in either the location inherited from the top-level variable `default_location`, or from a more specific `location` value if set at a lower scope.

Location can also be overridden for individual resources using the [advanced](#settingsadvanced) input.

#### `settings.tags`

Set additional tags for all management resources.
Tags are appended to those inherited from the top-level variable `default_tags`.

```hcl
tags = {
  MyTag  = "MyValue"
  MyTag2 = "MyValue2"
}
```

> **NOTE:**
> The inherited tags will include those set by the module, unless [disable_base_module_tags][wiki_disable_base_module_tags] is set to `true`.

#### `settings.advanced`

The `advanced` block provides a way to manipulate almost any setting on any management resource created by the module.
This is currently undocumented and only intended for experienced users.

> :warning: **WARNING**
>
> Although the `advanced` block has now evolved to a stable state, we recommend that customers use this with caution as it is not officially supported.
> The long awaited GA release of the `optional()` feature is expected in Terraform `v1.3`.
> This is likely to be used to supplement or replace the `advanced` input in release `v3.0.0` of the module.

See [Using the Advanced Block with management resources][wiki_management_advanced_block] page for more information.

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

[this_page]: # "Link for the current page."

[agent_health_overview]:                  https://docs.microsoft.com/azure/azure-monitor/insights/solution-agenthealth
[change_tracking_overview]:               https://docs.microsoft.com/azure/automation/change-tracking/overview
[la_retention_period]:                    https://docs.microsoft.com/azure/azure-monitor/logs/manage-cost-storage#change-the-data-retention-period
[sentinel_overview]:                      https://docs.microsoft.com/azure/sentinel/overview
[service_map_overview]:                   https://docs.microsoft.com/azure/azure-monitor/vm/service-map
[sql_assessment_overview]:                https://docs.microsoft.com/azure/azure-monitor/insights/sql-assessment
[sql_vulnerability_assessment_overview]:  https://docs.microsoft.com/azure/azure-sql/database/sql-vulnerability-assessment#configure-vulnerability-assessment
[sql_advanced_threat_detection_overview]: https://docs.microsoft.com/azure/azure-sql/database/threat-detection-configure
[updates_overview]:                       https://docs.microsoft.com/azure/automation/update-management/overview
[vm_insights_overview]:                   https://docs.microsoft.com/azure/azure-monitor/vm/vminsights-overview
[microsoft_defender_for_cloud]:           https://docs.microsoft.com/azure/defender-for-cloud/defender-for-cloud-introduction
[microsoft_defender_for_sql]:             https://docs.microsoft.com/azure/azure-sql/database/azure-defender-for-sql

[wiki_management_advanced_block]: %5BVariables%5D-configure_management_resources_advanced "Using the advanced block with management resources"
[wiki_disable_base_module_tags]:   %5BVariables%5D-disable_base_module_tags "Instructions for how to use the disable_base_module_tags variable."
