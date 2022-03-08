## Overview

This page describes how to assign built-in Azure Policies to your Enterprise Scale deployment.

In this example you will use two built-in policies and one built-in policy set definition. The policies you will use are `XXXXX` and `XXXXX`. The policy set definition (Initiative) you will use is  `XXXXX`.

You will update the built-in configuration by following these steps:

- Create the policy assignment files for `XXXXX`, `XXXXX` and `XXXXX`
- Assign the policy definition for `XXXXX` at the `es_root` Management Group by extending the built-in archetype for `es_root`
- Assign the policy set definition for `XXXXX` at the `es_root` Management Group by extending the built-in archetype for `es_root`
- Assign the policy definition for `XXXXX` at the `Landing Zones` Management Group by extending the built-in archetype for `es_landing_zones`

>IMPORTANT: To allow the declaration of custom or expanded templates, you must create a custom library folder within the root module and include the path to this folder using the `library_path` variable within the module configuration. In our example, the directory is `/lib`.

In order to assign built-in policies, we need to create an assignment file for each policy or policy set definition that we want to use. In this example we will do this by using the below files:

- [lib/policy_assignments/policy_assignment_es_enforce_rg_tags.json](#libpolicy_assignmentspolicy_assignment_es_enforce_rg_tagsjson)
- [lib/policy_assignments/policy_assignment_es_enforce_resource_tags.json](#libpolicy_assignmentspolicy_assignment_es_enforce_resource_tagsjson)
- [lib/policy_assignments/policy_assignment_es_deny_nic_nsg.json](#libpolicy_assignmentspolicy_assignment_es_deny_nic_nsgjson)

## Create Custom Policy Assignment Files

In order to assign built-in policies or policy sets, you need to create policy assignment files. The first step is to create a `policy_assignments` subdirectory within `/lib`.

>NOTE: Creating a `policy_assignments` subdirectory within `\lib` is a recommendation only. If you prefer not to create one or to call it something else, the custom policies will still work.

You will then need to create a file named `policy_assignment_es_XXXXX.json` within the `policy_assignments` directory. Copy the below code in to the file and save it.

### `lib/policy_assignments/policy_assignment_es_XXXXX.json`

```json
{
    "name": "Enforce-RG-Tags",
    "type": "Microsoft.Authorization/policyAssignments",
    "apiVersion": "2019-09-01",
    "properties": {
        "description": "Enforce Mandatory Tags on Resource Groups",
        "displayName": "Resource groups must have mandatory tagging applied",
        "notScopes": [],
        "parameters": {
        } ,
        "policyDefinitionId": "${root_scope_resource_id}/providers/Microsoft.Authorization/policyDefinitions/Enforce-RG-Tags",
        "scope": "${current_scope_resource_id}",
        "enforcementMode": null,
        "nonComplianceMessages": [
        {
            "message": "Mandatory tags must be provided."
        }
        ]
    },
    "location": "${default_location}",
    "identity": {
        "type": "SystemAssigned"
    }
}
```

Now create a file named `policy_assignment_es_XXXXX.json` within the `policy_assignments` directory. Copy the below code in to the file and save it.

### `lib/policy_assignments/policy_assignment_es_XXXXX.json`

```json
{
    "name": "Enforce-Resource-Tags",
    "type": "Microsoft.Authorization/policyAssignments",
    "apiVersion": "2019-09-01",
    "properties": {
        "description": "Enforce Mandatory Tags on Resources",
        "displayName": "Resources must have mandatory tagging applied",
        "notScopes": [],
        "parameters": {
        } ,
        "policyDefinitionId": "${root_scope_resource_id}/providers/Microsoft.Authorization/policyDefinitions/Enforce-Resource-Tags",
        "scope": "${current_scope_resource_id}",
        "enforcementMode": null,
        "nonComplianceMessages": [
        {
            "message": "Mandatory tags must be provided."
        }
        ]
    },
    "location": "${default_location}",
    "identity": {
        "type": "SystemAssigned"
    }
}
```

Finally, create a file named `policy_assignment_XXXXX.json` within the `policy_assignments` directory. Copy the below code in to the file and save it.

### `lib/policy_assignments/policy_assignment_es_XXXXX.json`

```json
{
    "name": "Deny-NIC-NSG",
    "type": "Microsoft.Authorization/policyAssignments",
    "apiVersion": "2019-09-01",
    "properties": {
      "description": "This policy will prevent NSGs from being applied to network interface cards.",
      "displayName": "Prevent Network Security Groups from being applied to Network Interface Cards",
      "notScopes": [],
      "parameters": {} ,
      "policyDefinitionId": "${root_scope_resource_id}/providers/Microsoft.Authorization/policyDefinitions/Deny-NIC-NSG",
      "scope": "${current_scope_resource_id}",
      "enforcementMode": null,
      "nonComplianceMessages": [
        {
            "message": "NSGs must not be applied to Network Interface cards."
        }
    ]

    },
    "location": "${default_location}",
    "identity": {
      "type": "SystemAssigned"
    }
  }
```

## Assign the `XXXXX` Policy at the `es_root` Management Group

You now need to assign the `XXXXX` policy and in this example, we will assign it at `es_root`. To do this, update your existing `archetype_extension_es_root.tmpl.json` file with the below code and save it.

```json
{
  "extend_es_root": {
    "policy_assignments": ["XXXXX"],
    "policy_definitions": [],
    "policy_set_definitions": [],
    "role_definitions": [],
    "archetype_config": {
      "access_control": {
      }
    }
  }
}
```

You should now kick-off your Terraform workflow (init, plan, apply) to apply the new configuration. This can be done either locally or through a pipeline. When your workflow has finished, the `XXXXX` policy will be assigned at `es_root`.

## Assign the `XXXXX` Policy Set at the es_root Management Group

In this example, we will assign it at the `Landing Zones` Management Group. To do this, either update your existing `archetype_extension_es_landing_zones.tmpl.json` file or create one and copy the below code in to it and save.

```json
{
  "extend_es_landing_zones": {
    "policy_assignments": ["xxxxx"],
    "policy_definitions": [],
    "policy_set_definitions": [],
    "role_definitions": [],
    "archetype_config": {
      "access_control": {
      }
    }
  }
}
```

You should now kick-off your Terraform workflow again to apply the updated configuration. This can be done either locally or through a pipeline. When your workflow has finished, the `XXXXX` Policy Definition will be assigned at the `Landing Zones` Management Group.

```hcl
terraform apply
```

You have now successfully assigned a built-in Policy Definition and a built-in Policy Set Definition within your Azure environment. You can re-use the steps in this article for any other built-in policies that you may wish to use within your environment.