<!-- markdownlint-disable first-line-h1 -->
## Overview

[**template_file_variables**](#overview) `any` (optional)

If specified, provides the ability to define custom template variables used when reading in template files from the built-in and custom library_path.

## Default value

`{}`

## Validation

None

## Usage

The module includes a set of built-in template file variables covering the following:

| Source module | Variable name | Example value | Description |
| --- | --- | --- | --- |
| archetype | `root_scope_id` | `myorg` | The scope ID associated with the intermediate root archetype. |
| archetype | `root_scope_resource_id` | `/providers/Microsoft.Management/managementGroups/myorg` | The scope resource ID associated with the intermediate root archetype. |
| archetype | `current_scope_id` | `myorg-managagement` | The scope ID associated with the current archetype being processed. |
| archetype | `current_scope_resource_id` | `/providers/Microsoft.Management/managementGroups/myorg-managagement` | The scope resource ID associated with the current archetype being processed. |
| archetype | `default_location` | `eastus` | Default location used for resources created by the module (when not overridden). |
| archetype | `location` | `eastus` | Default location used for resources created by the module (when not overridden). |
| archetype | `builtin` | `/mymodule/.terraform/modules/enterprise_scale/modules/archetypes/lib` | Folder path for the built-in library. |
| archetype | `builtin_library_path` | `/mymodule/.terraform/modules/enterprise_scale/modules/archetypes/lib` | Folder path for the built-in library. |
| archetype | `custom` | `/mymodule/lib` | Folder path for the custom library. |
| archetype | `custom_library_path` | `/mymodule/lib` | Folder path for the custom library. |
| connectivity | `ddos_protection_plan_resource_id` | `/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myorg-ddos/providers/Microsoft.Network/ddosProtectionPlans/myorg-ddos-westus` | Resource ID for the DDoS protection plan created by the module. |
| connectivity | `private_dns_zone_prefix` | `/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myorg-dns/providers/Microsoft.Network/privateDnsZones/` | Resource ID suffix used for all azurerm_private_dns_zone resources created by the module under the scope of connectivity resources. |
| connectivity | `connectivity_location` | `westus` | Location set for the connectivity resources. |
| connectivity | `virtual_network_resource_id_by_location` | `{ westus = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myorg-connectivity-westus/providers/Microsoft.Network/virtualNetworks/myorg-hub-northeurope" }` | Map of Resource IDs by location for virtual network resources created by the module. |
| connectivity | `vpn_gateway_resource_id_by_location` | `{ westus = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myorg-connectivity-westus/providers/Microsoft.Network/virtualNetworkGateways/myorg-vpngw-northeurope" }` | Map of Resource IDs by location for VPN gateway resources created by the module. |
| connectivity | `firewall_resource_id_by_location` | `{ westus = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myorg-connectivity-westus/providers/Microsoft.Network/azureFirewalls/myorg-fw-northeurope" }` | Map of Resource IDs by location for Azure Firewall resources created by the module. |
| management | `log_analytics_workspace_resource_id` | `/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myorg-mgmt/providers/Microsoft.OperationalInsights/workspaces/myorg-la` | Resource ID for the Log Analytics workspace created by the module. |
| management | `log_analytics_workspace_name` | `myorg-la` | Name for the Log Analytics workspace created by the module.
| management | `log_analytics_workspace_location` | `northeurope` | Location for the Log Analytics workspace created by the module. |
| management | `automation_account_resource_id` | `/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myorg-mgmt/providers/Microsoft.Automation/automationAccounts/myorg-automation` | Resource ID for the Automation Account created by the module. |
| management | `automation_account_name` | `myorg-automation` | Name for the Automation Account created by the module.
| management | `automation_account_location` | `northeurope` | Location for the Automation Account created by the module. |
| management | `management_location` | `northeurope` | Location set for the management resources. |
| management | `management_resource_group_name` | `myorg-mgmt` | Name of the Resource Group deployed by the module for management resources. |
| management | `data_retention` | `30` | Retention period (in days) used when configuring the Log Analytics workstation and associated policies. |

For any template file in the library, these values are used to substitute the template variable with the actual value when the file is loaded into the module.

The template variables available for use within the template files can be extended by setting the `template_file_variables` input variable in your module block, with a custom `map` object.
As long as the key matches the variable used in the template, the value should be inserted during import.

To specify custom template variables, simply add the following input variable to the module block:

```hcl
  template_file_variables = {
    myCustomValue1 = "This is a custom template value"
    myCustomValue2 = "This is another template value"
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
    "myCustomValue2": "This is another template value"
}
```

> **NOTE:** We have intentionally ordered the `merge()` values to ensure `core_template_file_variables` values and those from the child modules are applied in preference over any conflicting values provided in `template_file_variables`.
This is to prevent unexpected module behavior. Please ensure to use unique template variable names to avoid unexpected results.

Please refer to the Terraform documentation for more information on using the [`templatefile()`][terraform_templatefile] function.

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

[this_page]: # "Link for the current page."
[terraform_templatefile]: https://www.terraform.io/language/functions/templatefile "Terraform templatefile() function documentation."
