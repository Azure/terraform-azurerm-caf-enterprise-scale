<!-- markdownlint-disable first-line-h1 -->
## Overview

[**strict_subscription_association**](#overview) `bool` (optional)

If set to true, subscriptions associated to management groups will be exclusively set by the module and any added by another process will be removed.
If set to false, the module will will only enforce association of the specified subscriptions and those added to management groups by other processes will not be removed.

Note that platform subscriptions should always be associated to their respective management groups using this module, due to other dependencies on these inputs.

For more information, please refer to:

- [`subscription_id_connectivity`][subscription_id_connectivity]
- [`subscription_id_identity`][subscription_id_identity]
- [`subscription_id_management`][subscription_id_management]

> **Important**
>
> Migration from strict to non-strict is not idempotent, this is due to the behavior of the AzureRM provider. If you are setting this variable to `false` with an existing config, you must either:
>
> - Remove all platform & other managed subscriptions associated to management groups to another place, e.g. the tenant root group. The module will then put them back; Or,
> - Perform a Terraform import of the management group subscription association. The address of the Terraform resource for the import is is:
> `module.MODULENAME.azurerm_management_group_subscription_association.enterprise_scale["/providers/Microsoft.Management/managementGroups/MGNAME/subscriptions/SUBID"]`.
> The Azure resource ID should be the same as the key name (in square brackets `[]` ).

## Default value

`true`

## Validation

None

## Usage

Simply add the `strict_subscription_association` input variable to the module block, and set the value to either true or false.

```hcl
strict_subscription_association = true
```

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

[this_page]: # "Link for the current page."

[subscription_id_connectivity]: %5BVariables%5D-subscription_id_connectivity "Instructions for how to use the subscription_id_connectivity variable."
[subscription_id_identity]:     %5BVariables%5D-subscription_id_identity "Instructions for how to use the subscription_id_identity variable."
[subscription_id_management]:   %5BVariables%5D-subscription_id_management "Instructions for how to use the subscription_id_management variable."
