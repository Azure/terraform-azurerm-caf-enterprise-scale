# [v3.2.0] Title TBC

## Overview

The `v3.2.0` release includes ...

### New features

- Added new logic to merge parameters for policy assignments on a per-parameter basis, rather than per-assignment to simplify editing individual parameter values at different scopes.
- Updated the `description` field for the `vulnerabilityAssessmentsEmail` parameter on the `Deploy-Sql-vulnerabilityAssessments` policy definition to provide clearer guidance on how to specify multiple email addresses.
- Updated description for `archetype_config_overrides` input variable.
- Updated the `displayName` field for the `Deny-MachineLearning-PublicAccessWhenBehindVnet` policy definition (to correct spelling mistake).

### Fixed issues

- Fix [130](https://github.com/Azure/Enterprise-Scale/issues/130) (Deploy-Sql-vulnerabilityAssessments definition vulnerabilityAssessmentsEmail parameter type should be a list #130)
- Fix [573](https://github.com/Azure/Enterprise-Scale/issues/573) ("archetype_config_overrides" has no effect on management groups (module version 2.4.0) #573)
- Fix [607](https://github.com/Azure/Enterprise-Scale/issues/607) (Policy Assignment Deploy-Resource-Diag -> logAnalytics Subscription ID is 00000000-0000-0000-0000-00 0000000000 #607)

### Breaking changes

n/a

### Input variable changes

none

## For more information

**Full Changelog**: [v3.1.2...v3.2.0](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/compare/v3.1.2...v3.2.0)
