## Overview

[**subscription_id_overrides**](#overview) `map(list(string))` (optional)

If specified, will be used to assign subscription_ids to the default Enterprise-scale Management Groups.

## Default value

`{}`

## Validation

None

## Usage

To associate one or more Subscriptions with one of the default Management Groups, update the `subscription_id_overrides` variable to contain a map using the default Management Group ID as each key and a list of Subscription IDs as the value.

A full list of default Management Groups:

**`root`**, **`decommissioned`**, **`sandboxes`**, **`landing-zones`**, **`platform`**, **`connectivity`**, **`management`**, **`identity`**

```hcl
  subscription_id_overrides = {
    sandboxes = [
      "00000000-0000-0000-0000-000000000000",
      "11111111-1111-1111-1111-111111111111",
      "22222222-2222-2222-2222-222222222222",
    ]
  }
```

> NOTE: You do not need to replace `root` with the actual root ID, or prefix the other Management Group IDs. The module will do this for you.

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

[this_page]: # "Link for the current page."
