<!-- BEGIN_TF_DOCS -->
# Role Assignment for Policy sub-module

## Documentation
<!-- markdownlint-disable MD033 -->

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.3.1)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (>= 3.35.0)

## Modules

No modules.

<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD034 -->
## Required Inputs

The following input variables are required:

### <a name="input_policy_assignment_id"></a> [policy\_assignment\_id](#input\_policy\_assignment\_id)

Description: Policy Assignment ID.

Type: `string`

### <a name="input_principal_id"></a> [principal\_id](#input\_principal\_id)

Description: Principal ID of the Managed Identity created for the Policy Assignment.

Type: `string`

### <a name="input_scope_id"></a> [scope\_id](#input\_scope\_id)

Description: Scope ID from the Policy Assignment. Depending on the Policy Assignment type, this could be the `management_group_id`, `subscription_id`, `resource_group_id` or `resource_id`.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_additional_scope_ids"></a> [additional\_scope\_ids](#input\_additional\_scope\_ids)

Description: List of additional scopes IDs for Role Assignments needed for the Policy Assignment. By default, the module will create a Role Assignment at the same scope as the Policy Assignment.

Type: `list(string)`

Default: `[]`

### <a name="input_role_definition_ids"></a> [role\_definition\_ids](#input\_role\_definition\_ids)

Description: List of Role Definition IDs for the Policy Assignment. Used to create Role Assignment(s) for the Managed Identity created for the Policy Assignment.

Type: `list(string)`

Default: `[]`

## Resources

The following resources are used by this module:

- [azurerm_role_assignment.for_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)

## Outputs

The following outputs are exported:

### <a name="output_azurerm_role_assignment"></a> [azurerm\_role\_assignment](#output\_azurerm\_role\_assignment)

Description: Returns the configuration data for all Role Assignments created by this module.

<!-- markdownlint-enable -->

<!-- END_TF_DOCS -->