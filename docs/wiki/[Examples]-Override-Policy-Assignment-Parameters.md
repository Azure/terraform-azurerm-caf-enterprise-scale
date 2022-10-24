## Overview

This page describes how to override parameters of Policy Assignments.

On deployment, the module will auto-generate the parameters necessary for any Policy Assignment. Depending on how the policy assignment was applied, there are four ways to update the parameters:

- Within the archetype_config_overrides input variable
- Within an archetype definition
- Setting static parameter values within a policy assignment template (within the custom lib folder)
- Within the custom_landing_zones input variable

Before overriding the parameters, you need to know three properties:

- Policy Assignment name to override (e.g. Deny-Subnet-Without-Nsg). You can get this name from either the policy assignment in the Policy blade on the Azure Portal, or by looking in the [archetype definitions](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/blob/main/modules/archetypes/lib/archetype_definitions)
- The scope where the policy assignment is deployed (e.g. `corp` or `landing-zones`). You can find this information in the name of the file of the [archetype definitions](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/tree/e4019d8f8943cc341ba8fd13ba29c105d48031d1/modules/archetypes/lib/archetype_definitions)
- The parameter you would like to change (e.g. `effect` or `ACRPublicIpDenyEffect`). If you are changing the assignment of a policy set definition, you can find the parameter name in the definition file(https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/blob/main/modules/archetypes/lib/policy_set_definitions/policy_set_definition_es_deny_publicpaasendpoints.tmpl.json#L86)

### Within an archetype_config_overrides block

Parameters of built-in policies can be changed with the archectype definition. We will use the `Deny-Subnet-Without-Nsg` and `Deny-Public-Endpoints` policy assignments as an example. Let's say you would like to update the policy effects for those policies. First, it's important to understand where the policy is assigned. If the policy is assigned to landing zones, the `landing-zones` archetype needs to be overwritten. When the policy is assigned to corp, the `corp`, archetype needs to be overwritten like so:

```hcl
module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"

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
}
```

### Within an archetype definition

When you extend your archetype definitions, you can override parameters in the following way:

```` hcl
{
    "extend_es_root": {
        "policy_assignments": [],
        "policy_definitions": [],
        "policy_set_definitions": [],
        "role_definitions": [],
        "archetype_config": {
            "parameters": {
                "Deny-Resource-Locations": {
                    "listOfAllowedLocations": [
                        "eastus",
                        "eastus2",
                        "westus",
                        "northcentralus",
                        "southcentralus"
                    ]
                }
            },
            "access_control": {}
        }
    }
}

````

### Within a policy assignment template in the custom lib folder

If you extend your archetype by using a custom `/lib` directory, you can update the `Deny-Subnet-Without-Nsg` policy assignment in a similar way:

```` hcl
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
````

### Within the custom_landing_zones block

In case you define a `custom_landing_zones` block, you can update the parameters in the following way:

```` hcl
locals {
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
}
````