# The following block of locals are used to avoid using
# empty object types in the code.
locals {
  empty_string = ""
  empty_list   = []
  empty_map    = {}
}

# Convert the input vars to locals, applying any required
# logic needed before they are used in the module.
# No vars should be referenced elsewhere in the module.
# NOTE: Need to catch error for resource_suffix when
# no value for subscription_id is provided.
locals {
  enabled                                      = var.enabled
  root_id                                      = var.root_id
  subscription_id                              = coalesce(var.subscription_id, "00000000-0000-0000-0000-000000000000")
  settings                                     = var.settings
  location                                     = lower(var.location)
  tags                                         = var.tags
  resource_prefix                              = coalesce(var.resource_prefix, local.root_id)
  resource_suffix                              = length(var.resource_suffix) > 0 ? "-${var.resource_suffix}" : local.empty_string
  existing_resource_group_name                 = var.existing_resource_group_name
  existing_log_analytics_workspace_resource_id = var.existing_log_analytics_workspace_resource_id
  existing_automation_account_resource_id      = var.existing_automation_account_resource_id
  link_log_analytics_to_automation_account     = var.link_log_analytics_to_automation_account
  custom_settings                              = var.custom_settings_by_resource_type
  asc_export_resource_group_name               = coalesce(var.asc_export_resource_group_name, "${local.root_id}-asc-export")
}

# Extract individual custom settings blocks from
# the custom_settings_by_resource_type variable.
locals {
  custom_settings_rsg                 = try(local.custom_settings.azurerm_resource_group["management"], local.empty_map)
  custom_settings_la_workspace        = try(local.custom_settings.azurerm_log_analytics_workspace["management"], local.empty_map)
  custom_settings_la_solution         = try(local.custom_settings.azurerm_log_analytics_solution["management"], local.empty_map)
  custom_settings_aa                  = try(local.custom_settings.azurerm_automation_account["management"], local.empty_map)
  custom_settings_uami                = try(local.custom_settings.azurerm_user_assigned_identity["management"], local.empty_map)
  custom_settings_la_linked_service   = try(local.custom_settings.azurerm_log_analytics_linked_service["management"], local.empty_map)
  custom_settings_dcr_vm_insights     = try(local.custom_settings.azurerm_data_collection_rule["vm_insights"], local.empty_map)
  custom_settings_dcr_change_tracking = try(local.custom_settings.azurerm_data_collection_rule["change_tracking"], local.empty_map)
  custom_settings_dcr_defender_sql    = try(local.custom_settings.azurerm_data_collection_rule["defender_sql"], local.empty_map)
}

# Logic to determine whether specific resources
# should be created by this module
locals {
  deploy_monitoring_settings          = local.settings.log_analytics.enabled
  deploy_monitoring_for_vm            = local.deploy_monitoring_settings && local.settings.log_analytics.config.enable_monitoring_for_vm
  deploy_monitoring_for_vmss          = local.deploy_monitoring_settings && local.settings.log_analytics.config.enable_monitoring_for_vmss
  deploy_monitoring_resources         = local.enabled && local.deploy_monitoring_settings
  deploy_resource_group               = local.deploy_monitoring_resources && local.existing_resource_group_name == local.empty_string
  deploy_log_analytics_workspace      = local.deploy_monitoring_resources && local.existing_log_analytics_workspace_resource_id == local.empty_string
  deploy_log_analytics_linked_service = local.deploy_monitoring_resources && local.link_log_analytics_to_automation_account
  deploy_automation_account           = local.deploy_monitoring_resources && local.existing_automation_account_resource_id == local.empty_string
  deploy_azure_monitor_solutions = {
    ChangeTracking    = local.deploy_monitoring_resources && local.settings.log_analytics.config.enable_change_tracking
    VMInsights        = local.deploy_monitoring_resources && local.settings.log_analytics.config.enable_solution_for_vm_insights
    ContainerInsights = local.deploy_monitoring_resources && local.settings.log_analytics.config.enable_solution_for_container_insights
    SecurityInsights  = local.deploy_monitoring_resources && local.settings.log_analytics.config.enable_sentinel
  }
  deploy_security_settings                              = local.settings.security_center.enabled
  deploy_defender_for_app_services                      = local.settings.security_center.config.enable_defender_for_app_services
  deploy_defender_for_arm                               = local.settings.security_center.config.enable_defender_for_arm
  deploy_defender_for_containers                        = local.settings.security_center.config.enable_defender_for_containers
  deploy_defender_for_cosmosdbs                         = local.settings.security_center.config.enable_defender_for_cosmosdbs
  deploy_defender_for_cspm                              = local.settings.security_center.config.enable_defender_for_cspm
  deploy_defender_for_key_vault                         = local.settings.security_center.config.enable_defender_for_key_vault
  deploy_defender_for_oss_databases                     = local.settings.security_center.config.enable_defender_for_oss_databases
  deploy_defender_for_servers                           = local.settings.security_center.config.enable_defender_for_servers
  deploy_defender_for_servers_vulnerability_assessments = local.settings.security_center.config.enable_defender_for_servers_vulnerability_assessments
  deploy_defender_for_sql_servers                       = local.settings.security_center.config.enable_defender_for_sql_servers
  deploy_defender_for_sql_server_vms                    = local.settings.security_center.config.enable_defender_for_sql_server_vms
  deploy_defender_for_storage                           = local.settings.security_center.config.enable_defender_for_storage
  deploy_ama_uami                                       = local.deploy_monitoring_resources && local.settings.ama.enable_uami
  deploy_vminsights_dcr                                 = local.deploy_monitoring_resources && local.settings.ama.enable_vminsights_dcr
  deploy_change_tracking_dcr                            = local.deploy_monitoring_resources && local.settings.ama.enable_change_tracking_dcr
  deploy_mdfc_defender_for_sql_dcr                      = local.deploy_monitoring_resources && local.settings.ama.enable_mdfc_defender_for_sql_dcr
}

