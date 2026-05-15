# Diagnostic settings for the blob service sub-resource.
# Log and metric categories are driven by local.blob_service — no hardcoded strings.
resource "azurerm_monitor_diagnostic_setting" "blob" {
  name                       = "diag-${local.names.storage_account}-${local.blob_service.subresource}"
  target_resource_id         = "${azurerm_storage_account.this.id}/${local.blob_service.diag_path}"
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "enabled_log" {
    for_each = local.blob_service.log_categories
    content {
      category = enabled_log.value
    }
  }

  dynamic "metric" {
    for_each = local.blob_service.metric_categories
    content {
      category = metric.value
      enabled  = true
    }
  }
}

# Diagnostic settings at the storage account level (account-level metrics).
resource "azurerm_monitor_diagnostic_setting" "account" {
  name                       = "diag-${local.names.storage_account}"
  target_resource_id         = azurerm_storage_account.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "metric" {
    for_each = local.blob_service.metric_categories
    content {
      category = metric.value
      enabled  = true
    }
  }
}
