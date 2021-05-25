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

  # Base module configuration settings
  root_parent_id   = data.azurerm_client_config.current.tenant_id
  root_id          = var.root_id_3
  root_name        = "${var.root_name}-3"
  library_path     = "${path.root}/lib"
  default_location = var.location

  # Configuration settings for core resources
  custom_landing_zones       = local.custom_landing_zones
  archetype_config_overrides = local.archetype_config_overrides
  subscription_id_overrides  = local.subscription_id_overrides

  # Configuration settings for management resources
  deploy_management_resources    = true
  configure_management_resources = local.configure_management_resources
  subscription_id_management     = data.azurerm_client_config.current.subscription_id

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
