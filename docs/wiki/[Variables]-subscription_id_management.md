## Overview 
[**subscription_id_managmement**] `string` (optional)

If specified, identifies the Platform subscription for \"Management\" for resource deployment and correct placement in the Management Group hierarchy.

## Default value
```hcl
variable "subscription_id_management" {
  type        = string
  description = ""
  default     = ""
 ```

## Validation
The subscription can be a passed in string that is 36 characters long containing alphanumeric characters, a string passed in through the variable "subscription_id_management", or an empty white string in the event that it's pulled in from the provider/ 
 ```hcl
  validation {
    condition     = can(regex("^[a-z0-9-]{36}$", var.subscription_id_management)) || var.subscription_id_management == ""
    error_message = "Value must be a valid Subscription ID (GUID)."
  }
}
```
