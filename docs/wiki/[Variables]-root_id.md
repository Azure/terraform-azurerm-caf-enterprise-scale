## Overview

[**root_id**](#overview) `string` (optional)

If specified, will set a custom Name (ID) value for the Enterprise-scale "root" Management Group, and append this to the ID for all core Enterprise-scale Management Groups.

## Default value

`"es"`

## Validation

The `root_id` must be a string between 2 to 10 characters long and can only contain alphanumeric characters and hyphens, matching the following RegEx:

`[a-zA-Z0-9-]{2,10}$`

## Usage

To set a custom Name (ID) value for the Enterprise-scale "root" Management Group to `myorg`, set the value of `root_id` as below:

```hcl
  root_id = "myorg"
```

> WARNING: Changing this value will cause Terraform to re-create <u>all</u> resources managed by this module

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

[this_page]: # "Link for the current page."
