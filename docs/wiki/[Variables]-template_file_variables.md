## Overview

[**template_file_variables**](#overview) `map(any)` (optional)

If specified, provides the ability to define custom template variables used when reading in template files from the built-in and custom library_path.

## Default value

`{}`

## Validation

None

## Usage

The module includes a set of built-in template file variables which are based on the following map object:

```hcl
  builtin_template_file_variables = {
    root_scope_id             = basename(local.root_id)
    root_scope_resource_id    = local.root_id
    current_scope_id          = basename(local.scope_id)
    current_scope_resource_id = local.scope_id
    default_location          = local.default_location
    location                  = local.default_location
    builtin                   = local.builtin_library_path
    builtin_library_path      = local.builtin_library_path
    custom                    = local.custom_library_path
    custom_library_path       = local.custom_library_path
  }
```

For any template file in the library, these values are used to substitute the template variable with the actual value when the file is loaded into the module.

The template variables available for use within the template files can be extended by setting the `template_file_variables` input variable in your module block, with a custom `map(string)` object value. As long as the key matches the variable used in the template, the value should be inserted during import.

To specify custom template variables, simply add the following input variable to the module block:

```hcl
  template_file_variables = {
    myCustomValue1 = "This is a custom template value"
    myCustomValue2 = "Must be a valid string value"
  }
```

As an example, if you had a simple template file like the following:

```json
{
    "myRootScopeId": "${root_scope_id}",
    "myRootScopeResourceId": "${root_scope_resource_id}",
    "myCustomValue1": "${myCustomValue1}",
    "myCustomValue2": "${myCustomValue3}"
}
```

And were to import this in a run where the `root_id` input variable was set to `"myTemplateDemo"`, the template function would convert it to the following during import:

```json
{
    "myRootScopeId": "myTemplateDemo",
    "myRootScopeResourceId": "/providers/Microsoft.Management/managementGroups/myTemplateDemo",
    "myCustomValue1": "This is a custom template value",
    "myCustomValue2": "Must be a valid string value"
}
```

> **NOTE:** We have intentionally ordered the `merge()` values to ensure `builtin_template_file_variables` values are applied in preference over any conflicting values provided in `template_file_variables`. This is to prevent unexpected module behaviour. Please ensure to use unique template variable names to avoid unexpected results.

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

[this_page]: # "Link for the current page."
