<!-- markdownlint-disable first-line-h1 -->
## Summary

The caf-enterprise-scale module contains outputs with the purpose of _providing all configuration arguments for every azure resource created by the module._  This in turn allows you to dynamically utilize resource attributes from the caf-enterprise-scale module in other parts of your Terraform configuration within the root module.

This guide will list all the outputs and detail how they can be used.

## `outputs.tf` File Structure Overview

The `outputs.tf` file within the caf-enterprise-scale module comprises of a different output for every resource type (e.g. `azurerm_management_group`, `azurerm_resource_group` etc.). Then within each output is a map of each _local name_ (instance) of the given resource type to the associated resource block. e.g.

```hcl
output "azurerm_resource_group" {
  value = {
    management   = azurerm_resource_group.management
    connectivity = azurerm_resource_group.connectivity
    virtual_wan  = azurerm_resource_group.virtual_wan
  }
 ...
}
```

## Accessing Resource Configuration from Outputs

Most resource blocks within the caf-enterprise-scale module are responsible for creating multiple resource instances through the `for_each` meta-argument, and by definition, in Terraform, resource instances are identified by the map key from the value provided to `for_each` (See [Referring to Instances][terraform_resource_instances] for more information).

In the caf-enterprise-scale module the map keys are always the `resource_id` of the resource instance that the resource block is creating.

### Example

The following code extract will show us accessing the configuration arguments of the `azurerm_firewall` resource:

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

output "azurerm_firewall_connectivity" {
  value = module.enterprise_scale.azurerm_firewall.connectivity["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/contoso-connectivity-eastus/providers/Microsoft.Network/azureFirewalls/contoso-fw-eastus"]
}
```

Now we can export attributes from the output containing the resource such as `location` or `sku_tier` (i.e. `outputs.azurerm_firewall_connectivity.location`, `outputs.azurerm_firewall_connectivity.sku_tier`).

### General Formula

In general for any given resource we have:

```hcl
module "enterprise_scale" {
...
}

output "azurerm_resource" {
  value = module.enterprise_scale.<RESOURCE TYPE>.<LOCAL NAME>[<RESOURCE ID>]
}
```

### Re-mapping with Friendly Keys

The `resource_id` can be too long and complex, alternatively we can redefine the map keys to use friendly names. Take for example the following which maps the location of the virtual networks to the virtual networks' configuration values:

```hcl
module "enterprise_scale" {
...
}

output "azurerm_virtual_network" {
  value = {
    for k,v in module.enterprise_scale.azurerm_virtual_network.connectivity:
      v.location => v
    }
}
```

In this scenario, We can now export attributes from the virtual network in `eastus`, such as `name` or `address_space` (i.e. `outputs.azurerm_virtual_network.eastus.name`, `outputs.azurerm_virtual_network.address_space`).

> **NOTE:** The new map keys used must be unique relatively within the map.

## List of Module Outputs

```hcl
# The following output is used to ensure all Management Group
# data is returned to the root module.
output "azurerm_management_group" {
  value = {
    level_1 = azurerm_management_group.level_1
    level_2 = azurerm_management_group.level_2
    level_3 = azurerm_management_group.level_3
    level_4 = azurerm_management_group.level_4
    level_5 = azurerm_management_group.level_5
    level_6 = azurerm_management_group.level_6
  }
  description = "Returns the configuration data for all Management Groups created by this module."
}

# The following output is used to ensure all Management Group
# Subscription Association data is returned to the root module.
output "azurerm_management_group_subscription_association" {
  value = {
    enterprise_scale = azurerm_management_group_subscription_association.enterprise_scale
  }
  description = "Returns the configuration data for all Management Group Subscription Associations created by this module."
}

# The following output is used to ensure all Policy
# Definition data is returned to the root module.
output "azurerm_policy_definition" {
  value = {
    enterprise_scale = azurerm_policy_definition.enterprise_scale
  }
  description = "Returns the configuration data for all Policy Definitions created by this module."
}

