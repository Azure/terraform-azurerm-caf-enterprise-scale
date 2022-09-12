# Telemetry is collected by creating an empty ARM deployment with a specific name
# If you want to disable telemetry, you can set the disable_telemetry variable to true

# This file contains telemetry for the core module

# The following locals are used to create the bitfield data, dependent on the module configuration
locals {
  # Bitfield bit 1 (LSB): Is deploy core LZs enabled?
  telem_core_deploy_core_landing_zones = local.deploy_core_landing_zones ? 1 : 0

  # Bitfield bit 2: Is deploy corp LZ set?
  telem_core_deploy_corp_prod_landing_zones = local.deploy_corp_prod_landing_zones ? 2 : 0

  # Bitfield bit 3: Is deploy online LZ set?
  telem_core_deploy_online_prod_landing_zones = local.deploy_online_prod_landing_zones ? 4 : 0

  # Bitfield bit 4: Is deploy epic LZ set?
  telem_core_deploy_epic_prod_landing_zones = local.deploy_online_prod_landing_zones ? 8 : 0

  # Bitfield bit 4: Is deploy citrix LZ set?
  telem_core_deploy_citrix_prod_landing_zones = local.deploy_online_prod_landing_zones ? 8 : 0

  # Bitfield bit 4: Is deploy clinical LZ set?
  telem_core_deploy_clinical_prod_landing_zones = local.deploy_online_prod_landing_zones ? 10 : 0

  # Bitfield bit 11: Is deploy Finance Prod LZ set?
  telem_core_deploy_finance_prod_landing_zones = local.deploy_online_prod_landing_zones ? 11 : 0

  # Bitfield bit 4: Is deploy business LZ set?
  telem_core_deploy_business_prod_landing_zones = local.deploy_online_prod_landing_zones ? 8 : 0

  # Bitfield bit 5: Are there any custom LZs configured?
  telem_core_custom_lzs_configured = length(local.custom_landing_zones) > 0 ? 16 : 0
}

# The following locals calculate the telemetry bit field by summiung the above locals and then representing as hexadecimal
# Hex number is represented as four digits wide and is zero padded
locals {
  telem_core_bitfield_denery = (
    local.telem_core_deploy_core_landing_zones +
    local.telem_core_deploy_corp_prod_landing_zones +
    local.telem_core_deploy_online_prod_landing_zones +
    local.telem_core_deploy_epic_prod_landing_zones +
    local.telem_core_deploy_finance_prod_landing_zones +
    local.telem_core_deploy_citrix_prod_landing_zones +
    local.telem_core_deploy_business_prod_landing_zones +
    local.telem_core_deploy_clinical_prod_landing_zones +
    local.telem_core_custom_lzs_configured
  )
  telem_core_bitfield_hex = format("%04x", local.telem_core_bitfield_denery)
}

# This construicts the ARM deployment name that is used for the telemetry.
# We shouldn't ever hit the 64 character limit but use substr just in case
locals {
  telem_core_arm_deployment_name = substr(
    format(
      "pid-%s_%s_%s_%s",
      local.telem_core_puid,
      local.module_version,
      local.telem_core_bitfield_hex,
      local.telem_random_hex,
    ),
    0,
    64
  )
}

# Condition to determine whether we create the core telemetry deployment
locals {
  telem_core_deployment_enabled = !local.disable_telemetry
}
