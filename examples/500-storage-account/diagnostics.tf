# Diagnostic settings for the blob service sub-resource.
# Captures read/write/delete operations and transaction metrics.
resource "azurerm_monitor_diagnostic_setting" "blob" {
  name                       = "diag-${local.names.storage_account}-blob"
  target_resource_id         = "${azurerm_storage_account.this.id}/blobServices/default"
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "StorageRead"
  }

  enabled_log {
    category = "StorageWrite"
  }

  enabled_log {
    category = "StorageDelete"
  }

  metric {
    category = "Transaction"
    enabled  = true
  }

  metric {
    category = "Capacity"
    enabled  = true
  }
}

# Diagnostic settings at the storage account level (account-level metrics).
resource "azurerm_monitor_diagnostic_setting" "account" {
  name                       = "diag-${local.names.storage_account}"
  target_resource_id         = azurerm_storage_account.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  metric {
    category = "Transaction"
    enabled  = true
  }

  metric {
    category = "Capacity"
    enabled  = true
  }
}
