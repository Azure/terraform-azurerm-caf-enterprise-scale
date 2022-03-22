# The following random id is created once per module instantiation and is appended to the teleletry deployment name
resource "random_id" "telemetry_id" {
  count       = var.disable_telemetry ? 0 : 1
  byte_length = 6
}

# This is the ARM deployment we use for telemetry, it is only created if we can find the
# root_id management group and if telemetry is enabled.
resource "azurerm_management_group_template_deployment" "telemetry_root_id" {
  count                 = local.telem_root_id_deployment_enabled ? 1 : 0
  name                  = local.telem_arm_deployment_name
  location              = local.default_location
  management_group_name = local.telem_deployment_scope
  template_content      = local.telem_arm_management_group_template_content

  depends_on = [
    azurerm_management_group.level_1["${local.provider_path.management_groups}${local.root_id}"]
  ]
}

# This is a fallback telemetry deployment that is only created if we can't find
# the root_id management group and if telemetry is enabled.
# It is deployed to the default subscription
resource "azurerm_subscription_template_deployment" "telemetry_fallback" {
  count            = local.telem_fallback_deployment_enabled ? 1 : 0
  name             = local.telem_arm_deployment_name
  location         = local.default_location
  template_content = local.telem_arm_subscription_template_content
}
