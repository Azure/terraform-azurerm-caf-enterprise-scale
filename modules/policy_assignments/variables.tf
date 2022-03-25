# Further information provided within the description block
# for each variable

variable "name" {
  type        = string
  description = "Name for the Policy Assignment."
}

variable "scope_id" {
  type        = string
  description = "Scope at which to create the Policy Assignment."
}

variable "policy_definition_id" {
  type        = string
  description = "Policy Definition ID to assign."
}

variable "description" {
  type        = string
  description = "Description for the Policy Assignment."
  default     = ""
}

variable "display_name" {
  type        = string
  description = "Display name for the Policy Assignment."
  default     = ""
}

variable "metadata" {
  type        = any
  description = "Metadata object for the Policy Assignment."
  default     = {}
}

variable "not_scopes" {
  type        = list(string)
  description = "List of notScopes for the Policy Assignment."
  default     = []
}

variable "location" {
  type        = string
  description = "Location for the Policy Assignment."
  default     = ""
}

variable "identity" {
  type        = any
  description = "Identity configuration object for the Policy Assignment."
  default     = {}
}

variable "parameters" {
  type        = any
  description = "Template object containing parameter settings for the Policy Assignment."
  default     = {}
}

variable "enforce" {
  type        = bool
  description = "Control the Policy Assignment enforcement mode."
  default     = true
}

variable "role_definition_ids" {
  type        = list(string)
  description = "List of Role Definition IDs for the Policy Assignment. Used to create Role Assignment(s) for the Managed Identity created for the Policy Assignment."
  default     = []
}

variable "role_assignment_scope_ids" {
  type        = list(string)
  description = "List of additional scopes IDs for Role Assignments needed for the Policy Assignment. By default, the module will create a Role Assignment at the same scope as the Policy Assignment."
  default     = []
}
