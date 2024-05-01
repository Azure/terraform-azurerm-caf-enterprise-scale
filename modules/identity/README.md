<!-- BEGIN_TF_DOCS -->
# Identity sub-module

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

Description: Controls whether to manage the identity landing zone policies and deploy the identity resources into the current Subscription context.

Type: `bool`

### <a name="input_root_id"></a> [root\_id](#input\_root\_id)

Description: Specifies the ID of the Enterprise-scale root Management Group, used as a prefix for resources created by this module.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_settings"></a> [settings](#input\_settings)

Description: Configuration settings for the "Identity" landing zone resources.

Type:

```hcl
object({
    identity = optional(object({
      enabled = optional(bool, true)
      config = optional(object({
        enable_deny_public_ip             = optional(bool, true)
        enable_deny_rdp_from_internet     = optional(bool, true)
        enable_deny_subnet_without_nsg    = optional(bool, true)
        enable_deploy_azure_backup_on_vms = optional(bool, true)
      }), {})
    }), {})
  })
```

Default: `{}`

## Resources

No resources.

## Outputs

The following outputs are exported:

### <a name="output_configuration"></a> [configuration](#output\_configuration)

Description: Returns the configuration settings for resources to deploy for the identity solution.

<!-- markdownlint-enable -->
<!-- END_TF_DOCS -->