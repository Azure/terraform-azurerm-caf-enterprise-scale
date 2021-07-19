# The following variables are used to determine the archetype
# definition to use and create the required resources.
#
# Further information provided within the description block
# for each variable

variable "enabled" {
  type        = bool
  description = "Controls whether to manage the connectivity landing zone policies and deploy the connectivity resources into the current Subscription context."
}

variable "root_id" {
  type        = string
  description = "Specifies the ID of the Enterprise-scale root Management Group, used as a prefix for resources created by this module."

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{2,10}$", var.root_id))
    error_message = "Value must be between 2 to 10 characters long, consisting of alphanumeric characters and hyphens."
  }
}

variable "subscription_id" {
  type        = string
  description = "Specifies the Subscription ID for the Subscription containing all connectivity resources."

  validation {
    condition     = can(regex("^[a-z0-9-]{36}$", var.subscription_id)) || var.subscription_id == ""
    error_message = "Value must be a valid Subscription ID (GUID)."
  }
}

variable "location" {
  type        = string
  description = "Sets the default location used for resource deployments where needed."
  default     = "eastus"
}

variable "tags" {
  type        = map(string)
  description = "If specified, will set the default tags for all resources deployed by this module where supported."
  default     = {}
}

variable "settings" {
  type = object({
    hub_networks = list(
      object({
        enabled = bool
        config = object({
          address_space                   = list(string)
          location                        = string
          enable_ddos_protection_standard = bool
          dns_servers                     = list(string)
          bgp_community                   = string
          subnets = list(
            object({
              name                      = string
              address_prefixes          = list(string)
              network_security_group_id = string
              route_table_id            = string
            })
          )
          virtual_network_gateway = object({
            enabled = bool
            config = object({
              address_prefix           = string # Only support adding a single address prefix for GatewaySubnet subnet
              gateway_sku_expressroute = string # If specified, will deploy the ExpressRoute gateway into the GatewaySubnet subnet
              gateway_sku_vpn          = string # If specified, will deploy the VPN gateway into the GatewaySubnet subnet
            })
          })
          azure_firewall = object({
            enabled = bool
            config = object({
              address_prefix   = string # Only support adding a single address prefix for AzureFirewallManagementSubnet subnet
              enable_dns_proxy = bool
              availability_zones = object({
                zone_1 = bool
                zone_2 = bool
                zone_3 = bool
              })
            })
          })
        })
      })
    )
    vwan_hub_networks = list(object({}))
    ddos_protection_plan = object({
      enabled = bool
      config = object({
        location = string
      })
    })
    dns = object({
      enabled = bool
      config = object({
        location          = string
        public_dns_zones  = list(string)
        private_dns_zones = list(string)
      })
    })
  })
  description = "Configuration settings for the \"Connectivity\" landing zone resources."
}

variable "resource_prefix" {
  type        = string
  description = "If specified, will set the resource name prefix for connectivity resources (default value determined from \"var.root_id\")."
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{2,10}$", var.resource_prefix)) || var.resource_prefix == ""
    error_message = "Value must be between 2 to 10 characters long, consisting of alphanumeric characters and hyphens."
  }
}

variable "resource_suffix" {
  type        = string
  description = "If specified, will set the resource name suffix for connectivity resources."
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{2,36}$", var.resource_suffix)) || var.resource_suffix == ""
    error_message = "Value must be between 2 to 36 characters long, consisting of alphanumeric characters and hyphens."
  }

}

variable "existing_ddos_protection_plan_resource_id" {
  type        = string
  description = "If specified, module will skip creation of DDoS Protection Plan and use existing."
  default     = ""
}

variable "custom_settings_by_resource_type" {
  type        = any
  description = "If specified, allows full customization of common settings for all resources (by type) deployed by this module."
  default     = {}

  validation {
    condition     = can([for k in keys(var.custom_settings_by_resource_type) : contains(["azurerm_resource_group", "azurerm_virtual_network", "azurerm_subnet", "azurerm_virtual_network_gateway", "azurerm_public_ip", "azurerm_firewall", "azurerm_network_ddos_protection_plan", "azurerm_dns_zone", "azurerm_virtual_network_peering"], k)]) || var.custom_settings_by_resource_type == {}
    error_message = "Invalid key specified. Please check the list of allowed resource types supported by the connectivity module for caf-enterprise-scale."
  }
}
