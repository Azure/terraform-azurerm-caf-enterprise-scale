<!-- BEGIN_TF_DOCS -->
# Archetypes sub-module

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

No requirements.

## Modules

No modules.

<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD034 -->
## Required Inputs

The following input variables are required:

### <a name="input_archetype_id"></a> [archetype\_id](#input\_archetype\_id)

Description: Specifies the ID of the archetype to apply against the provided scope. Must be a valid archetype ID from either the built-in module library, or as defined by the library\_path variable.

Type: `string`

### <a name="input_default_location"></a> [default\_location](#input\_default\_location)

Description: Sets the default location used for resource deployments where needed.

Type: `string`

### <a name="input_root_id"></a> [root\_id](#input\_root\_id)

Description: Specifies the ID of the Enterprise-scale root Management Group where Policy Definitions are created by default.

Type: `string`

### <a name="input_scope_id"></a> [scope\_id](#input\_scope\_id)

Description: Specifies the scope to apply the archetype resources against.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_access_control"></a> [access\_control](#input\_access\_control)

Description: If specified, will use the specified access control map to set Role Assignments on the archetype instance at the current scope.

Type: `map(any)`

Default: `{}`

### <a name="input_enforcement_mode"></a> [enforcement\_mode](#input\_enforcement\_mode)

Description: If specified, will use the specified enforcement\_mode values to override defaults for Policy Assignments.

Type: `map(bool)`

Default: `{}`

### <a name="input_library_path"></a> [library\_path](#input\_library\_path)

Description: If specified, sets the path to a custom library folder for archetype artefacts.

Type: `string`

Default: `""`

### <a name="input_parameters"></a> [parameters](#input\_parameters)

Description: If specified, will use the specified parameters to override defaults for Policy Assignments.

Type: `any`

Default: `{}`

### <a name="input_template_file_variables"></a> [template\_file\_variables](#input\_template\_file\_variables)

Description: If specified, provides the ability to define custom template vars used when reading in template files from the library\_path

Type: `any`

Default: `{}`

## Resources

No resources.

## Outputs

The following outputs are exported:

### <a name="output_configuration"></a> [configuration](#output\_configuration)

Description: Returns the archetype configuration data used to generate all resources needed to complete deployment of the Enterprise-scale Landing Zones, as per the specified archetype\_id.

<!-- markdownlint-enable -->
<!-- END_TF_DOCS -->