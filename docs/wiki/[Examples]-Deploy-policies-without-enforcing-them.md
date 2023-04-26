<!-- markdownlint-disable first-line-h1 -->
## Overview

Policies have a property [enforcementMode](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/assignment-structure#enforcement-mode). The `enforcementMode` property provides customers the ability to test the outcome of a policy on existing resources without initiating the policy effect or triggering entries in the Azure Activity log.

This scenario is commonly referred to as "What If" and aligns to safe deployment practices. `enforcementMode` is different from the `Disabled` effect, as that effect prevents resource evaluation from happening at all.

Setting the `enforcementMode` property to false can be useful in browncase scenarios, so that existing workloads can be changed before enforcing the policies.

This page describes how to deploy your Azure landing zone with a custom configuration for the enforcementMode.

> **NOTE:** This feature is available from version 4.0.0.

First, it is important to understand on which archetype policies are applied. For the default configuration, the policy assignments are [here](../../modules/archetypes/lib/archetype_definitions/).

In this example, we will take the default landing zone archetype, which is defined [here](../../modules/archetypes/lib/archetype_definitions/archetype_definition_es_landing_zones.tmpl.json).

Currently, this file looks like this. You can see that a couple of policies are assigned at this scope, some of which could break existing workloads from functioning correctly.

```json
{
    "es_landing_zones": {
        "policy_assignments": [
            "Deny-IP-Forwarding",
            "Deny-RDP-From-Internet",
            "Deny-Storage-http",
            "Deny-Subnet-Without-Nsg",
            "Deploy-AKS-Policy",
            "Deploy-SQL-DB-Auditing",
            "Deploy-SQL-Threat",
            "Deploy-VM-Backup",
            "Deny-Priv-Escalation-AKS",
            "Deny-Priv-Containers-AKS",
            "Enable-DDoS-VNET",
            "Enforce-AKS-HTTPS",
            "Enforce-TLS-SSL"
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

## Override the enforcementMode of policy assignments

### `terraform.tf`

```hcl
# Configure Terraform to set the required AzureRM provider
# version and features{} block.

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.19.0"
    }
  }
}

provider "azurerm" {
  features {}
}
```

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
```

### `main.tf`

The `main.tf` file contains the `azurerm_client_config` resource, which is used to determine the Tenant ID from your user connection to Azure. This is used to ensure the deployment will target your `Tenant Root Group` by default.

To overwrite the `enforcementMode` property for some of those policies, we need to pass a valid configuration for the parameter `archetype_config_overrides` when we call the module.

> **NOTE:** To learn more about module configuration using input variables, please refer to the [Module Variables](%5BUser-Guide%5D-Module-Variables) documentation.

```hcl
# You can use the azurerm_client_config data resource to dynamically
# extract connection settings from the provider configuration.

data "azurerm_client_config" "core" {}

# Call the caf-enterprise-scale module directly from the Terraform Registry
# pinning to the latest version

module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "<version>" # change this to your desired version, https://www.terraform.io/language/expressions/version-constraints, should be at least 3.4.0

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm
    azurerm.management   = azurerm
  }

  root_parent_id = data.azurerm_client_config.core.tenant_id
  root_id        = "myorg"
  root_name      = "My Organization"
  
  deploy_corp_landing_zones   = true
  deploy_online_landing_zones = true
  deploy_identity_resources   = true

  archetype_config_overrides = local.archetype_config_overrides
}
```

### `archetype_config_overrides.tf` for landing zones archetype

Examplary, to change the enforcementMode for the landing zone archetype, we could use the following configuration. Note how the `root_id` specified when calling the module in `main.tf` is used to identify the archetype.

```hcl
locals {
  archetype_config_overrides = {
    myorg-landing-zones = {
      enforcement_mode = {
        Deny-IP-Forwarding       = false
        Deny-RDP-From-Internet   = false
        Deny-Storage-http        = false
        Deny-Subnet-Without-Nsg  = false
        Deploy-AKS-Policy        = false
        Deploy-SQL-DB-Auditing   = false
        Deploy-SQL-Threat        = false
        Deploy-VM-Backup         = false
        Deny-Priv-Escalation-AKS = false
        Deny-Priv-Containers-AKS = false
        Enable-DDoS-VNET         = false
        Enforce-AKS-HTTPS        = false
        Enforce-TLS-SSL          = false
      }
    }
  }
}
```

You have successfully overridden the `enforcementMode` for the landing zone archetype.

## Brownfield deployment for corp landing zone

If you want to move your workloads quickly into the corp landing zone, it might be useful to also set the `enforcementMode` for the corp archetype.

### `archetype_config_overrides.tf` for brownfield

```hcl
locals {
  archetype_config_overrides = {
    myorg-corp = {
      enforcement_mode = {
        Deny-DataB-Pip           = false
        Deny-DataB-Sku           = false
        Deny-DataB-Vnet          = false
        Deny-Public-Endpoints    = false
        Deploy-Private-DNS-Zones = false
      }
    }
    myorg-landing-zones = {
      enforcement_mode = {
        Deny-IP-Forwarding       = false
        Deny-RDP-From-Internet   = false
        Deny-Storage-http        = false
        Deny-Subnet-Without-Nsg  = false
        Deploy-AKS-Policy        = false
        Deploy-SQL-DB-Auditing   = false
        Deploy-SQL-Threat        = false
        Deploy-VM-Backup         = false
        Deny-Priv-Escalation-AKS = false
        Deny-Priv-Containers-AKS = false
        Enable-DDoS-VNET         = false
        Enforce-AKS-HTTPS        = false
        Enforce-TLS-SSL          = false
      }
    }
  }
}
```
