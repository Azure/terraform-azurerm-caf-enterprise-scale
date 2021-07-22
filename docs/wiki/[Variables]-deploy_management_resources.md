
## Overview

[**deploy_management_resources**](#overview) `map(list(string))` (optional)

If specified, will be used to deploy log analytics, sentinel, and an automation account to the subscription provided for centralized, Enterprise-scale Management.

## Default value

`{enabled = "false"}`

## Validation

None

## Usage

To associate one or more Subscriptions with one of the default Management Groups, update the `subscription_id_overrides` variable to contain a map using the default Management Group ID as each key and a list of Subscription IDs as the value.

A full list of default Management Groups:

**`root`**, **`decommissioned`**, **`sandboxes`**, **`landing-zones`**, **`platform`**, **`connectivity`**, **`management`**, **`identity`**

```hcl
    data "azurerm_client_config" current {}

    variable "deploy_management_resources" {
    type        = bool
    description = "If set to true, will deploy the \"Management\" landing zone resources into the current Subscription context."
    default     = false
    }

    variable "configure_management_resources" {
  type = object({
    settings = object({
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
          enable_defender_for_acr            = bool
          enable_defender_for_app_services   = bool
          enable_defender_for_arm            = bool
          enable_defender_for_dns            = bool
          enable_defender_for_key_vault      = bool
          enable_defender_for_kubernetes     = bool
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
 
  }
}
    
  
```

> NOTE: You do not need to replace `root` with the actual root ID, or prefix the other Management Group IDs. The module will do this for you.

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

[this_page]: # "Link for the current page."