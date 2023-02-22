<!-- markdownlint-disable first-line-h1 -->
## Overview

This page describes how to set custom parameter values for Policy Assignments created by the module.

By default, the module will create Policy Assignments with parameter values set to recommended defaults.
These defaults usually come from the `defaultValue` set within a Policy Definition.
For policies which require a parameter value to be specified (or where our recommended setting differs from the default), the module automatically sets the value based on various inputs to the module.
We refer to these as "managed Policy Assignments", and these typically cover scenarios where the output of a resource created by the module must be used as an input to a Policy Assignment.

An example of this is the `Deploy-MDFC-Config` Policy Assignment, which takes a number of parameter values from either user-specified inputs (e.g. `emailSecurityContact`) or from resources created by the module (e.g. `logAnalytics`).

Customers wanting to create additional or change existing Policy Assignment parameter values should consider the following options:

1. Setting a `defaultValue` for parameters within a Policy Definition template</br>[View Policy Definition templates included with the module](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/tree/main/modules/archetypes/lib/policy_definitions)
1. Setting a `value` for parameters within a Policy Assignment template</br>[View Policy Assignment templates included with the module](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/tree/main/modules/archetypes/lib/policy_assignments)
1. Setting parameter key/value pairs within an Archetype Definition template</br>[View Archetype Definition templates included with the module](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/tree/main/modules/archetypes/lib/archetype_definitions)
1. Setting parameter key/value pairs within the `archetype_config_overrides` or `custom_landing_zones` input variable

> **NOTE:** The module will set values based on the above options in order.
> As you move down the list, each of the above options will take precedence over the others.
> If you want to change one parameter value for a specific Policy Assignment, you must set all required values using the preferred option or the assignment will revert to the `defaultValue` specified within the Policy Definition template.
> If the parameter doesn't have a `defaultValue` within the Policy Definition and you don't provide a value, creation of the assignment will fail.
> This is particularly important to consider if changing the value of parameters for a "managed Policy Assignment".

Before overriding the parameters, you need to know three properties:

- Policy Assignment `name` to override (e.g. `Deny-Subnet-Without-Nsg`).
- The scope where the policy assignment is deployed. This could be either the `archetype_id` (e.g. `es_corp`, `es_landing_zones`, etc.) or the Management Group (e.g. `corp`, `landing-zones`, etc.).
- The parameter name(s) you would like to change (e.g. `effect` or `ACRPublicIpDenyEffect`) and their corresponding value(s).

The following sections provide examples showing how to update parameters using each of the available options.

### Option: Policy Definition template

Please refer to the Microsoft documentation for setting a `defaultValue` for [parameters](https://learn.microsoft.com/azure/governance/policy/concepts/definition-structure#parameters) within a Policy Definition template.

This approach can be used when adding new custom Policy Definitions to a custom `lib` folder, as specified by the [library_path](./%5BVariables%5D-library_path) input variable.

> **NOTE:** Whilst possible, we don't recommend using this approach if you want to set different values for custom Policy Definitions provided by the module.

### Option: Policy Assignment template

Please refer to the Microsoft documentation for setting a `value` for [parameters](https://learn.microsoft.com/azure/governance/policy/concepts/assignment-structure#parameters) within a Policy Assignment template.

This approach can be used when adding new custom Policy Assignments to a custom `lib` folder, as specified by the [library_path](./%5BVariables%5D-library_path) input variable.

> **NOTE:** Whilst possible, we don't recommend using this approach if you want to set different values for custom Policy Assignments provided by the module.

Parameter values set at this scope will override those set within a Policy Definition template.

### Option: Archetype definition template

When you create a custom archetype definition, you can set parameters within the `archetype_config.parameters` object.

Parameters are grouped by Policy Assignment `name`.

In the following example, you can see we define a custom archetype definition called `my_archetype`.
Within this archetype definition, we create a Policy Assignment for `Deny-Resource-Locations` and set a custom value for the parameter `listOfAllowedLocations`:

```json
{
  "my_archetype" : {
    "policy_assignments" : [
      "Deny-Resource-Locations"
    ],
    "policy_definitions" : [],
    "policy_set_definitions" : [],
    "role_definitions" : [],
    "archetype_config" : {
      "parameters" : {
        "Deny-Resource-Locations" : {
          "listOfAllowedLocations" : [
            "eastus",
            "eastus2",
            "westus",
            "northcentralus",
            "southcentralus"
          ]
        }
      },
      "access_control" : {}
    }
  }
}
```

> **NOTE:** The parameters must correspond to a Policy Assignment created at the same scope.
> This is why the example includes this policy in the `policy_assignments` list.

If you want to [expand an existing archetype](./%5BExamples%5D-Expand-Built-in-Archetype-Definitions#to-enable-the-extension-function), you can also use the same format.

In the following example we use the archetype extension approach to set the `effect` parameter for the `Deny-Subnet-Without-Nsg` Policy Assignment to `Audit` for the default `es_landing_zones` archetype definition:

```json
{
  "extend_es_landing_zones": {
    "policy_assignments": [],
    "policy_definitions": [],
    "policy_set_definitions": [],
    "role_definitions": [],
    "archetype_config": {
      "parameters": {
        "Deny-Subnet-Without-Nsg": {
          "effect": "Audit"
        }
      },
      "access_control": {}
    }
  }
}
```

Parameter values set at this scope will override those set within a Policy Definition template or Policy Assignment template.

### Option: `archetype_config_overrides` input variable

Parameters of Policy Assignments included with the module can be changed with the `archetype_config_overrides` input variable.

In this example, we will update parameters for the `Deny-Subnet-Without-Nsg` and `Deny-Public-Endpoints` Policy Assignments.

Let's say you would like to update the policy effects for those policies.
First, it's important to understand where the policy is assigned.
If the policy is assigned to landing zones, the `landing-zones` archetype needs to be overwritten.
When the policy is assigned to corp, the `corp`, archetype needs to be overwritten.

The following shows how you would do this using the `archetype_config_overrides` input variable:

```hcl
archetype_config_overrides = {
  landing-zones = {
    archetype_id = "es_landing_zones"
    parameters = {
      Deny-Subnet-Without-Nsg = {
        effect = "Audit"
      }
    }
    access_control = {}
  }
  corp = {
    archetype_id = "es_corp"
    parameters = {
      Deny-Public-Endpoints = {
        ACRPublicIpDenyEffect = "Audit"
      }
    }
    access_control = {}
  }
}
```

### Option: `custom_landing_zones` input variable

In case you define a `custom_landing_zones` block, you can update the parameters in the following way:

```hcl
custom_landing_zones = {
  "${var.root_id}-secure" = {
    display_name               = "Secure Workloads (HITRUST/HIPAA)"
    parent_management_group_id = "${var.root_id}-landing-zones"
    subscription_ids           = []
    archetype_config = {
      archetype_id = "customer_secure"
      parameters = {
        Deny-Resource-Locations = {
          listOfAllowedLocations = [
            "eastus",
            "westus",
          ]
        }
      }
    }
  }
}
```
