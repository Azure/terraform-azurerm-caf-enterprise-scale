## Overview

[**create_duration_delay**](#overview) `map(string)` (optional)

Sets a custom delay period after creation of the specified resource type. Used to tune `terraform apply` when faced with errors caused by API caching or eventual consistency.

## Default value

```hcl
{
  azurerm_management_group      = "30s"
  azurerm_policy_assignment     = "30s"
  azurerm_policy_definition     = "30s"
  azurerm_policy_set_definition = "30s"
  azurerm_role_assignment       = "0s"
  azurerm_role_definition       = "60s"
}
```

## Validation

Each `create_duration_delay` value must be a string containing the duration in numbers (1-6 digits) followed by the measure of time represented by s (seconds), m (minutes), or h (hours), matching the following RegEx:

`^[0-9]{1,6}(s|m|h)$`

## Usage

Change the delay period of the specified resource type.

```hcl
{
  azurerm_management_group      = "30s"
  azurerm_policy_assignment     = "30s"
  azurerm_policy_definition     = "30s"
  azurerm_policy_set_definition = "30s"
  azurerm_role_assignment       = "30s"
  azurerm_role_definition       = "90s"
}
```

> Important: Only supported for the resource type listed in the example above

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

[this_page]: # "Link for the current page."
