## What is an archetype?

Archetypes are used in the Enterprise-scale architecture to describe the Landing Zone configuration using a template-driven approach. The archetype is what fundamentally transforms ***Management Groups*** and ***Subscriptions*** into ***Landing Zones***.

An archetype defines which Azure Policy and Access control (IAM) settings are needed to secure and configure the Landing Zones with everything needed for safe handover to the Landing Zone owner. This covers critical platform controls and configuration items, such as:

- Consistent role-based access control (RBAC) settings
- Guardrails for security settings
- Guardrails for common workload configurations (e.g. SAP, AKS, WVD, etc.)
- Automate provisioning of critical platform resources such as monitoring and networking solutions in each Landing Zone

This approach provides improved autonomy for application teams, whilst ensuring security policies and standards are enforced.

## Working with archetype definitions and the custom library

The `archetype_definition` is a template file written in JSON or YAML. The default archetype definitions can be found in the [built-in module library][TFAES-Library], but custom archetype definitions can also be added to a custom library in the root module.
The archetype definition is associated to the scope (i.e. Management Group) by specifying the `archetype_id` within the ***Landing Zone*** configuration object.

Both the built-in and custom libraries are also used to store ARM based templates for the Policy Assignments, Policy Definitions, Policy Set Definitions (Initiatives) and Role Definitions. Role Assignments are an exception as these are defined as part of the `archetype_config` instead.

To use a custom library, simply create a folder in your root module (e.g. `/lib`) and tell the module about it using the `library_path` variable (e.g. `library_path = "${path.root}/lib"`). Save your custom templates in the custom library location and as long as they are valid templates for the resource type and match the following naming conventions, the module will automatically import and use them:

| Resource Type | File Name Pattern |
| ------------- | ----------------- |
| Archetype Definitions  | `**/archetype_definition_*.{json,yml,yaml}`  |
| Policy Assignments     | `**/policy_assignment_*.{json,yml,yaml}`     |
| Policy Definitions     | `**/policy_definition_*.{json,yml,yaml}`     |
| Policy Set Definitions | `**/policy_set_definition_*.{json,yml,yaml}` |
| Role Definitions       | `**/role_definition_*.{json,yml,yaml}`       |

> The decision to store Policy Assignments, Policy Definitions, Policy Set Definitions (Initiatives) and Role Definitions as native ARM was based on a number of factors:
>
>- Policies in Terraform require you to understand how to write significant sections of the resource configuration in the native ARM format, and then convert this to a JSON string within Terraform resource.
>- Using a native ARM format makes copying these template assets between ARM and Terraform much easier.
>- Terraform doesn't support importing data objects from native Terraform file formats (`.hcl`, `.tf` or `.tfvar`) so we had to use an alternative to be able to support the custom library model for extensibility and customisation.
>
> **PRO TIP:** The module also supports YAML for these files as long as they match the ARM schema.

This template driven approach is designed to simplify the process of defining an archetype and forms the foundations for how the module is able to provide feature-rich defaults, whilst also allowing a great degree of extensibility and customisation through the input variables instead of having to fork and modify the module.

The `archetype_definition` template contains lists of the Policy Assignments, Policy Definitions, Policy Set Definitions (Initiatives) and Role Definitions you want to create when assigning the archetype to a Management Group. It also includes the ability to set default values for parameters associated with Policy Assignments, and set default Role Assignments.

To keep the `archetype_definition` template as lean as possible, we simply declare the value of the `name` field from the resource templates (by type). The exception is Role Definitions which must have a GUID for the `name` field, so we use the `roleName` value from `properties` instead.

As long as you follow these patterns, you can create your own archetype definitions to start advanced customisation of your Enterprise-scale deployment.

This template-based approach was chosen to make the desired-state easier to understand, simplify the process of managing configuration and versioning, reduce code duplication (DRY), and to improve consistency in complex environments.

### Example archetype definition

```json
{
    "archetype_id": {
        "policy_assignments": [
          // List of Policy Assignments, as per the "name" field in the library templates
          "Policy-Assignment-Name-1",
          "Policy-Assignment-Name-2",
          "Policy-Assignment-Name-3"
        ],
        "policy_definitions": [
          // List of Policy Definitions, as per the "name" field in the library templates
          // We recommend only creating Policy Definitions at the root_id scope
          "Policy-Definition-Name-1",
          "Policy-Definition-Name-2",
          "Policy-Definition-Name-3",
          "Policy-Definition-Name-4",
          "Policy-Definition-Name-5",
          "Policy-Definition-Name-6"
        ],
        "policy_set_definitions": [
          // List of Policy Set Definitions, as per the "name" field in the library templates
          // We recommend only creating Policy Set Definitions at the root_id scope
          "Policy-Set-Definition-Name-1",
          "Policy-Set-Definition-Name-2"
        ],
        "role_definitions": [
          // List of Role Definitions, as per the "properties.roleName" field in the library templates
          // We recommend only creating Role Definitions at the root_id scope
          "Role-Definition-Name-1"
        ],
        "archetype_config": {
            "parameters": {
              // Map of parameters, grouped by Policy Assignment
              // Key should match the "name" field from Policy Assignment
              // Value should be a map containing key-value pairs for each parameter
              "Policy-Assignment-Name-1": {
                "parameterName1": "myStringValue",
                "parameterName2": 100,
                "parameterName3": true,
                "parameterName4": [
                  "myListValue1",
                  "myListValue2",
                  "myListValue3"
                ],
                "parameterName5": {
                  "myObjectKey1": "myObjectValue1",
                  "myObjectKey2": "myObjectValue2",
                  "myObjectKey3": "myObjectValue3"
                }
              }
            },
            "access_control": {
              // Map of Role Assignments to create, grouped by Role Definition name
              // Key should match the "name" of the Role Definition to assign
              // Value should be a list of strings, specifying the Object Id(s) (from Azure AD) of all identities to assign to the role
              "Reader": [
                "00000000-0000-0000-0000-000000000000",
                "11111111-1111-1111-1111-111111111111",
                "22222222-2222-2222-2222-222222222222"
              ],
              "Role-Definition-Name-1": [
                "33333333-3333-3333-3333-333333333333"
              ]
            }
        }
    }
}
```

