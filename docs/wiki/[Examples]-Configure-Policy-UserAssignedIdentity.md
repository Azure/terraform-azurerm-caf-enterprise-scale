<!-- markdownlint-disable first-line-h1 -->
## Overview

This page describes how to use the module to configure an Azure Policy Assignment with the user managed identity. Azure policies who implement a deploy if not exist require an identity to have the right permission to deploy the missing resources.

By leveraging the user managed identities, customers can reduce the number of system identities created by the assignments by using a user managed identity. The other benefit of using a user managed identity is the decouple the role assignment from the policy.

You can also review a working existing example located in examples/400-multi-with-orchestration

In this page, we will create a policy assignment template to override an existing policy assignment currently using a SystemIdentity. We will then assign an existing user managed identity to that policy assignment.

>**IMPORTANT**: To allow the declaration of custom or expanded templates, you must create a custom library folder within the root module and include the path to this folder using the `library_path` variable within the module configuration. In our example, the directory is `lib`.

## Create Policy Assignment template file

In your `lib` directory create a `policy_assignments` subdirectory if you don't already have one. You can learn more about archetypes and custom libraries in [this article](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Archetype-Definitions).

> **NOTE:** Creating a `policy_assignments` subdirectory is a recommendation only. If you prefer not to create one or to call it something else, the role assignment will still work.

In the `policy_assignments` subdirectory, create a `policy_assignment_es_deploy_vmss_monitoring.tmpl.json.tftpl` file. This file will contain the role assignment for the `vmss_monitoring` initiative.

> **NOTE:** If you reuse an existing name, this policy assignment will override the default policy assignment from the shared module library. It could be a good way to migrate your existing SystemAssigned to UserAssiged (User Managed Identity). By using a different name you will not change the current assignments.

In this example, we demonstrate how to upgrade an existing policy assignment from SystemAssigned to UserAssigned.

Copy the bellow code into the `policy_assignment_es_deploy_vmss_monitoring.tmpl.json.tftpl` file.

```json
${jsonencode(
  {
  "type": "Microsoft.Authorization/policyAssignments",
  "apiVersion": "2022-06-01",
  "name": "Deploy-VMSS-Monitoring",
  "location": "${default_location}",
  "dependsOn": [],
  "identity": {
    "type": "UserAssigned",
    "userAssignedIdentities": {
      for msi_id in userAssignedIdentities.Deploy-VMSS-Monitoring : msi_id => {}
    }
  },
  "properties": {
    "description": "Enable Azure Monitor for the Virtual Machine Scale Sets in the specified scope (Management group, Subscription or resource group). Takes Log Analytics workspace as parameter. Note: if your scale set upgradePolicy is set to Manual, you need to apply the extension to the all VMs in the set by calling upgrade on them. In CLI this would be az vmss update-instances.",
    "displayName": "Enable Azure Monitor for Virtual Machine Scale Sets",
    "policyDefinitionId": "/providers/Microsoft.Authorization/policySetDefinitions/75714362-cae7-409e-9b99-a8e5075b7fad",
    "enforcementMode": "Default",
    "nonComplianceMessages": [
      {
        "message": "Azure Monitor {enforcementMode} be enabled for Virtual Machines Scales Sets."
      }
    ],
    "parameters": {
      "logAnalytics_1": {
        "value": "/subscriptions/00000000-0000-0000-0000-000000000000/resourcegroups/${root_scope_id}-mgmt/providers/Microsoft.OperationalInsights/workspaces/${root_scope_id}-la"
      }
    },
    "scope": "${current_scope_resource_id}",
    "notScopes": []
  }
}
)}

```

Pay attention to the following identity section. It has been modified to process a variable that will come from the ***template_file_variables***

```json
"identity": {
  "type": "UserAssigned",
  "userAssignedIdentities": {
    for msi_id in userAssignedIdentities.Deploy-VMSS-Monitoring : msi_id => {}
  }
},
```

This template will read

```hcl
var.template_file_variables.userAssignedIdentities["Deploy-VMSS-Monitoring"]
```

## Configuration file

There is not a single way to retrieve the existing user managed identity and pass it to the module. The most common ways are using a terraform variable file (*.tfvars), you can also create your user managed identity and reference it inline to the module in the variable ***template_file_variables***

