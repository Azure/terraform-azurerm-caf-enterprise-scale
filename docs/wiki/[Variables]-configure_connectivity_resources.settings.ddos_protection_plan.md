<!-- markdownlint-disable first-line-h1 -->
## Overview

[**configure_connectivity_resources.settings.ddos_protection_plan**](#overview) `object({})` [*see validation for detailed type*](#Validation) (optional)

The `configure_connectivity_resources.settings.ddos_protection_plan` object provides configuration settings to control creation of DDoS resources in the target location.

## Default value

```hcl
ddos_protection_plan = {
  enabled = false
  config = {
    location = ""
  }
}
```

## Validation

Validation provided by schema:

```hcl
object({
  enabled = bool
  config = object({
    location = string
  })
})
```

## Usage

Configuration settings for resources created in the hub network.
These control which resources are created, and what settings are applied to those resources.

> **NOTE:**
> In addition to the below settings, the module is able to link the DDoS protection plan to each of the hub networks (hub and spoke only).
> This requires setting [link_to_ddos_protection_plan = true][wiki_hub_networks_link_to_ddos_protection_plan] on each hub network you want to link.

### `enabled`

The `enabled` (`bool`) input allows you to toggle whether to create a DDoS protection plan, including all associated resources.

### `config`

The `config` (`object`) input allows you to set the following configuration items for the DDoS protection plan:

#### `config.location`

Set the location/region where the DDoS protection plan is created.
Changing this forces new resources to be created.
By default, leaving an empty value in the `location` field will deploy the DDoS protection plan to the location inherited from either `configure_connectivity_resources.location`, or the top-level variable `default_location`, in order of precedence.

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

[this_page]: # "Link for the current page."

[wiki_hub_networks_link_to_ddos_protection_plan]: %5BVariables%5D-configure_connectivity_resources.settings.hub_networks#configlinktoddosprotectionplan "Wiki - configure_connectivity_resources settings hub_networks config link_to_ddos_protection_plan"
