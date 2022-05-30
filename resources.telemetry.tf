# The following random id is created once per module instantiation and is appended to the teleletry deployment name
resource "random_id" "telem" {
  count       = local.disable_telemetry ? 0 : 1
  byte_length = 4
}

# This is the core module telemetry deployment that is only created if telemetry is enabled.
# It is deployed to the default subscription
resource "azurerm_subscription_template_deployment" "telemetry_core" {
  count            = local.telem_core_deployment_enabled ? 1 : 0
  provider         = azurerm
  name             = local.telem_core_arm_deployment_name
  location         = local.default_location
  template_content = local.telem_arm_subscription_template_content
}

# This is the management module telemetry deployment that is only created if telemetry is enabled.
# It is deployed to the management subscription
resource "azurerm_subscription_template_deployment" "telemetry_management" {
  count            = local.telem_management_deployment_enabled ? 1 : 0
  provider         = azurerm.management
  name             = local.telem_management_arm_deployment_name
  location         = local.default_location
  template_content = local.telem_arm_subscription_template_content
}

# This is the connectivity module telemetry deployment that is only created if telemetry is enabled.
# It is deployed to the connectivity subscription
resource "azurerm_subscription_template_deployment" "telemetry_connectivity" {
  count            = local.telem_connectivity_deployment_enabled ? 1 : 0
  provider         = azurerm.connectivity
  name             = local.telem_connectivity_arm_deployment_name
  location         = local.default_location
  template_content = local.telem_arm_subscription_template_content
}

# This is the identity module telemetry deployment that is only created if telemetry is enabled.
# It is deployed to the identity subscription
resource "azurerm_subscription_template_deployment" "telemetry_identity" {
  count            = local.telem_identity_deployment_enabled ? 1 : 0
  provider         = azurerm # azurerm.identity # Must update once enabled
  name             = local.telem_identity_arm_deployment_name
  location         = local.default_location
  template_content = local.telem_arm_subscription_template_content
}