# Configuration settings for resource type:
#  - azurerm_resource_group
locals {
  resource_group_name = coalesce(
    local.existing_resource_group_name,
    lookup(local.custom_settings_rsg, "name", "${local.resource_prefix}-mgmt"),
  )
  resource_group_resource_id = "/subscriptions/${local.subscription_id}/resourceGroups/${local.resource_group_name}"
  azurerm_resource_group = {
    name     = local.resource_group_name,
    location = lookup(local.custom_settings_rsg, "location", local.location)
    tags     = lookup(local.custom_settings_rsg, "tags", local.tags)
  }
}

# Configuration settings for resource type:
#  - azurerm_log_analytics_workspace
locals {
  log_analytics_workspace_resource_id = coalesce(
    local.existing_log_analytics_workspace_resource_id,
    "${local.resource_group_resource_id}/providers/Microsoft.OperationalInsights/workspaces/${local.azurerm_log_analytics_workspace.name}"
  )
  azurerm_log_analytics_workspace = {
    name                               = lookup(local.custom_settings_la_workspace, "name", "${local.resource_prefix}-la${local.resource_suffix}")
    resource_group_name                = lookup(local.custom_settings_la_workspace, "resource_group_name", local.resource_group_name)
    location                           = lookup(local.custom_settings_la_workspace, "location", local.location)
    allow_resource_only_permissions    = lookup(local.custom_settings_la_workspace, "allow_resource_only_permissions", true) # Available only in v3.36.0 onwards
    sku                                = lookup(local.custom_settings_la_workspace, "sku", "PerGB2018")
    retention_in_days                  = lookup(local.custom_settings_la_workspace, "retention_in_days", local.settings.log_analytics.config.retention_in_days)
    daily_quota_gb                     = lookup(local.custom_settings_la_workspace, "daily_quota_gb", null)
    cmk_for_query_forced               = lookup(local.custom_settings_la_workspace, "cmk_for_query_forced", null)
    internet_ingestion_enabled         = lookup(local.custom_settings_la_workspace, "internet_ingestion_enabled", true)
    internet_query_enabled             = lookup(local.custom_settings_la_workspace, "internet_query_enabled", true)
    reservation_capacity_in_gb_per_day = lookup(local.custom_settings_la_workspace, "reservation_capacity_in_gb_per_day", null)
    tags                               = lookup(local.custom_settings_la_workspace, "tags", local.tags)
  }
}

# Configuration settings for resource type:
#  - azurerm_log_analytics_solution
locals {
  log_analytics_solution_resource_id = {
    for resource in local.azurerm_log_analytics_solution :
    resource.solution_name => "${local.resource_group_resource_id}/providers/Microsoft.OperationsManagement/solutions/${resource.solution_name}(${local.azurerm_log_analytics_workspace.name})"
  }
  azurerm_log_analytics_solution = [
    for solution_name, solution_enabled in local.deploy_azure_monitor_solutions :
    {
      solution_name         = solution_name
      resource_group_name   = lookup(local.custom_settings_la_solution, "resource_group_name", local.resource_group_name)
      location              = lookup(local.custom_settings_la_solution, "location", local.location)
      workspace_resource_id = local.log_analytics_workspace_resource_id
      workspace_name        = basename(local.log_analytics_workspace_resource_id)
      tags                  = lookup(local.custom_settings_la_solution, "tags", local.tags)
      plan = {
        publisher = "Microsoft"
        product   = "OMSGallery/${solution_name}"
      }
    }
    if solution_enabled
  ]
}

