config {
  module = true
}

plugin "azurerm" {
  enabled = true
  version = "0.16.0"
  source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}
