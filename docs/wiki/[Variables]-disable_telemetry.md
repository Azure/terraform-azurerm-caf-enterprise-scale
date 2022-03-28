## Overview

[**disable_telemetry**](#overview) `bool` (optional)

> Telemetry tracking was added to release `1.2.0` of the module

Microsoft can identify the deployments of this module with the deployed Azure resources.
Microsoft can correlate these resources used to support the deployments.
Microsoft collects this information to provide the best experiences with their products and to operate their business.
The telemetry is collected through customer usage attribution.
The data is collected and governed by Microsoft's privacy policies, located at the trust center.

To disable this tracking, we have included a variable called `disable_telemetry` with a simple boolean flag. The default value is `false` which does not disable the telemetry.
If you would like to disable this tracking, then simply set this value to `true` and this module will not create the telemetry tracking resources and therefore telemetry tracking will be disabled.

For example, to disable telemetry tracking, you can add this variable to the module declaration:

```terraform
module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "1.2.0"

  disable_telemetry = true
}
```

## Default value

`false`

## Validation

None

## Usage

```terraform
disable_telemetry = true
```

## Module PID Value Mapping

| Module Name | PID |
| - | - |
| Core | `36dcde81-8c33-4da0-8dc3-265381502ccb` |
| Connectivity | `97603aac-98f8-4a55-92fc-4c78378c9ba5` |
| Identity | `67becfb7-b296-43a9-ba38-0b5c19cb065a` |
| Management | `6fffb9f9-2691-412a-837e-3f72dcfe70cb` |

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

[this_page]: # "Link for the current page."