> **WARNING** The `jsondecode()` function used by Terraform doesn't support comments in JSON. Please also note that HCL objects are Case-Sensitive so the JSON object must be created with the correct character case on anything referenced by Terraform.
> Typically this applies to each `key` in an object but there are also situations where the `value` also needs to be interpreted by the module. For archetype definitions, the case of all values within each section must match those used in the mapped field for each template being assigned. Incorrect casing can result in `terraform plan` identifying unnecessary resource updates.
> For example, the Azure REST API returns `"type": "String"` in parameter blocks, regardless of what case was used to create the resource. Not using the same casing in your source templates can result in Terraform trying to update resources when no real changes have occurred.

### Using the `default_empty` archetype definition

Specifying an `archetype_id` value is mandatory for all Management Groups created by the module.

The default library includes a `default_empty` archetype definition which is useful when defining Management Groups which only require Role Assignments, or are being used for logical segregation of Landing Zones under a parent archetype.
You can assign this to any Landing Zone definition, using the `archetype_config` > `archetype_id` value as per the following `custom_landing_zones` example:

```hcl
  custom_landing_zones = {
    example-landing-zone-id = {
      display_name               = "Example Landing Zone"
      parent_management_group_id = "tf-landing-zones"
      subscription_ids           = []
      archetype_config = {
        archetype_id = "default_empty"
        parameters   = {}
        access_control = {}
      }
    }
  }
```

This is equivalent to creating a standard Management Group without creating any custom Policy Assignments, Policy Definitions, Policy Set Definitions (Initiatives) or Role Definitions.

Role Assignments can be created using the `custom_landing_zones.${management_group_id}.archetype_config.access_control` object scope.

> Note that you still need to provide a full and valid Landing Zone object as per the example above.

### Working with the `archetype_config` object

The `archetype_config` object appears in a number of places and can be used to control the configuration settings of your deployment.

Below is the required structure for the `archetype_config` object:

```hcl
object({
  archetype_id   = string
  parameters     = map(any)
  access_control = map(list(string))
})
```

The `archetype_config` object must contain the following properties:

- `archetype_id` specifies which `archetype_definition` to associate with the current scope.
This must reference a valid `archetype_definition` from the built-in or custom library.

- `parameters` provides the option to set parameter values for any Policy Assignment(s) specified within the chosen archetype definition.
To target a specific Policy Assignment, create a new `map()` entry using the Policy Assignment `name` field as the `key`.
The `value` should be an `object({})` containing `key/value` pairs for each `parameter` needed by the Policy Assignment.

  > Note that parameters are specified as simple `key/value` pairs, and do not require the same structure used in native ARM templates.

- `access_control` provides the option to add user-specified Role Assignments which will be added to the specified Management Group.
To avoid a direct dependency on the [Azure Active Directory Provider][azuread_provider], this module requires the input to be a list of Object IDs for each Azure AD object you want to assign the specified permission.
To add your own Role Assignments, specify the `name` of the Role Definition you want to assign as the `key`, and provide a list of Azure Active Directory Object IDs to assign to this role as the `value`.

You will find the `archetype_config` object in the following places:

- Within each `archetype_definition` template (as per the [example](#example-archetype-definition) above)
- Within each entry of the [`custom_landing_zones`][wiki_variables_custom_landing_zones] input variable
- As the value of each (optional) entry in the [`archetype_config_overrides`][wiki_variables_archetype_config_overrides] input variable

When planning your configuration, keep in mind that the module uses a hierarchy to determine which values to apply.

- For `parameters` entries are merged at the Policy Assignment level, so all required `parameters` must be specified per Policy Assignment.
This allows you to override parameter values for as many or as few Policy Assignments as needed, but you cannot selectively override individual parameter values whilst inheriting others from a lower scope.

- For `access_control` entries are merged at the Role Definition level, so any Role Assignments found under a duplicate Role Definition name will be overwritten by the higher scope.

 [//]: # (************************)
 [//]: # (INSERT LINK LABELS BELOW)
 [//]: # (************************)

[TFAES-Library]: https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/tree/main/modules/archetypes/lib

[wiki_variables_archetype_config_overrides]: ./%5BVariables%5D-archetype_config_overrides "Wiki - Variables - archetype_config_overrides"
[wiki_variables_custom_landing_zones]:       ./%5BVariables%5D-custom_landing_zones "Wiki - Variables - custom_landing_zones"
