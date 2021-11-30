## Overview

[**default_tags**](#overview) `map(string)` (optional)

Set the default tags to apply to all resources created by the module, where supported. Please refer to the [Tag support for Azure resources][msdocs_azure_tag_support] documentation for more information on which resources support tags.

## Default value

`{}`

## Validation

None

## Usage

Create a custom tag block containing the tags of your choice.

```hcl
  default_tags = {
      myTagName = "MyTagValue"
  }
```

Tags must meet the supported [tagging limitations][msdocs_azure_tag_limitations] set by the platform.

Although not set by the `default_tags` input variable, the module will apply a set of base tags to all resources allowing you to easily identify that they were created by this module, including the module version as per the below example:

```hcl
{
   deployedBy = "terraform/azure/caf-enterprise-scale/{{module_version}}"
}
```

This helps you to easily identify which resources are managed by the module when working interactively with resources through the Portal, Azure Powershell, AZ CLI, or any other SDK.
Although we advise against this, this can be disabled by setting the input variable [`disable_base_module_tags = true`][disable_base_module_tags] in the module block.

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

[this_page]: # "Link for the current page."

[msdocs_azure_tag_support]:     https://docs.microsoft.com/azure/azure-resource-manager/management/tag-support "Tag support for Azure resources"
[msdocs_azure_tag_limitations]: https://docs.microsoft.com/azure/azure-resource-manager/management/tag-resources?tabs=json#limitations "Use tags to organize your Azure resources and management hierarchy #Limitations"

[disable_base_module_tags]: ./%5BVariables%5D-disable_base_module_tags "Instructions for how to use the disable_base_module_tags variable."
