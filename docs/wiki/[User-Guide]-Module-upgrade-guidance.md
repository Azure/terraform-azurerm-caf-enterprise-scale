<!-- markdownlint-disable first-line-h1 -->
## Staying up to date

Deploying the latest version of the module is the recommended approach for staying up to date with the latest architectural changes to Azure landing zones.
Looking at it from a governance perspective, this also ensures you have the latest recommended policies applied to your environment for improved compliance.

With each [release of the module][wiki_module_releases], it's possible that your environment will change.
We will do our best to ensure any changes are clearly documented in the release notes, or upgrade guides when publishing a new major version.
To avoid unexpected or unwanted changes we recommend that you configure your [version constraints][version_constraints] to pin to a specific module version.

To do this, you would use the following version constraint syntax:

```terraform
module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "<version>" # change this to your desired version, https://www.terraform.io/language/expressions/version-constraints

  # Insert provider block and input variables here
}
```

> **NOTE:** This is the format we use in all of our documentation.

To allow automatic upgrades to the latest patch release, use the following version constraint syntax:

```terraform
module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "~> 3.1.2"

  # Insert provider block and input variables here
}
```

This should ensure you receive the latest fixes for the module, reducing the risk of unexpected behavior.

> **NOTE:** To reduce the risk of failed plans, we do not recommend using a less restrictive version constraint when deploying using CI/CD pipelines.

When planning an upgrade, please take care to review both the [release notes][module_releases] and [upgrade guides](#upgrade-guides) where applicable.

As a general rule, we will only document an upgrade guide when publishing a new major release, and this will be written on the assumption that you plan to upgrade from the most recent version of the previous release, to the first new release.
For example, from release `v1.1.4` to release `v2.0.0`.
If jumping multiple release versions, take care to note additional changes documented in the [release notes][module_releases] of all iterative releases.

## Upgrade guides

Please refer to the following upgrade guides when updating between major release:

- [Upgrade from v5.2.1 to v6.0.0][wiki_upgrade_from_v5_2_1_to_v6_0_0]
- [Upgrade from v5.1.0 to v5.2.0][wiki_upgrade_from_v5_1_0_to_v5_2_0]
- [Upgrade from v4.2.0 to v5.0.0][wiki_upgrade_from_v4_2_0_to_v5_0_0]
- [Upgrade from v3.3.0 to v4.0.0][wiki_upgrade_from_v3_3_0_to_v4_0_0]
- [Upgrade from v2.4.1 to v3.0.0][wiki_upgrade_from_v2_4_1_to_v3_0_0]
- [Upgrade from v1.1.4 to v2.0.0][wiki_upgrade_from_v1_1_4_to_v2_0_0]
- [Upgrade from v0.4.0 to v1.0.0][wiki_upgrade_from_v0_4_0_to_v1_0_0]
- [Upgrade from v0.3.3 to v0.4.0][wiki_upgrade_from_v0_3_3_to_v0_4_0]
- [Upgrade from v0.1.2 to v0.2.0][wiki_upgrade_from_v0_1_2_to_v0_2_0]
- [Upgrade from v0.0.8 to v0.1.0][wiki_upgrade_from_v0_0_8_to_v0_1_0]

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

[version_constraints]: https://www.terraform.io/language/modules/syntax#version "Terraform - Version Constraints"
[module_releases]:     https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/releases "Releases - Azure/terraform-azurerm-caf-enterprise-scale"

[wiki_module_releases]:               %5BUser-Guide%5D-Module-Releases "Wiki - [User Guide] Module Releases"
[wiki_upgrade_from_v5_2_1_to_v6_0_0]: %5BUser-Guide%5D-Upgrade-from-v5.2.1-to-v6.0.0 "Wiki - Upgrade from v5.2.1 to v6.0.0"
[wiki_upgrade_from_v5_1_0_to_v5_2_0]: %5BUser-Guide%5D-Upgrade-from-v5.1.0-to-v5.2.0 "Wiki - Upgrade from v5.1.0 to v5.2.0"
[wiki_upgrade_from_v4_2_0_to_v5_0_0]: %5BUser-Guide%5D-Upgrade-from-v4.2.0-to-v5.0.0 "Wiki - Upgrade from v4.2.0 to v5.0.0"
[wiki_upgrade_from_v3_3_0_to_v4_0_0]: %5BUser-Guide%5D-Upgrade-from-v3.3.0-to-v4.0.0 "Wiki - Upgrade from v3.3.0 to v4.0.0"
[wiki_upgrade_from_v2_4_1_to_v3_0_0]: %5BUser-Guide%5D-Upgrade-from-v2.4.1-to-v3.0.0 "Wiki - Upgrade from v2.4.1 to v3.0.0"
[wiki_upgrade_from_v1_1_4_to_v2_0_0]: %5BUser-Guide%5D-Upgrade-from-v1.1.4-to-v2.0.0 "Wiki - Upgrade from v1.1.4 to v2.0.0"
[wiki_upgrade_from_v0_4_0_to_v1_0_0]: %5BUser-Guide%5D-Upgrade-from-v0.4.0-to-v1.0.0 "Wiki - Upgrade from v0.4.0 to v1.0.0"
[wiki_upgrade_from_v0_3_3_to_v0_4_0]: %5BUser-Guide%5D-Upgrade-from-v0.3.3-to-v0.4.0 "Wiki - Upgrade from v0.3.3 to v0.4.0"
[wiki_upgrade_from_v0_1_2_to_v0_2_0]: %5BUser-Guide%5D-Upgrade-from-v0.1.2-to-v0.2.0 "Wiki - Upgrade from v0.1.2 to v0.2.0"
[wiki_upgrade_from_v0_0_8_to_v0_1_0]: %5BUser-Guide%5D-Upgrade-from-v0.0.8-to-v0.1.0 "Wiki - Upgrade from v0.0.8 to v0.1.0"
