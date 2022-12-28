# [v3.1.1] HOTFIX: Add missing parameter to `Deploy-ASC-SecurityContacts`

## Overview

The `v3.1.1` release includes an important update to the `Deploy-ASC-SecurityContacts` Policy Definition to enable successful remediation.

### New features

- Added missing `minimalSeverity` parameter to `Deploy-ASC-SecurityContacts` Policy Definition (with `"defaultValue" = "high"`)

### Fixed issues

- External issue [Azure/Enterprise-Scale/issues/1162](https://github.com/Azure/Enterprise-Scale/issues/1162) (Policy definition Deploy-ASC-SecurityContacts missing parameter minimalSeverity in template definition #1162)

### Breaking changes

n/a

### Input variable changes

none

## For more information

**Full Changelog**: [v3.1.0...v3.1.1](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/compare/v3.1.0...v3.1.1)
