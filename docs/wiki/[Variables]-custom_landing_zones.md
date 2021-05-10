## Overview

[**custom_landing_zones**][this_page] `map` (optional)

```hcl
variable "custom_landing_zones" {
  type = map(
    object({
      display_name               = string
      parent_management_group_id = string
      subscription_ids           = list(string)
      archetype_config = object({
        archetype_id   = string
        parameters     = any
        access_control = any
      })
    })
  )
```

If specified, will deploy additional Management Groups alongside Enterprise-scale core Management Groups.

## Default value

`{}`

## Validation

The custom_landing_zones keys must be between 2 to 36 characters long and can only contain lowercase letters, numbers and hyphens, matching the following RegEx:

`[a-z0-9-]{2,36}$`

## Usage

In a deployment when `custom_landing_zones` block is configured, will deploy additional Management Groups alongside core Management Groups.
The main block parameters are `display_name`, `parent_management_group_id`, `subscription_ids`and `archetype_config`.

`display_name` is the name assigned to the Management Group.

`parent_management_group_id` is the name of the parent Management Group and must be a valid Management Group ID.

`subscription_ids` is an object containing a list of Subscription IDs to assign to the current Management Group.

[`archetype_config`](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Archetype-Definitions) is used to configure archetype settings applied to each Management Group. This object must contain valid entries for the `archetype_id` `parameters`, and `access_control` attributes.

```hcl
  custom_landing_zones = {
    myorg-1-customer-corp = {
      display_name               = ""
      parent_management_group_id = ""
      subscription_ids           = []
      archetype_config = {
        archetype_id   = ""
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
