terraform
# modules/archetypes/main.tf
module "core_resources" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-core/azurerm"
  version = "7.1.0"

  default_location             = var.default_location
  root_parent_id               = var.root_parent_id
  root_id                      = var.root_id
  root_name                    = var.root_name
  subscription_display_name    = var.subscription_display_name
  subscription_alias_enabled   = var.subscription_alias_enabled
  subscription_alias_id        = var.subscription_alias_id
  subscription_id              = var.subscription_id
  features                     = var.features
  management_group_associations = var.management_group_associations
  tags                         = var.tags
}

module "connectivity_resources" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-connectivity/azurerm"
  version = "7.1.0"

  # required inputs
  default_location          = var.default_location
  root_parent_id            = var.root_parent_id
  root_id                   = var.root_id
  networking                = var.networking
  shared_resource_group     = var.shared_resource_group
  subscription_id           = var.subscription_id
  tags                      = var.tags
  features                  = var.features
  use_custom_settings       = var.use_custom_settings
  custom_settings           = var.custom_settings
  shared_private_dns_zones  = var.shared_private_dns_zones

  # optional inputs - management group associations
  management_group_associations = var.management_group_associations

  providers = {
    azurerm.connectivity   = azurerm.connectivity
    azurerm.shared_dns_zones = azurerm.shared_dns_zones
  }
}

module "identity_resources" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-identity/azurerm"
  version = "7.1.0"

  default_location          = var.default_location
  root_parent_id            = var.root_parent_id
  root_id                   = var.root_id
  identity                = var.identity
  shared_resource_group     = var.shared_resource_group
  subscription_id           = var.subscription_id
  tags                      = var.tags
  features                  = var.features
  use_custom_settings       = var.use_custom_settings
  custom_settings           = var.custom_settings

  # optional inputs - management group associations
  management_group_associations = var.management_group_associations

  providers = {
    azurerm.identity = azurerm.identity
  }
}

module "management_resources" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-management/azurerm"
  version = "7.1.0"

  # required inputs
  default_location          = var.default_location
  root_parent_id            = var.root_parent_id
  root_id                   = var.root_id
  management              = var.management
  shared_resource_group     = var.shared_resource_group
  subscription_id           = var.subscription_id
  tags                      = var.tags
  features                  = var.features
  use_custom_settings       = var.use_custom_settings
  custom_settings           = var.custom_settings

  # optional inputs - management group associations
  management_group_associations = var.management_group_associations

  providers = {
    azurerm.management = azurerm.management
  }
}

module "management_group_archetypes" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-archetypes/azurerm"
  version = "7.1.0"

  # required inputs
  root_parent_id                 = var.root_parent_id
  root_id                        = var.root_id
  default_location               = var.default_location
  archetype_config_overrides     = var.archetype_config_overrides
  archetype_id                   = var.archetype_id
  archetype_overrides_enabled    = var.archetype_overrides_enabled
  deploy_location_signatures     = var.deploy_location_signatures
  enforce_location_allowed       = var.enforce_location_allowed
  features                       = var.features
  subscription_id                  = var.subscription_id
  use_custom_settings              = var.use_custom_settings
  custom_settings                  = var.custom_settings

  # optional inputs - n/a

  providers = {
    azurerm = azurerm
  }
}
```

```
terraform
# modules/connectivity/main.tf
module "core_resources" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-core/azurerm"
  version = "7.1.0"

  default_location             = var.default_location
  root_parent_id               = var.root_parent_id
  root_id                      = var.root_id
  root_name                    = var.root_name
  subscription_display_name    = var.subscription_display_name
  subscription_alias_enabled   = var.subscription_alias_enabled
  subscription_alias_id        = var.subscription_alias_id
  subscription_id              = var.subscription_id
  features                     = var.features
  management_group_associations = var.management_group_associations
  tags                         = var.tags
}

module "connectivity_resources" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-connectivity/azurerm"
  version = "7.1.0"

  # required inputs
  default_location          = var.default_location
  root_parent_id            = var.root_parent_id
  root_id                   = var.root_id
  networking                = var.networking
  shared_resource_group     = var.shared_resource_group
  subscription_id           = var.subscription_id
  tags                      = var.tags
  features                  = var.features
  use_custom_settings       = var.use_custom_settings
  custom_settings           = var.custom_settings
  shared_private_dns_zones  = var.shared_private_dns_zones

  # optional inputs - management group associations
  management_group_associations = var.management_group_associations

  providers = {
    azurerm.connectivity   = azurerm.connectivity
    azurerm.shared_dns_zones = azurerm.shared_dns_zones
  }
}