# Configuration for the user assigned managed identity
locals {
  user_assigned_managed_identity_resource_id = "${local.resource_group_resource_id}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${local.user_assigned_managed_identity.name}"
  user_assigned_managed_identity = {
    name                = lookup(local.custom_settings_uami, "name", "${local.resource_prefix}-uami${local.resource_suffix}")
    resource_group_name = lookup(local.custom_settings_uami, "resource_group_name", local.resource_group_name)
    location            = lookup(local.custom_settings_uami, "location", local.location)
    tags                = lookup(local.custom_settings_uami, "tags", local.tags)
  }
}

# Configuration for the change tracking DCR
locals {
  azure_monitor_data_collection_rule_change_tracking_resource_id = "${local.resource_group_resource_id}/providers/Microsoft.Insights/dataCollectionRules/${local.azure_monitor_data_collection_rule_change_tracking.name}"
  azure_monitor_data_collection_rule_change_tracking = {
    name                      = lookup(local.custom_settings_dcr_change_tracking, "name", "${local.resource_prefix}-dcr-changetracking-prod${local.resource_suffix}")
    type                      = "Microsoft.Insights/dataCollectionRules@2021-04-01"
    parent_id                 = local.resource_group_resource_id
    location                  = lookup(local.custom_settings_dcr_change_tracking, "location", local.location)
    schema_validation_enabled = true
    tags                      = lookup(local.custom_settings_dcr_change_tracking, "tags", local.tags)
    body = {
      properties = {
        description = "Data collection rule for CT"
        dataSources = {
          extensions = [
            {
              streams = [
                "Microsoft-ConfigurationChange",
                "Microsoft-ConfigurationChangeV2",
                "Microsoft-ConfigurationData"
              ]
              extensionName = "ChangeTracking-Windows"
              extensionSettings = {
                enableFiles     = true,
                enableSoftware  = true,
                enableRegistry  = true,
                enableServices  = true,
                enableInventory = true,
                registrySettings = {
                  registryCollectionFrequency = 3600
                  registryInfo = [
                    {
                      name        = "Registry_1",
                      groupTag    = "Recommended",
                      enabled     = false,
                      recurse     = true,
                      description = "",
                      keyName     = "HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows\\CurrentVersion\\Group Policy\\Scripts\\Startup",
                      valueName   = ""
                    },
                    {
                      name        = "Registry_2",
                      groupTag    = "Recommended",
                      enabled     = false,
                      recurse     = true,
                      description = "",
                      keyName     = "HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows\\CurrentVersion\\Group Policy\\Scripts\\Shutdown",
                      valueName   = ""
                    },
                    {
                      name        = "Registry_3",
                      groupTag    = "Recommended",
                      enabled     = false,
                      recurse     = true,
                      description = "",
                      keyName     = "HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\Run",
                      valueName   = ""
                    },
                    {
                      name        = "Registry_4",
                      groupTag    = "Recommended",
                      enabled     = false,
                      recurse     = true,
                      description = "",
                      keyName     = "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Active Setup\\Installed Components",
                      valueName   = ""
                    },
                    {
                      name        = "Registry_5",
                      groupTag    = "Recommended",
                      enabled     = false,
                      recurse     = true,
                      description = "",
                      keyName     = "HKEY_LOCAL_MACHINE\\Software\\Classes\\Directory\\ShellEx\\ContextMenuHandlers",
                      valueName   = ""
                    },
                    {
                      name        = "Registry_6",
                      groupTag    = "Recommended",
                      enabled     = false,
                      recurse     = true,
                      description = "",
                      keyName     = "HKEY_LOCAL_MACHINE\\Software\\Classes\\Directory\\Background\\ShellEx\\ContextMenuHandlers",
                      valueName   = ""
                    },
                    {
                      name        = "Registry_7",
                      groupTag    = "Recommended",
                      enabled     = false,
                      recurse     = true,
                      description = "",
                      keyName     = "HKEY_LOCAL_MACHINE\\Software\\Classes\\Directory\\Shellex\\CopyHookHandlers",
                      valueName   = ""
                    },
                    {
                      name        = "Registry_8",
                      groupTag    = "Recommended",
                      enabled     = false,
                      recurse     = true,
                      description = "",
                      keyName     = "HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\ShellIconOverlayIdentifiers",
                      valueName   = ""
                    },
                    {
                      name        = "Registry_9",
                      groupTag    = "Recommended",
                      enabled     = false,
                      recurse     = true,
                      description = "",
                      keyName     = "HKEY_LOCAL_MACHINE\\Software\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\Explorer\\ShellIconOverlayIdentifiers",
                      valueName   = ""
                    },
                    {
                      name        = "Registry_10",
                      groupTag    = "Recommended",
                      enabled     = false,
                      recurse     = true,
                      description = "",
                      keyName     = "HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Browser Helper Objects",
                      valueName   = ""
                    },
                    {
                      name        = "Registry_11",
                      groupTag    = "Recommended",
                      enabled     = false,
                      recurse     = true,
                      description = "",
                      keyName     = "HKEY_LOCAL_MACHINE\\Software\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Browser Helper Objects",
                      valueName   = ""
                    },
                    {
                      name        = "Registry_12",
                      groupTag    = "Recommended",
                      enabled     = false,
                      recurse     = true,
                      description = "",
                      keyName     = "HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Internet Explorer\\Extensions",
                      valueName   = ""
                    },
                    {
                      name        = "Registry_13",
                      groupTag    = "Recommended",
                      enabled     = false,
                      recurse     = true,
                      description = "",
                      keyName     = "HKEY_LOCAL_MACHINE\\Software\\Wow6432Node\\Microsoft\\Internet Explorer\\Extensions",
                      valueName   = ""
                    },
                    {
                      name        = "Registry_14",
                      groupTag    = "Recommended",
                      enabled     = false,
                      recurse     = true,
                      description = "",
                      keyName     = "HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows NT\\CurrentVersion\\Drivers32",
                      valueName   = ""
                    },
                    {
                      name        = "Registry_15",
                      groupTag    = "Recommended",
                      enabled     = false,
                      recurse     = true,
                      description = "",
                      keyName     = "HKEY_LOCAL_MACHINE\\Software\\Wow6432Node\\Microsoft\\Windows NT\\CurrentVersion\\Drivers32",
                      valueName   = ""
                    },
                    {
                      name        = "Registry_16",
                      groupTag    = "Recommended",
                      enabled     = false,
                      recurse     = true,
                      description = "",
                      keyName     = "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Session Manager\\KnownDlls",
                      valueName   = ""
                    },
                    {
                      name        = "Registry_17",
                      groupTag    = "Recommended",
                      enabled     = false,
                      recurse     = true,
                      description = "",
                      keyName     = "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon\\Notify",
                      valueName   = ""
                    }
                  ]
                }
                fileSettings = {
                  fileCollectionFrequency = 2700,
                },
                softwareSettings = {
                  softwareCollectionFrequency = 1800
                },
                inventorySettings = {
                  inventoryCollectionFrequency = 36000
                },
                servicesSettings = {
                  serviceCollectionFrequency = 1800
                }
              }
              name = "CTDataSource-Windows"
            },
            {
              streams = [
                "Microsoft-ConfigurationChange",
                "Microsoft-ConfigurationChangeV2",
                "Microsoft-ConfigurationData"
              ]
              extensionName = "ChangeTracking-Linux"
              extensionSettings = {
                enableFiles     = true,
                enableSoftware  = true,
                enableRegistry  = false,
                enableServices  = true,
                enableInventory = true,
                fileSettings = {
                  fileCollectionFrequency = 900,
                  fileInfo = [
                    {
                      name                  = "ChangeTrackingLinuxPath_default",
                      enabled               = true,
                      destinationPath       = "/etc/.*.conf",
                      useSudo               = true,
                      recurse               = true,
                      maxContentsReturnable = 5000000,
                      pathType              = "File",
                      type                  = "File",
                      links                 = "Follow",
                      maxOutputSize         = 500000,
                      groupTag              = "Recommended"
                    }
                  ]
                },
                softwareSettings = {
                  softwareCollectionFrequency = 300
                },
                inventorySettings = {
                  inventoryCollectionFrequency = 36000
                },
                servicesSettings = {
                  serviceCollectionFrequency = 300
                }
              }
              name = "CTDataSource-Linux"
            }
          ]
        }
        destinations = {
          logAnalytics = [
            {
              name                = "Microsoft-CT-Dest"
              workspaceResourceId = local.log_analytics_workspace_resource_id
            }
          ]
        }
        dataFlows = [
          {
            streams = [
              "Microsoft-ConfigurationChange",
              "Microsoft-ConfigurationChangeV2",
              "Microsoft-ConfigurationData"
            ]
            destinations = ["Microsoft-CT-Dest"]
          }
        ]
      }
    }
  }
}

