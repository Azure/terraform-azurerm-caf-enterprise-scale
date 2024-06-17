# Configure the management resources settings.
locals {
  configure_management_resources = {
    settings = {
      ama = {
        enable_uami                                                         = true
        enable_vminsights_dcr                                               = true
        enable_change_tracking_dcr                                          = true
        enable_mdfc_defender_for_sql_dcr                                    = true
        enable_mdfc_defender_for_sql_query_collection_for_security_research = true
      }
      log_analytics = {
        enabled = true
        config = {
          retention_in_days          = 60
          enable_monitoring_for_arc  = true
          enable_monitoring_for_vm   = true
          enable_monitoring_for_vmss = true
          enable_change_tracking     = true
          enable_sentinel            = true
        }
      }
      security_center = {
        enabled = true
        config = {
          email_security_contact                                = var.email_security_contact
          enable_defender_for_apis                              = true
          enable_defender_for_app_services                      = true
          enable_defender_for_arm                               = true
          enable_defender_for_containers                        = true
          enable_defender_for_cosmosdbs                         = true
          enable_defender_for_cspm                              = true
          enable_defender_for_dns                               = true
          enable_defender_for_key_vault                         = true
          enable_defender_for_oss_databases                     = true
          enable_defender_for_servers                           = true
          enable_defender_for_servers_vulnerability_assessments = true
          enable_defender_for_sql_servers                       = true
          enable_defender_for_sql_server_vms                    = true
          enable_defender_for_storage                           = true
        }
      }
    }

    location = null
    tags = {
      deployedBy = "${local.default_tags.deployedBy}/management"
    }
    advanced = {
      asc_export_resource_group_name = "${var.root_id}-security-logs-export"
      #existing_resource_group_name   = "${var.root_id}-mgmt"
    }
  }
}
