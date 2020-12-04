provider "azurerm" {
  version = "2.39"
  features {}
}

data "azurerm_client_config" "current" {}

variable "root_id" {
  type = string
}

variable "root_name" {
  type = string
}

module "enterprise_scale" {
  source = "../../"

  root_parent_id = data.azurerm_client_config.current.tenant_id
  root_id        = var.root_id
  root_name      = var.root_name

  deploy_core_landing_zones = true
  deploy_demo_landing_zones = true
}
