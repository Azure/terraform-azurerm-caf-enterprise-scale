## Overview

[**archetype_config_overrides**][this_page] (optional)

```hcl
map(
  object({
    archetype_id   = string
    parameters     = any
    access_control = any
  })
)
```

If specified, will set custom Archetype configurations to the default Enterprise-scale Management Groups.

## Default value

`{}`

## Validation

None

## Usage

To override default configuration settings for the default Management Groups, update the `archetype_config_overrides` variable to contain a valid `archetype_config` object with the required settings for each Management Group to customize.

Supported default Management Group IDs:

**`root`**, **`decommissioned`**, **`sandboxes`**, **`landing-zones`**, **`platform`**, **`connectivity`**, **`management`**, **`identity`**

```hcl
  archetype_config_overrides = {
    root = {
      archetype_id = ""
      parameters = {}
      access_control = {}
    }
  }
```

The [`archetype_config`](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Archetype-Definitions) object must contain valid entries for the `archetype_id` `parameters`, and `access_control` attributes.

> NOTE: This variable can also be used to customize the [demo Management Groups](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BVariables%5D-deploy_demo_landing_zones): `demo-corp`, `demo-online`, `demo-sap`

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"
[this_page]: # "Link for the current page."
