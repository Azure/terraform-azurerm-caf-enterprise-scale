<!-- markdownlint-disable first-line-h1 -->
## Overview

[**relaxed_management_group_subscription_association**](#overview) `bool` (optional)

If set to true, will allow subscriptions not defined in this module to be associated with managed management groups.
The default is `false`, meaning that management group subscription membership must be exclusively defined in this module.

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
