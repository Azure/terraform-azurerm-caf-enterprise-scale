<!-- markdownlint-disable first-line-h1 -->
## Overview

This page describes how to deploy your Azure landing zone with custom policy definitions and policy set (Initiative) definitions.

In this example you will use three custom policies and a custom policy set definition. The custom policies will be named `Enforce-RG-Tags`, `Enforce-Resource-Tags` and `Deny-NIC-NSG`. You will then create a custom policy set definition (Initiative) named `Enforce-Mandatory-Tags` that will include the `Enforce-RG-Tags` and `Enforce-Resource-Tags` custom policies.

You will update the built-in configuration by following these steps:

- Create the custom policy definition file for `Enforce-RG-Tags`
- Create the custom policy definition file for `Enforce-Resource-Tags`
- Create the custom policy definition file for `Deny-NIC-NSG`
- Create the custom policy set definition file for `Enforce-Mandatory-Tags`
- Make the custom policy definitions available for use in Azure by extending the built-in archetype for `es_root`
- Create the policy assignment files for `Enforce-RG-Tags`, `Enforce-Resource-Tags`, `Deny-NIC-NSG` and `Enforce-Mandatory-Tags`
- Assign the custom policy set definition for `Enforce-Mandatory-Tags` at the `es_root` Management Group by extending the built-in archetype for `es_root`
- Assign the custom policy definition for `Deny-NIC-NSG` at the `Landing Zones` Management Group by extending the built-in archetype for `es_landing_zones`

>IMPORTANT: To allow the declaration of custom or expanded templates, you must create a custom library folder within the root module and include the path to this folder using the `library_path` variable within the module configuration. In our example, the directory is `/lib`.

In order to create and assign custom policies, we need to create both a definition file and an assignment file for each custom policy or custom policy set definition. In this example we will do this by using the below files:

