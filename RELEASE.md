# [v3.2.0] Title TBC

## Overview

The `v3.2.0` release includes ...

### New features

- Added the ability to set custom policy compliance messages on policy assignments. There are a number of new variables to control this behaviour and allow localisation. These start with `policy_compliance_message_`.

### Fixed issues

n/a

### Breaking changes

n/a

### Input variable changes

Added the following new input variables:
- `policy_compliance_message_default_enabled`: Specifies whether to apply the default compliance message if none is supplied by the policy assignment.
- `policy_compliance_message_default`: If enabled, specifies the default compliance message to use if none is supplied by the policy assignment.
- `policy_compliance_message_not_supported_definitions`: A list of GUIDs that specific built-in policy definitions that do not support compliance messages.

The following variables control the language used when a policy assignment is enforced or optional:
- `policy_compliance_message_enforced_placeholder`: The placeholder used within a string that is replaced by the enforced or optional replacement text specified in the relevant variable.
- `policy_compliance_message_enforced_replacement`: The text used for the placeholder when the policy assignment is enforced.
- `policy_compliance_message_not_enforced_replacement`: The text used for the placeholder when the policy assignment is not enforced and is optional.
