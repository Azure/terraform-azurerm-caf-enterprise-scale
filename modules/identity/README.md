<!-- BEGIN_TF_DOCS -->
# Identity sub-module

> [!IMPORTANT]
> For new deployments we now recommend using Azure Verified Modules for Platform Landing Zones.
> Please see the documentation at <https://aka.ms/alz/tf>.

## ⚠️ DEPRECATION NOTICE

**This module is now in extended support mode and will be archived on August 1, 2026.**

### Current Status
- **Extended Support Period**: This module is now in extended support for one year (until August 1, 2026)
- **Support Scope**: During this period, we will provide quality updates and policy updates only
- **No New Features**: No new features or functionality will be added to this module

### Migration Path
We strongly recommend that all users migrate to the new **Azure Verified Modules** approach for Azure Landing Zones. This new approach provides:
- Enhanced reliability and testing
- Improved modularity and flexibility
- Better alignment with Azure best practices
- Ongoing feature development and support

**Further reading**: Please read our recent [blog](https://techcommunity.microsoft.com/blog/azuretoolsblog/terraform-azure-verified-modules-for-platform-landing-zone-alz-migration-guidanc/4432035)

**Migration Guide**: Please visit [aka.ms/alz/tf/migrate](https://aka.ms/alz/tf/migrate) for detailed migration guidance and resources.

### Timeline
- **Now - August 1, 2026**: Extended support (quality and policy updates only)
- **August 1, 2026**: Repository will be archived and no further updates will be made

### Questions?
If you have questions about the migration process or need assistance, please refer to the migration documentation or raise an issue in the repository before the archive date.

## Documentation
<!-- markdownlint-disable MD033 -->

## Requirements

No requirements.

## Modules

No modules.

<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD034 -->
## Required Inputs

The following input variables are required:

### <a name="input_enabled"></a> [enabled](#input\_enabled)

Description: Controls whether to manage the identity landing zone policies and deploy the identity resources into the current Subscription context.

Type: `bool`

### <a name="input_root_id"></a> [root\_id](#input\_root\_id)

Description: Specifies the ID of the Enterprise-scale root Management Group, used as a prefix for resources created by this module.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_settings"></a> [settings](#input\_settings)

Description: Configuration settings for the "Identity" landing zone resources.

Type:

```hcl
object({
    identity = optional(object({
      enabled = optional(bool, true)
      config = optional(object({
        enable_deny_public_ip             = optional(bool, true)
        enable_deny_rdp_from_internet     = optional(bool, true)
        enable_deny_subnet_without_nsg    = optional(bool, true)
        enable_deploy_azure_backup_on_vms = optional(bool, true)
      }), {})
    }), {})
  })
```

Default: `{}`

## Resources

No resources.

## Outputs

The following outputs are exported:

### <a name="output_configuration"></a> [configuration](#output\_configuration)

Description: Returns the configuration settings for resources to deploy for the identity solution.

<!-- markdownlint-enable -->
<!-- END_TF_DOCS -->