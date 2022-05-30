variable "root_id" {
  type        = string
  description = "Sets the value used for generating unique resource naming within the module."
  default     = "12345"
}

variable "root_name" {
  type        = string
  description = "Sets the display name of the \"root\" Management Group."
  default     = "Test Framework"
}

variable "primary_location" {
  type        = string
  description = "Sets the location for \"primary\" resources to be created in."
  default     = "northeurope"
}

variable "secondary_location" {
  type        = string
  description = "Sets the location for \"secondary\" resources to be created in."
  default     = "westeurope"
}

variable "create_duration_delay" {
  type        = map(string)
  description = "Sets a custom delay period after creation of the specified resource type."
  default = {
    azurerm_management_group = "120s"
  }
}

variable "destroy_duration_delay" {
  type        = map(string)
  description = "Sets a custom delay period after destruction of the specified resource type."
  default     = {}
}
