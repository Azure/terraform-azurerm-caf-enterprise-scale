## Overview

[**subscription_id_identity**](#overview) `string` (optional)

If specified, identifies the Platform subscription for \"Identity\" for resource deployment and correct placement in the Management Group hierarchy.

## Default value

`""`

## Validation

The `subscription_id_identity` value must be a valid GUID, matching the following RegEx:

`^[a-z0-9-]{36}$`

## Usage

To identify the Identity Subscription by ID, set the `subscription_id_identity` input variable in the module block and specify the desired Subscription ID as the value.

```hcl
  subscription_id_identity = "00000000-0000-0000-0000-000000000000"
```

> **NOTE:** This input variable is used to control the data model for setting up the correct values for Policy Assignments and to move the Subscription to the "Identity" Management Group. No additional resources are deployed to this Subscription.

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

[this_page]: # "Link for the current page."
