## Overview

This page describes how to override parameters of Policy Assignments.

On deployment, the module will auto-generate the parameters necessary for any Policy Assignment. Depending on how the policy assignment was applied, there are four ways to update the parameters:

- Within an archetype definition
- Setting static parameter values within a policy assignment template (within the custom lib folder)
- Within the archetype_config_overrides input variable
- Within the custom_landing_zones input variable

### Within an archetype definition

Parameters of built-in policies can be changed with the archectype definition. We will use the `Deny-Subnet-Without-Nsg` and `Deny-Public-Endpoints` policy assignments as an example. Let's say you would like to update the policy effects for those policies. First, it's important to understand where the policy is assigned. If the policy is assigned to landing zones, the `landing-zones` archetype needs to be overwritten. When the policy is assigned to corp, the `corp`, archetype needs to be overwritten like so:

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
