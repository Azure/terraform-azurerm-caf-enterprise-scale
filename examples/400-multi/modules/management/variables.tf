variable "root_id" {
  type = string
}

variable "primary_location" {
  type = string
}

variable "secondary_location" {
  type = string
}

variable "subscription_id_management" {
  type = string
}

variable "email_security_contact" {
  type = string
}

variable "log_retention_in_days" {
  type = number
}

variable "management_resources_tags" {
  type = map(string)
}
