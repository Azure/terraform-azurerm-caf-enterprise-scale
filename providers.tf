# providers.tf
# Defines the required providers and their configurations, including aliases for multi-subscription deployments.

terraform {
  required_providers {
    azapi = {
      source = "Azure/azapi"
      # Use version constraint compatible with your caf-enterprise-scale module version
      # Example based on module requirements.
      version = ">= 1.0, <= 2.3.0"
    }
    azurerm = {
      source = "hashicorp/azurerm"
      # Use version constraint compatible with your caf-enterprise-scale module version
      # Example based on recent module requirements
      version = ">= 3.0, <= 4.26.0"
    }
    random = {
      source = "hashicorp/random"
      # Use version constraint compatible with your caf-enterprise-scale module version
      # Example based on recent module requirements
      version = "~> 3.7.1"
    }
    time = {
      source = "hashicorp/time"
      # Use version constraint compatible with your caf-enterprise-scale module version
      # Example based on recent module requirements
      version = "~> 0.13.0"
    }
  }
}

# Default Azure Provider (azurerm)
# Configured for the primary subscription where Terraform commands are executed,
# or potentially the management subscription if preferred for default operations.
# Ensure the identity running Terraform has appropriate permissions.
provider "azurerm" {
  features {}
  # subscription_id = var.subscription_id_management # Example: Explicitly set to management sub
  # tenant_id       = var.tenant_id                # Example: Explicitly set tenant
  # Or rely on Azure CLI/Environment variables for authentication context [3]
}

# Provider alias for Connectivity Landing Zone Subscription
# Used by resources/modules targeting the connectivity subscription. [1, 2]
provider "azurerm" {
  alias = "connectivity"
  features {}
  subscription_id = var.subscription_id_connectivity # Requires var.subscription_id_connectivity to be defined
  # tenant_id       = var.tenant_id                    # Ensure tenant context if needed
}

# Provider alias for Management Landing Zone Subscription
# Used by resources/modules targeting the management subscription. [1, 2]
provider "azurerm" {
  alias = "management"
  features {}
  subscription_id = var.subscription_id_management # Requires var.subscription_id_management to be defined
  # tenant_id       = var.tenant_id                # Ensure tenant context if needed
}

# Provider alias for Identity Landing Zone Subscription
# Used by resources/modules targeting the identity subscription. [1, 2]
provider "azurerm" {
  alias = "identity"
  features {}
  subscription_id = var.subscription_id_identity # Requires var.subscription_id_identity to be defined
  # tenant_id       = var.tenant_id              # Ensure tenant context if needed
}

# Provider alias for Root/Management Group operations
# Often targets the Management subscription or another subscription with permissions
# to manage Management Groups, Policy Definitions, Role Definitions at a higher scope. [1]
provider "azurerm" {
  alias = "root"
  features {}
  # Typically uses the same subscription as the default provider or management provider
  # subscription_id = var.subscription_id_management # Example
  # tenant_id       = var.tenant_id                # Ensure tenant context if needed
}

# Azure API Provider (azapi)
# Generally doesn't require specific subscription context unless managing resources
# across different subscriptions directly with azapi, which is less common. [4, 5]
provider "azapi" {
  # No specific configuration usually needed here unless overriding defaults
  # or authenticating differently than azurerm provider.
}