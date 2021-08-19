## Overview

[**archetype_config_overrides**](#overview) `any` (optional)

If specified, will set custom Archetype configurations to the default Enterprise-scale Management Groups.

## Default value

`{}`

## Validation

None

## Usage

Although the object type for this input variable is set to `any`, the expected object is based on the following structure:

```hcl
map(
  object({
    archetype_id   = string
    parameters     = map(any)
    access_control = map(list(string))
  })
)
```

> INFORMATION: The decision not to hard code the structure in the input variable `type` is by design, as it allows Terraform to handle the input as a dynamic object type.
This was necessary to allow the `parameters` value to be correctly interpreted.
Without this, Terraform would throw an error if each parameter value wasn't a consistent type, as it would incorrectly identify the input as a `tuple` which must contain consistent type structure across all entries.

To override the default configuration settings for any of the core Management Groups, add an entry to the `archetype_config_overrides` variable for each Management Group you want to customize.

To create a valid `archetype_config_overrides` entry, you must provide the required values in the `archetype_config_overrides` object for the Management Group you wish to re-configure.
To do this, simply create an entry similar to the `root` example below for one or more of the supported core Management Group IDs:

- `root`
- `decommissioned`
- `sandboxes`
- `landing-zones`
- `platform`
- `connectivity`
- `management`
- `identity`
- `corp`
- `online`
- `sap`

> **NOTE:** The module will handle conversion of the specified Management Group ID from the default value (as listed above) to the "real" value generated from the `root_id` input variable.
>
> For example, if you specify `root_id = "myorg"` in the module block, the module will automatically map `root` to `myorg`, `landing-zones` to `myorg-landing-zones`, etc.

This variable can also be used to customize the [demo Management Groups](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BVariables%5D-deploy_demo_landing_zones): `demo-corp`, `demo-online`, `demo-sap`

The `archetype_config_overrides` example below shows how to set an override for the `root` Management Group, setting the `archetype_id` to `custom_archetype_definition` showing example parameters with different value types for a Policy Assignment called `Example-Policy-Assignment`, and a Role Assignment adding two Object IDs to a Role Definition called `Example-Role-Definition`:

```hcl
  archetype_config_overrides = {
    root = {
      archetype_id = "custom_archetype_definition"
      parameters = {
        Example-Policy-Assignment = {
          parameterStringExample = "value1",
          parameterBoolExample   = true,
          parameterNumberExample = 10,
          parameterListExample = [
            "listItem1",
            "listItem2",
          ]
          parameterObjectExample = {
            key1 = "value1",
            key2 = "value2",
          }
        }
      }
      access_control = {
        Example-Role-Definition = [
          "00000000-0000-0000-0000-000000000000", # Object ID of user/group/spn/mi from Azure AD
          "11111111-1111-1111-1111-111111111111", # Object ID of user/group/spn/mi from Azure AD
        ]
      }
    }
  }
```

The value for each entry in the `archetype_config_overrides` object must be a valid `archetype_config` object containing the `archetype_id` `parameters`, and `access_control` attributes.
For more information, please refer to our documentation on [Working with the `archetype config` object][archetype_config_object].

The following diagram shows how each property in the `archetype_config_overrides` object relates to external references:

![archetype_config_overrides_mapping][archetype_config_overrides_mapping]

As with many other parts of the module, the Role Definition name in the `access_control` object is Case Sensitive.

Please also note that the `roleName` for Role Definitions created by the module include a prefix, creating the format `[SCOPE_IN_UPPERCASE] roleName`.

If you look at the Role Definition `Network-Subnet-Contributor` provided in the module, this is deployed at the `root` scope by default.
In a deployment where `root_id = "myorg"`, this Role Definition will have the `roleName` set to `[MYORG] Network-Subnet-Contributor` in Azure.
This is the value you need to specify in the `access_control` object.

[//]: # (*****************************)
[//]: # (INSERT IMAGE REFERENCES BELOW)
[//]: # (*****************************)

[archetype_config_overrides_mapping]: ./media/variables-archetype_config_overrides-mapping.png "Mapping of archetype_config_overrides entries to their respective sources"

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

[this_page]: # "Link for the current page."

[azuread_provider]: https://registry.terraform.io/providers/hashicorp/azuread/latest/docs "Azure Active Directory Provider"

[archetype_config_object]: ./%5BUser-Guide%5D-Archetype-Definitions#working-with-the-archetype_config-object "Working with the archetype_config object"