## Overview

This page describes how to deploy Enterprise-scale with the [Connectivity resources][wiki_connectivity_resources] created in the current Subscription context, using custom configuration settings.

> **WARNING:** This deployment includes resource types which can incur increased consumption costs. Please take care to review the resources being deployed before proceeding.

The module supports customising almost any part of the configuration, however each subset of resources has it's own configuration block which is designed to simplify setting specific options.
For the Connectivity resources, this is configured through the [`configure_connectivity_resources`][configure_connectivity_resources] input variable.

In this example, we take the base [Deploy Connectivity resources][wiki_deploy_connectivity_resources] configuration and make the following changes:

- Add input variable on the root module for enabling/disabling Connectivity resources
- Add a local variable for `configure_connectivity_resources` and set custom values for the following:
  - Deploy a shared DDoS Protection Standard plan in the `northeurope` region
  - Deploy hub Virtual Networks to `northeurope` and `westeurope`
  - Deploy an ExpressRoute Gateway and Azure Firewall to the hub Virtual Network in `northeurope`
  - Deploy a VPN Gateway to the hub Virtual Network in `westeurope`
  - Remove the `AzureFirewallSubnet` Subnet from the hub Virtual Network in `westeurope`
  - Link the hub Virtual Network in `northeurope` and `westeurope` to the central DDoS Protection Standard plan
  - Ensure Private DNS Zones for Private Endpoints are enabled for `northeurope` and `westeurope` regions <sup>1</sup>
  - Set a different default location for Connectivity resources (controlled through an input variable on the root module)
  - Add custom resource tags for Connectivity resources (controlled through an input variable on the root module)

> <sup>1</sup> - The domain namespace for some Private Endpoints (e.g. Azure Batch) are bound to a specific Azure Region.
By default, the module will use the location set by the `configure_connectivity_resources.location` value, or the `default_location` value (`eastus`), in order of precedence.
To deploy Private DNS Zones to more locations for these resource types, update the `configure_connectivity_resources.settings.dns.config.private_link_locations` value to reflect the locations you want to enable.
Each value in this list must be in the shortname format (`uksouth`), and not DisplayName (`UK South`).
Setting this value will overwrite the default value.

The module allows for further customisation of the Connectivity resources through the `advanced` setting, however this is out-of-scope for this example.

> Use of the `advanced` setting is currently undocumented and experimental.
Please be aware that using this setting may result in future breaking changes.

If you've already deployed the [Connectivity resources using default settings][wiki_deploy_connectivity_resources], you will be able to see the changes made when moving to this configuration.

> Due to the way the Azure RM Provider manages dependencies, you may see a number of `azurerm_role_assignment` resources being replaced when updating Policy Assignments.
Unfortunately this is a product limitation, but should have minimal impact due to the way Azure Policy works.

If the `configure_connectivity_resources.location` value is not specified, the resources will default to the same location set by the [`default_location`][default_location] input variable.

> IMPORTANT: Ensure the module version is set to the latest, and don't forget to run `terraform init` if upgrading to a later version of the module.

![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/Azure/terraform-azurerm-caf-enterprise-scale?style=flat&logo=github)

## Example root module

To make the code easier to maintain when extending your configuration, we recommend splitting the root module into multiple files. For the purpose of this example, we use the following:

- [terraform.tf](#terraformtf)
- [variables.tf](#variablestf)
- [main.tf](#maintf)
- [settings.connectivity.tf](#settingsconnectivitytf)

> TIP: The exact number of resources created depends on the module configuration, but you can expect upwards of 320 resources to be created by the module for this example.

### `terraform.tf`

The `terraform.tf` file is used to set the provider configuration, including pinning to a specific version (or range of versions) for the AzureRM Provider. For production use, we recommend pinning to a specific version, and not using ranges.

```hcl
# Configure Terraform to set the required AzureRM provider
# version and features{} block.

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.77.0"
    }
  }
}

provider "azurerm" {
  features {}
}
```

If you wish to deploy the Connectivity resources to a different Subscription context than the one used for Core resources, please refer to our guide for [Multi-Subscription deployment][wiki_provider_configuration_multi].

### `variables.tf`

The `variables.tf` file is used to declare a couple of example variables which are used to customize deployment of this root module. Defaults are provided for simplicity, but these should be replaced or over-ridden with values suitable for your environment.

```hcl
# Use variables to customize the deployment

variable "root_id" {
  type    = string
  default = "myorg"
}

variable "root_name" {
  type    = string
  default = "My Organization"
}

variable "deploy_connectivity_resources" {
  type    = bool
  default = true
}

variable "log_retention_in_days" {
  type    = number
  default = 50
}

variable "security_alerts_email_address" {
  type    = string
  default = "my_valid_security_contact@replace_me" # Replace this value with your own email address.
}

variable "connectivity_resources_location" {
  type    = string
  default = "uksouth"
}

variable "connectivity_resources_tags" {
  type = map(string)
  default = {
    demo_type = "deploy_connectivity_resources_custom"
  }
}
```

### `main.tf`

The `main.tf` file contains the `azurerm_client_config` resource, which is used to determine the Tenant ID and Subscription ID values from your user connection to Azure. These are used to ensure the deployment will target your `Tenant Root Group` by default, and to populate the `subscription_id_connectivity` input variable.

It also contains the module declaration for this module, containing a number of customisations as needed to meet the specification defined in the overview above.

```hcl
# Get the current client configuration from the AzureRM provider.
# This is used to populate the root_parent_id variable with the
# current Tenant ID used as the ID for the "Tenant Root Group"
# Management Group.

data "azurerm_client_config" "core" {}

# Declare the Terraform Module for Cloud Adoption Framework
# Enterprise-scale and provide a base configuration.

module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "1.1.0"

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm
    azurerm.management   = azurerm
  }

  root_parent_id = data.azurerm_client_config.core.tenant_id
  root_id        = var.root_id
  root_name      = var.root_name

  deploy_connectivity_resources    = var.deploy_connectivity_resources
  subscription_id_connectivity     = data.azurerm_client_config.core.subscription_id
  configure_connectivity_resources = local.configure_connectivity_resources

}
```

### `settings.connectivity.tf`

The `settings.connectivity.tf` file contains a local variable containing the custom configuration for the `configure_connectivity_resources` input variable.
This helps to keep the module block clean, whilst providing clear separation between settings for different groups of resources.

```hcl
# Configure the connectivity resources settings.
locals {
  configure_connectivity_resources = {
    settings = {
      hub_networks = [
        {
          enabled = true
          config = {
            address_space                = ["10.100.0.0/16", ]
            location                     = "northeurope"
            link_to_ddos_protection_plan = true
            dns_servers                  = []
            bgp_community                = ""
            subnets                      = []
            virtual_network_gateway = {
              enabled = true
              config = {
                address_prefix           = "10.100.1.0/24"
                gateway_sku_expressroute = "ErGw2AZ"
                gateway_sku_vpn          = ""
              }
            }
            azure_firewall = {
              enabled = true
              config = {
                address_prefix   = "10.100.0.0/24"
                enable_dns_proxy = true
                availability_zones = {
                  zone_1 = true
                  zone_2 = true
                  zone_3 = true
                }
              }
            }
            spoke_virtual_network_resource_ids      = []
            enable_outbound_virtual_network_peering = true
          }
        },
        {
          enabled = true
          config = {
            address_space                = ["10.101.0.0/16", ]
            location                     = "westeurope"
            link_to_ddos_protection_plan = true
            dns_servers                  = []
            bgp_community                = ""
            subnets                      = []
            virtual_network_gateway = {
              enabled = true
              config = {
                address_prefix           = "10.101.1.0/24"
                gateway_sku_expressroute = ""
                gateway_sku_vpn          = "VpnGw2AZ"
              }
            }
            azure_firewall = {
              enabled = false
              config = {
                address_prefix   = ""
                enable_dns_proxy = true
                availability_zones = {
                  zone_1 = true
                  zone_2 = true
                  zone_3 = true
                }
              }
            }
            spoke_virtual_network_resource_ids      = []
            enable_outbound_virtual_network_peering = true
          }
        },
      ]
      vwan_hub_networks = []
      ddos_protection_plan = {
        enabled = true
        config = {
          location = "northeurope"
        }
      }
      dns = {
        enabled = true
        config = {
          location = null
          enable_private_link_by_service = {
            azure_automation_webhook             = true
            azure_automation_dscandhybridworker  = true
            azure_sql_database_sqlserver         = true
            azure_synapse_analytics_sqlserver    = true
            azure_synapse_analytics_sql          = true
            storage_account_blob                 = true
            storage_account_table                = true
            storage_account_queue                = true
            storage_account_file                 = true
            storage_account_web                  = true
            azure_data_lake_file_system_gen2     = true
            azure_cosmos_db_sql                  = true
            azure_cosmos_db_mongodb              = true
            azure_cosmos_db_cassandra            = true
            azure_cosmos_db_gremlin              = true
            azure_cosmos_db_table                = true
            azure_database_for_postgresql_server = true
            azure_database_for_mysql_server      = true
            azure_database_for_mariadb_server    = true
            azure_key_vault                      = true
            azure_kubernetes_service_management  = true
            azure_search_service                 = true
            azure_container_registry             = true
            azure_app_configuration_stores       = true
            azure_backup                         = true
            azure_site_recovery                  = true
            azure_event_hubs_namespace           = true
            azure_service_bus_namespace          = true
            azure_iot_hub                        = true
            azure_relay_namespace                = true
            azure_event_grid_topic               = true
            azure_event_grid_domain              = true
            azure_web_apps_sites                 = true
            azure_machine_learning_workspace     = true
            signalr                              = true
            azure_monitor                        = true
            cognitive_services_account           = true
            azure_file_sync                      = true
            azure_data_factory                   = true
            azure_data_factory_portal            = true
            azure_cache_for_redis                = true
          }
          private_link_locations                                 = []
          public_dns_zones                                       = []
          private_dns_zones                                      = []
          enable_private_dns_zone_virtual_network_link_on_hubs   = true
          enable_private_dns_zone_virtual_network_link_on_spokes = true
        }
      }
    }

    location = var.connectivity_resources_location
    tags     = var.connectivity_resources_tags
    advanced = null
  }
}
```

## Deployed Management Groups

![Deployed resource hierarchy](./media/examples-deploy-connectivity-custom-core.png)

You have successfully created the default Management Group resource hierarchy, along with the recommended Azure Policy and Access control (IAM) settings for Enterprise-scale.

You have also assigned the current Subscription from your provider configuration to the `connectivity` Management Group.

## Policy Assignment configuration

Check the following Policy Assignments to see how these have been configured with settings matching your Connectivity resources configuration set by `configure_connectivity_resources`:

- Scope = `connectivity`
  - `Enable-DDoS-VNET`
- Scope = `corp`
  - `Deploy-Private-DNS-Zones`

These Policy Assignments should all be assigned with custom parameter values based on your configuration, with `enforcement_mode` correctly set.
Once evaluated, the compliance state should also be updated and you can run remediation tasks to remediate any non-compliant resources.

## Deployed Connectivity resources

Once deployment is complete and policy has run, you should have the following Resource Groups deployed in your assigned Connectivity Subscription:

![Deployed Resources](./media/examples-deploy-connectivity-custom-rsgs.png)

You should see that each of the Resource Groups are aligned to regions based on the configuration.
In this case, they are set as follows:

- `myorg-asc-export` is set to `East US`, inherited from the module default for `default_location`.
- `myorg-connectivity-northeurope` is set to `North Europe`, set by the hardcoded `settings.hub_networks[0].config.location` value from the local variable `configure_connectivity_resources`.
- `myorg-connectivity-westeurope` is set to `West Europe`, set by the hardcoded `settings.hub_networks[1].config.location` value from the local variable `configure_connectivity_resources`.
- `myorg-ddos` is set to `North Europe`, set by the hardcoded `settings.ddos_protection_plan.config.location` value from the local variable `configure_connectivity_resources`.
- `myorg-dns` is set to `UK South`, set by the default value for `var.connectivity_resources_location` which is assigned to the `settings.location` value from the local variable `configure_connectivity_resources`.
- `NetworkWatcherRG` is set to `West Europe`, matching the first region where a Virtual Network was deployed and remediated by Policy.

In general, the Resource Group will be set to the same location as the resources within.

> **NOTE:** `myorg-asc-export` is related to the [Management resources][wiki_management_resources].
This should contain a hidden `microsoft.security/automations` resource `ExportToWorkspace` once the [Management resources][wiki_management_resources] are configured and Azure Policy has completed remediation.
`NetworkWatcherRG` is also automatically generated by policy as part of the Virtual Network creation.

### Resource Group `myorg-connectivity-northeurope`

The Resource Group `myorg-connectivity-northeurope` should be created and contain the following resources:

![Deployed Resources](./media/examples-deploy-connectivity-custom-rsg-myorg-connectivity-northeurope.png)

When you explore the configuration, note that `myorg-hub-northeurope` is pre-configured with Subnets for `GatewaySubnet` and `AzureFirewallSubnet`.
These are now used by the created ExpressRoute Gateway and Azure Firewall resources.
DDoS Protection Standard should also be set to `Enable` and connected to the DDoS protection plan `myorg-ddos-northeurope`.

### Resource Group `myorg-connectivity-westeurope`

The Resource Group `myorg-connectivity-westeurope` should be created and contain the following resources:

![Deployed Resources](./media/examples-deploy-connectivity-custom-rsg-myorg-connectivity-westeurope.png)

When you explore the configuration, note that `myorg-hub-westeurope` is pre-configured with a Subnet for `GatewaySubnet` only. The `AzureFirewallSubnet` is no longer deployed as we removed the `azure_firewall.config.address_prefix` value for the this hub network.
This now used by the created VPN Gateway resource.
DDoS Protection Standard should also be set to `Enable` and connected to the DDoS protection plan `myorg-ddos-northeurope`.

### Resource Group `myorg-ddos`

In this example, we have now deployed a DDoS protection plan (Standard).
The Enterprise-scale recommendation is to deploy a single, centralised DDoS protection plan.
As such, the Resource Group name doesn't include the location.

The Resource Group and DDoS protection plan are created in `northeurope`, as specified via the `ddos_protection_plan.config.location` value.

![Deployed Resources](./media/examples-deploy-connectivity-custom-rsg-myorg-ddos.png)

### Resource Group `myorg-dns`

The Resource Group is created in `UK South`, as per the default example. This was set by the default value for `var.connectivity_resources_location` which is assigned to the `settings.location` value from the local variable `configure_connectivity_resources`.
All Private DNS Zone resources are `Global`.

![Deployed Resources](./media/examples-deploy-connectivity-custom-rsg-myorg-dns.png)

By default we create a Private DNS Zone for all services which currently [support Private Endpoints][azure_private_endpoint_support].
New Private DNS Zones may be added in future releases as additional services release Private Endpoint support.

In this example, we have also enabled additional Private DNS Zones for the services which use region-bound endpoints:

- `northeurope.privatelink.siterecovery.windowsazure.com`
- `privatelink.northeurope.azmk8s.io`
- `privatelink.northeurope.backup.windowsazure.com`
- `privatelink.westeurope.azmk8s.io`
- `privatelink.westeurope.backup.windowsazure.com`
- `westeurope.privatelink.siterecovery.windowsazure.com`

We also configure `Virtual network links` to connect each Private DNS Zone to the hub Virtual Networks, which in this example are `myorg-hub-northeurope` and `myorg-hub-westeurope`.

> **NOTE:** As we have defined custom locations, note that the default `eastus` location is no longer included.

## Additional considerations

If you are using [Archetype Exclusions][archetype_exclusions] or [custom Archetypes][custom_archetypes] in your code, make sure to not disable DDoS or DNS policies if you require policy integration using this module.
The relationship between the resources deployed and the Policy parameters is dependent on [specific Policy Assignments](#policy-assignment-configuration) being used.

## Next steps

Take particular note of the following additional changes:

- All Private DNS zones are linked to both hub Virtual Networks in `northeurope` and `westeurope`.
- Both Virtual Networks in `northeurope` and `westeurope` are linked to the DDoS protection plan.
- As we defined custom locations for `dns.config.private_link_locations`, note that the default `eastus` location is no longer included in the Private DNS Zone locations.

Try updating the configuration settings in the `configure_connectivity_resources` local variable to see how this changes your configuration.
Also try setting your own values in the input variables, and toggling the `deploy_connectivity_resources` input variable to see which resources are created/destroyed.

For more information regarding configuration of this module, please refer to the [Module Variables](./%5BUser-Guide%5D-Module-Variables) documentation.

Looking for further inspiration? Why not try some of our other [examples][wiki_examples]?

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

[ESLZ-Connectivity]: https://docs.microsoft.com/azure/cloud-adoption-framework/ready/enterprise-scale/network-topology-and-connectivity

[azure_private_endpoint_support]: https://docs.microsoft.com/azure/private-link/private-endpoint-dns#azure-services-dns-zone-configuration "Azure services DNS zone configuration"

[wiki_management_resources]:         ./%5BUser-Guide%5D-Management-Resources "Wiki - Management Resources."
[wiki_connectivity_resources]:         ./%5BUser-Guide%5D-Connectivity-Resources "Wiki - Connectivity Resources."
[wiki_deploy_connectivity_resources]:  ./%5BExamples%5D-Deploy-Connectivity-Resources "Wiki - Deploy Connectivity Resources."
[wiki_provider_configuration_multi]:   ./%5BUser-Guide%5D-Provider-Configuration#multi-subscription-deployment "Wiki - Provider Configuration - Multi-Subscription deployment."
[wiki_examples]:                       ./Examples "Wiki - Examples"

[configure_connectivity_resources]: ./%5BVariables%5D-configure_connectivity_resources "Instructions for how to use the configure_connectivity_resources variable."
[deploy_connectivity_resources]:    ./%5BVariables%5D-deploy_connectivity_resources "Instructions for how to use the deploy_connectivity_resources variable."
[subscription_id_connectivity]:     ./%5BVariables%5D-subscription_id_connectivity "Instructions for how to use the subscription_id_connectivity variable."
[default_location]:                 ./%5BVariables%5D-default_location "Instructions for how to use the default_location variable."
[archetype_exclusions]:             ./%5BExamples%5D-Expand-Built-in-Archetype-Definitions#to-enable-the-exclusion-function "Wiki - Expand Built-in Archetype Definitions # To enable the exclusion function"
[custom_archetypes]:                ./%5BUser-Guide%5D-Archetype-Definitions "[User Guide] Archetype Definitions"

[azure_tag_support]: https://docs.microsoft.com/azure/azure-resource-manager/management/tag-support "Tag support for Azure resources"