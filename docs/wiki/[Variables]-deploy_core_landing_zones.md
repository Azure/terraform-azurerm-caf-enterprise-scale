## Overview

[**deploy_core_landing_zones**][this_page] `bool` (optional)

If set to true, will include the core Enterprise-scale Management Group hierarchy.

## Default value

`true`

## Validation

None

## Usage

Set the value to true or false.
If set to _false_ with all the other values as _default_, the module will deploy no resources.
This is for advanced scenarios such as:

- Nested deployments (see [example](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Using-Module-Nesting))
- Landing zone resources:
  - Management (coming soon)
  - Connectivity (coming soon)

```hcl
  deploy_core_landing_zones = false
```

> Important: If changed to _false_ after initial deployment, terraform will destroy all core Enterprise-scale Management Groups and Management Group scoped resources.

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"
[this_page]: # "Link for the current page."
