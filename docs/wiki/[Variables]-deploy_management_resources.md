## Overview

[**deploy_management_resources**](#overview) `map(list(string))` (optional)

If specified, will be used to deploy Log Analytics, Sentinel, and an Automation account to the subscription provided for centralized, Enterprise-scale Management.

## Default value

`{}`

## Validation

None

## Usage

To associate one or more Subscriptions with one of the default Management Groups, update the `subscription_id_overrides` variable to contain a map using the default Management Group ID as each key and a list of Subscription IDs as the value.

A full list of default Management Groups:

**`root`**, **`decommissioned`**, **`sandboxes`**, **`landing-zones`**, **`platform`**, **`connectivity`**, **`management`**, **`identity`**

```hcl
    data "azurerm_client_config" current {}

    module "enterprise_scale" {
      source = "Azure/caf-enterprise-scale/azurerm"
      version = "0.3.3"

    root_parent_id = data.azurerm_client_config.current.tenant_id
    root_id = "contoso" 
    root_name = "Contoso"
    deploy_management_resources = "true" 
    subscription_id_management = data.azurerm_client_config.current.subscription_id //Required variable
    
    }
```

> NOTE: You do not need to replace `root` with the actual root ID, or prefix the other Management Group IDs. The module will do this for you.

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"
[this_page]: # "Link for the current page."