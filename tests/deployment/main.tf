data "azurerm_client_config" "current" {}

module "test_root_id_1" {
  source = "../../"

  root_parent_id = data.azurerm_client_config.current.tenant_id
  root_id        = var.root_id_1
  root_name      = "${var.root_name}-1"

}

module "test_root_id_2" {
  source = "../../"

  root_parent_id = data.azurerm_client_config.current.tenant_id
  root_id        = var.root_id_2
  root_name      = "${var.root_name}-2"

  deploy_demo_landing_zones = true

}

module "test_root_id_3" {
  source = "../../"

  root_parent_id = data.azurerm_client_config.current.tenant_id
  root_id        = var.root_id_3
  root_name      = "${var.root_name}-3"
  library_path   = "${path.root}/lib"

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
            listOfAllowedLocations = [
              "eastus",
              "westus",
              "uksouth",
              "ukwest",
            ]
          }
          Deny-RSG-Locations = {
            listOfAllowedLocations = [
              "eastus",
              "westus",
              "uksouth",
              "ukwest",
            ]
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
            listOfAllowedLocations = [
              "eastus",
              "westus",
            ]
          }
          Deny-RSG-Locations = {
            listOfAllowedLocations = [
              "eastus",
              "westus",
            ]
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
            listOfAllowedLocations = [
              "eastus",
            ]
          }
          Deny-RSG-Locations = {
            listOfAllowedLocations = [
              "eastus",
            ]
          }
        }
        access_control = {}
      }
    }

  }

  archetype_config_overrides = {
    root = {
      archetype_id = "es_root"
      parameters = {
        Deploy-HITRUST-HIPAA = {
          CertificateThumbprints                                        = ""
          DeployDiagnosticSettingsforNetworkSecurityGroupsrgName        = "${var.root_id_3}-rg"
          DeployDiagnosticSettingsforNetworkSecurityGroupsstoragePrefix = var.root_id_3
          installedApplicationsOnWindowsVM                              = ""
          listOfLocations = [
            "eastus",
          ]
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

  custom_landing_zones = {
    "${var.root_id_3}-scoped-lz1" = {
      display_name               = "Scoped LZ1"
      parent_management_group_id = "${var.root_id_3}-landing-zones"
      subscription_ids           = []
      archetype_config = {
        archetype_id = "customer_online"
        parameters = {
          Deny-Resource-Locations = {
            listOfAllowedLocations = [
              "northcentralus",
              "southcentralus",
            ]
          }
          Deny-RSG-Locations = {
            listOfAllowedLocations = [
              "northcentralus",
              "southcentralus",
            ]
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
