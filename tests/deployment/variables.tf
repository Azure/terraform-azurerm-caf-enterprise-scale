variable "root_id_1" {
  type    = string
  default = "root-1"
}

variable "root_id_2" {
  type    = string
  default = "root-2"
}

variable "root_id_3" {
  type    = string
  default = "root-3"
}

variable "root_name" {
  type    = string
  default = "Test Framework"
}

variable "location" {
  type    = string
  default = "uksouth"
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
