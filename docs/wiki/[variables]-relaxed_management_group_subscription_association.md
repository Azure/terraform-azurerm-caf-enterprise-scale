<!-- markdownlint-disable first-line-h1 -->
## Overview

[**relaxed_management_group_subscription_association**](#overview) `bool` (optional)

If set to true, will allow subscriptions not defined in this module to be associated with managed management groups.
The default is `false`, meaning that management group subscription membership must be exclusively defined in this module.

Note that platform subscriptions should always be associated to their respective management groups using this module, due to other dependencies on these inputs.

See:

* [`subscription_id_connectivity`][subscription_id_connectivity]
* [`subscription_id_identity`][subscription_id_identity]
* [`subscription_id_management`][subscription_id_management]

## Default value

`false`

## Validation

None

## Usage

Simply add the `relaxed_management_group_subscription_association` input variable to the module block, and set the value to either true or false.

```hcl
relaxed_management_group_subscription_association = true
```

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

[this_page]: # "Link for the current page."

[subscription_id_connectivity]:                      %5BVariables%5D-subscription_id_connectivity "Instructions for how to use the subscription_id_connectivity variable."
[subscription_id_identity]:                          %5BVariables%5D-subscription_id_identity "Instructions for how to use the subscription_id_identity variable."
[subscription_id_management]:                        %5BVariables%5D-subscription_id_management "Instructions for how to use the subscription_id_management variable."