# The following output is used to ensure all Policy Set
# Definition data is returned to the root module.
output "azurerm_policy_set_definition" {
  value = {
    enterprise_scale = azurerm_policy_set_definition.enterprise_scale
  }
  description = "Returns the configuration data for all Policy Set Definitions created by this module."
}

# The following output is used to ensure all Policy
# Assignment data is returned to the root module.
output "azurerm_management_group_policy_assignment" {
  value = {
    enterprise_scale = azurerm_management_group_policy_assignment.enterprise_scale
  }
  description = "Returns the configuration data for all Management Group Policy Assignments created by this module."
}

# The following output is used to ensure all Role
# Definition data is returned to the root module.
output "azurerm_role_definition" {
  value = {
    enterprise_scale = azurerm_role_definition.enterprise_scale
  }
  description = "Returns the configuration data for all Role Definitions created by this module."
}

# The following output is used to ensure all Role
# Assignment data is returned to the root module.
output "azurerm_role_assignment" {
  value = {
    enterprise_scale  = azurerm_role_assignment.enterprise_scale
    policy_assignment = local.role_assignments_for_policy_output
  }
  description = "Returns the configuration data for all Role Assignments created by this module."
}

# The following output is used to ensure all Resource
# Group data is returned to the root module.
output "azurerm_resource_group" {
  value = {
    management   = azurerm_resource_group.management
    connectivity = azurerm_resource_group.connectivity
    virtual_wan  = azurerm_resource_group.virtual_wan
  }
  description = "Returns the configuration data for all Resource Groups created by this module."
}

# The following output is used to ensure all Log Analytics
# Workspace data is returned to the root module.
# Includes logic to remove sensitive values.
output "azurerm_log_analytics_workspace" {
  value = {
    management = azurerm_log_analytics_workspace.management
  }
  description = "Returns the configuration data for all Log Analytics workspaces created by this module."
}

# The following output is used to ensure all Log Analytics
# Solution data is returned to the root module.
output "azurerm_log_analytics_solution" {
  value = {
    management = azurerm_log_analytics_solution.management
  }
  description = "Returns the configuration data for all Log Analytics solutions created by this module."
}

# The following output is used to ensure all Automation
# Account data is returned to the root module.
output "azurerm_automation_account" {
  value = {
    management = azurerm_automation_account.management
  }
  description = "Returns the configuration data for all Automation Accounts created by this module."
}

# The following output is used to ensure all Log Analytics
# Linked Service data is returned to the root module.
output "azurerm_log_analytics_linked_service" {
  value = {
    management = azurerm_log_analytics_linked_service.management
  }
  description = "Returns the configuration data for all Log Analytics linked services created by this module."
}

# The following output is used to ensure all Virtual Network
# data is returned to the root module.
output "azurerm_virtual_network" {
  value = {
    connectivity = azurerm_virtual_network.connectivity
  }
  description = "Returns the configuration data for all Virtual Networks created by this module."
}

# The following output is used to ensure all Subnets
# data is returned to the root module.
output "azurerm_subnet" {
  value = {
    connectivity = azurerm_subnet.connectivity
  }
  description = "Returns the configuration data for all Subnets created by this module."
}

# The following output is used to ensure all DDoS Protection Plan
# data is returned to the root module.
output "azurerm_network_ddos_protection_plan" {
  value = {
    connectivity = azurerm_network_ddos_protection_plan.connectivity
  }
  description = "Returns the configuration data for all DDoS Protection Plans created by this module."
}

# The following output is used to ensure all Public IP
# data is returned to the root module.
output "azurerm_public_ip" {
  value = {
    connectivity = azurerm_public_ip.connectivity
  }
  description = "Returns the configuration data for all Public IPs created by this module."
}

# The following output is used to ensure all Virtual Network Gateway
# data is returned to the root module.
output "azurerm_virtual_network_gateway" {
  value = {
    connectivity = azurerm_virtual_network_gateway.connectivity
  }
  description = "Returns the configuration data for all Virtual Network Gateways created by this module."
}

