<!-- BEGIN_TF_DOCS -->
# Archetypes sub-module

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

Type: `map(string)`

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