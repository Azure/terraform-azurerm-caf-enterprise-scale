# [v3.4.0] Policy Refresh

## Overview

The `v3.4.0` release includes ...

### New features

- Support for version 3.54.0 of the `azurerm` provider. This is a breaking change and will require updates to your calling module.
- Upstream policy definition and assignment updates have now been included in this module. Full details of the policy updates can be found [here](https://github.com/Azure/Enterprise-Scale/wiki/Whats-new#april-2023).
- Support for policy assignment overrides as per [these docs](https://learn.microsoft.com/en-gb/azure/governance/policy/concepts/assignment-structure#overrides-preview).

#### Policy Update details

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

**Full Changelog**: [v3.3.0...v3.4.0](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/compare/v3.3.0...v3.4.0)
