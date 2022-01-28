locals {
  nested_custom_landing_zones = {
    "${var.root_id}-custom-lz1" = {
      display_name               = "Nested Custom LZ1"
      parent_management_group_id = "${var.root_id}-landing-zones"
      subscription_ids           = []
      archetype_config = {
        archetype_id = "customer_online"
        parameters = {
          Deny-Resource-Locations = {
            listOfAllowedLocations = [
              "northcentralus",
              "southcentralus",
            ]
          }
        }
        access_control = {}
      }
    }
  }
}
