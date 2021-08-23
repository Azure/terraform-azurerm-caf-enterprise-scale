## Overview

[**deploy_management_resources**](#overview) `bool` (optional)

If set to true, will enable the "Management" landing zone settings and add "Management" resources into the current Subscription context.

## Default value

`false`

## Validation

None

## Usage

Simply add the `deploy_management_resources` input variable to the module block, and set the value to either true or false.

```hcl
deploy_management_resources = true
```

Setting this value to true will update the input parameters on a number of related Policy Assignments.
To ensure the correct values are generated, be careful to ensure you provide the correct value for [`subscription_id_management`][subscription_id_management].
In a standard deployment, this will be the same as the Subscription ID from the current context, but may be different when deploying to [multiple Subscriptions][wiki_multi_subscription].

The resources deployed by this module and their corresponding configuration settings also depend on which options are selected in the [`configure_management_resources`][configure_management_resources] input variable.

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

[this_page]: # "Link for the current page."

[subscription_id_management]:     ./%5BVariables%5D-subscription_id_management "Instructions for how to use the subscription_id_management variable."
[configure_management_resources]: ./%5BVariables%5D-configure_management_resources "Instructions for how to use the configure_management_resources variable."
[wiki_multi_subscription]:        ./%5BUser-Guide%5D-Provider-Configuration#multi-subscription-deployment "[User Guide] Provider Configuration # Multi-Subscription deployment"
