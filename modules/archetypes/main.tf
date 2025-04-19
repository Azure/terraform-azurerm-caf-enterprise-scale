terraform
# modules/archetypes/main.tf
module "core_resources" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-core/azurerm"
  version = "6.2.0"

  # insert other module configurations here
}

module "connectivity_resources" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-connectivity/azurerm"
  version = "6.2.0"

  # insert other module configurations here
}

module "identity_resources" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-identity/azurerm"
  version = "6.2.0"

  # insert other module configurations here
}

module "management_resources" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-management/azurerm"
  version = "6.2.0"

  # insert other module configurations here
}

module "management_group_archetypes" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-archetypes/azurerm"
  version = "6.2.0"

  # insert other module configurations here
}

# modules/connectivity/main.tf
module "core_resources" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-core/azurerm"
  version = "6.2.0"

  # insert other module configurations here
}

module "connectivity_resources" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-connectivity/azurerm"
  version = "6.2.0"

  # insert other module configurations here
}

module "identity_resources" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-identity/azurerm"
  version = "6.2.0"

  # insert other module configurations here
}

module "management_resources" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-management/azurerm"
  version = "6.2.0"

  # insert other module configurations here
}

module "management_group_archetypes" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-archetypes/azurerm"
  version = "6.2.0"

  # insert other module configurations here
}

# modules/identity/main.tf
module "core_resources" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-core/azurerm"
  version = "6.2.0"

  # insert other module configurations here
}

module "connectivity_resources" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-connectivity/azurerm"
  version = "6.2.0"

  # insert other module configurations here
}

module "identity_resources" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-identity/azurerm"
  version = "6.2.0"

  # insert other module configurations here
}

module "management_resources" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-management/azurerm"
  version = "6.2.0"

  # insert other module configurations here
}

module "management_group_archetypes" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-archetypes/azurerm"
  version = "6.2.0"

  # insert other module configurations here
}

# modules/management/main.tf
module "core_resources" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-core/azurerm"
  version = "6.2.0"

  # insert other module configurations here
}

module "connectivity_resources" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-connectivity/azurerm"
  version = "6.2.0"

  # insert other module configurations here
}

module "identity_resources" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-identity/azurerm"
  version = "6.2.0"

  # insert other module configurations here
}

module "management_resources" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-management/azurerm"
  version = "6.2.0"

  # insert other module configurations here
}

module "management_group_archetypes" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-archetypes/azurerm"
  version = "6.2.0"

  # insert other module configurations here
}