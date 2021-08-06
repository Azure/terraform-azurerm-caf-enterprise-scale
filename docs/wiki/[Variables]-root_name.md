## Overview

[**root_name**](#overview) `string` (optional)

If specified, will set a custom Display Name value for the Enterprise-scale "root" Management Group.

## Default value

`"Enterprise-Scale"`

## Validation

The `root_name` value must be a string between 2 to 24 characters long, start with a letter, end with a letter or number, and can only contain space, hyphen, underscore or period characters, matching the following RegEx:

`[A-Za-z][A-Za-z0-9- ._]{1,22}[A-Za-z0-9]?$`

## Usage

To set a custom Display Name value for the Enterprise-scale "root" Management Group to `My Organization`, set the value of `root_name` as below:

```hcl
  root_name = "My Organization"

```

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

[this_page]: # "Link for the current page."
