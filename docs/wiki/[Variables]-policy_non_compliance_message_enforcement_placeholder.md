<!-- markdownlint-disable first-line-h1 -->
## Overview

[**policy_non_compliance_message_enforcement_placeholder**](#overview) `string` (optional)

If specified, sets the placeholder that will be replaced inside the policy non-compliance message with the values of `policy_non_compliance_message_enforced_replacement` or `policy_non_compliance_message_not_enforced_replacement` based on the enforcement mode of the policy assignment.

## Default value

`"{enforcementMode}"`

## Validation

None

## Usage

```hcl
  policy_non_compliance_message_enforcement_placeholder = "{my_placeholder}"
```

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"
