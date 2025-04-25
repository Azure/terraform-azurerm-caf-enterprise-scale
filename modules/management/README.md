<!-- BEGIN_TF_DOCS -->
# Management sub-module

> [!IMPORTANT]
> For new deployments we now recommend using Azure Verified Modules for Platform Landing Zones.
> Please see the documentation at <https://aka.ms/alz/tf>.
> This module will continue to be supported for existing deployments.

## Documentation
<!-- markdownlint-disable MD033 -->

## Requirements

No requirements.

## Modules

No modules.

<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD034 -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Controls whether to manage the management landing zone policies and deploy the management resources into the current Subscription context. | `bool` | n/a | yes |
| <a name="input_root_id"></a> [root\_id](#input\_root\_id) | Specifies the ID of the Enterprise-scale root Management Group, used as a prefix for resources created by this module. | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Specifies the Subscription ID for the Subscription containing all management resources. | `string` | n/a | yes |
| <a name="input_asc_export_resource_group_name"></a> [asc\_export\_resource\_group\_name](#input\_asc\_export\_resource\_group\_name) | If specified, will customise the `ascExportResourceGroupName` parameter for the `Deploy-MDFC-Config` Policy Assignment when managed by the module. | `string` | `""` | no |
| <a name="input_custom_settings_by_resource_type"></a> [custom\_settings\_by\_resource\_type](#input\_custom\_settings\_by\_resource\_type) | If specified, allows full customization of common settings for all resources (by type) deployed by this module. | `any` | `{}` | no |
| <a name="input_existing_automation_account_resource_id"></a> [existing\_automation\_account\_resource\_id](#input\_existing\_automation\_account\_resource\_id) | If specified, module will skip creation of Automation Account and use existing. | `string` | `""` | no |
| <a name="input_existing_log_analytics_workspace_resource_id"></a> [existing\_log\_analytics\_workspace\_resource\_id](#input\_existing\_log\_analytics\_workspace\_resource\_id) | If specified, module will skip creation of Log Analytics workspace and use existing. | `string` | `""` | no |
| <a name="input_existing_resource_group_name"></a> [existing\_resource\_group\_name](#input\_existing\_resource\_group\_name) | If specified, module will skip creation of the management Resource Group and use existing. | `string` | `""` | no |
| <a name="input_link_log_analytics_to_automation_account"></a> [link\_log\_analytics\_to\_automation\_account](#input\_link\_log\_analytics\_to\_automation\_account) | If set to true, module will link the Log Analytics workspace and Automation Account. | `bool` | `true` | no |
| <a name="input_location"></a> [location](#input\_location) | Sets the default location used for resource deployments where needed. | `string` | `"eastus"` | no |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | If specified, will set the resource name prefix for management resources (default value determined from "var.root\_id"). | `string` | `""` | no |
| <a name="input_resource_suffix"></a> [resource\_suffix](#input\_resource\_suffix) | If specified, will set the resource name suffix for management resources. | `string` | `""` | no |
| <a name="input_settings"></a> [settings](#input\_settings) | Configuration settings for the "Management" landing zone resources. | <pre>object({<br>    ama = optional(object({<br>      enable_uami                                                         = optional(bool, true)<br>      enable_vminsights_dcr                                               = optional(bool, true)<br>      enable_change_tracking_dcr                                          = optional(bool, true)<br>      enable_mdfc_defender_for_sql_dcr                                    = optional(bool, true)<br>      enable_mdfc_defender_for_sql_query_collection_for_security_research = optional(bool, true)<br>    }), {})<br>    log_analytics = optional(object({<br>      enabled = optional(bool, true)<br>      config = optional(object({<br>        daily_quota_gb                         = optional(number, -1)<br>        retention_in_days                      = optional(number, 30)<br>        enable_monitoring_for_vm               = optional(bool, true)<br>        enable_monitoring_for_vmss             = optional(bool, true)<br>        enable_sentinel                        = optional(bool, true)<br>        enable_change_tracking                 = optional(bool, true)<br>        enable_solution_for_vm_insights        = optional(bool, true)<br>        enable_solution_for_container_insights = optional(bool, true)<br>        sentinel_customer_managed_key_enabled  = optional(bool, false)<br>      }), {})<br>    }), {})<br>    security_center = optional(object({<br>      enabled = optional(bool, true)<br>      config = optional(object({<br>        email_security_contact                                = optional(string, "security_contact@replace_me")<br>        enable_defender_for_app_services                      = optional(bool, true)<br>        enable_defender_for_arm                               = optional(bool, true)<br>        enable_defender_for_containers                        = optional(bool, true)<br>        enable_defender_for_cosmosdbs                         = optional(bool, true)<br>        enable_defender_for_cspm                              = optional(bool, true)<br>        enable_defender_for_key_vault                         = optional(bool, true)<br>        enable_defender_for_oss_databases                     = optional(bool, true)<br>        enable_defender_for_servers                           = optional(bool, true)<br>        enable_defender_for_servers_vulnerability_assessments = optional(bool, true)<br>        enable_defender_for_sql_servers                       = optional(bool, true)<br>        enable_defender_for_sql_server_vms                    = optional(bool, true)<br>        enable_defender_for_storage                           = optional(bool, true)<br>      }), {})<br>    }), {})<br>  })</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | If specified, will set the default tags for all resources deployed by this module where supported. | `map(string)` | `{}` | no |

## Resources

No resources.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_configuration"></a> [configuration](#output\_configuration) | Returns the configuration settings for resources to deploy for the management solution. |

<!-- markdownlint-enable -->
<!-- END_TF_DOCS -->