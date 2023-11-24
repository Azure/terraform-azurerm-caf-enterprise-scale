<!-- markdownlint-disable first-line-h1 -->
## Overview

The `v5.0.0` release makes the following breaking changes:

1. Strict mode for subscription association is no longer default. This better aligns with subscription vending however please see explanatory notes below.

### Strict Mode for Subscription Association

Existing module users should explicitly set `strict_subscription_association` to `true` in their calling module to ensure that the module continues to behave as it does now:

```hcl
module "enterprise_scale" {
  source = "Azure/caf-enterprise-scale/azurerm"
  version = "5.0.0"
  # Other variables omitted for brevity...

  strict_subscription_association = true
}
```

For new users of the module we recommend that you leave `strict_subscription_association` set to its new default of `false`.

If you want to migrate from `true` (the old defaut) to `false` (the new default) then you will need to follow the steps below:

- Run terraform import for all the subscriptions associations managed by the module:

```bash
terraform import 'module.<YOUR_MODULE_REFERENCE>.azurerm_management_group_subscription_association.enterprise_scale["/providers/Microsoft.Management/managementGroups/<YOUR_MG>/subscriptions/<YOUR_SUBSCRIPTION_ID>"]' '/providers/Microsoft.Management/managementGroups/<YOUR_MG>/subscriptions/<YOUR_SUBSCRIPTION_ID>'
```

### Full list of changes

- docs: Fix documentation for recent policy updates by @jaredfholgate in <https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/pull/798>
- Update Library Templates (automated) by @cae-pr-creator in <https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/pull/799>
- Update ALZ Repo (Terraform) with Entra product names by @lachaves in <https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/pull/805>
- docs: fix policy enforcement override example by @jaredfholgate in <https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/pull/808>
- Bump actions/checkout from 3 to 4 by @dependabot in <https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/pull/807>
- Bump tibdex/github-app-token from 1 to 2 by @dependabot in <https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/pull/813>
- Add Routing Intent by @luke-taylor in <https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/pull/822>
- Add Italy North and avoid casing issues by @jaredfholgate in <https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/pull/834>
- Add support for user managed identity for policy assignments by @LaurentLesle in <https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/pull/806>
- fix: revert user-assigned managed identity by @matt-FFFFFF in <https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/pull/844>
- feat: strict subs no longer default by @matt-FFFFFF in <https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/pull/836>
- Update dynamic overrides section for in and not_in by @MISO-mgriffin in <https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/pull/840>
- fix: bug-vpn_client_config by @gogondi1 in <https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/pull/835>
- Update Library Templates (automated) by @cae-pr-creator in <https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/pull/827>
- Remove Basic SKU requirement on AzureFirewallManagementSubnet by @ryan-royals in <https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/pull/845>

## For more information

**Full Changelog**: [v4.2.0...v5.0.0](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/compare/v4.2.0...v5.0.0)

## Next steps

Take a look at the latest [User Guide](User-Guide) documentation and our [Examples](Examples) to understand the latest module configuration options, and review your implementation against the changes documented on this page.

## Need help?

If you're running into problems with the upgrade, please let us know via the [GitHub Issues](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues).
We will do our best to point you in the right direction.