Create a file called `template_file_variables.auto.tfvars` or `template_file_variables.tfvars` in your root module. Then copy the content and make sure to adjust the resource id of the user managed identity.

```json
template_file_variables = {
  userAssignedIdentities = {
    # Put the name of the policy assignment to better recognise the which user managed identity is assigned to which policy assignment
    "Deploy-VMSS-Monitoring" = [
      # Even if it is a list (to comply with api and official document), only 1 user MSI is supported
      "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/msi/providers/Microsoft.ManagedIdentity/userAssignedIdentities/ms1"
    ]
  }
}
```

The next section is describing how to pass the user managed identity resource id to the module.

## Map template_file_variables to your module's parameters

In order to process the ***template_file_variables*** from the tfvars you must verify you have added the ***template_file_variables*** into your `variables.tf` or equivalent and map it to the module.

```hcl
variable "template_file_variables" {
  type        = any
  description = "If specified, provides the ability to define custom template variables used when reading in template files from the built-in and custom library_path."
  default     = {}
}
```

```hcl
module "alz" {
  # To enable correct testing of our examples, we must source this
  # module locally. Please remove the local `source = "../../../../"`
  # and uncomment the remote `source` and `version` below.
  source = "../../../../"
  # source  = "Azure/caf-enterprise-scale/azurerm"
  # version = "<version>" # change this to your desired version, https://www.terraform.io/language/expressions/version-constraints

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm
    azurerm.management   = azurerm
  }

  # Base module configuration settings
  root_parent_id   = data.azurerm_client_config.current.tenant_id
  root_id          = var.root_id
  root_name        = var.root_name
  library_path     = "${path.module}/lib"
  default_location = "eastus"

  # Enable creation of the core management group hierarchy
  # and additional custom_landing_zones
  deploy_core_landing_zones = true
  custom_landing_zones      = local.custom_landing_zones

  # Configuration settings for identity resources is
  # bundled with core as no resources are actually created
  # for the identity subscription
  deploy_identity_resources    = true
  configure_identity_resources = local.configure_identity_resources
  subscription_id_identity     = var.subscription_id_identity

  # The following inputs ensure that managed parameters are
  # configured correctly for policies relating to connectivity
  # resources created by the connectivity module instance and
  # to map the subscription to the correct management group,
  # but no resources are created by this module instance
  deploy_connectivity_resources    = false
  configure_connectivity_resources = var.configure_connectivity_resources
  subscription_id_connectivity     = var.subscription_id_connectivity

  # The following inputs ensure that managed parameters are
  # configured correctly for policies relating to management
  # resources created by the management module instance and
  # to map the subscription to the correct management group,
  # but no resources are created by this module instance
  deploy_management_resources    = false
  configure_management_resources = var.configure_management_resources
  subscription_id_management     = var.subscription_id_management

  template_file_variables = var.template_file_variables

}
```

Another way to pass the user managed indentity is using the inline approach (partial script)

```hcl
module "alz" {
  # To enable correct testing of our examples, we must source this
  # module locally. Please remove the local `source = "../../../../"`
  # and uncomment the remote `source` and `version` below.
  source = "../../../../"
  # source  = "Azure/caf-enterprise-scale/azurerm"
  # version = "<version>" # change this to your desired version, https://www.terraform.io/language/expressions/version-constraints

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm
    azurerm.management   = azurerm
  }

  ...Removed...

  template_file_variables = {
    userAssignedIdentities = {
      "Deploy-VMSS-Monitoring" = [
        azurerm_user_assigned_identity.msi1.id
      ]
    }
  }

}

# or a data source if already created
resource "azurerm_user_assigned_identity" "msi1" {
  location            = azurerm_resource_group.example.location
  name                = "msi1"
  resource_group_name = azurerm_resource_group.example.name
}

```

## Trigger the deployment

You should now kick-off your Terraform workflow (init, plan, apply) again to apply the updated configuration. This can be done either locally or through a pipeline.
When your workflow has finished, the `Deploy-VMSS-Monitoring` policy assignment will be assigned at the Landing Zones Management Group.

