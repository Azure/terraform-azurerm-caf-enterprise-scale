# AZURERM Enterprise-scale Landing Zones

## Create Enterprise-scale Landing Zones

This module provides an opinionated approach for delivering the core platform capabilities of Enterprise-scale Landing Zones using Terraform, based on the architecture published in the [Cloud Adoption Framework enterprise-scale landing zone architecture][ESLZ-Architecture]:

![Enterprise-scale Landing Zone Architecture][ESLZ-Architecture-Diagram]

Specifically, this module provides a consistent approach for deploying the following core platform components:

- Management Group and Subscription organisation
  - Create the Management Group hierarchy
  - Assign Subscriptions to Management Groups
  - Create custom Policy Definitions, Policy Set Definitions (Initiatives), and Policy Assignments (Enterprise-scale policies and customer-defined policies)
- Identity and access management
  - Create custom Role Definitions, and Role Assignments (Enterprise-scale policies and customer-defined roles)

The following resource types are deployed and managed by this module:

| Azure Resource | Terraform Resource |
| -------------- | ------------------ |
| [Management Groups][arm_management_group]           | [`azurerm_management_group`][azurerm_management_group] |
| [Policy Assignments][arm_policy_assignment]         | [`azurerm_policy_assignment`][azurerm_policy_assignment] |
| [Policy Definitions][arm_policy_definition]         | [`azurerm_policy_definition`][azurerm_policy_definition] |
| [Policy Set Definitions][arm_policy_set_definition] | [`azurerm_policy_set_definition`][azurerm_policy_set_definition] |
| [Role Assignments ][arm_role_assignment]            | [`azurerm_role_assignment`][azurerm_role_assignment] |
| [Role Definitions ][arm_role_definition]            | [`azurerm_role_definition`][azurerm_role_definition] |

The concept of ***archetypes*** is used to define configuration settings for each ***Management Group*** using a template-driven approach. This approach is designed to make reading the high-level configuration settings easier, simplify the process of managing configuration and versioning, reduce code duplication (DRY), and to improve consistency in complex environments. An archetype is defined using a simple JSON structure (as below) and should define which policy and role settings should be deployed. This is associated to the scope (Management Group) as part of the ***Landing Zone*** definitions.

**Example archetype definition structure**
```json
{
    "archetype_id": {
        "policy_assignments": [],
        "policy_definitions": [],
        "policy_set_definitions": [],
        "role_assignments": [],
        "role_definitions": []
    }
}
```

The module contains a default library of templates for the official Enterprise-scale Archetype Definitions, Policy Assignments, Policy Definitions, Policy Set Definitions, Role Assignments, and Role Definitions. These can be overridden using a custom library, details of which are provided under the usage section of this README.

## Usage in Terraform 0.13

To use this module with all default settings, please include the following in your root module:

> **Module usage notes:**
>
> 1. Please note, this module requires a minimum `azurerm` provider version of `2.29.0` to support correct operation with Policy Set Definitions. We also recommend using Terraform version `0.13.3` or greater.
>
> 2. This module has a single mandatory variable `es_root_parent_id` which is used to set the parent ID to use as the root for deployment. All other variables are optional but can be used to customise your deployment.
>
> 3. If using the `azurerm_subscription` data source to provide a `tenant_id` value from the current context for `es_root_parent_id`, you are likely to get a warning that Terraform cannot determine the number of resources to create during the `plan` stage. To avoid the need to use `terraform apply -target=resource` or putting such values in source code, we recommend providing the `es_root_parent_id` value explicitly via the command-line using `-var 'es_root_parent_id={{ tenant_id }}'` or your preferred method of injecting variable values at runtime.

```hcl
provider "azurerm" {
  version = ">= 2.29.0"
  features {}
}

variable "tenant_id" {
  type        = string
  description = "The tenant_id is used to set the es_root_parent_id value for the enterprise_scale module."
}

module "enterprise_scale" {
  source = "https://github.com/Azure/terraform-azurerm-enterprise-scale.git"

  es_root_parent_id = var.tenant_id

}
```

