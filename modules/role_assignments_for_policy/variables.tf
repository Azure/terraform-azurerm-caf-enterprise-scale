# Further information provided within the description block
# for each variable

variable "policy_assignment_id" {
  type        = string
  description = "Policy Assignment ID."
}

variable "scope_id" {
  type        = string
  description = "Scope ID from the Policy Assignment. Depending on the Policy Assignment type, this could be the `management_group_id`, `subscription_id`, `resource_group_id` or `resource_id`."
}

variable "principal_id" {
  type        = string
  description = "Principal ID of the Managed Identity created for the Policy Assignment."
}

variable "role_definition_ids" {
  type        = list(string)
  description = "List of Role Definition IDs for the Policy Assignment. Used to create Role Assignment(s) for the Managed Identity created for the Policy Assignment."
  default     = []
}

variable "additional_scope_ids" {
  type        = list(string)
  description = "List of additional scopes IDs for Role Assignments needed for the Policy Assignment. By default, the module will create a Role Assignment at the same scope as the Policy Assignment."
  default     = []
}
