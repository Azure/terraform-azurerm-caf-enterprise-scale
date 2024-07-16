<!-- markdownlint-disable first-line-h1 -->
## Overview

This is a major release, following the update of Azure Landing Zones with it's major policy refresh and move to Azure Monitoring Agent from Microsoft Monitoring Agent.

## ‼️ Breaking Changes

1. Minimum AzureRM provider version now `3.107.0`
2. Minimum Terraform version now `1.7.0`
3. `var.configure_management_resources` schema change, removing legacy components and adding support for AMA resources

## Incorporates the following changes from upstream

1. [Policy refresh H2 FY24](https://github.com/Azure/Enterprise-Scale/pull/1651)
2. [AMA Updates](https://github.com/Azure/Enterprise-Scale/pull/1649)

## Policy Refresh

See: <https://github.com/Azure/Enterprise-Scale/wiki/ALZ-Policies>

- Move to built-in policies for deployment of diagnostic settings (original assignment will be moved to new definitions)
- Move to built-in policies for deployment of Azure Monitor Agent

## Azure Monitor Agent

The Microsoft Monitoring Agent is deprecated and all assignments have been removed, however the policy definitions remain.
We now assign polices that deploy the Azure Monitor Agent (AMA) instead of the Microsoft Monitoring Agent (MMA).
We deploy AMA resources using the new `configure_management_resources` variable.

### New resources

- A user-assigned managed identity (UAMI) for the AMA agent to authenticate with Azure Monitor (this needs no special tole assignments, any valid identity will suffice)
- Data collection rule for VM Insights
- Data collection rule for Change Tracking
- Data collection rule for Defender for SQL

Going forward, this module will not provide support for the MMA, and will only support the AMA.
If you wish to continue using the MMA, you will need to manage this outside of the module.

### Microsoft Monitoring Agent (MMA) Cleanup

As MMA resources were deployed using Azure Policy (DeployIfNotExists), the resources will not be cleaned up automatically.
You will need to manually clean up the resources.
Please see product group guidance on how to clean up the MMA resources: <https://learn.microsoft.com/azure/azure-monitor/agents/azure-monitor-agent-mma-removal-tool?tabs=single-tenant%2Cdiscovery>.

We will publish a link to additional ALZ tooling once it is published.

## Notable changes from our awesome community

1. feat: new private DNS zones: [#918](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/pull/918) (thanks @chrsundermann!)
2. feat: new virtual network gateway routing parameters: [#925](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/pull/925) (thanks @nyanhp!)
3. fix: mg diag setting location: [#952](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/pull/952) (thanks @Keetika-Yogendra!)

### `configure_management_resources`

This has been updated, the changed sections are shown below.
Note the removal of deprecated log analytics solutions and the addition of the new AMA settings.

```terraform
variable "configure_management_resources" {
  type = object({
    settings = optional(object({
      ama = optional(object({
        enable_uami                                                         = optional(bool, true)
        enable_vminsights_dcr                                               = optional(bool, true)
        enable_change_tracking_dcr                                          = optional(bool, true)
        enable_mdfc_defender_for_sql_dcr                                    = optional(bool, true)
        enable_mdfc_defender_for_sql_query_collection_for_security_research = optional(bool, true)
      }), {})
      log_analytics = optional(object({
        enabled = optional(bool, true)
        config = optional(object({
          retention_in_days          = optional(number, 30)
          enable_monitoring_for_vm   = optional(bool, true)
          enable_monitoring_for_vmss = optional(bool, true)
          enable_sentinel            = optional(bool, true)
          enable_change_tracking     = optional(bool, true)
        }), {})
      }), {})
      ### ... (other settings, no changes)
    }), {})
  })
}
```

## Acknowledgements

Thanks to:

- @JamesDLD for providing a helpful contribution for the DCRs
- @jaredfholgate for the policy sync process work and code review
- @arjenhuitema for his awesome work on the AMA design
- @springstone for an awesome policy refresh effort
- @jtracey93 for his technical assurance and oversight

**Full Changelog**: [v5.2.1...v6.0.0](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/compare/v5.2.1...v6.0.0)

## Next steps

Take a look at the latest [User Guide](User-Guide) documentation and our [Examples](Examples) to understand the latest module configuration options, and review your implementation against the changes documented on this page.

## Need help?

If you're running into problems with the upgrade, please let us know via the [GitHub Issues](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues).
We will do our best to point you in the right direction.
