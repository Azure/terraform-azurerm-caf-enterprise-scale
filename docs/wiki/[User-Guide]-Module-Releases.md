<!-- markdownlint-disable first-line-h1 -->
## Release strategy

The Azure landing zones Terraform module is designed to be published and consumed through the Terraform Registry.
This approach allows us to release updates in a controlled manner, helping customers to manage change effectively.

This also allows customers to implement recommended practices for consuming modules using [versioning][module_versions], mitigating the risk of unexpected or unwanted changes.

Releases are tagged based on [Semantic Versioning 2.0.0][sem_ver_2] and release notes will always outline the changes being introduced.
In most cases, we will include the following information:

- What's changed?
- New features
- Fixed issues
- Breaking changes

Whilst we try to follow the published [Semantic Versioning 2.0.0][sem_ver_2] guidelines, module releases are typically versioned according to the following:

### Major releases

Major versions are typically used when one or more of the following is true:

- Adding significant functionality to the module (such as the addition of the Virtual WAN capability in release [v2.0.0][release_v2_0_0])
- A significant change is needed to the customer code which requires careful consideration before being able to successfully run `terraform plan`
- Existing resources will be recreated with direct customer impact (such as redeployment of networking resources)
- Changes to `default` values which would result in unexpected changes to deployed resources
- Addition of new input variables without a `default` value

> **NOTE:** When publishing major releases we will always provide a detailed upgrade guide to help with the upgrade experience.

### Minor releases

Minor versions are typically used when one or more of the following is true:

- New resources will be automatically added to the customer environment without impacting existing resources managed by the module (such as addition of the new Log Analytics solutions in release [v2.1.0][release_v2_1_0])
- New resources will be added to the customer environment, but only if a new (optional) setting is explicitly enabled
- A new feature is being enabled which is configured through new input variables
- Addition of new input variables with a `default` value
- Existing resources will be recreated without direct customer impact (such as redeployment of Azure Policy resources, or Roles)
- Minor updates will be needed for customer code before being able to successfully run `terraform plan`, such as simple edits to one or more input variables
- Updates to policies which impact Policy Assignments (resulting in potential loss of compliance history)

### Patch releases

Patch versions are typically used when one or more of the following is true:

- A bugfix is being released to fix incorrect behavior in the module without the need for updates to customer code
- Updates to policies which do not impact Policy Assignments (no loss of compliance history)

## Next steps

Review our [Module upgrade guidance][wiki_module_upgrade_guidance] for more information on how to stay up to date.

 [//]: # (************************)
 [//]: # (INSERT LINK LABELS BELOW)
 [//]: # (************************)

[module_versions]: https://www.terraform.io/language/modules/syntax#version "Terraform - Module Versions"
[sem_ver_2]:       https://semver.org/ "Overview of Semantic Versioning 2.0.0"
[release_v2_0_0]:  https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/releases/tag/v2.0.0 "Release notes for v2.0.0 of the Azure landing zones Terraform module"
[release_v2_1_0]:  https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/releases/tag/v2.1.0 "Release notes for v2.1.0 of the Azure landing zones Terraform module"

[wiki_module_upgrade_guidance]: %5BUser-Guide%5D-Module-upgrade-guidance "Wiki - Module upgrade guidance"
