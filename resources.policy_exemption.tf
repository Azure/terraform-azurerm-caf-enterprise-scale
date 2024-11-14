resource "azurerm_resource_group_policy_exemption" "policy_mitigated_by_overwrite" {
  for_each             = { for idx, val in local.policy_mitigated : idx => val if val.is_resource_group }
  name                 = "caf-mitigated-${each.key}-${each.value.name}"
  resource_group_id    = each.value.overwrite_id
  policy_assignment_id = each.value.policy_assignment_id
  metadata             = each.value.metadata
  exemption_category   = "Mitigated"
}

resource "azurerm_subscription_policy_exemption" "policy_mitigated_by_overwrite" {
  for_each             = { for idx, val in local.policy_mitigated : idx => val if val.is_subscription }
  name                 = "caf-mitigated-${each.key}-${each.value.name}"
  subscription_id      = each.value.overwrite_id
  policy_assignment_id = each.value.policy_assignment_id
  metadata             = each.value.metadata
  exemption_category   = "Mitigated"
}

# if it is neither a subscription nor a resource group, it must be a resource
resource "azurerm_resource_policy_exemption" "policy_mitigated_by_overwrite" {
  for_each             = { for idx, val in local.policy_mitigated : idx => val if !val.is_subscription && !val.is_resource_group }
  name                 = "caf-mitigated-${each.key}-${each.value.name}"
  resource_id          = each.value.overwrite_id
  policy_assignment_id = each.value.policy_assignment_id
  metadata             = each.value.metadata
  exemption_category   = "Mitigated"
}


resource "azurerm_resource_group_policy_exemption" "initiative_mitigated_by_overwrite" {
  for_each                        = { for idx, val in local.initiative_mitigated : idx => val if val.is_resource_group }
  name                            = "caf-mitigated-${each.key}-${each.value.name}"
  resource_group_id               = each.value.overwrite_id
  policy_assignment_id            = each.value.policy_assignment_id
  metadata                        = each.value.metadata
  exemption_category              = "Mitigated"
  policy_definition_reference_ids = each.value.policy_definition_reference_ids
}

resource "azurerm_subscription_policy_exemption" "initiative_mitigated_by_overwrite" {
  for_each                        = { for idx, val in local.initiative_mitigated : idx => val if val.is_subscription }
  name                            = "caf-mitigated-${each.key}-${each.value.name}"
  subscription_id                 = each.value.overwrite_id
  policy_assignment_id            = each.value.policy_assignment_id
  metadata                        = each.value.metadata
  exemption_category              = "Mitigated"
  policy_definition_reference_ids = each.value.policy_definition_reference_ids
}

# if it is neither a subscription nor a resource group, it must be a resource
resource "azurerm_resource_policy_exemption" "initiative_mitigated_by_overwrite" {
  for_each                        = { for idx, val in local.initiative_mitigated : idx => val if !val.is_subscription && !val.is_resource_group }
  name                            = "caf-mitigated-${each.key}-${each.value.name}"
  resource_id                     = each.value.overwrite_id
  policy_assignment_id            = each.value.policy_assignment_id
  metadata                        = each.value.metadata
  exemption_category              = "Mitigated"
  policy_definition_reference_ids = each.value.policy_definition_reference_ids
}
