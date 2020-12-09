data "azurerm_client_config" "current" {}

module "enterprise_scale" {
  source = "../../"

  root_parent_id = data.azurerm_client_config.current.tenant_id
  root_id        = var.root_id
  root_name      = var.root_name

}

module "enterprise_scale_demo" {
  source = "../../"

  root_parent_id            = data.azurerm_client_config.current.tenant_id
  root_id                   = var.root_id_2
  root_name                 = var.root_name
  deploy_demo_landing_zones = true

}

module "enterprise_scale_custom" {
  source = "../../"

  root_parent_id = data.azurerm_client_config.current.tenant_id
  root_id        = var.root_id_3
  root_name      = var.root_name
  library_path   = "${path.root}/lib"

  custom_landing_zones = {
    customer-corp = {
      display_name               = "Corp Custom"
      parent_management_group_id = "tf-landing-zones"
      subscription_ids           = []
      archetype_config = {
        archetype_id   = "customer_corp"
        parameters     = {}
        access_control = {}
      }
    }
    customer-online = {
      display_name               = "Online"
      parent_management_group_id = "tf-landing-zones"
      subscription_ids           = []
      archetype_config = {
        archetype_id   = "default_empty"
        parameters     = {}
        access_control = {}
      }
    }
    customer-sap = {
      display_name               = "SAP"
      parent_management_group_id = "tf-landing-zones"
      subscription_ids           = []
      archetype_config = {
        archetype_id   = "customer_sap"
        parameters     = {}
        access_control = {}
      }
    }
    customer-web-prod = {
      display_name               = "Prod Web Applications"
      parent_management_group_id = "tf-landing-zones"
      subscription_ids           = []
      archetype_config = {
        archetype_id   = "default_empty"
        parameters     = {}
        access_control = {}
      }
    }
    customer-web-test = {
      display_name               = "Test Web Applications"
      parent_management_group_id = "tf-landing-zones"
      subscription_ids           = []
      archetype_config = {
        archetype_id = "customer_online"
        parameters = {
          ES-Allowed-Locations = {
            listOfAllowedLocations = [
              "eastus"
            ]
          }
        }
        access_control = {}
      }
    }
    customer-web-dev = {
      display_name               = "Dev Web Applications"
      parent_management_group_id = "tf-landing-zones"
      subscription_ids           = []
      archetype_config = {
        archetype_id   = "customer_online"
        parameters     = {}
        access_control = {}
      }
    }

  }

  archetype_config_overrides = {
    root = {
      archetype_id = "custom_root"
      parameters = {
        Deploy-SQL-Auditing = {
          retentionDays                = jsonencode("10")
          storageAccountsResourceGroup = jsonencode("")
        }
        Deploy-HITRUST-HIPAA = {
          CertificateThumbprints                                        = jsonencode("")
          DeployDiagnosticSettingsforNetworkSecurityGroupsrgName        = jsonencode("true")
          DeployDiagnosticSettingsforNetworkSecurityGroupsstoragePrefix = jsonencode(var.root_id_3)
          installedApplicationsOnWindowsVM                              = jsonencode("")
        }
      }
      access_control = {}
    }
  }

  subscription_id_overrides = {
    root           = []
    decommissioned = []
    sandboxes      = []
    landing-zones  = []
    platform       = []
    connectivity   = []
    management     = []
    identity       = []
    demo-corp      = []
    demo-online    = []
    demo-sap       = []
  }

}

# module "enterprise_scale_lz1" {
#   source = "../../"

#   root_parent_id            = "${local.custom_root_id}-landing-zones"
#   root_id                   = local.custom_root_id
#   deploy_core_landing_zones = false
#   library_path              = local.custom_library_path

#   custom_landing_zones = {
#     self-serv-lz1 = {
#       display_name               = "Self Serve LZ1"
#       parent_management_group_id = "${local.custom_root_id}-landing-zones"
#       subscription_ids           = []
#       archetype_config = {
#         archetype_id = "customer_online"
#         parameters = {
#           ES-Allowed-Locations = {
#             listOfAllowedLocations = jsonencode([
#               "northeurope",
#               "westeurope",
#               "uksouth",
#               "ukwest",
#             ])
#           }
#         }
#         access_control = {
#           "Owner" = [
#             "7efe2a0d-12b4-4b40-a707-416920ec93f6" // Demo User 1
#           ]
#           "[${upper(local.custom_root_id)}] ES-Network-Subnet-Contributor" = [
#             "2cc10333-e3d6-46ea-8b25-3aa768145b58" // Demo User 2
#           ]
#         }
#       }
#     }
#   }

#   depends_on = [
#     module.enterprise_scale_custom,
#   ]

# }
