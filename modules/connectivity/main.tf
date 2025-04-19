terraform
module "core_resources" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-core/azurerm"
  version = var.modules.core.version

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm.connectivity
    azurerm.identity     = azurerm.identity
    azurerm.management   = azurerm.management
    azurerm.root         = azurerm.root
  }

  default_location           = var.default_location
  default_location_short     = var.default_location_short
  diagnostic_settings        = var.diagnostic_settings
  display_name               = local.display_name
  dns_service_delegated_link = var.dns_service_delegated_link
  enable_default_telemetry   = var.enable_default_telemetry
  features                   = var.features
  global_settings            = var.global_settings
  location                   = local.location
  location_short             = local.location_short
  resource_name              = "core"
  root_parent_id             = var.root_parent_id
  root_parent_type           = var.root_parent_type
  subscription_id            = var.subscription_id
  tags                       = var.tags

  use_custom_settings = false

  custom_settings = {
    management_group_id_prefix = ""
    resource_group_name_prefix = ""
  }

}

module "connectivity_resources" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-connectivity/azurerm"
  version = var.modules.connectivity.version

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm.connectivity
    azurerm.management   = azurerm.management
    azurerm.root         = azurerm.root
  }

  custom_settings = {
    dns_service               = var.connectivity_settings.dns.custom_settings.dns_service
    enable_private_endpoints  = var.connectivity_settings.private_endpoints.custom_settings.enabled
    firewall_policy_enabled   = var.connectivity_settings.firewall.custom_settings.firewall_policy_enabled
    resource_group_name       = var.connectivity_settings.resource_management.custom_settings.resource_group_name
    virtual_network_addresses = var.connectivity_settings.virtual_network.custom_settings.address_space
    virtual_network_name      = var.connectivity_settings.virtual_network.custom_settings.virtual_network_name
  }

  default_location                   = var.default_location
  default_location_short             = var.default_location_short
  diagnostic_settings                = var.diagnostic_settings
  dns_service                        = var.connectivity_settings.dns.service
  enable_default_telemetry           = var.enable_default_telemetry
  features                           = var.features
  firewall_policy_enabled            = var.connectivity_settings.firewall.firewall_policy_enabled
  location                           = local.location
  location_short                     = local.location_short
  resource_name                      = "connectivity"
  root_parent_id                     = var.root_parent_id
  root_parent_type                   = var.root_parent_type
  subscription_id                    = var.subscription_id
  subscription_ids_to_place          = var.connectivity_settings.subscriptions
  subscription_mg_name               = local.subscription_mg_name
  tags                               = var.tags
  use_custom_settings                = var.connectivity_settings.use_custom_settings
  virtual_network_address_space      = var.connectivity_settings.virtual_network.address_space
  virtual_network_address_prefixes   = var.connectivity_settings.virtual_network.address_prefixes
  virtual_network_name               = var.connectivity_settings.virtual_network.virtual_network_name
  virtual_network_resource_group_name = var.connectivity_settings.virtual_network.resource_group_name
  vwan_hub_enabled                   = var.connectivity_settings.virtual_wan.hub.enabled
  vwan_hub_name                      = var.connectivity_settings.virtual_wan.hub.name
  vwan_hub_resource_group_name       = var.connectivity_settings.virtual_wan.hub.resource_group_name

  # use values from core_resouces module for variables that support custom settings but have not
  # been configured with a custom value
  management_group_id_prefix = module.core_resources.management_group_id_prefix
  resource_group_name_prefix = module.core_resources.resource_group_name_prefix
}

module "identity_resources" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-identity/azurerm"
  version = var.modules.identity.version

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm.connectivity
    azurerm.identity     = azurerm.identity
    azurerm.management   = azurerm.management
    azurerm.root         = azurerm.root
  }

  custom_settings = {
    resource_group_name = var.identity_settings.resource_management.custom_settings.resource_group_name
  }

  default_location         = var.default_location
  default_location_short   = var.default_location_short
  diagnostic_settings      = var.diagnostic_settings
  enable_default_telemetry = var.enable_default_telemetry
  features                 = var.features
  location                 = local.location
  location_short           = local.location_short
  resource_name            = "identity"
  root_parent_id           = var.root_parent_id
  root_parent_type         = var.root_parent_type
  subscription_id          = var.subscription_id
  subscription_ids_to_place = concat(
    var.identity_settings.subscriptions,
    var.identity_settings.custom_identity.managed_identities_assignments
  )
  subscription_mg_name = local.subscription_mg_name
  tags                 = var.tags
  use_custom_settings  = var.identity_settings.use_custom_settings

  # use values from core_resouces module for variables that support custom settings but have not
  # been configured with a custom value
  management_group_id_prefix = module.core_resources.management_group_id_prefix
  resource_group_name_prefix = module.core_resources.resource_group_name_prefix
}

module "management_resources" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-management/azurerm"
  version = var.modules.management.version

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm.connectivity
    azurerm.identity     = azurerm.identity
    azurerm.management   = azurerm.management
    azurerm.root         = azurerm.root
  }

  custom_settings = {
    log_analytics_workspace_name = var.management_settings.log_analytics.custom_settings.workspace_name
    resource_group_name          = var.management_settings.resource_management.custom_settings.resource_group_name
    storage_account_name         = var.management_settings.log_analytics.custom_settings.storage_account_name
  }

  default_location              = var.default_location
  default_location_short        = var.default_location_short
  diagnostic_settings           = var.diagnostic_settings
  enable_default_telemetry      = var.enable_default_telemetry
  features                      = var.features
  location                      = local.location
  location_short                = local.location_short
  log_analytics_workspace_name  = var.management_settings.log_analytics.workspace_name
  resource_name                 = "management"
  root_parent_id                = var.root_parent_id
  root_parent_type              = var.root_parent_type
  subscription_id               = var.subscription_id
  subscription_ids_to_place     = var.management_settings.subscriptions
  subscription_mg_name          = local.subscription_mg_name
  tags                          = var.tags
  use_custom_settings           = var.management_settings.use_custom_settings

  # use values from core_resouces module for variables that support custom settings but have not
  # been configured with a custom value
  management_group_id_prefix = module.core_resources.management_group_id_prefix
  resource_group_name_prefix = module.core_resources.resource_group_name_prefix
}

module "management_group_archetypes" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-archetypes/azurerm"
  version = var.modules.archetypes.version

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm.connectivity
    azurerm.identity     = azurerm.identity
    azurerm.management   = azurerm.management
    azurerm.root         = azurerm.root
  }

  archetype_id                        = local.archetype_id
  archetype_overrides                 = var.archetype_config_overrides
  default_location                    = var.default_location
  default_location_short              = var.default_location_short
  deploy_core_landing_zones             = var.deploy_core_landing_zones
  deploy_diagnostics_for_mg           = var.deploy_diagnostics_for_mg
  diagnostic_settings                 = var.diagnostic_settings
  display_name                        = local.display_name
  dns_service_delegated_link          = var.dns_service_delegated_link
  enable_default_telemetry            = var.enable_default_telemetry
  enforce_security_compliance_in_root = var.enforce_security_compliance_in_root
  features                            = var.features
  global_settings                     = var.global_settings
  location                            = local.location
  location_short                      = local.location_short
  root_parent_id                      = var.root_parent_id
  root_parent_type                    = var.root_parent_type
  subscription_id                     = var.subscription_id
  tags                                = var.tags
}