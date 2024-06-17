module "test_core" {
  source = "../../../"

  providers = {
    azurerm              = azurerm.management
    azurerm.connectivity = azurerm.connectivity
    azurerm.management   = azurerm.management
  }

  # Base module configuration settings
  root_parent_id   = data.azurerm_client_config.management.tenant_id
  root_id          = var.root_id
  root_name        = var.root_name
  default_location = var.primary_location
  default_tags     = module.settings.shared.default_tags

  # Tuning delay timers to improve pipeline completion success rate
  create_duration_delay  = var.create_duration_delay
  destroy_duration_delay = var.destroy_duration_delay

  # Configuration settings for optional landing zones
  deploy_corp_landing_zones   = true
  deploy_online_landing_zones = true
  deploy_sap_landing_zones    = false
  deploy_demo_landing_zones   = false

  # Configure path for custom library folder and
  # custom template file variables
  library_path            = "${path.root}/../test_lib"
  template_file_variables = module.settings.core.custom_template_file_variables

  # Configuration settings for core resources
  deploy_core_landing_zones  = true
  custom_landing_zones       = module.settings.core.custom_landing_zones
  archetype_config_overrides = module.settings.core.archetype_config_overrides
  subscription_id_overrides  = module.settings.core.subscription_id_overrides

  # Configuration settings for management resources
  deploy_management_resources    = true
  configure_management_resources = module.settings.management.configure_management_resources
  subscription_id_management     = data.azurerm_client_config.management.subscription_id

  # Configuration settings for connectivity resources
  deploy_connectivity_resources    = false
  configure_connectivity_resources = module.settings.connectivity.configure_connectivity_resources
  subscription_id_connectivity     = data.azurerm_client_config.connectivity.subscription_id

  # Disable default non-compliance messages
  policy_non_compliance_message_default_enabled = false
}
