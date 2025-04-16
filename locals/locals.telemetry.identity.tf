# Telemetry is collected by creating an empty ARM deployment with a specific name
# If you want to disable telemetry, you can set the disable_telemetry variable to true

# This file contains telemetry for the identity module

# The following locals are used to create the bitfield data, dependent on the module configuration
locals {
  # Bitfield bit 1 (LSB): Is log analytics enabled?
  telem_identity_configure_identity_policies = local.configure_identity_resources.settings.identity.enabled ? 1 : 0
}

# The following locals calculate the telemetry bit field by summiung the above locals and then representing as hexadecimal
# Hex number is represented as four digits wide and is zero padded
locals {
  telem_identity_bitfield_denery = (
    local.telem_identity_configure_identity_policies
  )
  telem_identity_bitfield_hex = format("%04x", local.telem_identity_bitfield_denery)
}

# This construicts the ARM deployment name that is used for the telemetry.
# We shouldn't ever hit the 64 character limit but use substr just in case
locals {
  telem_identity_arm_deployment_name = substr(
    format(
      "pid-%s_%s_%s_%s",
      local.telem_identity_puid,
      local.module_version,
      local.telem_identity_bitfield_hex,
      local.telem_random_hex,
    ),
    0,
    64
  )
}

# Condition to determine whether we create the management telemetry deployment
# Disabled until identity resources are added to the module
locals {
  telem_identity_deployment_enabled = false # !local.disable_telemetry && local.deploy_identity_resources
}
