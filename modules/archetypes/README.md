<!-- BEGIN_TF_DOCS -->
# Archetypes sub-module

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
| <a name="input_archetype_id"></a> [archetype\_id](#input\_archetype\_id) | Specifies the ID of the archetype to apply against the provided scope. Must be a valid archetype ID from either the built-in module library, or as defined by the library\_path variable. | `string` | n/a | yes |
| <a name="input_default_location"></a> [default\_location](#input\_default\_location) | Sets the default location used for resource deployments where needed. | `string` | n/a | yes |
| <a name="input_root_id"></a> [root\_id](#input\_root\_id) | Specifies the ID of the Enterprise-scale root Management Group where Policy Definitions are created by default. | `string` | n/a | yes |
| <a name="input_scope_id"></a> [scope\_id](#input\_scope\_id) | Specifies the scope to apply the archetype resources against. | `string` | n/a | yes |
| <a name="input_access_control"></a> [access\_control](#input\_access\_control) | If specified, will use the specified access control map to set Role Assignments on the archetype instance at the current scope. | `map(any)` | `{}` | no |
| <a name="input_enforcement_mode"></a> [enforcement\_mode](#input\_enforcement\_mode) | If specified, will use the specified enforcement\_mode values to override defaults for Policy Assignments. | `map(bool)` | `{}` | no |
| <a name="input_library_path"></a> [library\_path](#input\_library\_path) | If specified, sets the path to a custom library folder for archetype artefacts. | `string` | `""` | no |
| <a name="input_parameters"></a> [parameters](#input\_parameters) | If specified, will use the specified parameters to override defaults for Policy Assignments. | `any` | `{}` | no |
| <a name="input_template_file_variables"></a> [template\_file\_variables](#input\_template\_file\_variables) | If specified, provides the ability to define custom template vars used when reading in template files from the library\_path | `any` | `{}` | no |

## Resources

No resources.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_configuration"></a> [configuration](#output\_configuration) | Returns the archetype configuration data used to generate all resources needed to complete deployment of the Enterprise-scale Landing Zones, as per the specified archetype\_id. |

<!-- markdownlint-enable -->
<!-- END_TF_DOCS -->