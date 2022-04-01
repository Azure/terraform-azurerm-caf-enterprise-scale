# Telemetry is collected by creating an empty ARM deployment with a specific name
# If you want to disable telemetry, you can set the disable_telemetry variable to true

# This file contains telemetry for the management module

# The following locals are used to create the bitfield data, dependent on the module configuration
locals {
  # Bitfield bit 1 (LSB): Is log analytics enabled?
  telem_management_configure_log_analytics = var.configure_management_resources.settings.log_analytics.enabled ? 1 : 0

  # Bitfield bit 2: Is defender for cloud enabled (prev. Azure security center) enabled?
  telem_management_configure_security_center = var.configure_management_resources.settings.security_center.enabled ? 2 : 0
}

# The following locals calculate the telemetry bitfield by summiung thhe above locals and then representing as hexadecimal
# Hex number is represented as two digits wide and is zero padded
locals {
  telem_management_bitfield_denery = (
    local.telem_management_configure_log_analytics +
    local.telem_management_configure_security_center
  )
  telem_management_bitfield_hex = format("%02x", local.telem_management_bitfield_denery)
}

# This construicts the ARM deployment name that is used for the telemetry.
# We shouldn't ever hit the 64 character limit but use substr just in case
locals {
  telem_management_arm_deployment_name = substr(
    format(
      "pid-%s_%s_%s_%s",
      local.telem_management_puid,
      local.module_version,
      local.telem_management_bitfield_hex,
      local.telem_random_hex,
    ),
    0,
    64
  )
}

# Condition to determine whether we create the management telemetry deployment
locals {
  telem_management_deployment_enabled = !var.disable_telemetry && var.deploy_management_resources
}
