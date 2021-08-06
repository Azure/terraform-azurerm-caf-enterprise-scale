# Convert the input vars to locals, applying any required
# logic needed before they are used in the module.
# No vars should be referenced elsewhere in the module.
# NOTE: Need to catch error for resource_suffix when
# no value for subscription_id is provided.
locals {
  enabled  = var.enabled
  root_id  = var.root_id
  settings = var.settings
}

# Logic to determine whether specific resources
# should be created by this module
locals {
  deploy_identity                          = local.enabled && local.settings.identity.enabled
  deploy_enable_deny_public_ip             = local.deploy_identity && local.settings.identity.config.enable_deny_public_ip
  deploy_enable_deny_rdp_from_internet     = local.deploy_identity && local.settings.identity.config.enable_deny_rdp_from_internet
  deploy_enable_deny_subnet_without_nsg    = local.deploy_identity && local.settings.identity.config.enable_deny_subnet_without_nsg
  deploy_enable_deploy_azure_backup_on_vms = local.deploy_identity && local.settings.identity.config.enable_deploy_azure_backup_on_vms
}

# Archetype configuration overrides
locals {
  archetype_config_overrides = {
    "${local.root_id}-identity" = {
      parameters = {
        Deny-Public-IP = {
          effect = "Deny"
        }
        Deny-RDP-From-Internet = {
          effect = "Deny"
        }
        Deny-Subnet-Without-Nsg = {
          effect = "Deny"
        }
        Deploy-VM-Backup = {
          effect            = "deployIfNotExists"
          exclusionTagName  = ""
          exclusionTagValue = []
        }
      }
      enforcement_mode = {
        Deny-Public-IP          = local.deploy_enable_deny_public_ip
        Deny-RDP-From-Internet  = local.deploy_enable_deny_rdp_from_internet
        Deny-Subnet-Without-Nsg = local.deploy_enable_deny_subnet_without_nsg
        Deploy-VM-Backup        = local.deploy_enable_deploy_azure_backup_on_vms
      }
    }
  }
}

# Generate the configuration output object for the module
locals {
  module_output = {
    archetype_config_overrides = local.archetype_config_overrides
  }
}
