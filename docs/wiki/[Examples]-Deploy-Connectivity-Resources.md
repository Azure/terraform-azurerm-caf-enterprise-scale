<!-- markdownlint-disable first-line-h1 -->
## Overview

This page describes how to deploy Azure landing zones with connectivity resources based on the [Traditional Azure networking topology (hub and spoke)][wiki_connectivity_resources_hub_and_spoke] created in the current Subscription context, using the default configuration settings.

> **NOTE:**
> If you need to deploy a network based on Virtual WAN, please see our [Deploy Connectivity Resources (Virtual WAN)][wiki_deploy_virtual_wan_resources] example.

As connectivity resources can start to significantly increase Azure consumption costs, the module defaults are aimed to help build the basic connectivity configuration whilst minimizing cost.
Please refer to the [Network topology and connectivity][alz_connectivity] recommendations to better understand which of these settings you should enable in a Production environment.

In this example, we take the [default configuration][wiki_deploy_default_configuration] and make the following changes:

- Set `deploy_connectivity_resources` to enable creation of the default Connectivity resources, including:
  - Resource Groups to contain all connectivity resources.
  - Virtual Network to use as a hub for hybrid-connectivity.
  - Azure private DNS zones for private endpoints.
- Set `subscription_id_connectivity` to ensure the Subscription is moved to the correct Management Group, and policies are updated with the correct values.

When `deploy_connectivity_resources` is set to `true`, the module updates the `parameters` and `enforcement_mode` for a number of policy assignments, to enable features relating to the DDoS protection plan and private DNS zones for private endpoints.

<!-- Some private DNS zones for private endpoints are bound to a specific Azure Region.
By default, the module will use the location set for connectivity resources, or the `default_location` value (`eastus`), in order of precedence.
To add more locations, simply add them to the `configure_connectivity_resources.settings.dns.config.private_link_locations` value.
This must be in the short format (`uksouth`), and not DisplayName (`UK South`). -->

> **IMPORTANT:**
> Ensure the module version is set to the latest, and don't forget to run `terraform init` if upgrading to a later version of the module.

![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/Azure/terraform-azurerm-caf-enterprise-scale?style=flat&logo=github)

## Example root module

To create the Connectivity resources, `deploy_connectivity_resources` must be set to `true`, and the `subscription_id_connectivity` is also required.

Although `subscription_id_connectivity` is required, the subscription used for creation of resources is determined by the [provider configuration][wiki_provider_configuration].
Please ensure you have a provider configured with access to the same subscription specified by `subscription_id_connectivity`, and map this to `azurerm.connectivity` in the module providers object.

> **TIP:**
> The exact number of resources created depends on the module configuration, but you can expect upwards of 260 resources to be created by the module for this example.

To keep this example simple, the root module for this example is based on a single file:

### `main.tf`

```hcl
# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used.

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.107"
    }
  }
}

provider "azurerm" {
  features {}
}

# You can use the azurerm_client_config data resource to dynamically
# extract connection settings from the provider configuration.

data "azurerm_client_config" "core" {}

# Call the caf-enterprise-scale module directly from the Terraform Registry
# pinning to the latest version

module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "<version>" # change this to your desired version, https://www.terraform.io/language/expressions/version-constraints

  default_location = "<YOUR_LOCATION>"

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm
    azurerm.management   = azurerm
  }

  root_parent_id = data.azurerm_client_config.core.tenant_id
  root_id        = "myorg"
  root_name      = "My Organization"

  deploy_connectivity_resources = true
  subscription_id_connectivity  = data.azurerm_client_config.core.subscription_id
}
```

## Deployed Management Groups

![Deployed resource hierarchy](media/examples-deploy-connectivity-core.png)

You have successfully created the default management group resource hierarchy, along with the recommended Azure Policy and Access control (IAM) settings for your Azure landing zone.

You have also assigned the current subscription from your provider configuration to the `connectivity` management group.

## Policy Assignment configuration

Check the following policy assignments to see how these have been configured with default settings for parameters and enforcement mode:

- Scope = `connectivity` and `landing-zones`
  - `Enable-DDoS-VNET`
- Scope = `corp`
  - `Deploy-Private-DNS-Zones`

> You may want to [Deploy Connectivity Resources With Custom Settings (Hub and Spoke)][wiki_deploy_connectivity_resources_custom] to change some of these settings.

## Deployed Connectivity resources

