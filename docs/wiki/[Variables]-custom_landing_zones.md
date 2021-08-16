## Overview

[**custom_landing_zones**](#overview) `any` (optional)

If specified, will deploy additional Management Groups alongside Enterprise-scale core Management Groups.

## Default value

`{}`

## Validation

The custom_landing_zones keys must be between 2 to 36 characters long and can only contain lowercase letters, numbers and hyphens, matching the following RegEx:

`[a-z0-9-]{2,36}$`

## Usage

Although the object type for this input variable is set to `any`, the expected object is based on the following structure:

```hcl
variable "custom_landing_zones" {
  type = map(
    object({
      display_name               = string
      parent_management_group_id = string
      subscription_ids           = list(string)
      archetype_config = object({
        archetype_id   = string
        parameters     = map(any)
        access_control = map(list(string))
      })
    })
  )
```

> INFORMATION: The decision not to hard code the structure in the input variable `type` is by design, as it allows Terraform to handle the input as a dynamic object type.
This was necessary to allow the `parameters` value to be correctly interpreted.
Without this, Terraform would throw an error if each parameter value wasn't a consistent type, as it would incorrectly identify the input as a `tuple` which must contain consistent type structure across all entries.

The `custom_landing_zones` object is used to deploy additional Management Groups within the core Management Group hierarchy.
The main object parameters are `display_name`, `parent_management_group_id`, `subscription_ids`and `archetype_config`.

- `display_name` is the name assigned to the Management Group.

- `parent_management_group_id` is the name of the parent Management Group and must be a valid Management Group ID.

- `subscription_ids` is an object containing a list of Subscription IDs to assign to the current Management Group.

- `archetype_config` is used to configure the configuration applied to each Management Group. This object must contain valid entries for the `archetype_id` `parameters`, and `access_control` attributes. For more information about how to populate this object, please refer to the [Working with the `archetype config` object][archetype_config_object] section on our Wiki.

The following example shows how you would add a simple Management Group `${root_id}-customer-corp` under the `${root_id}-landing-zones` Management Group, where `root_id = "myorg"` and using the [`default_empty`][using_default_empty] archetype definition.

```hcl
  custom_landing_zones = {
    myorg-customer-corp = {
      display_name               = "MyOrg Customer Corp"
      parent_management_group_id = "myorg-landing-zones"
      subscription_ids           = [
        "00000000-0000-0000-0000-000000000000",
        "11111111-1111-1111-1111-111111111111",
      ]
      archetype_config = {
        archetype_id   = "default_empty"
        parameters     = {}
        access_control = {}
      }
    }
  }
```

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

[this_page]: # "Link for the current page."

[archetype_config_object]: ./%5BUser-Guide%5D-Archetype-Definitions#working-with-the-archetype_config-object "Working with the archetype_config object"
[using_default_empty]: ./%5BUser-Guide%5D-Archetype-Definitions#using-the-default_empty-archetype-definition "Using the `default_empty` archetype definition"
