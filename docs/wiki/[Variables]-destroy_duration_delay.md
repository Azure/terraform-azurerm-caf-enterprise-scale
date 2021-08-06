## Overview

[**destroy_duration_delay**](#overview) `map(string)` (optional)

Used to tune terraform deploy when faced with errors caused by API caching or eventual consistency. Sets a custom delay period after destruction of the specified resource type.

## Default value

```hcl
{}
```

## Validation

The `destroy_duration_delay` values must be a string containing the duration in numbers (1-6 digits) followed by the measure of time represented by s (seconds), m (minutes), or h (hours), matching the following RegEx:

`[0-9]{1,6}(s|m|h)$`

## Usage

To create a delay after the destruction of a supported resource type, change the value as per the example.
In the following, we set a 30s delay after the destruction of `azurerm_policy_assignment` resources.

```hcl
{
  azurerm_management_group      = "0s"
  azurerm_policy_assignment     = "30s"
  azurerm_policy_definition     = "0s"
  azurerm_policy_set_definition = "0s"
  azurerm_role_assignment       = "0s"
  azurerm_role_definition       = "0s"
}
```

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

[this_page]: # "Link for the current page."
