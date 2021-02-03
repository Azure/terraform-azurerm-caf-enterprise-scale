# Azure Cloud Adoption Framework - Enterprise-scale

## Create Cloud Adoption Framework enterprise-scale landing zones

This module provides an opinionated approach for delivering the core platform capabilities of enterprise-scale landing zones using Terraform, based on the architecture published in the [Cloud Adoption Framework enterprise-scale landing zone architecture][ESLZ-Architecture], with a focus on the central resource hierarchy and governance:

![Enterprise-scale Landing Zone Architecture][ESLZ-Architecture-Diagram]

Specifically, this module provides a consistent approach for deploying the following core platform components:

- Management Group and Subscription organisation
  - Create the Management Group resource hierarchy
  - Assign Subscriptions to Management Groups
  - Create custom Policy Assignments, Policy Definitions and Policy Set Definitions (Initiatives)<br>(Enterprise-scale policies and customer-defined policies)
- Identity and access management
  - Create custom Role Assignments and Role Definitions<br>(Enterprise-scale roles and customer-defined roles)

The following resource types are deployed and managed by this module:

|     | Azure Resource | Terraform Resource |
| --- | -------------- | ------------------ |
| Management Groups      | [`Microsoft.Management/managementGroups`][arm_management_group]             | [`azurerm_management_group`][azurerm_management_group]           |
| Policy Assignments     | [`Microsoft.Authorization/policyAssignments`][arm_policy_assignment]        | [`azurerm_policy_assignment`][azurerm_policy_assignment]         |
| Policy Definitions     | [`Microsoft.Authorization/policyDefinitions`][arm_policy_definition]        | [`azurerm_policy_definition`][azurerm_policy_definition]         |
| Policy Set Definitions | [`Microsoft.Authorization/policySetDefinitions`][arm_policy_set_definition] | [`azurerm_policy_set_definition`][azurerm_policy_set_definition] |
| Role Assignments       | [`Microsoft.Authorization/roleAssignments`][arm_role_assignment]            | [`azurerm_role_assignment`][azurerm_role_assignment]             |
| Role Definitions       | [`Microsoft.Authorization/roleDefinitions`][arm_role_definition]            | [`azurerm_role_definition`][azurerm_role_definition]             |

## Usage in Terraform 0.13

To use this module with all default settings, please include the following in your root module:

> **Module usage notes:**
>
> 1. Please note, this module requires a minimum `azurerm` provider version of `2.31.1` to support correct operation with Policy Set Definitions. We also recommend using Terraform version `0.13.3` or greater.
>
> 2. This module has a single mandatory variable `root_parent_id` which is used to set the parent ID to use as the root for deployment. All other variables are optional but can be used to customise your deployment.
>
> 3. If using the `azurerm_subscription` data source to provide a `tenant_id` value from the current context for `root_parent_id`, you are likely to get a warning that Terraform cannot determine the number of resources to create during the `plan` stage. To avoid the need to use `terraform apply -target=resource` or putting such values in source code, we recommend providing the `root_parent_id` value explicitly via the command-line using `-var 'root_parent_id={{ tenant_id }}'` or your preferred method of injecting variable values at runtime.
>
> 4. As of version `0.0.8` this module now supports the creation of Role Assignments for any valid Policy Assignment deployed using the module. This feature enumerates the appropriate role(s) needed by the assigned Policy Definition or Policy Set Definition and creates the necessary Role Assignments for the auto-generated Managed Identity at the same scope as the Policy Assignment. This capability provides feature parity with the Azure Portal experience when creating Policy Assignments using the `DeployIfNotExists` or `Modify` effects. If the Policy Assignment needs to interact with resources not under the same scope as the Policy Assignment, you will need to create additional Role Assignments at the appropriate scope.

### Simple Example

```hcl
provider "azurerm" {
  version = ">= 2.31.1"
  features {}
}

variable "tenant_id" {
  type        = string
  description = "The tenant_id is used to set the root_parent_id value for the enterprise_scale module."
}

module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "0.0.8"

  root_parent_id = var.tenant_id

}
```

### Advanced Example

To customise the module, you can add any of the following optional variables:

```hcl
provider "azurerm" {
  version = ">= 2.31.1"
  features {}
}

variable "tenant_id" {
  type        = string
  description = "The tenant_id is used to set the root_parent_id value for the enterprise_scale module."
}

module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "0.0.8"

  # Mandatory Variables
  root_parent_id            = var.tenant_id

  # Optional Variables
  root_id                   = "tf"                // Define a custom ID to use for the root Management Group. Also used as a prefix for all core Management Group IDs.
  root_name                 = "ES Terraform Demo" // Define a custom "friendly name" for the root Management Group
  deploy_core_landing_zones = true                // Control whether to deploy the default core landing zones // default = true
  deploy_demo_landing_zones = false               // Control whether to deploy the demo landing zones (default = false)
  library_path              = "${path.root}/lib"  // Set a path for the custom archetype library path

  custom_landing_zones = {
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
        access_control = {}
      }
    }
    customer-web-dev = {
      display_name               = "Dev Web Applications"
      parent_management_group_id = "tf-landing-zones"
      subscription_ids           = []
      archetype_config = {
        archetype_id = "customer_online"
        parameters = {}
        access_control = {}
      }
    }
    #------------------------------------------------------#
    # EXAMPLES
    #------------------------------------------------------#
    # example-mg = {
    #   display_name               = "Example Management Group"
    #   parent_management_group_id = "es-landing-zones"
    #   subscription_ids           = [
    #     "3117d098-8b43-433b-849d-b761742eb717",
    #   ]
    #   archetype_config = {
    #     archetype_id = "es_landing_zones"
    #     parameters = {
    #       policy_assignment_id = {
    #         param_name_1 = param_value_1
    #         param_name_2 = param_value_2
    #         param_name_3 = param_value_3
    #       }
    #     }
    #     access_control = {
    #       role_definition_name = {
    #         "member_1_object_id",
    #         "member_2_object_id",
    #         "member_3_object_id",
    #       }
    #     }
    #   }
    # }
    #------------------------------------------------------#
  }

  # The following var provides an example for how to specify
  # custom archetypes for the connectivity Landing Zones
  archetype_config_overrides = {
    #------------------------------------------------------#
    # This variable is used to configure the built-in
    # Enterprise-scale Management Groups with alternate
    # (or custom) name and parameters.
    # Simply uncomment the one(s) you want to modify and
    # provide the required values.
    #------------------------------------------------------#
    # root = {
    #   archetype_id   = "es_root"
    #   parameters     = {}
    #   access_control = {}
    # }
    # decommissioned = {
    #   archetype_id   = "es_decommissioned"
    #   parameters     = {}
    #   access_control = {}
    # }
    # sandboxes = {
    #   archetype_id   = "es_sandboxes"
    #   parameters     = {}
    #   access_control = {}
    # }
    # landing-zones = {
    #   archetype_id   = "es_landing_zones"
    #   parameters     = {}
    #   access_control = {}
    # }
    # platform = {
    #   archetype_id   = "es_platform"
    #   parameters     = {}
    #   access_control = {}
    # }
    # connectivity = {
    #   archetype_id   = "es_connectivity_foundation"
    #   parameters     = {}
    #   access_control = {}
    # }
    # management = {
    #   archetype_id   = "es_management"
    #   parameters     = {}
    #   access_control = {}
    # }
    # identity = {
    #   archetype_id   = "es_identity"
    #   parameters     = {}
    #   access_control = {}
    # }
    # demo-corp = {
    #   archetype_id   = "es_demo_corp"
    #   parameters     = {}
    #   access_control = {}
    # }
    # demo-online = {
    #   archetype_id   = "es_demo_online"
    #   parameters     = {}
    #   access_control = {}
    # }
    # demo-sap = {
    #   archetype_id   = "es_demo_sap"
    #   parameters     = {}
    #   access_control = {}
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
    #   access_control = {
    #     role_definition_name = {
    #       "member_1_object_id",
    #       "member_2_object_id",
    #       "member_3_object_id",
    #     }
    #   }
    # }
    #------------------------------------------------------#
  }

  subscription_id_overrides = {
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

## Guide to further customisation

This module contains a default library containing templates for the default Enterprise-scale Archetype Definitions, Policy Assignments, Policy Definitions, Policy Set Definitions (Initiatives), Role Assignments and Role Definitions. These can be added to and overridden by creating a custom library within your root module. Further details of this are provided in the following sections.

### What is an archetype?

Archetypes are used in the Enterprise-scale architecture to describe the Landing Zone configuration using a template-driven approach. The archetype is what fundamentally transforms ***Management Groups*** and ***Subscriptions*** into ***Landing Zones***.

An archetype defines which Azure Policy and Access control (IAM) settings are needed to secure and configure the Landing Zones with everything needed for safe handover to the Landing Zone owner. This covers critical platform controls and configuration items, such as:

- Consistent role-based access control (RBAC) settings
- Guardrails for security settings
- Guardrails for common workload configurations (e.g. SAP, AKS, WVD, etc.)
- Automate provisioning of critical platform resources such as monitoring and networking solutions in each Landing Zone

This approach provides improved autonomy for application teams, whilst ensuring security policies and standards are enforced.

### Working with archetype definitions and the custom library

The `archetype_definition` is a simple template file written in JSON or YAML. The default archetype definitions can be found in the [built-in module library][TFAES-Library], but custom archetype definitions can also be added to a custom library in the root module. The archetype definition is associated to the scope (i.e. Management Group) by specifying the `archetype_id` within the ***Landing Zone*** configuration object.

Both the built-in and custom libraries are also used to store ARM based templates for the Policy Assignments, Policy Definitions, Policy Set Definitions (Initiatives) and Role Definitions. Role Assignments are an exception as these are defined as part of the `archetype_config` instead.

To use a custom library, simply create a folder in your root module (e.g. `/lib`) and tell the module about it using the `library_path` variable (e.g. `library_path = "${path.root}/lib"`). Save your custom templates in the custom library location and as long as they are valid templates for the resource type and match the following naming conventions, the module will automatically import and use them:

| Resource Type | File Name Pattern |
| ------------- | ----------------- |
| Archetype Definitions  | `archetype_definition_*.{json,yml,yaml}`  |
| Policy Assignments     | `policy_assignment_*.{json,yml,yaml}`     |
| Policy Definitions     | `policy_definition_*.{json,yml,yaml}`     |
| Policy Set Definitions | `policy_set_definition_*.{json,yml,yaml}` |
| Role Definitions       | `role_definition_*.{json,yml,yaml}`       |

> The decision to store Policy Assignments, Policy Definitions, Policy Set Definitions (Initiatives) and Role Definitions as native ARM was based on a couple of factors:
>
>- Policies in Terraform require you to understand how to write significant sections of the resource configuration in the native ARM format, and then convert this to a JSON string within Terraform resource.
>- This makes copying these items between ARM templates and Terraform much easier.
>- Terraform doesn't support importing data objects from native Terraform file formats (`.hcl`, `.tf` or `.tfvar`) so we had to use an alternative to be able to support the custom library model for extensibility and customisation.<br>**PRO TIP:** The module also supports YAML for these files as long as they match the ARM schema, although we don't know why you would want to do that!
>

This template driven approach is designed to simplify the process of defining an archetype and forms the foundations for how the module is able to provide feature-rich defaults, whilst also allowing a great degree of extensibility and customisation through the input variables instead of having to fork and modify the module.

The `archetype_definition` template contains lists of the Policy Assignments, Policy Definitions, Policy Set Definitions (Initiatives) and Role Definitions you want to create when assigning the archetype to a Management Group. It also includes the ability to set default values for parameters associated with Policy Assignments, and set default Role Assignments.

To keep the `archetype_definition` template as lean as possible, we simply declare the value of the `name` field from the resource templates (by type). The exception is Role Definitions which must have a GUID for the `name` field, so we use the `roleName` value from `properties` instead.

As long as you follows these patterns, you can create your own archetype definitions to start advanced customisation of your Enterprise-scale deployment.

This template-based approach was chosen to make the desired-state easier to understand, simplify the process of managing configuration and versioning, reduce code duplication (DRY), and to improve consistency in complex environments.

#### Example archetype definition

```json
{
    "archetype_id": {
        "policy_assignments": [
          // list of Policy Assignment names
        ],
        "policy_definitions": [
          // list of Policy Definition names
        ],
        "policy_set_definitions": [
          // list of Policy Set Definition names
        ],
        "role_definitions": [
          // list of Role Definition names
        ],
        "archetype_config": {
            "parameters": {
              // map of parameter objects, grouped by Policy Assignment name
            },
            "access_control": {
              // map of Role Assignments to create, grouped by Role Definition name
            }
        }
    }
}
```

#### Using the `default_empty` archetype definition

The default library includes a `default_empty` archetype definition which is useful when defining Management Groups which only require Role Assignments, or are being used for logical segregation of Landing Zones under a parent arcehtype. You can assign this to any Landing Zone definition, using the `archetype_config` > `archetype_id` value as per the following `custom_landing_zones` example:

```hcl
  custom_landing_zones = {
    example-landing-zone-id = {
      display_name               = "Example Landing Zone"
      parent_management_group_id = "tf-landing-zones"
      subscription_ids           = []
      archetype_config = {
        archetype_id = "default_empty"
        parameters   = {}
        access_control = {}
      }
    }
  }
```

This is equivalent to creating a standard Management Group without creating any custom Policy Assignments, Policy Definitions, Policy Set Definitions (Initiatives) or Role Definitions.

Role Assignments can be created using the `archetype_config` > `access_control` object within the `custom_landing_zones` instance.

> Note that you still need to provide a full and valid Landing Zone object as per the example above.

## License

Please refer to our official [license statement][TFAES-LICENSE].

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit [https://cla.opensource.microsoft.com](https://cla.opensource.microsoft.com).

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.



 [//]: # (*****************************)
 [//]: # (INSERT IMAGE REFERENCES BELOW)
 [//]: # (*****************************)

[ESLZ-Architecture-Diagram]: media/terraform-caf-enterprise-scale-overview.png "Diagram that shows Cloud Adoption Framework Enterprise-scale Landing Zone architecture."

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
[TFAES-Library]: https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/tree/main/modules/terraform-azurerm-caf-enterprise-scale-archetypes/lib