# Configuration for the change tracking DCR
locals {
  azure_monitor_data_collection_rule_defender_sql_resource_id = "${local.resource_group_resource_id}/providers/Microsoft.Insights/dataCollectionRules/${local.azure_monitor_data_collection_rule_defender_sql.name}"
  azure_monitor_data_collection_rule_defender_sql = {
    name                      = lookup(local.custom_settings_dcr_defender_sql, "name", "${local.resource_prefix}-dcr-defendersql-prod${local.resource_suffix}")
    parent_id                 = local.resource_group_resource_id
    type                      = "Microsoft.Insights/dataCollectionRules@2021-04-01"
    location                  = lookup(local.custom_settings_dcr_defender_sql, "location", local.location)
    schema_validation_enabled = true
    tags                      = lookup(local.custom_settings_dcr_defender_sql, "tags", local.tags)
    body = {
      properties = {
        description = "Data collection rule for Defender for SQL.",
        dataSources = {
          extensions = [
            {
              extensionName = "MicrosoftDefenderForSQL",
              name          = "MicrosoftDefenderForSQL",
              streams = [
                "Microsoft-DefenderForSqlAlerts",
                "Microsoft-DefenderForSqlLogins",
                "Microsoft-DefenderForSqlTelemetry",
                "Microsoft-DefenderForSqlScanEvents",
                "Microsoft-DefenderForSqlScanResults",
              ],
              extensionSettings = {
                enableCollectionOfSqlQueriesForSecurityResearch = local.settings.ama.enable_mdfc_defender_for_sql_query_collection_for_security_research
              }
            }
          ]
        },
        destinations = {
          logAnalytics = [
            {
              workspaceResourceId = local.log_analytics_workspace_resource_id,
              name                = "LogAnalyticsDest"
            }
          ]
        },
        dataFlows = [
          {
            streams = [
              "Microsoft-DefenderForSqlAlerts",
              "Microsoft-DefenderForSqlLogins",
              "Microsoft-DefenderForSqlTelemetry",
              "Microsoft-DefenderForSqlScanEvents",
              "Microsoft-DefenderForSqlScanResults",
            ],
            destinations = [
              "LogAnalyticsDest"
            ]
          }
        ]
      }
    }
  }
}

