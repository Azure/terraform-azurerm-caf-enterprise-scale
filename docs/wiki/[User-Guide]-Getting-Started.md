## Initial considerations

Before getting started with this module, please take note of the following considerations:

1. This module requires a minimum `azurerm` provider version of `2.77.0`.

1. This module requires a minimum Terraform version `0.15.0`.

    > **NOTE:** New releases of the module may contain features which require the minimum supported versions to be increased, but changes will be clearly documented in the release notes, user guide, and readme.

1. This module has a single mandatory variable `root_parent_id` which is used to set the parent ID to use as the root for deployment. All other variables are optional but can be used to customize your deployment.

1. We recommend providing the `root_parent_id` value needed by the module using one of the following options:
    - Explicitly using an input variable in your root module, with the value specified via command-line using `-var 'root_parent_id={{ tenant_id }}'` or your preferred method of specifying variables at runtime.
    - Implicitly using the `azurerm_client_config` data resource in your root module to extract the `tenant_id` value from the current logged in user context (_see our [examples](./Examples)_).

      > **NOTE:** Using the `azurerm_subscription` data resource to provide a `tenant_id` value from the current context for `root_parent_id` should be avoided. This has been observed to generate a warning that Terraform cannot determine the number of resources to create during the `plan` stage.
      > Terraform will ask to run `terraform apply -target=resource` against the `azurerm_subscription` data resource. This is due to the `root_parent_id` being used within the module to generate values which are used as `keys` within the `for-each` loops for resource creation. To avoid this error, please use one of the recommended methods above.

1. As of version `0.0.8` this module now supports the creation of Role Assignments for any valid Policy Assignment deployed using the module.
This feature enumerates the appropriate role(s) needed by the assigned Policy Definition or Policy Set Definition and creates the necessary Role Assignments for the auto-generated Managed Identity at the same scope as the Policy Assignment.
This capability provides feature parity with the Azure Portal experience when creating Policy Assignments using the `DeployIfNotExists` or `Modify` effects.
If the Policy Assignment needs to interact with resources not under the same scope as the Policy Assignment, you will need to create additional Role Assignments at the appropriate scope.

1. In release version `0.1.0` onwards, there are a number of major updates to policies and roles which should be considered before upgrading.
Please refer to the [upgrade guide][wiki_upgrade_from_v0_0_8_to_v0_1_0] for more information.

1. In release version `0.2.0` onwards, there are further updates to policies which should be considered before upgrading.
Please refer to the [upgrade guide][wiki_upgrade_from_v0_1_2_to_v0_2_0] for more information.

1. Release version `0.2.0` also adds new functionality to enable deployment of [Management and monitoring][ESLZ-Management] resources into the current Subscription context.
Please refer to the [Deploy Management Resources][wiki_management_resources] page on our Wiki for more information about how to use this.

1. The `v0.3.0` release focuses mainly on updating the test framework, but also introduces a breaking change which removes the need (and support for) wrapping user-defined parameters in `jsonencode()`.
When upgrading to this release, please ensure to update your code to use native HCL values as documented in the [release notes](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/releases/tag/v0.3.0).

1. In release version `0.4.0` onwards, we have added significant new functionality to support deployment of [Identity][wiki_identity_resources] and [Connectivity][wiki_connectivity_resources] resources directly into the specified Subscriptions.
There are also updates to policies which should be considered before upgrading.
Please refer to the [upgrade guide][wiki_upgrade_from_v0_3_3_to_v0_4_0] for more information.

## Additional considerations when deploying Landing Zone resources with Terraform

Although you may be considering managing your platform using this Terraform module, Enterprise-scale is not prescriptive on which deployment method is used for deploying resources inside Landing Zone Subscriptions.
For example, application teams could use Bicep, ARM templates, or Terraform to deploy resources within their own subscriptions.
However, when application teams choose to deploy resources with Terraform, the following additional considerations apply:

1. `Deny-Subnet-Without-NSG` Policy Assignment

    The reference architecture assigns the this policy to the `Landing Zones` management group.
    In the event that a landing zone subscription is managed by Terraform, this policy will prevent Terraform from deploying `azurerm_subnet` resources due to the way that the Azure Terraform provider interacts with the Azure network resource provider.

    > One remediation is to override the policy assignment and change the policy effect from `deny` to `audit`.

1. Use of `DeployIfNotExists` and `Modify` Policy Effects

    Terraform expects to be authoritative over the resources that it manages.
    Any changes to the managed properties of Terraform managed resources in Azure will be rectified by Terraform during the next plan/apply cycle.

    The reference architecture uses Azure policy with `DeployIfNotExists` and `modify` effects that can modify properties of the Terraform managed resources.

    The combination of `DeployIfNotExists`/`modify` policy and Terraform can result in a loop, with resources being continuously remediated by Azure Policy, then reverted by Terraform, then again remediated by Policy.

    Create guidance for landing zone owners so that they understand the effects of these policies and can deploy resources in a compliant manner.

    > Notable exceptions to this are `DeployIfNotExists` policies that do not modify the in-scope resource. For example: Policies that deploy diagnostic settings.

## Provisioning instructions

Copy and paste the following 'module' block into your Terraform configuration, insert the required and optional [variables](%5BUser-Guide%5D-Module-Variables) needed for your configuration, and run `terraform init`:

```hcl
module "caf-enterprise-scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "1.1.0"

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm
    azurerm.management   = azurerm
  }

  # insert the 1 required variable here
}
```

For more detailed instructions, follow the [next steps](#next-steps) listed below or go straight to our [Examples](./Examples).

## Next steps

Learn how to use the [Module Variables](%5BUser-Guide%5D-Module-Variables) to customize the module configuration.

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

[ESLZ-Management]: https://docs.microsoft.com/azure/cloud-adoption-framework/ready/enterprise-scale/management-and-monitoring

[wiki_management_resources]:                  ./%5BUser-Guide%5D-Management-Resources "Wiki - Management Resources"
[wiki_connectivity_resources]:                ./%5BUser-Guide%5D-Connectivity-Resources "Wiki - Connectivity Resources"
[wiki_identity_resources]:                    ./%5BUser-Guide%5D-Identity-Resources "Wiki - Identity Resources"
[wiki_upgrade_from_v0_0_8_to_v0_1_0]:         ./%5BUser-Guide%5D-Upgrade-from-v0.0.8-to-v0.1.0 "Wiki - Upgrade from v0.0.8 to v0.1.0"
[wiki_upgrade_from_v0_1_2_to_v0_2_0]:         ./%5BUser-Guide%5D-Upgrade-from-v0.1.2-to-v0.2.0 "Wiki - Upgrade from v0.1.2 to v0.2.0"
[wiki_upgrade_from_v0_3_3_to_v0_4_0]:         ./%5BUser-Guide%5D-Upgrade-from-v0.3.3-to-v0.4.0 "Wiki - Upgrade from v0.3.3 to v0.4.0"
