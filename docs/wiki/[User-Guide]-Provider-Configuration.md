As of release `v0.4.0`, the [Terraform Module for Cloud Adoption Framework Enterprise-scale][terraform-registry-caf-enterprise-scale] now uses multiple provider aliases to allow resources to be deployed directly to the intended Subscription, without the need to specify multiple instances of the module.

This change is intended to simplify deployments using a single pipeline to create all resources, as it is no longer necessary to share the configuration inputs across multiple instances of the module to achieve consistency between the resources created, and associated policies.

The module utilises 3 providers in total:

| Resource category | Provider |
| ----------------- | -------- |
| [Core][wiki_core_resources]                 | `azurerm` *(default)*  |
| [Connectivity][wiki_connectivity_resources] | `azurerm.connectivity` |
| [Management][wiki_management_resources]     | `azurerm.management`   |
| [Identity][wiki_identity_resources]         | *n/a (no resources)*   |

Regardless of how you plan to use the module, you must map your provider(s) to the module providers. Failure to do so will result in one or both of the following error when running `terraform init`:

```shell
╷
│ Error: No configuration for provider azurerm.connectivity
│
│   on main.tf line 13:
│   13: module "enterprise_scale" {
│
│ Configuration required for module.enterprise_scale.provider["registry.terraform.io/hashicorp/azurerm"].connectivity.
│ Add a provider named azurerm.connectivity to the providers map for module.enterprise_scale in the root module.
╵

╷
│ Error: No configuration for provider azurerm.management
│
│   on main.tf line 13:
│   13: module "enterprise_scale" {
│
│ Configuration required for module.enterprise_scale.provider["registry.terraform.io/hashicorp/azurerm"].management.
│ Add a provider named azurerm.management to the providers map for module.enterprise_scale in the root module.
╵
```

The following section covers typical configuration scenarios.

## Provider configuration examples

### Single Subscription deployment

The following example shows how you can map a single (default) provider from the root module using the providers object:

```hcl
module "caf-enterprise-scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "0.4.0"

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm
    azurerm.management   = azurerm
  }

  # insert the required input variables here
}
```

For more detailed instructions, follow the [next steps](#next-steps) listed below or go straight to our [Examples](./Examples).

## Next steps

Learn how to use the [Module Variables](%5BUser-Guide%5D-Module-Variables) to customise the module configuration.

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

[terraform-registry-caf-enterprise-scale]: https://registry.terraform.io/modules/Azure/caf-enterprise-scale/azurerm/latest "Terraform Registry: Terraform Module for Cloud Adoption Framework Enterprise-scale"

[wiki_core_resources]:                        ./%5BUser-Guide%5D-Core-Resources "Wiki - Core Resources"
[wiki_management_resources]:                  ./%5BUser-Guide%5D-Management-Resources "Wiki - Management Resources"
[wiki_connectivity_resources]:                ./%5BUser-Guide%5D-Connectivity-Resources "Wiki - Connectivity Resources"
[wiki_identity_resources]:                    ./%5BUser-Guide%5D-Identity-Resources "Wiki - Identity Resources"
