# The following random id is created once per module instantiation and is appended to the teleletry deployment name
resource "random_id" "telemetry_id" {
  count       = var.disable_telemetry ? 0 : 1
  byte_length = 6
}

resource "azurerm_management_group_template_deployment" "telemetry" {
  count                 = local.telem_deployment_enabled ? 1 : 0
  name                  = local.telem_arm_deployment_name
  location              = var.default_location
  management_group_name = local.telem_deployment_scope
  template_content      = <<TEMPLATE
{
  "$schema": "https://schema.management.azure.com/schemas/2019-08-01/managementGroupDeploymentTemplate.json#"
  "contentVersion": "1.0.0.0",
  "parameters": {},
  "variables": {},
  "resources": [],
  "outputs": {
    "telemetry": {
      "type": "string",
      "value": "For more information, see https://aka.ms/alz-terraform-module-telemetry"
    },
  }
}
TEMPLATE

  depends_on = [
    azurerm_management_group.level_1[local.telem_deployment_scope]
  ]
}
