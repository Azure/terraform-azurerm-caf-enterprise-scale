variable "root_id" {
  type    = string
  default = "12345"
}

variable "root_name" {
  type    = string
  default = "Test Framework"
}

variable "primary_location" {
  type    = string
  default = "northeurope"
}

variable "secondary_location" {
  type    = string
  default = "westeurope"
}

variable "create_duration_delay" {
  type = map(string)
  default = {
    azurerm_management_group = "120s"
  }
}

variable "destroy_duration_delay" {
  type    = map(string)
  default = {}
}
