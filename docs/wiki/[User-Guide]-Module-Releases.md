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

## Staying up to date (Evergreen)

Deploying the latest version of the module is the recommended approach for staying up to date with the latest architectural changes to Azure landing zones.
Looking at it from a governance perspective, this also ensures you have the latest recommended policies applied to your environment for improved compliance.

With each release of the module, it's possible that your environment will change.
We will do our best to ensure any changes are clearly documented in the release notes, or upgrade guides when publishing a new major version.
To avoid unexpected or unwanted changes we recommend that you configure your [version constraints][version_constraints] to pin to a specific module version.

To do this, you would use the following version constraint syntax:

```terraform
module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "2.4.1"

  # Insert provider block and input variables here
}
```

> **NOTE:** This is the format we use in all of our documentation.

To allow automatic upgrades to the latest patch release, use the following version constraint syntax:

```terraform
module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "~> 2.4.1"

  # Insert provider block and input variables here
}
```

This should ensure you receive the latest fixes for the module, reducing the risk of unexpected behavior.

> **NOTE:** To reduce the risk of failed plans, we do not recommend using a less restrictive version constraint when deploying using CI/CD pipelines.

 [//]: # (************************)
 [//]: # (INSERT LINK LABELS BELOW)
 [//]: # (************************)

[module_versions]:     https://www.terraform.io/language/modules/syntax#version "Terraform - Module Versions"
[version_constraints]: https://www.terraform.io/language/modules/syntax#version "Terraform - Version Constraints"
[sem_ver_2]:           https://semver.org/ "Overview of Semantic Versioning 2.0.0"
[release_v2_0_0]:      https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/releases/tag/v2.0.0 "Release notes for v2.0.0 of the Azure landing zones Terraform module"
[release_v2_1_0]:      https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/releases/tag/v2.1.0 "Release notes for v2.1.0 of the Azure landing zones Terraform module"
