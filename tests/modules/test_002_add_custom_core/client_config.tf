data "azurerm_client_config" "current" {
}

data "azurerm_client_config" "connectivity" {
  provider = azurerm.connectivity
}

data "azurerm_client_config" "management" {
  provider = azurerm.management
}
