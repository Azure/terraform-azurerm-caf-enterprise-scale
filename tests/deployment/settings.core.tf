# Configure the custom landing zones to deploy in
# addition the core resource hierarchy.
locals {
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
        archetype_id = "customer_secure"
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
}

# Configure the archetype config overrides to customize
# the configuration.
locals {
  archetype_config_overrides = {
    root = {
      archetype_id = "es_root"
      parameters = {
        Deny-Resource-Locations = {
          listOfAllowedLocations = [
            "eastus",
            "eastus2",
            "westus",
            "northcentralus",
            "southcentralus",
            "uksouth",
            "ukwest",
          ]
        }
        Deny-RSG-Locations = {
          listOfAllowedLocations = [
            "eastus",
            "eastus2",
            "westus",
            "northcentralus",
            "southcentralus",
            "uksouth",
            "ukwest",
          ]
        }
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
}

# Configure the Subscription ID overrides to ensure
# Subscriptions are moved into the target management
# group.
locals {
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