# The following output is used to ensure all Azure Firewall
# Policy data is returned to the root module.
output "azurerm_firewall_policy" {
  value = {
    connectivity = azurerm_firewall_policy.connectivity
    virtual_wan  = azurerm_firewall_policy.virtual_wan
  }
  description = "Returns the configuration data for all Azure Firewall Policies created by this module."
}

# The following output is used to ensure all Azure Firewall
# data is returned to the root module.
output "azurerm_firewall" {
  value = {
    connectivity = azurerm_firewall.connectivity
    virtual_wan  = azurerm_firewall.virtual_wan
  }
  description = "Returns the configuration data for all Azure Firewalls created by this module."
}

# The following output is used to ensure all Private DNS Zone
# data is returned to the root module.
output "azurerm_private_dns_zone" {
  value = {
    connectivity = azurerm_private_dns_zone.connectivity
  }
  description = "Returns the configuration data for all Private DNS Zones created by this module."
}

# The following output is used to ensure all DNS Zone
# data is returned to the root module.
output "azurerm_dns_zone" {
  value = {
    connectivity = azurerm_dns_zone.connectivity
  }
  description = "Returns the configuration data for all DNS Zones created by this module."
}

# The following output is used to ensure all Private DNS Zone network link
# data is returned to the root module.
output "azurerm_private_dns_zone_virtual_network_link" {
  value = {
    connectivity = azurerm_private_dns_zone_virtual_network_link.connectivity
  }
  description = "Returns the configuration data for all Private DNS Zone network links created by this module."
}

# The following output is used to ensure all Virtual Network Peering
# data is returned to the root module.
output "azurerm_virtual_network_peering" {
  value = {
    connectivity = azurerm_virtual_network_peering.connectivity
  }
  description = "Returns the configuration data for all Virtual Network Peerings created by this module."
}

# The following output is used to ensure all Virtual WAN
# data is returned to the root module.
output "azurerm_virtual_wan" {
  value = {
    virtual_wan = azurerm_virtual_wan.virtual_wan
  }
  description = "Returns the configuration data for all Virtual WANs created by this module."
}

# The following output is used to ensure all Virtual Hub
# data is returned to the root module.
output "azurerm_virtual_hub" {
  value = {
    virtual_wan = azurerm_virtual_hub.virtual_wan
  }
  description = "Returns the configuration data for all Virtual Hubs created by this module."
}

# The following output is used to ensure all Virtual Hub routing intent
# data is returned to the root module.
output "azurerm_virtual_hub_routing_intent" {
  value = {
    virtual_wan = azurerm_virtual_hub_routing_intent.virtual_wan
  }
  description = "Returns the configuration data for all Virtual Hub Routing Intents created by this module."
}

# The following output is used to ensure all ExpressRoute
# Gateway data is returned to the root module.
output "azurerm_express_route_gateway" {
  value = {
    virtual_wan = azurerm_express_route_gateway.virtual_wan
  }
  description = "Returns the configuration data for all (Virtual WAN) ExpressRoute Gateways created by this module."
}

# The following output is used to ensure all VPN
# Gateway data is returned to the root module.
output "azurerm_vpn_gateway" {
  value = {
    virtual_wan = azurerm_vpn_gateway.virtual_wan
  }
  description = "Returns the configuration data for all (Virtual WAN) VPN Gateways created by this module."
}

# The following output is used to ensure all ExpressRoute
# Gateway data is returned to the root module.
output "azurerm_virtual_hub_connection" {
  value = {
    virtual_wan = azurerm_virtual_hub_connection.virtual_wan
  }
  description = "Returns the configuration data for all Virtual Hub Connections created by this module."
}

```

 [//]: # (************************)
 [//]: # (INSERT LINK LABELS BELOW)
 [//]: # (************************)

[terraform_resource_instances]:  https://developer.hashicorp.com/terraform/language/meta-arguments/for_each#referring-to-instances "Terraform documentation: Referring to instances"
