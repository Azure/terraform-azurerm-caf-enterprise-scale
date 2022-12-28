<!-- markdownlint-disable first-line-h1 -->
## Overview

[**custom_policy_roles**](#overview) `map(list(string))` (optional)

If specified, the `custom_policy_roles` variable overrides which Role Definition ID(s) (value) to assign for Policy Assignments with a Managed Identity, if the assigned "policyDefinitionId" (key) is included in this variable.

This is useful in scenarios where a complex policy assignment results in many different role assignments being automatically created for the associated managed identity, but you want to replace them with a single role assignment.

## Default value

`{}`

## Validation

None

## Usage

In the following example, we replace the automatically generated roles `Contributor` and `Security Admin` for the `Deploy-MDFC-Config` policy assignment with just the `Contributor` role.

```hcl
  custom_policy_roles = {
    Deploy-MDFC-Config = [
      "Contributor",
    ]
  }
```

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"
