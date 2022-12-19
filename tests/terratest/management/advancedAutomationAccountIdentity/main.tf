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
  skip_provider_registration = true
}

data "azurerm_client_config" "default" {}

locals {
  default_location = "northeurope"
}

# Configure ethe module to only deploy a hub network and a peering,
# using the advanced block to change the name of the peering
module "test_core" {
  source = "../../../../"
  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm
    azurerm.management   = azurerm
  }
  deploy_core_landing_zones   = false
  root_parent_id              = "none"
  disable_telemetry           = true
  deploy_management_resources = true
  default_location            = local.default_location
  subscription_id_management  = data.azurerm_client_config.default.subscription_id
  configure_management_resources = {
    settings = {
      log_analytics = {
        enabled = true
        config = {
          retention_in_days                                 = 30
          enable_monitoring_for_arc                         = false
          enable_monitoring_for_vm                          = false
          enable_monitoring_for_vmss                        = false
          enable_solution_for_agent_health_assessment       = false
          enable_solution_for_anti_malware                  = false
          enable_solution_for_change_tracking               = false
          enable_solution_for_service_map                   = false
          enable_solution_for_sql_assessment                = false
          enable_solution_for_sql_vulnerability_assessment  = false
          enable_solution_for_sql_advanced_threat_detection = false
          enable_solution_for_updates                       = false
          enable_solution_for_vm_insights                   = false
          enable_sentinel                                   = false
        }
      }
      security_center = {
        enabled = false
      }
    }
    advanced = var.test_advanced_identity ? {
      custom_settings_by_resource_type = {
        azurerm_automation_account = {
          management = {
            identity = [
              {
                type = "SystemAssigned, UserAssigned"
                identity_ids = [
                  "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test/providers/Microsoft.ManagedIdentity/userAssignedIdentities/test-id"
                ]
              }
            ]
          }
        }
      }
    } : null
  }
}