# Configuration for the VM Insights DCR
locals {
  azure_monitor_data_collection_rule_vm_insights_resource_id = "${local.resource_group_resource_id}/providers/Microsoft.Insights/dataCollectionRules/${local.azure_monitor_data_collection_rule_vm_insights.name}"
  azure_monitor_data_collection_rule_vm_insights = {
    name                      = lookup(local.custom_settings_dcr_vm_insights, "name", "${local.resource_prefix}-dcr-vm-insights${local.resource_suffix}")
    parent_id                 = local.resource_group_resource_id
    type                      = "Microsoft.Insights/dataCollectionRules@2021-04-01"
    location                  = lookup(local.custom_settings_dcr_vm_insights, "location", local.location)
    tags                      = lookup(local.custom_settings_dcr_vm_insights, "tags", local.tags)
    schema_validation_enabled = false
    body = {
      properties = {
        description = "Data collection rule for VM Insights.",
        dataSources = {
          performanceCounters = [
            {
              name = "VMInsightsPerfCounters",
              streams = [
                "Microsoft-InsightsMetrics"
              ],
              scheduledTransferPeriod    = "PT1M",
              samplingFrequencyInSeconds = 60,
              counterSpecifiers = [
                "\\VmInsights\\DetailedMetrics"
              ]
            }
          ],
          extensions = [
            {
              streams = [
                "Microsoft-ServiceMap"
              ],
              extensionName     = "DependencyAgent",
              extensionSettings = {},
              name              = "DependencyAgentDataSource"
            }
          ]
        },
        destinations = {
          logAnalytics = [
            {
              workspaceResourceId = local.log_analytics_workspace_resource_id,
              name                = "VMInsightsPerf-Logs-Dest"
            }
          ]
        },
        dataFlows = [
          {
            streams = [
              "Microsoft-InsightsMetrics"
            ],
            destinations = [
              "VMInsightsPerf-Logs-Dest"
            ]
          },
          {
            streams = [
              "Microsoft-ServiceMap"
            ],
            destinations = [
              "VMInsightsPerf-Logs-Dest"
            ]
          }
        ]
      }
    }
  }
}