To customise the module, you can add any of the following optional variables:

```hcl
provider "azurerm" {
  version = ">= 2.29.0"
  features {}
}

variable "tenant_id" {
  type        = string
  description = "The tenant_id is used to set the es_root_parent_id value for the enterprise_scale module."
}

module "enterprise_scale" {
  source = "https://github.com/Azure/terraform-azurerm-enterprise-scale.git"

  es_root_parent_id            = var.tenant_id

  # Define a custom ID to use for the root Management Group
  # Also used as a prefix for all core Management Group IDs
  es_root_id                   = "tf"

  # Define a custom "friendly name" for the root Management Group
  es_root_name                 = "ES Terraform Demo"

  # Control whether to deploy the default core landing zones // default = true
  es_deploy_core_landing_zones = true

  # Control whether to deploy the demo landing zones // default = false
  es_deploy_demo_landing_zones = false

  # Set a path for the custom archetype library path
  es_archetype_library_path    = "${path.root}/lib"

  es_custom_landing_zones = {
    #------------------------------------------------------#
    # This variable is used to add new Landing Zones using
    # the Enterprise-scale deployment model.
    # Simply add new map items containing the required
    # attributes, and the Enterprise-scale core module will
    # take care of the rest.
    # To associated existing Management Groups which have
    # been imported using "terraform import ...", please ensure
    # the key matches the id (Name) of the imported Management
    # Group and ensure all other values match the existing
    # configuration.
    #------------------------------------------------------#
    customer-web-prod = {
      display_name               = "Prod Web Applications"
      parent_management_group_id = "tf-landing-zones"
      subscription_ids           = []
      archetype_config = {
        archetype_id = "customer_online"
        parameters   = {}
      }
    }
    customer-web-dev = {
      display_name               = "Dev Web Applications"
      parent_management_group_id = "tf-landing-zones"
      subscription_ids           = []
      archetype_config = {
        archetype_id = "customer_online"
        parameters = {}
      }
    }
    #------------------------------------------------------#
    # EXAMPLES
    #------------------------------------------------------#
    # web-proxy = {
    #   display_name               = "Web Proxy"
    #   parent_management_group_id = "es-connectivity"
    #   subscription_ids           = []
    #   archetype_config = {
    #     archetype_id = "es_customer_online"
    #     parameters = {
    #       policy_assignment_id = {
    #         param_name_1 = param_value_1
    #         param_name_2 = param_value_2
    #         param_name_3 = param_value_3
    #       }
    #     }
    #   }
    # }
    #------------------------------------------------------#
  }

  # The following var provides an example for how to specify
  # custom archetypes for the connectivity Landing Zones
  es_archetype_config_overrides = {
    #------------------------------------------------------#
    # This variable is used to configure the built-in
    # Enterprise-scale Management Groups with alternate
    # (or custom) name and parameters.
    # Simply uncomment the one(s) you want to modify and
    # provide the required values.
    #------------------------------------------------------#
    # root = {
    #   archetype_id = "es_root"
    #   parameters   = {}
    # }
    # decommissioned = {
    #   archetype_id = "es_decommissioned"
    #   parameters   = {}
    # }
    # sandboxes = {
    #   archetype_id = "es_sandboxes"
    #   parameters   = {}
    # }
    # landing_zones = {
    #   archetype_id = "es_landing_zones"
    #   parameters   = {}
    # }
    # platform = {
    #   archetype_id = "es_platform"
    #   parameters   = {}
    # }
    # connectivity = {
    #   archetype_id = "es_connectivity_foundation"
    #   parameters   = {}
    # }
    # management = {
    #   archetype_id = "es_management"
    #   parameters   = {}
    # }
    # identity = {
    #   archetype_id = "es_identity"
    #   parameters   = {}
    # }
    # demo_corp = {
    #   archetype_id = "es_demo_corp"
    #   parameters   = {}
    # }
    # demo_online = {
    #   archetype_id = "es_demo_online"
    #   parameters   = {}
    # }
    # demo_sap = {
    #   archetype_id = "es_demo_sap"
    #   parameters   = {}
    # }
    #------------------------------------------------------#
    # EXAMPLES
    #------------------------------------------------------#
    # connectivity = {
    #   archetype_id = "es_connectivity_vwan"
    #   parameters = {
    #     policy_assignment_id = {
    #       param_name_1 = param_value_1
    #       param_name_2 = param_value_2
    #       param_name_3 = param_value_3
    #     }
    #   }
    # }
    #------------------------------------------------------#
  }

  es_subscription_ids_map = {
    #------------------------------------------------------#
    # This variable is used to associate Azure subscription_ids
    # with the built-in Enterprise-scale Management Groups.
    # Simply add one or more Subscription IDs to any of the
    # built-in Management Groups listed below as required.
    #------------------------------------------------------#
    root           = []
    decommissioned = []
    sandboxes      = []
    landing-zones  = []
    platform       = []
    connectivity   = []
    management     = []
    identity       = []
    demo-corp      = []
    demo-online    = []
    demo-sap       = []
    #------------------------------------------------------#
    # EXAMPLES
    #------------------------------------------------------#
    # connectivity = [
    #   "3117d098-8b43-433b-849d-b761742eb717",
    # ]
    # management = [
    #   "9ee716a9-e411-433a-86ea-d82bf7b7ca61",
    # ]
    # identity = [
    #   "cae4c823-f353-4a34-a91a-acc5a0bd65c7",
    # ]
    #------------------------------------------------------#
  }

}

```


