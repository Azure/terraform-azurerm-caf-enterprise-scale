# [v4.1.0] Policy Enforcement

## Overview

The `v4.1.0` release includes ...

### New features

There are no new features, this is a bug fix release.

### Fixed issues

- [762](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/pull/762) - Fix archetype config overrides bug
- [756](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/pull/760) - Fix SQL Auditing policy parameter casing issue.
- [722](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/pull/772) - Fix upstream policy enforcement mode sync.

### Breaking changes

- The [722](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/pull/772) bug fix changes the default enforcement mode for policies that previously were incorrectly not enforced. This may impact the existing behaviour of your landing zone policies, so please examine the changes to enformcements before you apply this version of the module.
- Bug [758](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/758) this fix means that we have standardized on the map keys for `archetype_config_overrides`. Now use the keys displayed in the variable documentation, not the names of your management groups.