Once deployment is complete and policy has run, you should have the following resource groups deployed in your assigned connectivity subscription:

![Deployed Resources](media/examples-deploy-connectivity-rsgs.png)

> **NOTE:**
> `myorg-asc-export` is related to the [management resources][wiki_management_resources].
> This should contain a hidden `microsoft.security/automations` resource `ExportToWorkspace` once the [management resources][wiki_management_resources] are configured and Azure Policy has completed remediation.
> `NetworkWatcherRG` is also automatically generated by the Azure platform when at least one virtual network is created within the subscription.

### Resource Group `myorg-connectivity-eastus`

The Resource Group `myorg-connectivity-eastus` should be created, and will initially contain a single virtual network with the name `myorg-hub-eastus`.

![Deployed Resources](media/examples-deploy-connectivity-rsg.png)

When you explore the configuration, note that `myorg-hub-eastus` is pre-configured with subnets for `GatewaySubnet` and `AzureFirewallSubnet`.
DDoS Network Protection should also be disabled to reduce costs, although we recommend you **enable this for production environments**.
The location of both the resource group and virtual network is created in the region specified via the `default_location` input variable, which uses the default value of `eastus` in this example.
These settings can all be changed if needed!

### Resource Group `myorg-dns`

As DNS resource are `Global` resources, the resource group is created in the region specified via the `default_location` input variable, which uses the default value of `eastus` in this example.
All private DNS zone resources are `Global`.

![Deployed Resources](media/examples-deploy-connectivity-dns-rsg.png)

By default we create a private DNS zone for all services which currently [support private endpoints][azure_private_endpoint_support].
New private DNS zones may be added in future releases as additional services release private endpoint support.

We also configure `virtual network links` to connect each private DNS zone to the hub virtual network, which in this example is `myorg-hub-eastus`.
This can be optionally enabled for spoke virtual networks being peered to the hub virtual network.

## Additional considerations

If you are using [archetype exclusions][wiki_archetype_exclusions] or [custom archetypes][wiki_custom_archetypes] in your code, make sure to not disable DDoS or DNS policies if you require policy integration using this module.
The relationship between the resources deployed and the policy parameters are dependent on [specific policy assignments](#policy-assignment-configuration) being used.

## Next steps

Go to our next example to learn how to deploy the [Connectivity resources with custom settings][wiki_deploy_connectivity_resources_custom].

To learn more about module configuration using input variables, please refer to the [Module Variables][wiki_module_variables] documentation.

Looking for further inspiration? Why not try some of our other [examples][wiki_examples]?

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

[alz_connectivity]: https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/network-topology-and-connectivity "Network topology and connectivity for Azure landing zones on the Cloud Adoption Framework."

[azure_private_endpoint_support]: https://learn.microsoft.com/azure/private-link/private-endpoint-dns#azure-services-dns-zone-configuration "Azure services DNS zone configuration"

[wiki_module_variables]:                     %5BUser-Guide%5D-Module-Variables "Wiki - Module Variables"
[wiki_provider_configuration]:               %5BUser-Guide%5D-Provider-Configuration "Wiki - Provider Configuration"
[wiki_connectivity_resources_hub_and_spoke]: %5BUser-Guide%5D-Connectivity-Resources#traditional-azure-networking-topology-hub-and-spoke "Wiki - Connectivity Resources - Traditional Azure networking topology (hub and spoke)"
[wiki_deploy_connectivity_resources_custom]: %5BExamples%5D-Deploy-Multi-Region-Networking-With-Custom-Settings "Wiki - Deploy multi region networking with custom settings (Hub and Spoke)"
[wiki_deploy_virtual_wan_resources]:         %5BExamples%5D-Deploy-Virtual-WAN-Resources "Wiki - Deploy Connectivity Resources (Virtual WAN)"
[wiki_examples]:                             Examples "Wiki - Examples"
[wiki_management_resources]:                 %5BUser-Guide%5D-Management-Resources "Wiki - Management Resources"
[wiki_deploy_default_configuration]:         %5BExamples%5D-Deploy-Default-Configuration "Wiki - Deploy Default Configuration"
[wiki_archetype_exclusions]:                 %5BExamples%5D-Expand-Built-in-Archetype-Definitions#to-enable-the-exclusion-function "Wiki - Expand Built-in Archetype Definitions # To enable the exclusion function"
[wiki_custom_archetypes]:                    %5BUser-Guide%5D-Archetype-Definitions "[User Guide] Archetype Definitions"
