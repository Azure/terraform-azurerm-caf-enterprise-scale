## Overview

[**deploy_demo_landing_zones**](#overview) `bool` (optional)

If set to true, will include the demo "Landing Zone" Management Groups.

## Default value

`false`

## Validation

None

## Usage

Set the value to true or false.
If set to _true_, the module will deploy additional Management Groups used for demonstrating the Enterprise-scale Landing Zone archetypes.
This is for demonstration purposes mainly and should not be used for production workloads.

```hcl
  deploy_demo_landing_zones = true
```

To see the effect of this change, please refer to the [Demo landing zones example](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Demo-Landing-Zone-Archetypes).

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

[this_page]: # "Link for the current page."