module "identity_resources" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-identity/azurerm"
  version = "7.1.0"

  default_location          = var.default_location
  root_parent_id            = var.root_parent_id
  root_id                   = var.root_id
  identity                = var.identity
  shared_resource_group     = var.shared_resource_group
  subscription_id           = var.subscription_id
  tags                      = var.tags
  features                  = var.features
  use_custom_settings       = var.use_custom_settings
  custom_settings           = var.custom_settings

  # optional inputs - management group associations
  management_group_associations = var.management_group_associations

  providers = {
    azurerm.identity = azurerm.identity
  }
}

module "management_resources" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-management/azurerm"
  version = "7.1.0"

  # required inputs
  default_location          = var.default_location
  root_parent_id            = var.root_parent_id
  root_id                   = var.root_id
  management              = var.management
  shared_resource_group     = var.shared_resource_group
  subscription_id           = var.subscription_id
  tags                      = var.tags
  features                  = var.features
  use_custom_settings       = var.use_custom_settings
  custom_settings           = var.custom_settings

  # optional inputs - management group associations
  management_group_associations = var.management_group_associations

  providers = {
    azurerm.management = azurerm.management
  }
}

module "management_group_archetypes" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-archetypes/azurerm"
  version = "7.1.0"

  # required inputs
  root_parent_id                 = var.root_parent_id
  root_id                        = var.root_id
  default_location               = var.default_location
  archetype_config_overrides     = var.archetype_config_overrides
  archetype_id                   = var.archetype_id
  archetype_overrides_enabled    = var.archetype_overrides_enabled
  deploy_location_signatures     = var.deploy_location_signatures
  enforce_location_allowed       = var.enforce_location_allowed
  features                       = var.features
  subscription_id                  = var.subscription_id
  use_custom_settings              = var.use_custom_settings
  custom_settings                  = var.custom_settings

  # optional inputs - n/a

  providers = {
    azurerm = azurerm
  }
}
```

```
terraform
# modules/identity/main.tf
module "core_resources" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-core/azurerm"
  version = "7.1.0"

  default_location             = var.default_location
  root_parent_id               = var.root_parent_id
  root_id                      = var.root_id
  root_name                    = var.root_name
  subscription_display_name    = var.subscription_display_name
  subscription_alias_enabled   = var.subscription_alias_enabled
  subscription_alias_id        = var.subscription_alias_id
  subscription_id              = var.subscription_id
  features                     = var.features
  management_group_associations = var.management_group_associations
  tags                         = var.tags
}

module "connectivity_resources" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-connectivity/azurerm"
  version = "7.1.0"

  # required inputs
  default_location          = var.default_location
  root_parent_id            = var.root_parent_id
  root_id                   = var.root_id
  networking                = var.networking
  shared_resource_group     = var.shared_resource_group
  subscription_id           = var.subscription_id
  tags                      = var.tags
  features                  = var.features
  use_custom_settings       = var.use_custom_settings
  custom_settings           = var.custom_settings
  shared_private_dns_zones  = var.shared_private_dns_zones

  # optional inputs - management group associations
  management_group_associations = var.management_group_associations

  providers = {
    azurerm.connectivity   = azurerm.connectivity
    azurerm.shared_dns_zones = azurerm.shared_dns_zones
  }
}

module "identity_resources" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-identity/azurerm"
  version = "7.1.0"

  default_location          = var.default_location
  root_parent_id            = var.root_parent_id
  root_id                   = var.root_id
  identity                = var.identity
  shared_resource_group     = var.shared_resource_group
  subscription_id           = var.subscription_id
  tags                      = var.tags
  features                  = var.features
  use_custom_settings       = var.use_custom_settings
  custom_settings           = var.custom_settings

  # optional inputs - management group associations
  management_group_associations = var.management_group_associations

  providers = {
    azurerm.identity = azurerm.identity
  }
}

module "management_resources" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-management/azurerm"
  version = "7.1.0"

  # required inputs
  default_location          = var.default_location
  root_parent_id            = var.root_parent_id
  root_id                   = var.root_id
  management              = var.management
  shared_resource_group     = var.shared_resource_group
  subscription_id           = var.subscription_id
  tags                      = var.tags
  features                  = var.features
  use_custom_settings       = var.use_custom_settings
  custom_settings           = var.custom_settings

  # optional inputs - management group associations
  management_group_associations = var.management_group_associations

  providers = {
    azurerm.management = azurerm.management
  }
}

