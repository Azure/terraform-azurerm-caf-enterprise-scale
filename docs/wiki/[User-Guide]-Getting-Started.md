## Considerations

Before getting started with this module, please take note of the following considerations:

1. This module requires a minimum `azurerm` provider version of `2.41.0`.

1. This module requires a minimum Terraform version `0.13.2`.

    > **NOTE:** New releases of the module may contain features which require the minimum supported versions to be increased, but changes will be clearly documented in the release notes, user guide, and readme.

1. This module has a single mandatory variable `root_parent_id` which is used to set the parent ID to use as the root for deployment. All other variables are optional but can be used to customise your deployment.

1. We recommend providing the `root_parent_id` value needed by the module using one of the following options:
    - Explicitly using an input variable in your root module, with the value specified via command-line using `-var 'root_parent_id={{ tenant_id }}'` or your preferred method of specifying variables at runtime.
    - Implicitly using the `azurerm_client_config` data resource in your root module to extract the `tenant_id` value from the current logged in user context (_see our [examples](./Examples)_).

      > **NOTE:** Using the `azurerm_subscription` data resource to provide a `tenant_id` value from the current context for `root_parent_id` should be avoided. This has been observed to generate a warning that Terraform cannot determine the number of resources to create during the `plan` stage. Terraform will ask to run `terraform apply -target=resource` against the `azurerm_subscription` data resource. This is due to the `root_parent_id` being used within the module to generate values which are used as `keys` within the `for-each` loops for resource creation. To avoid this error, please use one of the recommended methods above.

1. As of version `0.0.8` this module now supports the creation of Role Assignments for any valid Policy Assignment deployed using the module.
This feature enumerates the appropriate role(s) needed by the assigned Policy Definition or Policy Set Definition and creates the necessary Role Assignments for the auto-generated Managed Identity at the same scope as the Policy Assignment.
This capability provides feature parity with the Azure Portal experience when creating Policy Assignments using the `DeployIfNotExists` or `Modify` effects.
If the Policy Assignment needs to interact with resources not under the same scope as the Policy Assignment, you will need to create additional Role Assignments at the appropriate scope.

1. In release version `0.1.0` onwards, there are a number of major updates to policies and roles which should be considered before upgrading.
Please refer to the [upgrade guide][wiki_upgrade_from_v0_0_8_to_v0_1_0] for more information.

1. In release version `0.2.0` onwards, there are further updates to policies which should be considered before upgrading.
Please refer to the [upgrade guide][wiki_upgrade_from_v0_1_2_to_v0_2_0] for more information.

1. Release version `0.2.0` also adds new functionality to enable deployment of [Management and monitoring][ESLZ-Management] resources into the current Subscription context.
Please refer to the [Deploy Management Resources][wiki_deploy_management_resources] page on our Wiki for more information about how to use this. 

## Provisioning Instructions

Copy and paste the following 'module' block into your Terraform configuration, insert the required and optional [variables](%5BUser-Guide%5D-Module-Variables) needed for your configuration, and run `terraform init`:

```hcl
module "caf-enterprise-scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "0.2.0"
  # insert the 1 required variable here
}
```

For more detailed instructions, follow the [next steps](#next-steps) listed below or go straight to our [Examples](./Examples).

## Next steps

Learn how to use the [Module Variables](%5BUser-Guide%5D-Module-Variables) to customise the module configuration.


[wiki_upgrade_from_v0_0_8_to_v0_1_0]: https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Upgrade-from-v0.0.8-to-v0.1.0 "Wiki - Upgrade from v0.0.8 to v0.1.0"
[wiki_upgrade_from_v0_1_2_to_v0_2_0]: https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Upgrade-from-v0.1.2-to-v0.2.0 "Wiki - Upgrade from v0.1.2 to v0.2.0"
[wiki_deploy_management_resources]: https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Deploy-Management-Resources "Wiki - Deploy Management Resources"

[ESLZ-Management]: https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/enterprise-scale/management-and-monitoring
