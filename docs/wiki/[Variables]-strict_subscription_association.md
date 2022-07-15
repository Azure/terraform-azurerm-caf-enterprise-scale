<!-- markdownlint-disable first-line-h1 -->
## Overview

[**strict_subscription_association**](#overview) `bool` (optional)

If set to true, subscriptions associated to management groups will be exclusively set by the module and any added by another process will be removed.
If set to false, the module will will only enforce association of the specified subscriptions and those added to management groups by other processes will not be removed.

> **Note:**
> Platform subscriptions should always be associated to their respective management groups using this module, due to other dependencies on these inputs.
>
> For more information, please refer to:
>
> - [`subscription_id_connectivity`][subscription_id_connectivity]
> - [`subscription_id_identity`][subscription_id_identity]
> - [`subscription_id_management`][subscription_id_management]

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
