resource "azurerm_resource_group" "management" {
  for_each = local.azurerm_resource_group_management

  provider = azurerm.management

  # Mandatory resource attributes
  name     = each.value.template.name
  location = each.value.template.location
  tags     = each.value.template.tags
}

resource "azurerm_log_analytics_workspace" "management" {
  for_each = local.azurerm_log_analytics_workspace_management

  provider = azurerm.management

  # Mandatory resource attributes
  name                = each.value.template.name
  location            = each.value.template.location
  resource_group_name = each.value.template.resource_group_name

  # Optional resource attributes
  sku                                = each.value.template.sku
  retention_in_days                  = each.value.template.retention_in_days
  daily_quota_gb                     = each.value.template.daily_quota_gb
  cmk_for_query_forced               = each.value.template.cmk_for_query_forced
  internet_ingestion_enabled         = each.value.template.internet_ingestion_enabled
  internet_query_enabled             = each.value.template.internet_query_enabled
  reservation_capacity_in_gb_per_day = each.value.template.reservation_capacity_in_gb_per_day
  tags                               = each.value.template.tags

  # allow_resource_only_permissions = each.value.template.allow_resource_only_permissions # Available only in v3.36.0 onwards

  # Set explicit dependency on Resource Group deployment
  depends_on = [
    azurerm_resource_group.management,
  ]

}

resource "azurerm_log_analytics_solution" "management" {
  for_each = local.azurerm_log_analytics_solution_management

  provider = azurerm.management

  # Mandatory resource attributes
  solution_name         = each.value.template.solution_name
  location              = each.value.template.location
  resource_group_name   = each.value.template.resource_group_name
  workspace_resource_id = each.value.template.workspace_resource_id
  workspace_name        = each.value.template.workspace_name

  plan {
    publisher = each.value.template.plan.publisher
    product   = each.value.template.plan.product
  }

  # Optional resource attributes
  tags = each.value.template.tags

  # Set explicit dependency on Resource Group, Log Analytics
  # workspace and Automation Account to fix issue #109.
  # Ideally we would limit to specific solutions, but the
  # depends_on block only supports static values.
  depends_on = [
    azurerm_resource_group.management,
    azurerm_log_analytics_workspace.management,
    azurerm_automation_account.management,
    azurerm_log_analytics_linked_service.management,
  ]

}

resource "azurerm_automation_account" "management" {
  for_each = local.azurerm_automation_account_management

  provider = azurerm.management

  # Mandatory resource attributes
  name                = each.value.template.name
  location            = each.value.template.location
  resource_group_name = each.value.template.resource_group_name

  # Optional resource attributes
  sku_name                      = each.value.template.sku_name
  public_network_access_enabled = each.value.template.public_network_access_enabled
  local_authentication_enabled  = each.value.template.local_authentication_enabled
  tags                          = each.value.template.tags

  # Dynamic configuration blocks
  dynamic "identity" {
    for_each = each.value.template.identity
    content {
      # Mandatory attributes
      type = identity.value.type
      # Optional attributes
      identity_ids = lookup(identity.value, "identity_ids", null)
    }
  }

  dynamic "encryption" {
    for_each = each.value.template.encryption
    content {
      # Mandatory attributes
      key_vault_key_id = encryption.value["key_vault_key_id"]
      # Optional attributes
      user_assigned_identity_id = lookup(encryption.value, "user_assigned_identity_id", null)
      key_source                = lookup(encryption.value, "key_source", null)
    }
  }

  # Set explicit dependency on Resource Group deployment
  depends_on = [
    azurerm_resource_group.management,
  ]

}

resource "azurerm_log_analytics_linked_service" "management" {
  for_each = local.azurerm_log_analytics_linked_service_management

  provider = azurerm.management

  # Mandatory resource attributes
  resource_group_name = each.value.template.resource_group_name
  workspace_id        = each.value.template.workspace_id

  # Optional resource attributes
  read_access_id  = each.value.template.read_access_id
  write_access_id = each.value.template.write_access_id

  # Set explicit dependency on Resource Group, Log Analytics workspace and Automation Account deployments
  depends_on = [
    azurerm_resource_group.management,
    azurerm_log_analytics_workspace.management,
    azurerm_automation_account.management,
  ]

}
