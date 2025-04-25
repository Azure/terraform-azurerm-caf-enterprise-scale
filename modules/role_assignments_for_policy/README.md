<!-- BEGIN_TF_DOCS -->
# Role Assignment for Policy sub-module

> [!IMPORTANT]
> For new deployments we now recommend using Azure Verified Modules for Platform Landing Zones.
> Please see the documentation at <https://aka.ms/alz/tf>.
> This module will continue to be supported for existing deployments.

## Documentation
<!-- markdownlint-disable MD033 -->

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.7 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.107.0, < 5.0.0 |

## Modules

No modules.

<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD034 -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_policy_assignment_id"></a> [policy\_assignment\_id](#input\_policy\_assignment\_id) | Policy Assignment ID. | `string` | n/a | yes |
| <a name="input_principal_id"></a> [principal\_id](#input\_principal\_id) | Principal ID of the Managed Identity created for the Policy Assignment. | `string` | n/a | yes |
| <a name="input_scope_id"></a> [scope\_id](#input\_scope\_id) | Scope ID from the Policy Assignment. Depending on the Policy Assignment type, this could be the `management_group_id`, `subscription_id`, `resource_group_id` or `resource_id`. | `string` | n/a | yes |
| <a name="input_additional_scope_ids"></a> [additional\_scope\_ids](#input\_additional\_scope\_ids) | List of additional scopes IDs for Role Assignments needed for the Policy Assignment. By default, the module will create a Role Assignment at the same scope as the Policy Assignment. | `list(string)` | `[]` | no |
| <a name="input_role_definition_ids"></a> [role\_definition\_ids](#input\_role\_definition\_ids) | List of Role Definition IDs for the Policy Assignment. Used to create Role Assignment(s) for the Managed Identity created for the Policy Assignment. | `list(string)` | `[]` | no |

## Resources

| Name | Type |
|------|------|
| [azurerm_role_assignment.for_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_azurerm_role_assignment"></a> [azurerm\_role\_assignment](#output\_azurerm\_role\_assignment) | Returns the configuration data for all Role Assignments created by this module. |

<!-- markdownlint-enable -->
<!-- END_TF_DOCS -->