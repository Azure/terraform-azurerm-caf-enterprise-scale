output "resource_group_name" {
  description = "Name of the resource group containing all storage resources."
  value       = azurerm_resource_group.this.name
}

output "storage_account_id" {
  description = "Resource ID of the storage account."
  value       = azurerm_storage_account.this.id
}

output "storage_account_name" {
  description = "Name of the storage account."
  value       = azurerm_storage_account.this.name
}

# ── Primary endpoints (individual) ─────────────────────────────────────────────

output "primary_blob_endpoint" {
  description = "Primary blob service endpoint URL."
  value       = azurerm_storage_account.this.primary_blob_endpoint
}

output "primary_queue_endpoint" {
  description = "Primary queue service endpoint URL."
  value       = azurerm_storage_account.this.primary_queue_endpoint
}

output "primary_table_endpoint" {
  description = "Primary table service endpoint URL."
  value       = azurerm_storage_account.this.primary_table_endpoint
}

output "primary_file_endpoint" {
  description = "Primary file service endpoint URL."
  value       = azurerm_storage_account.this.primary_file_endpoint
}

output "primary_dfs_endpoint" {
  description = "Primary Data Lake Storage Gen2 (DFS) endpoint URL."
  value       = azurerm_storage_account.this.primary_dfs_endpoint
}

output "primary_web_endpoint" {
  description = "Primary static website endpoint URL."
  value       = azurerm_storage_account.this.primary_web_endpoint
}

# ── Consolidated endpoints object ───────────────────────────────────────────────
# Convenience output for callers that need all endpoints as a single object.

output "primary_endpoints" {
  description = "Map of all primary storage service endpoint URLs (blob, queue, table, file, dfs, web)."
  value = {
    blob  = azurerm_storage_account.this.primary_blob_endpoint
    queue = azurerm_storage_account.this.primary_queue_endpoint
    table = azurerm_storage_account.this.primary_table_endpoint
    file  = azurerm_storage_account.this.primary_file_endpoint
    dfs   = azurerm_storage_account.this.primary_dfs_endpoint
    web   = azurerm_storage_account.this.primary_web_endpoint
  }
}

# ── Managed identity ────────────────────────────────────────────────────────────

output "user_assigned_identity_id" {
  description = "Resource ID of the user-assigned managed identity."
  value       = azurerm_user_assigned_identity.this.id
}

output "user_assigned_identity_principal_id" {
  description = "Principal (object) ID of the managed identity — use for RBAC role assignments."
  value       = azurerm_user_assigned_identity.this.principal_id
}

output "user_assigned_identity_client_id" {
  description = "Client (application) ID of the managed identity — use for workload identity federation."
  value       = azurerm_user_assigned_identity.this.client_id
}

# ── Private endpoint ────────────────────────────────────────────────────────────

output "private_endpoint_id" {
  description = "Resource ID of the blob private endpoint."
  value       = azurerm_private_endpoint.blob.id
}

output "private_endpoint_ip_address" {
  description = "Private IP address assigned to the blob private endpoint NIC."
  value       = azurerm_private_endpoint.blob.private_service_connection[0].private_ip_address
}