module "management_group_archetypes" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-archetypes/azurerm"
  version = "7.1.0"

  # required inputs
  root_parent_id                 = var.root_parent_id
  root_id                        = var.root_id
  default_location               = var.default_location
  archetype_config_overrides     = var.archetype_config_overrides
  archetype_id                   = var.archetype_id
  archetype_overrides_enabled    = var.archetype_overrides_enabled
  deploy_location_signatures     = var.deploy_location_signatures
  enforce_location_allowed       = var.enforce_location_allowed
  features                       = var.features
  subscription_id                  = var.subscription_id
  use_custom_settings              = var.use_custom_settings
  custom_settings                  = var.custom_settings

  # optional inputs - n/a

  providers = {
    azurerm = azurerm
  }
}
```

```
terraform
# modules/management/main.tf
module "core_resources" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-core/azurerm"
  version = "7.1.0"

  default_location             = var.default_location
  root_parent_id               = var.root_parent_id
  root_id                      = var.root_id
  root_name                    = var.root_name
  subscription_display_name    = var.subscription_display_name
  subscription_alias_enabled   = var.subscription_alias_enabled
  subscription_alias_id        = var.subscription_alias_id
  subscription_id              = var.subscription_id
  features                     = var.features
  management_group_associations = var.management_group_associations
  tags                         = var.tags
}

module "connectivity_resources" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-connectivity/azurerm"
  version = "7.1.0"

  # required inputs
  default_location          = var.default_location
  root_parent_id            = var.root_parent_id
  root_id                   = var.root_id
  networking                = var.networking
  shared_resource_group     = var.shared_resource_group
  subscription_id           = var.subscription_id
  tags                      = var.tags
  features                  = var.features
  use_custom_settings       = var.use_custom_settings
  custom_settings           = var.custom_settings
  shared_private_dns_zones  = var.shared_private_dns_zones

  # optional inputs - management group associations
  management_group_associations = var.management_group_associations

  providers = {
    azurerm.connectivity   = azurerm.connectivity
    azurerm.shared_dns_zones = azurerm.shared_dns_zones
  }
}

module "identity_resources" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-identity/azurerm"
  version = "7.1.0"

  default_location          = var.default_location
  root_parent_id            = var.root_parent_id
  root_id                   = var.root_id
  identity                = var.identity
  shared_resource_group     = var.shared_resource_group
  subscription_id           = var.subscription_id
  tags                      = var.tags
  features                  = var.features
  use_custom_settings       = var.use_custom_settings
  custom_settings           = var.custom_settings

  # optional inputs - management group associations
  management_group_associations = var.management_group_associations

  providers = {
    azurerm.identity = azurerm.identity
  }
}

module "management_resources" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-management/azurerm"
  version = "7.1.0"

  # required inputs
  default_location          = var.default_location
  root_parent_id            = var.root_parent_id
  root_id                   = var.root_id
  management              = var.management
  shared_resource_group     = var.shared_resource_group
  subscription_id           = var.subscription_id
  tags                      = var.tags
  features                  = var.features
  use_custom_settings       = var.use_custom_settings
  custom_settings           = var.custom_settings

  # optional inputs - management group associations
  management_group_associations = var.management_group_associations

  providers = {
    azurerm.management = azurerm.management
  }
}

module "management_group_archetypes" {
  source  = "hashicorp.com/Azure/caf-terraform-landingzones-archetypes/azurerm"
  version = "7.1.0"

  # required inputs
  root_parent_id                 = var.root_parent_id
  root_id                        = var.root_id
  default_location               = var.default_location
  archetype_config_overrides     = var.archetype_config_overrides
  archetype_id                   = var.archetype_id
  archetype_overrides_enabled    = var.archetype_overrides_enabled
  deploy_location_signatures     = var.deploy_location_signatures
  enforce_location_allowed       = var.enforce_location_allowed
  features                       = var.features
  subscription_id                  = var.subscription_id
  use_custom_settings              = var.use_custom_settings
  custom_settings                  = var.custom_settings

  # optional inputs - n/a

  providers = {
    azurerm = azurerm
  }
}