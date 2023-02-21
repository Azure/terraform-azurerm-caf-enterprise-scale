<!-- markdownlint-disable first-line-h1 -->
## Overview

[**policy_non_compliance_message_not_supported_definitions**](#overview) `bool` (optional)

If specified, provides a list of built in policy definitions that do not support non-compliance messages. Only policies with the mode of 'Indexed' or 'All' support non-compliance messages. Any assignments with these policies will not have the default non-compliance message applied.

## Default value

```hcl
[
    "/providers/Microsoft.Authorization/policyDefinitions/1c6e92c9-99f0-4e55-9cf2-0c234dc48f99",
    "/providers/Microsoft.Authorization/policyDefinitions/1a5b4dca-0b6f-4cf5-907c-56316bc1bf3d",
    "/providers/Microsoft.Authorization/policyDefinitions/95edb821-ddaf-4404-9732-666045e056b4"
]
```

## Validation

None

## Usage

```hcl
  policy_non_compliance_message_not_supported_definitions = [
    "/providers/Microsoft.Authorization/policyDefinitions/1c6e92c9-99f0-4e55-9cf2-0c234dc48f99",
    "/providers/Microsoft.Authorization/policyDefinitions/1a5b4dca-0b6f-4cf5-907c-56316bc1bf3d",
    "/providers/Microsoft.Authorization/policyDefinitions/95edb821-ddaf-4404-9732-666045e056b4"
  ]
```

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"
