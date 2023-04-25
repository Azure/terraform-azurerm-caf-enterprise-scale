<!-- BEGIN_TF_DOCS -->
# Management sub-module

## Documentation
<!-- markdownlint-disable MD033 -->

## Requirements

No requirements.

## Modules

No modules.

<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD034 -->
## Required Inputs

The following input variables are required:

### <a name="input_enabled"></a> [enabled](#input\_enabled)

Description: Controls whether to manage the management landing zone policies and deploy the management resources into the current Subscription context.

Type: `bool`

### <a name="input_root_id"></a> [root\_id](#input\_root\_id)

Description: Specifies the ID of the Enterprise-scale root Management Group, used as a prefix for resources created by this module.

Type: `string`

### <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id)

Description: Specifies the Subscription ID for the Subscription containing all management resources.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_asc_export_resource_group_name"></a> [asc\_export\_resource\_group\_name](#input\_asc\_export\_resource\_group\_name)

Description: If specified, will customise the `ascExportResourceGroupName` parameter for the `Deploy-MDFC-Config` Policy Assignment when managed by the module.

Type: `string`

Default: `""`

### <a name="input_custom_settings_by_resource_type"></a> [custom\_settings\_by\_resource\_type](#input\_custom\_settings\_by\_resource\_type)

Description: If specified, allows full customization of common settings for all resources (by type) deployed by this module.

Type: `any`

Default: `{}`

### <a name="input_existing_automation_account_resource_id"></a> [existing\_automation\_account\_resource\_id](#input\_existing\_automation\_account\_resource\_id)

Description: If specified, module will skip creation of Automation Account and use existing.

Type: `string`

Default: `""`

### <a name="input_existing_log_analytics_workspace_resource_id"></a> [existing\_log\_analytics\_workspace\_resource\_id](#input\_existing\_log\_analytics\_workspace\_resource\_id)

Description: If specified, module will skip creation of Log Analytics workspace and use existing.

Type: `string`

Default: `""`

### <a name="input_existing_resource_group_name"></a> [existing\_resource\_group\_name](#input\_existing\_resource\_group\_name)

Description: If specified, module will skip creation of the management Resource Group and use existing.

Type: `string`

Default: `""`

### <a name="input_link_log_analytics_to_automation_account"></a> [link\_log\_analytics\_to\_automation\_account](#input\_link\_log\_analytics\_to\_automation\_account)

Description: If set to true, module will link the Log Analytics workspace and Automation Account.

Type: `bool`

Default: `true`

### <a name="input_location"></a> [location](#input\_location)

Description: Sets the default location used for resource deployments where needed.

Type: `string`

Default: `"eastus"`

### <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix)

Description: If specified, will set the resource name prefix for management resources (default value determined from "var.root\_id").

Type: `string`

Default: `""`

### <a name="input_resource_suffix"></a> [resource\_suffix](#input\_resource\_suffix)

Description: If specified, will set the resource name suffix for management resources.

Type: `string`

Default: `""`

### <a name="input_settings"></a> [settings](#input\_settings)

Description: Configuration settings for the "Management" landing zone resources.

Type:

```hcl
object({
    log_analytics = optional(object({
      enabled = optional(bool, true)
      config = optional(object({
        retention_in_days                                 = optional(number, 30)
        enable_monitoring_for_vm                          = optional(bool, true)
        enable_monitoring_for_vmss                        = optional(bool, true)
        enable_solution_for_agent_health_assessment       = optional(bool, true)
        enable_solution_for_anti_malware                  = optional(bool, true)
        enable_solution_for_change_tracking               = optional(bool, true)
        enable_solution_for_service_map                   = optional(bool, true)
        enable_solution_for_sql_assessment                = optional(bool, true)
        enable_solution_for_sql_vulnerability_assessment  = optional(bool, true)
        enable_solution_for_sql_advanced_threat_detection = optional(bool, true)
        enable_solution_for_updates                       = optional(bool, true)
        enable_solution_for_vm_insights                   = optional(bool, true)
        enable_solution_for_container_insights            = optional(bool, true)
        enable_sentinel                                   = optional(bool, true)
      }), {})
    }), {})
    security_center = optional(object({
      enabled = optional(bool, true)
      config = optional(object({
        email_security_contact             = optional(string, "security_contact@replace_me")
        enable_defender_for_app_services   = optional(bool, true)
        enable_defender_for_arm            = optional(bool, true)
        enable_defender_for_containers     = optional(bool, true)
        enable_defender_for_dns            = optional(bool, true)
        enable_defender_for_key_vault      = optional(bool, true)
        enable_defender_for_oss_databases  = optional(bool, true)
        enable_defender_for_servers        = optional(bool, true)
        enable_defender_for_sql_servers    = optional(bool, true)
        enable_defender_for_sql_server_vms = optional(bool, true)
        enable_defender_for_storage        = optional(bool, true)
      }), {})
    }), {})
  })
```

Default: `{}`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: If specified, will set the default tags for all resources deployed by this module where supported.

Type: `map(string)`

Default: `{}`

## Resources

No resources.

## Outputs

The following outputs are exported:

### <a name="output_configuration"></a> [configuration](#output\_configuration)

Description: Returns the configuration settings for resources to deploy for the management solution.

<!-- markdownlint-enable -->

<!-- END_TF_DOCS -->