# The following variables are used to determine the archetype
# definition to use and create the required resources.
#
# Further information provided within the description block
# for each variable

variable "enabled" {
  type        = bool
  description = "Controls whether to manage the management landing zone policies and deploy the management resources into the current Subscription context."
}

variable "root_id" {
  type        = string
  description = "Specifies the ID of the Enterprise-scale root Management Group, used as a prefix for resources created by this module."

  validation {
    condition     = can(regex("[a-zA-Z0-9-_\\(\\)\\.]", var.root_id))
    error_message = "Value must consist of alphanumeric characters and hyphens."
  }
}

variable "subscription_id" {
  type        = string
  description = "Specifies the Subscription ID for the Subscription containing all management resources."

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
    ama = optional(object({
      enable_uami                                                         = optional(bool, true)
      enable_vminsights_dcr                                               = optional(bool, true)
      enable_change_tracking_dcr                                          = optional(bool, true)
      enable_mdfc_defender_for_sql_dcr                                    = optional(bool, true)
      enable_mdfc_defender_for_sql_query_collection_for_security_research = optional(bool, true)
    }), {})
    log_analytics = optional(object({
      enabled = optional(bool, true)
      config = optional(object({
        retention_in_days                      = optional(number, 30)
        enable_monitoring_for_vm               = optional(bool, true)
        enable_monitoring_for_vmss             = optional(bool, true)
        enable_sentinel                        = optional(bool, true)
        enable_change_tracking                 = optional(bool, true)
        enable_solution_for_vm_insights        = optional(bool, true)
        enable_solution_for_container_insights = optional(bool, true)
        sentinel_customer_managed_key_enabled  = optional(bool, false)
      }), {})
    }), {})
    security_center = optional(object({
      enabled = optional(bool, true)
      config = optional(object({
        email_security_contact                                = optional(string, "security_contact@replace_me")
        enable_defender_for_app_services                      = optional(bool, true)
        enable_defender_for_arm                               = optional(bool, true)
        enable_defender_for_containers                        = optional(bool, true)
        enable_defender_for_cosmosdbs                         = optional(bool, true)
        enable_defender_for_cspm                              = optional(bool, true)
        enable_defender_for_key_vault                         = optional(bool, true)
        enable_defender_for_oss_databases                     = optional(bool, true)
        enable_defender_for_servers                           = optional(bool, true)
        enable_defender_for_servers_vulnerability_assessments = optional(bool, true)
        enable_defender_for_sql_servers                       = optional(bool, true)
        enable_defender_for_sql_server_vms                    = optional(bool, true)
        enable_defender_for_storage                           = optional(bool, true)
      }), {})
    }), {})
  })
  description = "Configuration settings for the \"Management\" landing zone resources."
  default     = {}
}

variable "resource_prefix" {
  type        = string
  description = "If specified, will set the resource name prefix for management resources (default value determined from \"var.root_id\")."
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{2,10}$", var.resource_prefix)) || var.resource_prefix == ""
    error_message = "Value must be between 2 to 10 characters long, consisting of alphanumeric characters and hyphens."
  }
}

variable "resource_suffix" {
  type        = string
  description = "If specified, will set the resource name suffix for management resources."
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{2,36}$", var.resource_suffix)) || var.resource_suffix == ""
    error_message = "Value must be between 2 to 36 characters long, consisting of alphanumeric characters and hyphens."
  }

}

variable "existing_resource_group_name" {
  type        = string
  description = "If specified, module will skip creation of the management Resource Group and use existing."
  default     = ""
}

variable "existing_log_analytics_workspace_resource_id" {
  type        = string
  description = "If specified, module will skip creation of Log Analytics workspace and use existing."
  default     = ""
}

variable "existing_automation_account_resource_id" {
  type        = string
  description = "If specified, module will skip creation of Automation Account and use existing."
  default     = ""
}

variable "link_log_analytics_to_automation_account" {
  type        = bool
  description = "If set to true, module will link the Log Analytics workspace and Automation Account."
  default     = true
}

variable "custom_settings_by_resource_type" {
  type        = any
  description = "If specified, allows full customization of common settings for all resources (by type) deployed by this module."
  default     = {}

  validation {
    condition     = can([for k in keys(var.custom_settings_by_resource_type) : contains(["azurerm_resource_group", "azurerm_log_analytics_workspace", "azurerm_log_analytics_solution", "azurerm_automation_account", "azurerm_log_analytics_linked_service", "azurerm_data_collection_rule"], k)]) || var.custom_settings_by_resource_type == {}
    error_message = "Invalid key specified. Please check the list of allowed resource types supported by the management module for caf-enterprise-scale."
  }
}

variable "asc_export_resource_group_name" {
  type        = string
  description = "If specified, will customise the `ascExportResourceGroupName` parameter for the `Deploy-MDFC-Config` Policy Assignment when managed by the module."
  default     = ""
}
