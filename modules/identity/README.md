<!-- BEGIN_TF_DOCS -->
# Identity sub-module

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
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Controls whether to manage the identity landing zone policies and deploy the identity resources into the current Subscription context. | `bool` | n/a | yes |
| <a name="input_root_id"></a> [root\_id](#input\_root\_id) | Specifies the ID of the Enterprise-scale root Management Group, used as a prefix for resources created by this module. | `string` | n/a | yes |
| <a name="input_settings"></a> [settings](#input\_settings) | Configuration settings for the "Identity" landing zone resources. | <pre>object({<br>    identity = optional(object({<br>      enabled = optional(bool, true)<br>      config = optional(object({<br>        enable_deny_public_ip             = optional(bool, true)<br>        enable_deny_rdp_from_internet     = optional(bool, true)<br>        enable_deny_subnet_without_nsg    = optional(bool, true)<br>        enable_deploy_azure_backup_on_vms = optional(bool, true)<br>      }), {})<br>    }), {})<br>  })</pre> | `{}` | no |

## Resources

No resources.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_configuration"></a> [configuration](#output\_configuration) | Returns the configuration settings for resources to deploy for the identity solution. |

<!-- markdownlint-enable -->
<!-- END_TF_DOCS -->