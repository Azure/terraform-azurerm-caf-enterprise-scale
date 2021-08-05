## Overview

[**library_path**](#overview) `string` (optional)

If specified, sets the path to a custom library folder for archetype artifacts.

## Default value

`""`

## Validation

None

## Usage

Set the path to a custom directory within your root module.

```hcl
  library_path = "${path.root}/lib"
```

> Important: Please ensure you create the `/lib` directory first within your root module. You can use this custom directory to store all your custom archetype definition templates.

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

[this_page]: # "Link for the current page."
