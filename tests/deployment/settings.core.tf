# Configure the custom landing zones to deploy in
# addition the core resource hierarchy.
locals {
  custom_landing_zones = {
    "${var.root_id_3}-secure" = {
      display_name               = "Secure Workloads (HITRUST/HIPAA)"
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
    "${var.root_id_3}-web-global" = {
      display_name               = "Global Web Applications"
      parent_management_group_id = "${var.root_id_3}-online"
      subscription_ids           = []
      archetype_config = {
        archetype_id   = "default_empty"
        parameters     = {}
        access_control = {}
      }
    }
    "${var.root_id_3}-web-us" = {
      display_name               = "US Web Applications"
      parent_management_group_id = "${var.root_id_3}-online"
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
    "${var.root_id_3}-web-emea" = {
      display_name               = "EMEA Web Applications"
      parent_management_group_id = "${var.root_id_3}-online"
      subscription_ids           = []
      archetype_config = {
        archetype_id = "customer_online"
        parameters = {
          Deny-Resource-Locations = {
            listOfAllowedLocations = [
              "northeurope",
              "westeurope",
            ]
          }
          Deny-RSG-Locations = {
            listOfAllowedLocations = [
              "northeurope",
              "westeurope",
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
            "northeurope",
            "westeurope",
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
            "northeurope",
            "westeurope",
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
    landing-zones  = [] # Not recommended, put Subscriptions in child management groups.
    platform       = [] # Not recommended, put Subscriptions in child management groups.
    connectivity   = [] # Not recommended, use subscription_id_connectivity instead.
    management     = [] # Not recommended, use subscription_id_management instead.
    identity       = [] # Not recommended, use subscription_id_identity instead.
    corp           = []
    online         = []
    sap            = []
    demo-corp      = []
    demo-online    = []
    demo-sap       = []
  }

}
