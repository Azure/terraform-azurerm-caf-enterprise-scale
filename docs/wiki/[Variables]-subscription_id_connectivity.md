## Overview

[**subscription_id_connectivity**](#overview) `string` (optional)

If specified, identifies the Platform subscription for \"Connectivity\" for resource deployment and correct placement in the Management Group hierarchy.

## Default value

`""`

## Validation

The `subscription_id_connectivity` value must be a valid GUID, matching the following RegEx:

`^[a-z0-9-]{36}$`

## Usage

To identify the Connectivity Subscription by ID, set the `subscription_id_connectivity` input variable in the module block and specify the desired Subscription ID as the value.

```hcl
  subscription_id_connectivity = "00000000-0000-0000-0000-000000000000"
```

> **NOTE:** This input variable is used to control the data model for setting up the correct values for Policy Assignments and to move the Subscription to the "Connectivity" Management Group, but does not control which Subscription the resources are deployed into. To ensure resources are deployed in the correct Subscription, please refer to our guidance on [Provider Configuration][wiki_provider_configuration].

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

[this_page]: # "Link for the current page."

[wiki_provider_configuration]: ./%5BUser-Guide%5D-Provider-Configuration "Wiki - Provider Configuration"
