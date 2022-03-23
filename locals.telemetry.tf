# Telemetry is collected by creating an empty ARM deployment with a specific name
# If you want to disable telemetry, you can set the disable_telemetry variable to true

# The following locals identify the module
locals {
  # PUID identifies the module
  telem_puid = "36dcde81-8c33-4da0-8dc3-265381502ccb"
}

# The following locals are used to create the bitfield data, dependent on the module configuration
locals {
  # Bitfield bit 1 (LSB): Is configure management resources set?
  telem_configure_management_resources = var.configure_management_resources ? 1 : 0

  # Bitfied bit 2: Is configure connectivity resources set?
  telem_configure_connectivity_resources = var.configure_connectivity_resources ? 2 : 0

  # Bitfield bit 3: Is configure identity resources set?
  telem_configure_identity_resources = var.configure_identity_resources ? 4 : 0

  # Bitfield bit 4: Is deploy core landing zones set?
  telem_deploy_core_landing_zones = var.deploy_core_landing_zones ? 8 : 0

  # Bitfield bit 5: Is deploy demo landing zones set?
  telem_deploy_demo_landing_zones = var.deploy_demo_landing_zones ? 16 : 0
}

# The following locals calculate the telemetry bitfield by summiung thhe above locals and then representing as hexadecimal
locals {
  telem_bitfield_denery = (
    local.telem_configure_management_resources +
    local.telem_configure_connectivity_resources +
    local.telem_configure_identity_resources +
    local.telem_deploy_core_landing_zones +
    local.telem_deploy_demo_landing_zones
  )
  telem_bitfield_hex = format("%x", local.telem_bitfield_denery)
}

# This construicts the ARM deployment name that is used for the telemetry.
# We shouldn't ever hit the 64 character limit but use substr just in case
locals {
  telem_arm_deployment_name = substr(
    format(
      "puid-%s-%s-%s-%s",
      local.telem_puid,
      local.module_version,
      local.telem_bitfield_hex,
      random_id.telemetry_id.hex
    ),
    0,
    64
  )
}

# This determines the management group to which we target the deployment
# First we try the root_id, then we try the first (by alphanumeric sort) management group in level_1
# If neither of those exist, we give up :)
locals {
  telem_root_id_management_group_created = lookup(azurerm_management_group.level_1, local.root_id, null)
  telem_root_id_deployment_enabled       = local.telem_root_id_management_group_created != null && !var.disable_telemetry
  telem_fallback_deployment_enabled      = !local.telem_root_id_deployment_enabled && !var.disable_telemetry
}

# Here we create the ARM templates for the telemetry deployment
# One for MG and one for subscription, used as a fallback if we can't find the root_id MG
locals {
  telem_arm_management_group_template_content = <<TEMPLATE
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

  telem_arm_subscription_template_content = <<TEMPLATE
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
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
}
