## Overview

[**deploy_identity_resources**](#overview) `bool` (optional)

If set to true, will enable the "Identity" landing zone settings.

## Default value

`false`

## Validation

None

## Usage

Simply add the `deploy_identity_resources` input variable to the module block, and set the value to either true or false.

```hcl
deploy_identity_resources = true
```

Setting this value to true will update the input parameters on a number of related Policy Assignments.

No additional resources are deployed by this module when setting this value to `true`, however their corresponding configuration settings also depend on which options are selected in the [`configure_identity_resources`][configure_identity_resources] input variable.

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

[this_page]: # "Link for the current page."

[subscription_id_identity]:     ./%5BVariables%5D-subscription_id_identity "Instructions for how to use the subscription_id_identity variable."
[configure_identity_resources]: ./%5BVariables%5D-configure_identity_resources "Instructions for how to use the configure_identity_resources variable."
