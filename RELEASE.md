# [v3.2.0] Title TBC

## Overview

The `v3.2.0` release includes ...

### New features

- Added new logic to merge parameters for policy assignments on a per-parameter basis, rather than per-assignment to simplify editing individual parameter values at different scopes.
- Updated the `description` field for the `vulnerabilityAssessmentsEmail` parameter on the `Deploy-Sql-vulnerabilityAssessments` policy definition to provide clearer guidance on how to specify multiple email addresses.
- Updated description for `archetype_config_overrides` input variable.
- Updated the `displayName` field for the `Deny-MachineLearning-PublicAccessWhenBehindVnet` policy definition (to correct spelling mistake).
- Added the ability to set custom policy compliance messages on policy assignments. There are a number of new variables to control this behaviour and allow localisation. These start with `policy_compliance_message_`. This feature is on by default. To turn this functionality off, you can specify `policy_non_compliance_message_enabled = false`.

### Fixed issues

- Fix [130](https://github.com/Azure/Enterprise-Scale/issues/130) (Deploy-Sql-vulnerabilityAssessments definition vulnerabilityAssessmentsEmail parameter type should be a list #130)
- Fix [573](https://github.com/Azure/Enterprise-Scale/issues/573) ("archetype_config_overrides" has no effect on management groups (module version 2.4.0) #573)
- Fix [607](https://github.com/Azure/Enterprise-Scale/issues/607) (Policy Assignment Deploy-Resource-Diag -> logAnalytics Subscription ID is 00000000-0000-0000-0000-00 0000000000 #607)

### Breaking changes

n/a

### Input variable changes

Added the following new input variables:

- `policy_non_compliance_message_enabled`: Specifies whether non-compliance are enabled. This defaults to true.
- `policy_non_compliance_message_default_enabled`: Specifies whether to apply the default non-compliance message if none is supplied by the policy assignment.
- `policy_non_compliance_message_default`: If enabled, specifies the default non-compliance message to use if none is supplied by the policy assignment.
- `policy_non_compliance_message_not_supported_definitions`: A list of GUIDs that specific built-in policy definitions that do not support non-compliance messages. Non-compliance messages are currently only supported for policy definitions with the mode `All` or `Indexed`. This is a fall back for versions of the `azurerm` provider <3.44.0. It will be removed in a future release.

The following variables control the language used when a policy assignment is enforced or optional:

- `policy_non_compliance_message_enforced_placeholder`: The placeholder used within a string that is replaced by the enforced or optional replacement text specified in the relevant variable.
- `policy_non_compliance_message_enforced_replacement`: The text used for the placeholder when the policy assignment is enforced.
- `policy_non_compliance_message_not_enforced_replacement`: The text used for the placeholder when the policy assignment is not enforced and is optional.

## For more information

**Full Changelog**: [v3.1.2...v3.2.0](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/compare/v3.1.2...v3.2.0)
