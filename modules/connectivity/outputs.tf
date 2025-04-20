output "configuration" {
  value       = local.module_output
  description = "Returns the configuration settings for resources to deploy for the connectivity solution."
}

output "debug" {
  value       = local.debug_output
  description = "Returns the debug output for the module."
}
