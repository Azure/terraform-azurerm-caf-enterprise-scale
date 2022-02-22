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
    condition     = can(regex("^[a-zA-Z0-9-]{2,10}$", var.root_id))
    error_message = "Value must be between 2 to 10 characters long, consisting of alphanumeric characters and hyphens."
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
  description = "Configuration settings for the \"Management\" landing zone resources."
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
    condition     = can([for k in keys(var.custom_settings_by_resource_type) : contains(["azurerm_resource_group", "azurerm_log_analytics_workspace", "azurerm_log_analytics_solution", "azurerm_automation_account", "azurerm_log_analytics_linked_service"], k)]) || var.custom_settings_by_resource_type == {}
    error_message = "Invalid key specified. Please check the list of allowed resource types supported by the management module for caf-enterprise-scale."
  }
}
