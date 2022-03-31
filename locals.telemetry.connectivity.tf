# Telemetry is collected by creating an empty ARM deployment with a specific name
# If you want to disable telemetry, you can set the disable_telemetry variable to true

# This file contains telemetry for the connectivity module

# The following locals are used to create the bitfield data, dependent on the module configuration
locals {
  # Bitfield bit 1 (LSB): Are hub networks configured?
  telem_connectivity_configure_hub_networks = length(var.configure_connectivity_resources.settings.hub_networks) > 0 ? 1 : 0

  # Bitfield bit 2: VWAN configured?
  telem_connectivity_configure_vwan_hub_networks = length(var.configure_connectivity_resources.settings.vwan_hub_networks) > 0 ? 2 : 0

  # Bitfield bit 3: Is DDOS protection configured?
  telem_connectivity_configure_ddos_protection_plan = var.configure_connectivity_resources.settings.ddos_protection_plan.enabled ? 4 : 0

  # Bitfield bit 4: DNS configured?
  telem_connectivity_configure_dns = var.configure_connectivity_resources.settings.dns.enabled ? 8 : 0
}

# The following locals calculate the telemetry bitfield by summiung thhe above locals and then representing as hexadecimal
# Hex number is represented as two digits wide and is zero padded
locals {
  telem_connectivity_bitfield_denery = (
    local.telem_connectivity_configure_hub_networks +
    local.telem_connectivity_configure_vwan_hub_networks +
    local.telem_connectivity_configure_ddos_protection_plan +
    local.telem_connectivity_configure_dns
  )
  telem_connectivity_bitfield_hex = format("%02x", local.telem_connectivity_bitfield_denery)
}

# This construicts the ARM deployment name that is used for the telemetry.
# We shouldn't ever hit the 64 character limit but use substr just in case
locals {
  telem_connectivity_arm_deployment_name = substr(
    format(
      "pid-%s_%s_%s_%s",
      local.telem_connectivity_puid,
      local.module_version,
      local.telem_connectivity_bitfield_hex,
      random_id.telem[0].hex
    ),
    0,
    64
  )
}

# Condition to determine whether we create the connectivity telemetry deployment
locals {
  telem_connectivity_deployment_enabled = !var.disable_telemetry && var.deploy_connectivity_resources
}
