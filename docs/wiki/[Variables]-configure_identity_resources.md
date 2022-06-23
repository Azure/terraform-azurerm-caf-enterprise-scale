<!-- markdownlint-disable first-line-h1 -->
## Overview

[**configure_identity_resources**](#overview) [*see validation for type*](#Validation) (optional)

If specified, will customize the "identity" landing zone settings and resources.

## Default value

<!-- markdownlint-disable-next-line no-inline-html -->
<details><summary>Click to view code...</summary>

```hcl
{
  settings = {
    identity = {
      enabled = true
      config = {
        enable_deny_public_ip             = true
        enable_deny_rdp_from_internet     = true
        enable_deny_subnet_without_nsg    = true
        enable_deploy_azure_backup_on_vms = true
      }
    }
  }
}
```

</details>

## Validation

Validation provided by schema:

<!-- markdownlint-disable-next-line no-inline-html -->
<details><summary>Click to view code...</summary>

```hcl
object({
  settings = object({
    identity = object({
      enabled = bool
      config = object({
        enable_deny_public_ip             = bool
        enable_deny_rdp_from_internet     = bool
        enable_deny_subnet_without_nsg    = bool
        enable_deploy_azure_backup_on_vms = bool
      })
    })
  })
})
```

</details>

## Usage

Configure settings for the `identity` landing zone resources.
This is sub divided into configuration objects for the following:

- [Configure identity policy assignments](#configure-identity-policy-assignments)

### Configure identity policy assignments

#### `settings.identity.enabled`

The `enabled` (`bool`) input allows you to toggle whether to enable the identity policy assignments settings managed by the module.

#### `settings.identity.config`

The `config` object allows you to set the following configuration settings:

##### `settings.identity.config.enable_deny_public_ip`

Provides granular control over the [enforcementMode][msdocs_policy_enforcement] property on the following policy assignments associated with the `identity` management group:

- Deny the creation of public IP

##### `settings.identity.config.enable_deny_rdp_from_internet`

Provides granular control over the [enforcementMode][msdocs_policy_enforcement] property on the following policy assignments associated with the `identity` management group:

- RDP access from the Internet should be blocked

##### `settings.identity.config.enable_deny_subnet_without_nsg`

Provides granular control over the [enforcementMode][msdocs_policy_enforcement] property on the following policy assignments associated with the `identity` management group:

- Subnets should have a Network Security Group

##### `settings.identity.config.enable_deploy_azure_backup_on_vms`

Provides granular control over the [enforcementMode][msdocs_policy_enforcement] property on the following policy assignments associated with the `identity` management group:

- Configure backup on virtual machines without a given tag to a new recovery services vault with a default policy

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

[this_page]: # "Link for the current page."

[msdocs_policy_enforcement]: https://docs.microsoft.com/azure/governance/policy/concepts/assignment-structure#enforcement-mode "Azure Policy - Enforcement Mode"
