variable "root_id" {
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

variable "enable_ddos_protection" {
  type = bool
}

variable "connectivity_resources_tags" {
  type = map(string)
}
