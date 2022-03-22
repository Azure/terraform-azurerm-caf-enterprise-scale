# Telemetry is collected by creating an empty ARM deployment with a specific name
# If you want to disable telemetry, you can set the disable_telemetry variable to true

# The following locals identify the module and the module version
locals {
  # PUID identifies the module
  telem_puid = "36dcde81-8c33-4da0-8dc3-265381502ccb"

  # Version of the module
  telem_version = "1.2.0"
}

# The following locals are used to create the bitfield data dependent on the module configuration
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
  telem_bitfield_denery = local.telem_configure_management_resources + local.telem_configure_connectivity_resources + local.telem_configure_identity_resources + local.telem_deploy_core_landing_zones + local.telem_deploy_demo_landing_zones
  telem_bitfield_hex = format("%x", local.telem_bitfield_denery)
}

locals {
  telem_arm_deployment_name = "puid-" + local.telem_puid + "-" + local.telem_version + "-" + local.telem_bitfield_hex + "-" + random_id.telemetry_id.hex
}
