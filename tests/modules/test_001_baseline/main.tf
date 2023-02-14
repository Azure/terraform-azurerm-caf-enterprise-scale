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

  # Test disable_telemetry
  disable_telemetry = true

}
