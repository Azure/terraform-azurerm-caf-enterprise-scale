## Overview

[**root_parent_id**](#overview) `string` (required)

Represents an existing Management Group, under which the Enterprise-scale resource hierarchy will be deployed.
Usually this will be the Tenant Root Group, which is the default Management Group referenced by the Tenant ID.

## Default value

None

## Validation

The `root_parent_id` value must be a valid Management Group ID matching the following RegEx:

`^[a-zA-Z0-9-_\(\)\.]{1,36}$`

## Usage

For a typical deployment, this will be the Tenant ID.

```hcl
  root_parent_id = "9dd91fa3-6367-43be-a321-27c56b855e88"
```

> In our examples we get the Tenant ID dynamically using [azurerm_client_config](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) data source.

In some cases you may need to do nested deployments. In this scenario, you must set the `root_parent_id` to the ID of an existing Management Group.

The following shows how you would configure the `root_parent_id` to the core "Landing Zones" Management Group, as per our nested deployments [example](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Using-Module-Nesting).

```hcl
  root_parent_id = "es-landing-zones"
```

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

[this_page]: # "Link for the current page."
