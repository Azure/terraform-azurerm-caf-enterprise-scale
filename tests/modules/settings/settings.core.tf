# Configure the custom landing zones to deploy in
# addition the core resource hierarchy.
locals {
  custom_landing_zones = {}
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
        # The following policy has only a subset of mandatory parameters set using this input.
        # This is to prove that the defaults set in the policy assignment template are correctly merged.
        Deploy-HITRUST-HIPAA = {
          DeployDiagnosticSettingsforNetworkSecurityGroupsrgName        = "${var.root_id}-rg"
          DeployDiagnosticSettingsforNetworkSecurityGroupsstoragePrefix = var.root_id
          listOfLocations = [
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
        # The following policy has only a subset of mandatory parameters set using this input.
        # This is to prove that the managed values set by the module are correctly merged.
        Deploy-Resource-Diag = {
          AKSLogAnalyticsEffect = "Disabled"
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

# Configure custom input for testing the
# template_file_variables input.
locals {
  custom_template_file_variables = {
    testStringKey = "testStringValue"
    listOfAllowedLocations = [
      "eastus",
      "eastus2",
      "westus",
      "northcentralus",
      "southcentralus",
    ]
    subscription_id         = data.azurerm_client_config.core.subscription_id
    umi_resource_group_name = local.umi_resource_group_name
    umi_name                = local.umi_name
  }
}
