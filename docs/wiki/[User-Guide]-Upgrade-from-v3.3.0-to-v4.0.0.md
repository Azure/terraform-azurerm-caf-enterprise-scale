<!-- markdownlint-disable first-line-h1 -->
## Overview

The `v4.0.0` release is predominantly a policy refresh release that brings the latest policy changes from the upstream reference.

### New features

- Support for version 3.54.0 of the `azurerm` provider. This is a breaking change and will require updates to your calling module.
- Upstream policy definition and assignment updates have now been included in this module. Full details of the policy updates can be found [here](https://github.com/Azure/Enterprise-Scale/wiki/Whats-new#april-2023).
- Support for policy assignment overrides as per [these docs](https://learn.microsoft.com/en-gb/azure/governance/policy/concepts/assignment-structure#overrides-preview).
- Azure Firewall Basic
- Policy Enforcement Mode control for built-in archetypes

### Breaking Policy Changes

The policy initiative `Enforce-EncryptTransit` has reduced some parameters and will therefore need to be either manually deleted (with any assignments), or the resource (and any assignments) will need to be tainted to force a redeployment with the new module version.
To taint the resources, run the following commands:

```bash
# Taint the definintion
terraform taint 'module.<MODULE_REFERENCE>.azurerm_policy_set_definition.enterprise_scale["/providers/Microsoft.Management/managementGroups/<YOUR_ROOT_MG>/providers/Microsoft.Authorization/policySetDefinitions/Enforce-EncryptTransit"]'

# Taint the assignment
terraform taint 'module.<MODULE_REFERENCE>.azurerm_management_group_policy_assignment.enterprise_scale["/providers/Microsoft.Management/managementGroups/<YOUR_LANDING_ZONES_MG>/providers/Microsoft.Authorization/policyAssignments/Enforce-TLS-SSL"]'
```

#### How to Retain the Previous Set of Policies

If you want to use the v3.3.0 version of policies, you can add the following files as per [these docs](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Expand-Built-in-Archetype-Definitions):

##### archetype_extension_es_corp.tmpl.json

```json
{
  "extend_es_corp": {
    "policy_assignments": [
      "Deny-DataB-Pip",
      "Deny-DataB-Sku",
      "Deny-DataB-Vnet"
    ],
    "policy_definitions": [],
    "policy_set_definitions": [],
    "role_definitions": [],
    "archetype_config": {
      "parameters": {},
      "access_control": {}
    }
  }
}
```

##### archetype_exclusion_es_corp.tmpl.json

```json
{
  "exclude_es_corp": {
    "policy_assignments": [
      "Audit-PeDnsZones",
      "Deny-HybridNetworking",
      "Deny-Public-IP-On-NIC",
    ],
    "policy_definitions": [],
    "policy_set_definitions": [],
    "role_definitions": [],
    "archetype_config": {
      "parameters": {},
      "access_control": {}
    }
  }
}
```

##### archetype_exclusion_es_decommissioned.tmpl.json

```json
{
  "exclude_es_decommissioned": {
    "policy_assignments": [
      "Enforce-ALZ-Decomm"
    ],
    "policy_definitions": [],
    "policy_set_definitions": [],
    "role_definitions": [],
    "archetype_config": {
      "parameters": {},
      "access_control": {}
    }
  }
}
```

##### archetype_extension_es_identity.tmpl.json

```json
{
  "extend_es_identity": {
    "policy_assignments": [
      "Deny-RDP-From-Internet"
    ],
    "policy_definitions": [],
    "policy_set_definitions": [],
    "role_definitions": [],
    "archetype_config": {
      "parameters": {},
      "access_control": {}
    }
  }
}
```

##### archetype_exclusion_es_identity.tmpl.json

```json
{
  "exclude_es_identity": {
    "policy_assignments": [
      "Deny-MgmtPorts-Internet"
    ],
    "policy_definitions": [],
    "policy_set_definitions": [],
    "role_definitions": [],
    "archetype_config": {
      "parameters": {},
      "access_control": {}
    }
  }
}
```

##### archetype_extension_es_landing_zones.tmpl.json

```json
{
  "extend_es_landing_zones": {
    "policy_assignments": [
      "Deny-RDP-From-Internet",
      "Deploy-SQL-DB-Auditing"
    ],
    "policy_definitions": [],
    "policy_set_definitions": [],
    "role_definitions": [],
    "archetype_config": {
      "parameters": {},
      "access_control": {}
    }
  }
}
```

##### archetype_exclusion_es_landing_zones.tmpl.json

```json
{
  "exclude_es_landing_zones": {
    "policy_assignments": [
      "Audit-AppGW-WAF",
      "Deny-MgmtPorts-Internet",
      "Deploy-AzSqlDb-Auditing",
      "Enforce-GR-KeyVault"
    ],
    "policy_definitions": [],
    "policy_set_definitions": [],
    "role_definitions": [],
    "archetype_config": {
      "parameters": {},
      "access_control": {}
    }
  }
}
```

##### archetype_exclusion_es_platform.tmpl.json

```json
{
  "exclude_es_platform": {
    "policy_assignments": [
      "Deny-MgmtPorts-Internet",
      "Deny-Subnet-Without-Nsg",
      "Deploy-Log-Analytics",
      "Deploy-VM-Backup"
    ],
    "policy_definitions": [],
    "policy_set_definitions": [],
    "role_definitions": [],
    "archetype_config": {
      "parameters": {},
      "access_control": {}
    }
  }
}
```

##### archetype_exclusion_es_root.tmpl.json

```json
{
  "exclude_es_root": {
    "policy_assignments": [
      "Audit-UnusedResources",
      "Deny-Classic-Resources",
      "Deny-UnmanagedDisk",
      "Deploy-MDEndpoints",
      "Deploy-MDFC-OssDb",
      "Deploy-MDFC-SqlAtp",
      "Enforce-ACSB"
    ],
    "policy_definitions": [],
    "policy_set_definitions": [],
    "role_definitions": [],
    "archetype_config": {
      "parameters": {},
      "access_control": {}
    }
  }
}
```

##### archetype_exclusion_es_sandboxes.tmpl.json

```json
{
  "exclude_es_sandboxes": {
    "policy_assignments": [
      "Enforce-ALZ-Sandbox"
    ],
    "policy_definitions": [],
    "policy_set_definitions": [],
    "role_definitions": [],
    "archetype_config": {
      "parameters": {},
      "access_control": {}
    }
  }
}
```

### Fixed issues

There are no bug fixes in this release, it is just a policy refresh release.

## For more information

**Full Changelog**: [v3.3.0...v4.0.0](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/compare/v3.3.0...v4.0.0)

## Next steps

Take a look at the latest [User Guide](User-Guide) documentation and our [Examples](Examples) to understand the latest module configuration options, and review your implementation against the changes documented on this page.

## Need help?

If you're running into problems with the upgrade, please let us know via the [GitHub Issues](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues).
We will do our best to point you in the right direction.
