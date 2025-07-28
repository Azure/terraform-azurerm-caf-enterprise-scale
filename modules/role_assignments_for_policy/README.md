<!-- BEGIN_TF_DOCS -->
# Role Assignment for Policy sub-module

> [!IMPORTANT]
> For new deployments we now recommend using Azure Verified Modules for Platform Landing Zones.
> Please see the documentation at <https://aka.ms/alz/tf>.

## ⚠️ DEPRECATION NOTICE

**This module is now in extended support mode and will be archived on August 1, 2026.**

### Current Status
- **Extended Support Period**: This module is now in extended support for one year (until August 1, 2026)
- **Support Scope**: During this period, we will provide quality updates and policy updates only
- **No New Features**: No new features or functionality will be added to this module

### Migration Path
We strongly recommend that all users migrate to the new **Azure Verified Modules** approach for Azure Landing Zones. This new approach provides:
- Enhanced reliability and testing
- Improved modularity and flexibility
- Better alignment with Azure best practices
- Ongoing feature development and support

**Further reading**: Please read our recent [blog](https://techcommunity.microsoft.com/blog/azuretoolsblog/terraform-azure-verified-modules-for-platform-landing-zone-alz-migration-guidanc/4432035)

**Migration Guide**: Please visit [aka.ms/alz/tf/migrate](https://aka.ms/alz/tf/migrate) for detailed migration guidance and resources.

### Timeline
- **Now - August 1, 2026**: Extended support (quality and policy updates only)
- **August 1, 2026**: Repository will be archived and no further updates will be made

### Questions?
If you have questions about the migration process or need assistance, please refer to the migration documentation or raise an issue in the repository before the archive date.

## Documentation
<!-- markdownlint-disable MD033 -->

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.7)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 3.107)

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