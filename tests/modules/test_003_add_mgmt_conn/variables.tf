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

variable "tertiary_location" {
  type        = string
  description = "Sets the location for \"tertiary\" resources to be created in."
  default     = "uksouth"
}

variable "subscription_id_connectivity" {
  type        = string
  description = "Sets the subscription ID to use for deploying \"connectivity\" resources."
  default     = ""
}

variable "subscription_id_management" {
  type        = string
  description = "Sets the subscription ID to use for deploying \"management\" resources."
  default     = ""
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
