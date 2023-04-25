# Obtain configuration settings.
module "settings" {
  source = "../settings"

  root_id            = var.root_id
  primary_location   = var.primary_location
  secondary_location = var.secondary_location
  tertiary_location  = var.tertiary_location
}
