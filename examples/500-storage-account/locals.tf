# ── Location shortname mapping (Azure CAF abbreviations) ───────────────────────
locals {
  # ── Symbolic service definition ─────────────────────────────────────────────
  # Single source of truth for the blob service: subresource name, DNS zone,
  # diagnostic target path, and log/metric category lists.
  # Update this block if a different storage service sub-resource is targeted.
  blob_service = {
    subresource       = "blob"
    private_dns       = "privatelink.blob.core.windows.net"
    diag_path         = "blobServices/default"
    log_categories    = ["StorageRead", "StorageWrite", "StorageDelete"]
    metric_categories = ["Transaction", "Capacity"]
  }


  location_short = {
    "norwayeast"        = "noe"
    "norwaywest"        = "now"
    "northeurope"       = "neu"
    "westeurope"        = "weu"
    "swedencentral"     = "swc"
    "uksouth"           = "uks"
    "ukwest"            = "ukw"
    "eastus"            = "eus"
    "eastus2"           = "eus2"
    "westus"            = "wus"
    "westus2"           = "wus2"
    "westus3"           = "wus3"
    "centralus"         = "cus"
    "australiaeast"     = "aue"
    "southeastasia"     = "sea"
    "eastasia"          = "ea"
    "japaneast"         = "jpe"
    "brazilsouth"       = "brs"
  }

  loc = lookup(local.location_short, var.location, substr(replace(var.location, " ", ""), 0, 6))

  # ── CAF resource names ──────────────────────────────────────────────────────
  # Storage account names: lowercase alphanumeric only, max 24 chars, globally unique.
  storage_account_name = lower(substr("st${var.workload}${var.environment}${local.loc}${var.instance}", 0, 24))

  names = {
    resource_group         = "rg-${var.workload}-${var.environment}-${local.loc}"
    user_assigned_identity = "id-${var.workload}-${var.environment}-${local.loc}"
    storage_account        = local.storage_account_name
    # Private endpoint names derived from blob_service.subresource — no hardcoded "blob".
    private_endpoint       = "pep-${var.workload}-${var.environment}-${local.loc}-${local.blob_service.subresource}"
    private_dns_zone       = local.blob_service.private_dns
    dns_zone_vnet_link     = "vnetlnk-${var.workload}-${var.environment}-${local.loc}-${local.blob_service.subresource}"
    dns_zone_group         = "pdnszg-${var.workload}-${var.environment}-${local.loc}-${local.blob_service.subresource}"
  }

  # ── Default tags ────────────────────────────────────────────────────────────
  default_tags = {
    environment  = var.environment
    cost_center  = var.cost_center
    owner        = var.owner
    workload     = var.workload
    managed_by   = "terraform"
  }

  tags = merge(local.default_tags, var.additional_tags)
}
