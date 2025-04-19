terraform
# modules/archetypes/main.tf
module "core_resources" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-core/azurerm"
  version = "6.0.0"

  default_location             = var.default_location
  root_parent_id               = data.azurerm_client_config.current.subscription_id
  root_id                      = var.root_id
  root_name                    = var.root_name
  subscription_display_name   = var.subscription_display_name
  subscription_id             = var.subscription_id
  deploy_root_keyvault         = var.deploy_root_keyvault
  deploy_root_log_analytics    = var.deploy_root_log_analytics
  deploy_telemetry_log_analytics = var.deploy_telemetry_log_analytics

  management_group_archetype_overrides = var.management_group_archetype_overrides
}

module "connectivity_resources" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-connectivity/azurerm"
  version = "6.0.0"

  default_location          = var.default_location
  deploy_bastion            = local.deploy_connectivity_resources ? var.deploy_bastion : false
  deploy_ddos_protection    = local.deploy_connectivity_resources ? var.deploy_ddos_protection : false
  deploy_firewall           = local.deploy_connectivity_resources ? var.deploy_firewall : false
  deploy_firewall_policy    = local.deploy_connectivity_resources ? var.deploy_firewall_policy : false
  firewall_policy_mode      = local.deploy_connectivity_resources ? var.firewall_policy_mode : "hub"
  deploy_nat_gateway        = local.deploy_connectivity_resources ? var.deploy_nat_gateway : false
  deploy_private_dns_zones  = local.deploy_connectivity_resources ? var.deploy_private_dns_zones : false
  deploy_public_ip_prefixes = local.deploy_connectivity_resources ? var.deploy_public_ip_prefixes : false
  shared_resource_group_name = local.deploy_connectivity_resources ? (
    var.shared_connectivity_resource_group_name != "" ? var.shared_connectivity_resource_group_name : module.core_resources.shared_connectivity_resource_group_name
  ) : null

  shared_route_table_name             = local.deploy_connectivity_resources ? var.shared_route_table_name : null
  shared_security_group_name          = local.deploy_connectivity_resources ? var.shared_security_group_name : null
  shared_virtual_network_address_space = local.deploy_connectivity_resources ? var.shared_virtual_network_address_space : null
  shared_virtual_network_dns_servers   = local.deploy_connectivity_resources ? var.shared_virtual_network_dns_servers : null
  shared_virtual_network_name         = local.deploy_connectivity_resources ? var.shared_virtual_network_name : null
  subscription_id                   = var.subscription_id
  virtual_network_address_space       = local.deploy_connectivity_resources ? var.virtual_network_address_space : null
  virtual_wan_hub_address_space       = local.deploy_connectivity_resources ? var.virtual_wan_hub_address_space : null
  virtual_wan_hub_name                = local.deploy_connectivity_resources ? var.virtual_wan_hub_name : null
  virtual_wan_name                    = local.deploy_connectivity_resources ? var.virtual_wan_name : null
  deploy_virtual_wan                  = local.deploy_connectivity_resources ? var.deploy_virtual_wan : false
  virtual_wan_hub_routing_intent      = local.deploy_connectivity_resources ? var.virtual_wan_hub_routing_intent : []
  deploy_virtual_network_peering      = local.deploy_connectivity_resources ? var.deploy_virtual_network_peering : false
  virtual_network_peering             = local.deploy_connectivity_resources ? var.virtual_network_peering : []
  bastion_settings                  = local.deploy_connectivity_resources ? var.bastion_settings : {}
  ddos_protection_settings          = local.deploy_connectivity_resources ? var.ddos_protection_settings : {}
  firewall_policy_settings          = local.deploy_connectivity_resources ? var.firewall_policy_settings : {}
  firewall_settings                 = local.deploy_connectivity_resources ? var.firewall_settings : {}
  nat_gateway_settings              = local.deploy_connectivity_resources ? var.nat_gateway_settings : {}
  private_dns_zones                 = local.deploy_connectivity_resources ? var.private_dns_zones : {}
  public_ip_prefixes_settings       = local.deploy_connectivity_resources ? var.public_ip_prefixes_settings : {}

  log_analytics_workspace_id = local.deploy_connectivity_resources ? (
    var.log_analytics_workspace_id != "" ? var.log_analytics_workspace_id : module.core_resources.log_analytics_workspace_id
  ) : null

  diagnostics_settings = local.deploy_connectivity_resources ? var.diagnostics_settings : {}
}

module "identity_resources" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-identity/azurerm"
  version = "6.0.0"

  default_location                    = var.default_location
  deploy_user_assigned_identity       = local.deploy_identity_resources ? var.deploy_user_assigned_identity : false
  shared_identity_resource_group_name = local.deploy_identity_resources ? (
    var.shared_identity_resource_group_name != "" ? var.shared_identity_resource_group_name : module.core_resources.shared_identity_resource_group_name
  ) : null

  subscription_id            = var.subscription_id
  user_assigned_identity_name = local.deploy_identity_resources ? var.user_assigned_identity_name : null

  diagnostics_settings = local.deploy_identity_resources ? var.diagnostics_settings : {}
}

