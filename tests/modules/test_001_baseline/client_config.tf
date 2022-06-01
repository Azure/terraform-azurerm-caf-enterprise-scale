data "azurerm_client_config" "current" {
}

data "azurerm_client_config" "management" {
  provider = azurerm.management
}
