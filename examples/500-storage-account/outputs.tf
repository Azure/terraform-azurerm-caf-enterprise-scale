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

output "primary_blob_endpoint" {
  description = "Primary blob endpoint URL."
  value       = azurerm_storage_account.this.primary_blob_endpoint
}

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

output "private_endpoint_id" {
  description = "Resource ID of the blob private endpoint."
  value       = azurerm_private_endpoint.blob.id
}

output "private_endpoint_ip_address" {
  description = "Private IP address assigned to the blob private endpoint NIC."
  value       = azurerm_private_endpoint.blob.private_service_connection[0].private_ip_address
}
