data "azurerm_client_config" "current" {}

locals = {
  create_duration_delay = {
    azurerm_management_group      = "30s"
    azurerm_policy_assignment     = "30s"
    azurerm_policy_definition     = "60s"
    azurerm_policy_set_definition = "30s"
    azurerm_role_assignment       = "0s"
    azurerm_role_definition       = "60s"
  }
}

module "test_root_id_1" {
  source = "../../"

  root_parent_id = data.azurerm_client_config.current.tenant_id
  root_id        = var.root_id_1
  root_name      = "${var.root_name}-1"

  create_duration_delay = local.create_duration_delay

}

module "test_root_id_2" {
  source = "../../"

  root_parent_id = data.azurerm_client_config.current.tenant_id
  root_id        = var.root_id_2
  root_name      = "${var.root_name}-2"

  create_duration_delay = local.create_duration_delay

  deploy_demo_landing_zones = true

}

module "test_root_id_3" {
  source = "../../"

  root_parent_id = data.azurerm_client_config.current.tenant_id
  root_id        = var.root_id_3
  root_name      = "${var.root_name}-3"
  library_path   = "${path.root}/lib"

  create_duration_delay = local.create_duration_delay

  custom_landing_zones = {
    "${var.root_id_3}-customer-corp" = {
      display_name               = "Corp Custom"
      parent_management_group_id = "${var.root_id_3}-landing-zones"
      subscription_ids           = []
      archetype_config = {
        archetype_id   = "default_empty"
        parameters     = {}
        access_control = {}
      }
    }
    "${var.root_id_3}-customer-sap" = {
      display_name               = "SAP"
      parent_management_group_id = "${var.root_id_3}-landing-zones"
      subscription_ids           = []
      archetype_config = {
        archetype_id   = "default_empty"
        parameters     = {}
        access_control = {}
      }
    }
    "${var.root_id_3}-customer-online" = {
      display_name               = "Online"
      parent_management_group_id = "${var.root_id_3}-landing-zones"
      subscription_ids           = []
      archetype_config = {
        archetype_id = "customer_online"
        parameters = {
          Deny-Resource-Locations = {
            listOfAllowedLocations = jsonencode([
              "eastus",
              "westus",
              "uksouth",
              "ukwest",
            ])
          }
          Deny-RSG-Locations = {
            listOfAllowedLocations = jsonencode([
              "eastus",
              "westus",
              "uksouth",
              "ukwest",
            ])
          }
        }
        access_control = {}
      }
    }
    "${var.root_id_3}-customer-web-prod" = {
      display_name               = "Prod Web Applications"
      parent_management_group_id = "${var.root_id_3}-customer-online"
      subscription_ids           = []
      archetype_config = {
        archetype_id   = "default_empty"
        parameters     = {}
        access_control = {}
      }
    }
    "${var.root_id_3}-customer-web-test" = {
      display_name               = "Test Web Applications"
      parent_management_group_id = "${var.root_id_3}-customer-online"
      subscription_ids           = []
      archetype_config = {
        archetype_id = "customer_online"
        parameters = {
          Deny-Resource-Locations = {
            listOfAllowedLocations = jsonencode([
              "eastus",
              "westus",
            ])
          }
          Deny-RSG-Locations = {
            listOfAllowedLocations = jsonencode([
              "eastus",
              "westus",
            ])
          }
        }
        access_control = {}
      }
    }
    "${var.root_id_3}-customer-web-dev" = {
      display_name               = "Dev Web Applications"
      parent_management_group_id = "${var.root_id_3}-customer-online"
      subscription_ids           = []
      archetype_config = {
        archetype_id = "customer_online"
        parameters = {
          Deny-Resource-Locations = {
            listOfAllowedLocations = jsonencode([
              "eastus",
            ])
          }
          Deny-RSG-Locations = {
            listOfAllowedLocations = jsonencode([
              "eastus",
            ])
          }
        }
        access_control = {}
      }
    }

  }

  archetype_config_overrides = {
    root = {
      archetype_id = "customer_root"
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

module "test_root_id_3_lz1" {
  source = "../../"

  root_parent_id            = "${var.root_id_3}-landing-zones"
  root_id                   = var.root_id_3
  deploy_core_landing_zones = false
  library_path              = "${path.root}/lib"

  create_duration_delay = local.create_duration_delay

  custom_landing_zones = {
    "${var.root_id_3}-scoped-lz1" = {
      display_name               = "Scoped LZ1"
      parent_management_group_id = "${var.root_id_3}-landing-zones"
      subscription_ids           = []
      archetype_config = {
        archetype_id = "customer_online"
        parameters = {
          Deny-Resource-Locations = {
            listOfAllowedLocations = jsonencode([
              "northcentralus",
              "southcentralus",
            ])
          }
          Deny-RSG-Locations = {
            listOfAllowedLocations = jsonencode([
              "northcentralus",
              "southcentralus",
            ])
          }
        }
        access_control = {}
      }
    }
  }

  depends_on = [
    module.test_root_id_3,
  ]

}
