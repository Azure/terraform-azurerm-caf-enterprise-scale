# Telemetry is collected by creating an empty ARM deployment with a specific name
# If you want to disable telemetry, you can set the disable_telemetry variable to true

# This file contains telemetry for the connectivity module

# The following locals are used to check for the existence of policy assignments that are made by the module that support a Zero Trust Networking configuration that is requried for telemetry triggers below - https://github.com/Azure/Enterprise-Scale/wiki/Deploying-ALZ-CustomerUsage#alz-acceleratoreslz-arm-deployment---zero-trust-networking---phase-1--definition
locals {
  telem_subnet_nsg_policy_assignment_exists = length([for k, v in local.azurerm_management_group_policy_assignment_enterprise_scale :
    k if contains(split("/", v.template.properties.policyDefinitionId), "Deny-Subnet-Without-Nsg") && contains(split("/", k), "Deny-Subnet-Without-Nsg") && (endswith(split("/", k)[4], "-identity") || endswith(split("/", k)[4], "-landing-zones"))
  ]) >= 2 ? true : false
  telem_storage_https_policy_assignment_exists = length([for k, v in local.azurerm_management_group_policy_assignment_enterprise_scale :
    k if contains(split("/", v.template.properties.policyDefinitionId), "404c3081-a854-4457-ae30-26a93ef643f9") && contains(split("/", k), "Deny-Storage-http") && (endswith(split("/", k)[4], "-landing-zones"))
  ]) >= 1 ? true : false
}

# The following locals are used to create the bitfield data, dependent on the module configuration
locals {
  # Bitfield bit 1 (LSB): Are hub networks configured?
  telem_connectivity_configure_hub_networks = length(local.configure_connectivity_resources.settings.hub_networks) > 0 ? 1 : 0

  # Bitfield bit 2: VWAN configured?
  telem_connectivity_configure_vwan_hub_networks = length(local.configure_connectivity_resources.settings.vwan_hub_networks) > 0 ? 2 : 0

  # Bitfield bit 3: Is DDOS protection configured?
  telem_connectivity_configure_ddos_protection_plan = local.configure_connectivity_resources.settings.ddos_protection_plan.enabled ? 4 : 0

  # Bitfield bit 4: DNS configured?
  telem_connectivity_configure_dns = local.configure_connectivity_resources.settings.dns.enabled ? 8 : 0

  # Bitfield bit 5: Zero Trust Network - Phase 1 configured? - https://github.com/Azure/Enterprise-Scale/wiki/Deploying-ALZ-CustomerUsage#alz-acceleratoreslz-arm-deployment---zero-trust-networking---phase-1--definition
  telem_connectivity_ztn_p1 = (local.configure_connectivity_resources.settings.ddos_protection_plan.enabled &&
    alltrue(flatten([[for azfw in local.configure_connectivity_resources.settings.hub_networks.*.config.azure_firewall.enabled : azfw == true], [for azfw in local.configure_connectivity_resources.settings.vwan_hub_networks.*.config.azure_firewall.enabled : azfw == true]])) &&
    alltrue(flatten([[for sku in local.configure_connectivity_resources.settings.hub_networks.*.config.azure_firewall.config.sku_tier : sku == "Premium"], [for sku in local.configure_connectivity_resources.settings.vwan_hub_networks.*.config.azure_firewall.config.sku_tier : sku == "Premium"]])) &&
    local.telem_subnet_nsg_policy_assignment_exists &&
    local.telem_storage_https_policy_assignment_exists
  ? 16 : 0)
}

# The following locals calculate the telemetry bit field by summiung the above locals and then representing as hexadecimal
# Hex number is represented as four digits wide and is zero padded
locals {
  telem_connectivity_bitfield_denery = (
    local.telem_connectivity_configure_hub_networks +
    local.telem_connectivity_configure_vwan_hub_networks +
    local.telem_connectivity_configure_ddos_protection_plan +
    local.telem_connectivity_configure_dns +
    local.telem_connectivity_ztn_p1
  )
  telem_connectivity_bitfield_hex = format("%04x", local.telem_connectivity_bitfield_denery)
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
      local.telem_random_hex,
    ),
    0,
    64
  )
}

# Condition to determine whether we create the connectivity telemetry deployment
locals {
  telem_connectivity_deployment_enabled = !local.disable_telemetry && local.deploy_connectivity_resources
}
