resource "azurerm_private_endpoint" "blob" {
  name                = local.names.private_endpoint
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = local.names.private_endpoint
    private_connection_resource_id = azurerm_storage_account.this.id
    subresource_names              = [local.blob_service.subresource]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = local.names.dns_zone_group
    private_dns_zone_ids = [azurerm_private_dns_zone.blob.id]
  }

  tags = local.tags
}

resource "azurerm_private_dns_zone" "blob" {
  name                = local.names.private_dns_zone
  resource_group_name = azurerm_resource_group.this.name
  tags                = local.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "blob" {
  name                  = local.names.dns_zone_vnet_link
  resource_group_name   = azurerm_resource_group.this.name
  private_dns_zone_name = azurerm_private_dns_zone.blob.name
  virtual_network_id    = var.private_dns_zone_vnet_id
  registration_enabled  = false
  tags                  = local.tags
}