- [lib/policy_definitions/policy_definition_es_enforce_rg_tags.json](#libpolicy_definitionspolicy_definition_es_enforce_rg_tagsjson)
- [lib/policy_definitions/policy_definition_es_enforce_resource_tags.json](#libpolicy_definitionspolicy_definition_es_enforce_resource_tagsjson)
- [lib/policy_definitions/policy_definition_es_deny_nic_nsg.json](#libpolicy_definitionspolicy_definition_es_deny_nic_nsgjson)
- [lib/policy_set_definitions/policy_set_definition_enforce_mandatory_tagging.json](#libpolicy_set_definitionspolicy_set_definition_enforce_mandatory_taggingjson)
- [lib/policy_assignments/policy_assignment_es_enforce_rg_tags.json](#libpolicy_assignmentspolicy_assignment_es_enforce_rg_tagsjson)
- [lib/policy_assignments/policy_assignment_es_enforce_resource_tags.json](#libpolicy_assignmentspolicy_assignment_es_enforce_resource_tagsjson)
- [lib/policy_assignments/policy_assignment_es_deny_nic_nsg.json](#libpolicy_assignmentspolicy_assignment_es_deny_nic_nsgjson)
- [lib/policy_assignments/policy_assignment_es_enforce_mandatory_tagging.json](#libpolicy_assignmentspolicy_assignment_es_enforce_mandatory_taggingjson)

> **NOTE:** This module provides the ability to define custom template variables used when reading in template files from the built-in and custom library_path. For more info [click here](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BVariables%5D-template_file_variables).

## Create Custom Policy Definition

In your `/lib` directory create a `policy_definitions` subdirectory if you don't already have one. You can learn more about archetypes and custom libraries in [this article](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Archetype-Definitions).

> **NOTE:** Creating a `policy_definitions` subdirectory is a recommendation only. If you prefer not to create one or to call it something else, the custom policies will still work.

In the `policy_definitions` subdirectory, create a `policy_definition_es_policy_enforce_rg_tags.json` file. This file will contain the policy definition for `Enforce-RG-Tags`. Copy the below code in to the file and save it.

### `lib/policy_definitions/policy_definition_es_enforce_rg_tags.json`

```json
{
    "name": "Enforce-RG-Tags",
    "type": "Microsoft.Authorization/policyDefinitions",
    "apiVersion": "2021-06-01",
    "scope": null,
      "properties": {
        "displayName": "Resource groups must have mandatory tagging applied",
        "policyType": "Custom",
        "mode": "All",
        "description": "Enforce mandatory 'Owner' and 'Department' tags on Resource Groups",
        "metadata": {
          "version": "1.0.0",
          "category": "Tags"
        },
        "policyRule": {
        "if": {
            "allOf":[
                {
                "field": "type",
                "equals": "Microsoft.Resources/subscriptions/resourceGroups"
                },
                {
                "anyof": [
                {
                    "field": "[concat('tags[', parameters('Owner'), ']')]",
                    "exists": "false"
                },
                {
                    "field": "[concat('tags[', parameters('Department'), ']')]",
                    "exists": "false"
                }
                ]
            }
            ]
        },
        "then": {
            "effect": "deny"
        }
        },
        "parameters": {
            "Owner": {
                "type": "String",
                "metadata": {
                    "displayName": "Owner",
                    "description": "Specifies the Owner of the Resource Group'"
                }
            },
            "Department": {
                "type": "String",
                "metadata": {
                    "displayName": "Department",
                    "description": "Specifies the Department that the Resource Group belongs to"
                }
            }
        }
    }
}
```

Now create a `policy_definition_es_policy_enforce_resource_tags.json` file. This file will contain the policy definition for `Enforce-Resource-Tags`. Copy the below code in to the file and save it.

### `lib/policy_definitions/policy_definition_es_enforce_resource_tags.json`

```json
{
"name": "Enforce-Resource-Tags",
"type": "Microsoft.Authorization/policyDefinitions",
"apiVersion": "2021-06-01",
"scope": null,
    "properties": {
    "displayName": "Resources must have mandatory tagging applied",
    "policyType": "Custom",
    "mode": "Indexed",
    "description": "Enforce mandatory 'Owner' and 'Department' tags on Resources",
    "metadata": {
        "version": "1.0.0",
        "category": "Tags"
    },
    "policyRule": {
        "if": {
            "anyof": [
                {
                    "field": "[concat('tags[', parameters('Owner'), ']')]",
                    "exists": "false"
                },
                {
                    "field": "[concat('tags[', parameters('Department'), ']')]",
                    "exists": "false"
                }
                ]
        },
        "then": {
            "effect": "deny"
        }
    },
        "parameters": {
            "Owner": {
                "type": "String",
                "metadata": {
                    "displayName": "Owner",
                    "description": "Specifies the Owner of the resource"
                }
            },
            "Department": {
                "type": "String",
                "metadata": {
                    "displayName": "Department",
                    "description": "Specifies the Department that the resource belongs to"
                }
            }
        }
    }
}
```

Next create a `policy_definition_es_policy_deny_nsg_nic.json` file. This file will contain the policy definition for our last custom policy - `Deny-NSG-NIC`. Copy the below code in to the file and save it.

### `lib/policy_definitions/policy_definition_es_deny_nic_nsg.json`

```json
{
    "type": "Microsoft.Authorization/policyDefinitions",
    "name": "Deny-NIC-NSG",
    "properties": {
        "displayName": "Prevent Network Security Groups from being applied to Network Interface Cards",
        "description": "This policy will prevent NSGs from being applied to network interface cards.",
        "policyType": "Custom",
        "mode": "All",
        "metadata": {
            "version": "1.0.0",
            "category": "Network"
        },
        "parameters": {
            "effect": {
                "type": "String",
                "defaultValue": "deny",
                "allowedValues": [
                    "audit",
                    "deny",
                    "disabled"
                ],
                "metadata": {
                    "displayName": "Effect",
                    "description": "Enable or disable the execution of the policy"
                }
            }
        },
        "policyRule": {
            "if": {
                "allOf": [
                {
                        "field": "type",
                        "equals": "Microsoft.Network/networkInterfaces"
                    },
                    {
                        "field": "Microsoft.Network/networkInterfaces/networkSecurityGroup.id",
                        "like": "*"
                    }
                ]
            },
            "then": {
                "effect": "[parameters('effect')]"
            }
        }
    }
}
```

## Create Custom Policy Set Definition

In your `/lib` directory create a `policy_set_definitions` subdirectory.

> **NOTE:** Creating a `policy_set_definitions` subdirectory is a recommendation only. If you prefer not to create one or to call it something else, the custom policies will still work.

In the `policy_set_definitions` subdirectory, create a `policy_set_definition_enforce_mandatory_tags.json` file. This file will contain the Policy Set Definition for `Enforce-Mandatory-Tags`. The policy set will contain the `Enforce-RG-Tags` and `Enforce-Resource-Tags` custom policies that you previously created. Copy the below code in to the file and save it.

### `lib/policy_set_definitions/policy_set_definition_enforce_mandatory_tagging.json`

```json
{
    "name": "Enforce-Mandatory-Tags",
    "type": "Microsoft.Authorization/policySetDefinitions",
    "apiVersion": "2021-06-01",
    "scope": null,
    "properties": {
      "policyType": "Custom",
      "displayName": "Ensure mandatory tagging is applied to both Resources and Resource Groups",
      "description": "Contains the core tagging policies applicable to the org",
      "metadata": {
        "version": "1.0.0",
        "category": "General"
      },
      "parameters": {
        "EnforceRGTags-Owner": {
            "type": "String",
            "metadata": {
              "displayName": "Owner",
              "description": "Specifies the Owner of the Resource Group"
            }
        },
        "EnforceRGTags-Department": {
            "type": "String",
            "metadata": {
              "displayName": "Department",
              "description": "Specifies the Department that the Resource Group belongs to"
            }
        },
        "EnforceResourceTags-Owner": {
            "type": "String",
            "metadata": {
              "displayName": "Owner",
              "description": "Specifies the Owner of the resource"
            }
        },
        "EnforceResourceTags-Department": {
            "type": "String",
            "metadata": {
              "displayName": "Department",
              "description": "Specifies the Department that the resource belongs to"
            }
        }
      },
      "policyDefinitions": [
        {
          "policyDefinitionReferenceId": "Resource groups must have mandatory tagging applied",
          "policyDefinitionId": "${root_scope_resource_id}/providers/Microsoft.Authorization/policyDefinitions/Enforce-RG-Tags",
          "parameters": {
            "Owner": {
              "value": "[parameters('EnforceRGTags-Owner')]"
            },
            "Department": {
              "value": "[parameters('EnforceRGTags-Department')]"
            }
          },
          "groupNames": []
        },
        {
          "policyDefinitionReferenceId": "Resources must have mandatory tagging applied",
          "policyDefinitionId": "${root_scope_resource_id}/providers/Microsoft.Authorization/policyDefinitions/Enforce-Resource-Tags",
          "parameters": {
            "Owner": {
              "value": "[parameters('EnforceResourceTags-Owner')]"
            },
            "Department": {
              "value": "[parameters('EnforceResourceTags-Department')]"
            }
          },
          "groupNames": []
        }
      ],
      "policyDefinitionGroups": null
    }
  }
```

## Create Custom Policy Assignment Files

In order to assign your custom policies or policy sets, you need to create policy assignment files. The first step is to create a `policy_assignments` subdirectory within `/lib`.

> **NOTE:** Creating a `policy_assignments` subdirectory within `\lib` is a recommendation only. If you prefer not to create one or to call it something else, the custom policies will still work.

- [lib/policy_assignments/policy_assignment_es_enforce_rg_tags.json](#libpolicy_assignmentspolicy_assignment_es_enforce_rg_tagsjson)
- [lib/policy_assignments/policy_assignment_es_enforce_resource_tags.json](#libpolicy_assignmentspolicy_assignment_es_enforce_resource_tagsjson)
- [lib/policy_assignments/policy_assignment_es_deny_nic_nsg.json](#libpolicy_assignmentspolicy_assignment_es_deny_nic_nsgjson)
- [lib/policy_assignments/policy_assignment_es_enforce_mandatory_tagging.json](#libpolicy_assignmentspolicy_assignment_es_enforce_mandatory_taggingjson)

You will then need to create a file named `policy_assignment_es_enforce_rg_tags.json` within the `policy_assignments` directory. Copy the below code in to the file and save it.

### `lib/policy_assignments/policy_assignment_es_enforce_rg_tags.json`

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
        "nonComplianceMessages": [
          {
            "message": "Mandatory tags {enforcementMode} be applied to Resource Groups."
          }
        ],
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

Now create a file named `policy_assignment_es_enforce_resource_tags.json` within the `policy_assignments` directory. Copy the below code in to the file and save it.

### `lib/policy_assignments/policy_assignment_es_enforce_resource_tags.json`

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
        "nonComplianceMessages": [
          {
            "message": "Mandatory tags {enforcementMode} be applied to resources."
          }
        ],
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

Next create a file named `policy_assignment_es_deny_nic_nsg.json` within the `policy_assignments` directory. Copy the below code in to the file and save it.

### `lib/policy_assignments/policy_assignment_es_deny_nic_nsg.json`

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
      "nonComplianceMessages": [
          {
            "message": "NSGs {enforcementMode} not be applied to network interface cards."
          }
        ],
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

Finally, create a file named `policy_assignment_es_enforce_mandatory_tagging.json`. Copy the below code in to the file and save it.

### `lib/policy_assignments/policy_assignment_es_enforce_mandatory_tagging.json`

```json
{
  "name": "Enforce-Mandatory-Tags",
  "type": "Microsoft.Authorization/policyAssignments",
  "apiVersion": "2019-09-01",
  "properties": {
    "description": "Contains the core policies applicable to the org",
    "displayName": "Ensure mandatory tagging is applied to both Resources and Resource Groups",
    "notScopes": [],
    "parameters": {
      "EnforceRGTags-Owner": {
        "Value": "Jane Doe"
      },
      "EnforceRGTags-Department": {
        "Value": "IT"
      },
      "EnforceResourceTags-Owner": {
        "Value": "Jane Doe"
      },
      "EnforceResourceTags-Department": {
        "Value": "IT"
      }
    },
    "policyDefinitionId": "${root_scope_resource_id}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-Mandatory-Tags",
    "nonComplianceMessages": [
      {
        "message": "Mandatory tags {enforcementMode} be applied to Resources and Resource Groups."
      }
    ],
    "scope": "${current_scope_resource_id}",
    "enforcementMode": null
  },
  "location": "${default_location}",
  "identity": {
    "type": "SystemAssigned"
  }
}
```

## Make the Custom Policy Definitions and Policy Set Definition available for use

You now need to save your custom policy and policy set definitions at the `es_root` Management Group to ensure they can be used at that scope or any scope beneath. To do that, we need to extend the built-in archetype for `es_root`.
> **NOTE:** Extending built-in archetypes is explained further in [this article](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Expand-Built-in-Archetype-Definitions).

If you don't already have an `archetype_extension_es_root.tmpl.json` file within your custom `/lib` directory, create one and copy the below code in to the file. This code saves the custom policy definition and policy set definitions but we still haven't assigned them anywhere yet.

```json
{
  "extend_es_root": {
    "policy_assignments": [],
    "policy_definitions": ["Enforce-RG-Tags", "Enforce-Resource-Tags", "Deny-NIC-NSG"],
    "policy_set_definitions": ["Enforce-Mandatory-Tags"],
    "role_definitions": [],
    "archetype_config": {
      "access_control": {
      }
    }
  }
}
```

## Assign the `Enforce-Mandatory-Tags` Custom Policy Set at the `es_root` Management Group

You now need to assign the `Enforce-Mandatory-Tags` policy set and in this example, we will assign it at `es_root`. To do this, update your existing `archetype_extension_es_root.tmpl.json` file with the below code and save it.

```json
{
  "extend_es_root": {
    "policy_assignments": ["Enforce-Mandatory-Tags"],
    "policy_definitions": ["Enforce-RG-Tags", "Enforce-Resource-Tags", "Deny-NIC-NSG"],
    "policy_set_definitions": ["Enforce-Mandatory-Tags"],
    "role_definitions": [],
    "archetype_config": {
      "access_control": {
      }
    }
  }
}
```

You should now kick-off your Terraform workflow (init, plan, apply) to apply the new configuration. This can be done either locally or through a pipeline. When your workflow has finished, the `Enforce-Mandatory-Tags` policy set will be assigned at `es_root`.

## Assign the `Deny-NIC-NSG` Custom Policy Definition at the Landing Zones Management Group

As you have already saved the `Deny-NIC-NSG` Custom Policy Set at `es_root`, this gives us the ability to assign it at the `es_root` scope or at any scope beneath it. In this example, we will assign it at the `Landing Zones` Management Group. To do this, either update your existing `archetype_extension_es_landing_zones.tmpl.json` file or create one and copy the below code in to it and save.

```json
{
  "extend_es_landing_zones": {
    "policy_assignments": ["Deny-NIC-NSG"],
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

You should now kick-off your Terraform workflow (init, plan, apply) again to apply the updated configuration. This can be done either locally or through a pipeline. When your workflow has finished, the `Deny-NIC-NSG` Policy Definition will be assigned at the `Landing Zones` Management Group.

You have now successfully created and assigned both a Custom Policy Definition and a Custom Policy Set Definition within your Azure environment. You can re-use the steps in this article for any Custom Policies of your own that you may wish to use.
