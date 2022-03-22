## Overview

[**disable_telemetry**](#overview) `bool` (optional)

Microsoft can identify the deployments of this module with the deployed Azure resources.
Microsoft can correlate these resources used to support the deployments.
Microsoft collects this information to provide the best experiences with their products and to operate their business.
The telemetry is collected through customer usage attribution.
The data is collected and governed by Microsoft's privacy policies, located at the trust center.

To disable this tracking, we have included a variable called `disable_telemetry` with a simple boolean flag. The default value is `false` which does not disable the telemetry.
If you would like to disable this tracking, then simply set this value to `true` and this module will not create the telemetry tracking resources and therefore telemetry tracking will be disabled.

## Default value

`false`

## Validation

None

## Usage

```hcl
disable_telemetry = true
```

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

[this_page]: # "Link for the current page."