# Configuration settings for resource type:
#  - azurerm_automation_account
locals {
  automation_account_resource_id = coalesce(
    local.existing_automation_account_resource_id,
    "${local.resource_group_resource_id}/providers/Microsoft.Automation/automationAccounts/${local.azurerm_automation_account.name}"
  )
  # As per issue #449, some automation accounts should be created in a different region to the log analytics workspace
  # The automation_account_location_map local is used to track these
  automation_account_location_map = {
    eastus  = "eastus2"
    eastus2 = "eastus"
  }
  automation_account_location = coalesce(
    lookup(local.custom_settings_aa, "location", null),
    lookup(local.automation_account_location_map, local.location, local.location)
  )
  azurerm_automation_account = {
    name                          = lookup(local.custom_settings_aa, "name", "${local.resource_prefix}-automation${local.resource_suffix}")
    resource_group_name           = lookup(local.custom_settings_aa, "resource_group_name", local.resource_group_name)
    location                      = lookup(local.custom_settings_aa, "location", local.automation_account_location)
    sku_name                      = lookup(local.custom_settings_aa, "sku_name", "Basic")
    public_network_access_enabled = lookup(local.custom_settings_aa, "public_network_access_enabled", true)
    local_authentication_enabled  = lookup(local.custom_settings_aa, "local_authentication_enabled", true)
    identity                      = lookup(local.custom_settings_aa, "identity", local.empty_list)
    encryption                    = lookup(local.custom_settings_aa, "encryption", local.empty_list)
    tags                          = lookup(local.custom_settings_aa, "tags", local.tags)
  }
}

# Configuration settings for resource type:
#  - azurerm_log_analytics_linked_service
locals {
  log_analytics_linked_service_resource_id = "${local.log_analytics_workspace_resource_id}/linkedServices/Automation"
  azurerm_log_analytics_linked_service = {
    resource_group_name = lookup(local.custom_settings_la_linked_service, "resource_group_name", local.resource_group_name)
    workspace_id        = lookup(local.custom_settings_la_linked_service, "workspace_id", local.log_analytics_workspace_resource_id)
    read_access_id      = lookup(local.custom_settings_la_linked_service, "read_access_id", local.automation_account_resource_id) # This should be used for linking to an Automation Account resource.
    write_access_id     = null                                                                                                    # DO NOT USE. This should be used for linking to a Log Analytics Cluster resource
  }
}

