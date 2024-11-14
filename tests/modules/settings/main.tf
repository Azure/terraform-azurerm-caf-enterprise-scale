data "azurerm_client_config" "core" {}

locals {
  umi_name                = "id-${var.root_id}-identity"
  umi_resource_group_name = "rg-${var.root_id}-identity"
}

resource "azurerm_resource_group" "example" {
  name     = local.umi_resource_group_name
  location = var.primary_location
}

resource "azurerm_user_assigned_identity" "example" {
  location            = azurerm_resource_group.example.location
  name                = local.umi_name
  resource_group_name = azurerm_resource_group.example.name
}