```hcl
# module.core.module.alz.data.azapi_resource.user_msi["/providers/Microsoft.Management/managementGroups/myorg/providers/Microsoft.Authorization/policyAssignments/Deploy-VMSS-Monitoring"] will be read during apply
  # (depends on a resource or a module with changes pending)
 <= data "azapi_resource" "user_msi" {
      + id                     = (known after apply)
      + location               = (known after apply)
      + output                 = (known after apply)
      + parent_id              = (known after apply)
      + resource_id            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/msi/providers/Microsoft.ManagedIdentity/userAssignedIdentities/ms1"
      + response_export_values = [
          + "properties.principalId",
        ]
      + tags                   = (known after apply)
      + type                   = "Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30"
    }

  # module.core.module.alz.azurerm_management_group_policy_assignment.enterprise_scale["/providers/Microsoft.Management/managementGroups/myorg/providers/Microsoft.Authorization/policyAssignments/Deploy-VMSS-Monitoring"] will be updated in-place
  ~ resource "azurerm_management_group_policy_assignment" "enterprise_scale" {
        id                   = "/providers/Microsoft.Management/managementGroups/myorg/providers/Microsoft.Authorization/policyAssignments/Deploy-VMSS-Monitoring"
        name                 = "Deploy-VMSS-Monitoring"
        # (9 unchanged attributes hidden)

      ~ identity {
          ~ identity_ids = [
              + "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/msi/providers/Microsoft.ManagedIdentity/userAssignedIdentities/ms1",
            ]
          ~ type         = "SystemAssigned" -> "UserAssigned"
            # (2 unchanged attributes hidden)
        }

        # (1 unchanged block hidden)
    }

  # module.core.module.alz.module.role_assignments_for_policy["/providers/Microsoft.Management/managementGroups/myorg/providers/Microsoft.Authorization/policyAssignments/Deploy-VMSS-Monitoring"].azurerm_role_assignment.for_policy["/providers/Microsoft.Management/managementGroups/myorg/providers/Microsoft.Authorization/roleAssignments/1e6eb635-dc9a-54d5-9bb5-7506132bff67"] must be replaced
-/+ resource "azurerm_role_assignment" "for_policy" {
      ~ id                               = "/providers/Microsoft.Management/managementGroups/myorg/providers/Microsoft.Authorization/roleAssignments/1e6eb635-dc9a-54d5-9bb5-7506132bff67" -> (known after apply)
        name                             = "1e6eb635-dc9a-54d5-9bb5-7506132bff67"
      ~ principal_id                     = "9ce8936e-cdd6-4a7c-a2a5-0e695c9ef8a5" # forces replacement -> (known after apply) # forces replacement
      ~ principal_type                   = "ServicePrincipal" -> (known after apply)
      ~ role_definition_name             = "Virtual Machine Contributor" -> (known after apply)
      + skip_service_principal_aad_check = (known after apply)
        # (2 unchanged attributes hidden)
    }

  # module.core.module.alz.module.role_assignments_for_policy["/providers/Microsoft.Management/managementGroups/myorg/providers/Microsoft.Authorization/policyAssignments/Deploy-VMSS-Monitoring"].azurerm_role_assignment.for_policy["/providers/Microsoft.Management/managementGroups/myorg/providers/Microsoft.Authorization/roleAssignments/55ffe1be-e389-5d46-9488-8d6915a8b60e"] must be replaced
-/+ resource "azurerm_role_assignment" "for_policy" {
      ~ id                               = "/providers/Microsoft.Management/managementGroups/myorg/providers/Microsoft.Authorization/roleAssignments/55ffe1be-e389-5d46-9488-8d6915a8b60e" -> (known after apply)
        name                             = "55ffe1be-e389-5d46-9488-8d6915a8b60e"
      ~ principal_id                     = "9ce8936e-cdd6-4a7c-a2a5-0e695c9ef8a5" # forces replacement -> (known after apply) # forces replacement
      ~ principal_type                   = "ServicePrincipal" -> (known after apply)
      ~ role_definition_name             = "Log Analytics Contributor" -> (known after apply)
      + skip_service_principal_aad_check = (known after apply)
        # (2 unchanged attributes hidden)
    }

Plan: 2 to add, 1 to change, 2 to destroy.
```