# Archetype configuration overrides
locals {
  archetype_config_overrides = {
    (local.root_id) = {
      parameters = {
        Deploy-MDFC-Config-H224 = {
          emailSecurityContact                        = local.settings.security_center.config.email_security_contact
          logAnalytics                                = local.log_analytics_workspace_resource_id
          ascExportResourceGroupName                  = local.asc_export_resource_group_name
          ascExportResourceGroupLocation              = local.location
          enableAscForAppServices                     = local.deploy_defender_for_app_services ? "DeployIfNotExists" : "Disabled"
          enableAscForArm                             = local.deploy_defender_for_arm ? "DeployIfNotExists" : "Disabled"
          enableAscForContainers                      = local.deploy_defender_for_containers ? "DeployIfNotExists" : "Disabled"
          enableAscForCosmosDbs                       = local.deploy_defender_for_cosmosdbs ? "DeployIfNotExists" : "Disabled"
          enableAscForCspm                            = local.deploy_defender_for_cspm ? "DeployIfNotExists" : "Disabled"
          enableAscForKeyVault                        = local.deploy_defender_for_key_vault ? "DeployIfNotExists" : "Disabled"
          enableAscForOssDb                           = local.deploy_defender_for_oss_databases ? "DeployIfNotExists" : "Disabled"
          enableAscForServers                         = local.deploy_defender_for_servers ? "DeployIfNotExists" : "Disabled"
          enableAscForServersVulnerabilityAssessments = local.deploy_defender_for_servers_vulnerability_assessments ? "DeployIfNotExists" : "Disabled"
          enableAscForSql                             = local.deploy_defender_for_sql_servers ? "DeployIfNotExists" : "Disabled"
          enableAscForSqlOnVm                         = local.deploy_defender_for_sql_server_vms ? "DeployIfNotExists" : "Disabled"
          enableAscForStorage                         = local.deploy_defender_for_storage ? "DeployIfNotExists" : "Disabled"
        }
        Deploy-AzActivity-Log = {
          logAnalytics = local.log_analytics_workspace_resource_id
        }
        Deploy-Diag-Logs = {
          logAnalytics = local.log_analytics_workspace_resource_id
        }
      }
      enforcement_mode = {
        Deploy-MDFC-Config     = local.deploy_security_settings
        Deploy-VM-Monitoring   = local.deploy_monitoring_for_vm
        Deploy-VMSS-Monitoring = local.deploy_monitoring_for_vmss
      }
    }
    "${local.root_id}-landing-zones" = {
      parameters = {
        DenyAction-DeleteUAMIAMA = {
          resourceName = local.user_assigned_managed_identity.name
          resourceType = "Microsoft.ManagedIdentity/userAssignedIdentities"
        }
        Deploy-MDFC-DefSQL-AMA = {
          userWorkspaceResourceId = local.log_analytics_workspace_resource_id
        }
        Deploy-AzSqlDb-Auditing = {
          logAnalyticsWorkspaceId = lower(local.log_analytics_workspace_resource_id)
        }
      }
      enforcement_mode = {}
    }
    "${local.root_id}-platform" = {
      parameters = {
        DenyAction-DeleteUAMIAMA = {
          resourceName = local.user_assigned_managed_identity.name
          resourceType = "Microsoft.ManagedIdentity/userAssignedIdentities"
        }
        Deploy-MDFC-DefSQL-AMA = {
          userWorkspaceResourceId = local.log_analytics_workspace_resource_id
        }
        Deploy-AzSqlDb-Auditing = {
          logAnalyticsWorkspaceId = lower(local.log_analytics_workspace_resource_id)
        }
      }
      enforcement_mode = {}
    }
    "${local.root_id}-management" = {
      parameters = {
        Deploy-Log-Analytics = {
          automationAccountName = local.azurerm_automation_account.name
          automationRegion      = local.azurerm_automation_account.location
          rgName                = local.azurerm_resource_group.name
          workspaceName         = local.azurerm_log_analytics_workspace.name
          workspaceRegion       = local.azurerm_log_analytics_workspace.location
          # Need to ensure dataRetention gets handled as a string
          dataRetention = tostring(local.azurerm_log_analytics_workspace.retention_in_days)
          # Need to ensure sku value is set to lowercase only when "PerGB2018" specified
          # Evaluating in lower() to ensure the correct error is surfaced on the resource if invalid casing is used
          sku = lower(local.azurerm_log_analytics_workspace.sku) == "pergb2018" ? lower(local.azurerm_log_analytics_workspace.sku) : local.azurerm_log_analytics_workspace.sku
        }
      }
      enforcement_mode = {
        Deploy-Log-Analytics = false
      }
    }
  }
}

# Sentinel onboarding
locals {
  azapi_sentinel_onboarding_resource_id = "${local.log_analytics_workspace_resource_id}/Microsoft.SecurityInsights/onboardingStates/default"
  azapi_sentinel_onboarding = {
    type = "Microsoft.SecurityInsights/onboardingStates@2024-03-01"
    body = {
      properties = {
        customerManagedKey = try(local.settings.log_analytics.config.sentinel_customer_managed_key_enabled, false)
      }
    }
    name      = "default"
    parent_id = local.log_analytics_workspace_resource_id
  }
}

# Template file variable outputs
locals {
  template_file_variables = {
    automation_account_location                                    = local.azurerm_automation_account.location
    automation_account_name                                        = local.azurerm_automation_account.name
    automation_account_resource_id                                 = local.automation_account_resource_id
    azure_monitor_data_collection_rule_change_tracking_resource_id = local.azure_monitor_data_collection_rule_change_tracking_resource_id
    azure_monitor_data_collection_rule_sql_resource_id             = local.azure_monitor_data_collection_rule_defender_sql_resource_id
    azure_monitor_data_collection_rule_vm_insights_resource_id     = local.azure_monitor_data_collection_rule_vm_insights_resource_id
    data_retention                                                 = tostring(local.azurerm_log_analytics_workspace.retention_in_days)
    log_analytics_workspace_location                               = local.azurerm_log_analytics_workspace.location
    log_analytics_workspace_name                                   = local.azurerm_log_analytics_workspace.name
    log_analytics_workspace_resource_id                            = local.log_analytics_workspace_resource_id
    management_location                                            = local.location
    management_resource_group_name                                 = local.azurerm_resource_group.name
    user_assigned_managed_identity_resource_id                     = local.user_assigned_managed_identity_resource_id
  }
}