# License

Please refer to our official [license statement][TFAES-LICENSE].

# Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.



 [//]: # (*****************************)
 [//]: # (INSERT IMAGE REFERENCES BELOW)
 [//]: # (*****************************)

[ESLZ-Architecture-Diagram]: https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/enterprise-scale/media/ns-arch-expanded.png "Diagram that shows Cloud Adoption Framework Enterprise-scale Landing Zone architecture."

 [//]: # (************************)
 [//]: # (INSERT LINK LABELS BELOW)
 [//]: # (************************)

[ESLZ-Architecture]: https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/enterprise-scale/architecture

[arm_management_group]:      https://docs.microsoft.com/en-us/azure/templates/microsoft.management/managementgroups
[arm_policy_assignment]:     https://docs.microsoft.com/en-us/azure/templates/microsoft.authorization/policyassignments
[arm_policy_definition]:     https://docs.microsoft.com/en-us/azure/templates/microsoft.authorization/policydefinitions
[arm_policy_set_definition]: https://docs.microsoft.com/en-us/azure/templates/microsoft.authorization/policysetdefinitions
[arm_role_assignment]:       https://docs.microsoft.com/en-us/azure/templates/microsoft.authorization/roleassignments
[arm_role_definition]:       https://docs.microsoft.com/en-us/azure/templates/microsoft.authorization/roledefinitions

[azurerm_management_group]:      https://www.terraform.io/docs/providers/azurerm/r/management_group.html
[azurerm_policy_assignment]:     https://www.terraform.io/docs/providers/azurerm/r/policy_assignment.html
[azurerm_policy_definition]:     https://www.terraform.io/docs/providers/azurerm/r/policy_definition.html
[azurerm_policy_set_definition]: https://www.terraform.io/docs/providers/azurerm/r/policy_set_definition.html
[azurerm_role_assignment]:       https://www.terraform.io/docs/providers/azurerm/r/role_assignment.html
[azurerm_role_definition]:       https://www.terraform.io/docs/providers/azurerm/r/role_definition.html

[TFAES-LICENSE]: https://github.com/Azure/terraform-azurerm-enterprise-scale/blob/main/LICENSE
