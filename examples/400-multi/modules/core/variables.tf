variable "root_id" {
  type = string
}

variable "root_name" {
  type = string
}

variable "primary_location" {
  type = string
}

variable "secondary_location" {
  type = string
}

variable "subscription_id_connectivity" {
  type = string
}

variable "subscription_id_identity" {
  type = string
}

variable "subscription_id_management" {
  type = string
}

variable "configure_connectivity_resources" {
  type = any
}

variable "configure_management_resources" {
  type = any
}