# Generate the configuration output object for the management module
locals {
  module_output = {
    azurerm_resource_group = [
      {
        resource_id   = local.resource_group_resource_id
        resource_name = basename(local.resource_group_resource_id)
        template = {
          for key, value in local.azurerm_resource_group :
          key => value
          if local.deploy_resource_group
        }
        managed_by_module = local.deploy_resource_group
      },
    ]
    azurerm_log_analytics_workspace = [
      {
        resource_id   = local.log_analytics_workspace_resource_id
        resource_name = basename(local.log_analytics_workspace_resource_id)
        template = {
          for key, value in local.azurerm_log_analytics_workspace :
          key => value
          if local.deploy_log_analytics_workspace
        }
        managed_by_module = local.deploy_log_analytics_workspace
      },
    ]
    azurerm_log_analytics_solution = [
      for resource in local.azurerm_log_analytics_solution :
      {
        resource_id       = local.log_analytics_solution_resource_id[resource.solution_name]
        resource_name     = basename(local.log_analytics_solution_resource_id[resource.solution_name])
        template          = resource
        managed_by_module = true
      }
    ]
    azurerm_automation_account = [
      {
        resource_id   = local.automation_account_resource_id
        resource_name = basename(local.automation_account_resource_id)
        template = {
          for key, value in local.azurerm_automation_account :
          key => value
          if local.deploy_automation_account
        }
        managed_by_module = local.deploy_automation_account
      },
    ]
    azurerm_log_analytics_linked_service = [
      {
        resource_id   = local.log_analytics_linked_service_resource_id
        resource_name = basename(local.log_analytics_linked_service_resource_id)
        template = {
          for key, value in local.azurerm_log_analytics_linked_service :
          key => value
          if local.deploy_log_analytics_linked_service
        }
        managed_by_module = local.deploy_log_analytics_linked_service
      },
    ]
    azurerm_user_assigned_identity = [
      {
        resource_id   = local.user_assigned_managed_identity_resource_id
        resource_name = basename(local.user_assigned_managed_identity_resource_id)
        template = {
          for key, value in local.user_assigned_managed_identity :
          key => value
          if local.deploy_ama_uami
        }
        managed_by_module = local.deploy_ama_uami
      }
    ]
    azurerm_monitor_data_collection_rule = [
      {
        resource_id   = local.azure_monitor_data_collection_rule_vm_insights_resource_id
        resource_name = basename(local.azure_monitor_data_collection_rule_vm_insights_resource_id)
        template = {
          for key, value in local.azure_monitor_data_collection_rule_vm_insights :
          key => value
          if local.deploy_vminsights_dcr
        }
        managed_by_module = local.deploy_vminsights_dcr
      },
      {
        resource_id   = local.azure_monitor_data_collection_rule_change_tracking_resource_id
        resource_name = basename(local.azure_monitor_data_collection_rule_change_tracking_resource_id)
        template = {
          for key, value in local.azure_monitor_data_collection_rule_change_tracking :
          key => value
          if local.deploy_change_tracking_dcr
        }
        managed_by_module = local.deploy_change_tracking_dcr
      },
      {
        resource_id   = local.azure_monitor_data_collection_rule_defender_sql_resource_id
        resource_name = basename(local.azure_monitor_data_collection_rule_defender_sql_resource_id)
        template = {
          for key, value in local.azure_monitor_data_collection_rule_defender_sql :
          key => value
          if local.deploy_mdfc_defender_for_sql_dcr
        }
        managed_by_module = local.deploy_mdfc_defender_for_sql_dcr
      }
    ]
    azapi_sentinel_onboarding = [
      {
        resource_id   = local.azapi_sentinel_onboarding_resource_id
        resource_name = basename(local.azapi_sentinel_onboarding_resource_id)
        template = {
          for key, value in local.azapi_sentinel_onboarding :
          key => value
          if local.deploy_azure_monitor_solutions.SecurityInsights
        }
        managed_by_module = local.deploy_azure_monitor_solutions.SecurityInsights
      }
    ]
    archetype_config_overrides = local.archetype_config_overrides
    template_file_variables    = local.template_file_variables
  }
}
