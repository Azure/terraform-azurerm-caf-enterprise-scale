variable "root_id" {
  type        = string
  description = "Sets the value used for generating unique resource naming within the module."
  default     = "test"
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

variable "email_security_contact" {
  type        = string
  description = "Set a custom value for the security contact email address."
  default     = "test.user@replace_me"
}