module "management_resources" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-management/azurerm"
  version = "6.0.0"

  default_location                     = var.default_location
  deploy_log_analytics                 = local.deploy_management_resources ? var.deploy_log_analytics : false
  deploy_resource_group                = local.deploy_management_resources ? var.deploy_resource_group : false
  deploy_security_center               = local.deploy_management_resources ? var.deploy_security_center : false
  deploy_subscription_configuration    = local.deploy_management_resources ? var.deploy_subscription_configuration : false
  location                             = var.log_analytics_location != "" ? var.log_analytics_location : var.default_location
  log_analytics_allowed_locations      = local.deploy_management_resources ? var.log_analytics_allowed_locations : null
  log_analytics_data_retention_in_days = local.deploy_management_resources ? var.log_analytics_data_retention_in_days : null
  log_analytics_name                   = local.deploy_management_resources ? var.log_analytics_name : null
  resource_group_name                  = local.deploy_management_resources ? var.resource_group_name : null
  subscription_id                      = var.subscription_id
  shared_resource_group_name = local.deploy_management_resources ? (
    var.shared_management_resource_group_name != "" ? var.shared_management_resource_group_name : module.core_resources.shared_management_resource_group_name
  ) : null

  diagnostics_settings                         = local.deploy_management_resources ? var.diagnostics_settings : {}
  log_analytics_linked_storage_account_ids     = local.deploy_management_resources ? var.log_analytics_linked_storage_account_ids : []
  log_analytics_solution_settings              = local.deploy_management_resources ? var.log_analytics_solution_settings : {}
  security_center_auto_provision              = local.deploy_management_resources ? var.security_center_auto_provision : null
  security_center_contact_email               = local.deploy_management_resources ? var.security_center_contact_email : null
  security_center_contact_phone               = local.deploy_management_resources ? var.security_center_contact_phone : null
  security_center_contact_alerts_notifications = local.deploy_management_resources ? var.security_center_contact_alerts_notifications : null
  security_center_contact_alerts_admins        = local.deploy_management_resources ? var.security_center_contact_alerts_admins : null
  security_center_standard_pricing_enabled     = local.deploy_management_resources ? var.security_center_standard_pricing_enabled : null
  security_center_suppression_rules            = local.deploy_management_resources ? var.security_center_suppression_rules : {}
  security_center_workspace_integration        = local.deploy_management_resources ? var.security_center_workspace_integration : null
  subscription_configuration                   = local.deploy_management_resources ? var.subscription_configuration : {}
}

module "management_group_archetypes" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-archetypes/azurerm"
  version = "6.0.0"

  # Required variables
  root_parent_id          = data.azurerm_client_config.current.subscription_id
  root_id                 = var.root_id
  root_name               = var.root_name
  default_location        = var.default_location
  subscription_ids        = [var.subscription_id]
  deploy_landing_zones    = var.deploy_landing_zones
  log_analytics_workspace_id = local.deploy_landing_zones ? (
    var.log_analytics_workspace_id != "" ? var.log_analytics_workspace_id : module.core_resources.log_analytics_workspace_id
  ) : null

  # Optional variables
  archetype_config_overrides           = var.archetype_config_overrides
  archetype_exclusions                 = var.archetype_exclusions
  archetype_extensions                 = var.archetype_extensions
  deploy_resource_instances            = var.deploy_resource_instances
  enforce_no_inherit_on_policy_assign  = var.enforce_no_inherit_on_policy_assign
  log_analytics_location               = var.log_analytics_location
  management_group_subscription_rules  = var.management_group_subscription_rules
  management_group_template_definitions = var.management_group_template_definitions
  subscription_display_name            = var.subscription_display_name
  use_secondary_location               = var.use_secondary_location
  secondary_location                   = var.secondary_location
  diagnostics_settings                     = var.deploy_diagnostics_for_mg ? var.diagnostics_settings : {}

  # Conditional variables - must align with `var.deploy_landing_zones`
  # Connectivity
  connectivity_subscription_id                    = local.deploy_connectivity_resources ? var.subscription_id : null
  connectivity_shared_resource_group_name         = local.deploy_connectivity_resources ? module.connectivity_resources.shared_resource_group_name : null
  connectivity_shared_virtual_network_id          = local.deploy_connectivity_resources ? module.connectivity_resources.shared_virtual_network_id : null
  connectivity_shared_virtual_network_address_space = local.deploy_connectivity_resources ? module.connectivity_resources.shared_virtual_network_address_space : null

  # Identity
  identity_subscription_id                    = local.deploy_identity_resources ? var.subscription_id : null
  identity_shared_resource_group_name         = local.deploy_identity_resources ? module.identity_resources.shared_identity_resource_group_name : null

  # Management
  management_subscription_id                    = local.deploy_management_resources ? var.subscription_id : null
  management_shared_resource_group_name         = local.deploy_management_resources ? module.management_resources.shared_resource_group_name : null
}