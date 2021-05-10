## Overview

[**default_location**][this_page] `string` (optional)

Set the Azure region in which region bound resources will be deployed.

## Default value

`"eastus"`

## Validation

None

> Important: The default location must be a valid Azure region.

## Usage

Set the value to your [Azure region](https://azure.microsoft.com/en-gb/global-infrastructure/geographies/) of choice.

```hcl
  default_location = "uksouth"
```

> Tip: Changing this value will cause all location bound resources to be recreated

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"
[this_page]: # "Link for the current page."
