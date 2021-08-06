{
  "name": "Deploy-Private-DNS-Zones",
  "type": "Microsoft.Authorization/policyAssignments",
  "apiVersion": "2019-09-01",
  "properties": {
    "description": "This policy initiative is a group of policies that ensures private endpoints to Azure PaaS services are integrated with Azure Private DNS zones.",
    "displayName": "Configure Azure PaaS services to use private DNS zones",
    "notScopes": [],
    "parameters": {
      "azureFilePrivateDnsZoneId": {
        "value": "${private_dns_zone_prefix}privatelink.afs.azure.net"
      },
      "azureWebPrivateDnsZoneId": {
        "value": "${private_dns_zone_prefix}privatelink.webpubsub.azure.com"
      },
      "azureBatchPrivateDnsZoneId": {
        "value": "${private_dns_zone_prefix}privatelink.${default_location}.batch.azure.com"
      },
      "azureAppPrivateDnsZoneId": {
        "value": "${private_dns_zone_prefix}privatelink.azconfig.io"
      },
      "azureAsrPrivateDnsZoneId": {
        "value": "${private_dns_zone_prefix}${default_location}.privatelink.siterecovery.windowsazure.com"
      },
      "azureIoTPrivateDnsZoneId": {
        "value": "${private_dns_zone_prefix}privatelink.azure-devices-provisioning.net"
      },
      "azureKeyVaultPrivateDnsZoneId": {
        "value": "${private_dns_zone_prefix}privatelink.vaultcore.azure.net"
      },
      "azureSignalRPrivateDnsZoneId": {
        "value": "${private_dns_zone_prefix}privatelink.service.signalr.net"
      },
      "azureAppServicesPrivateDnsZoneId": {
        "value": "${private_dns_zone_prefix}privatelink.azurewebsites.net"
      },
      "azureEventGridTopicsPrivateDnsZoneId": {
        "value": "${private_dns_zone_prefix}privatelink.eventgrid.azure.net"
      },
      "azureDiskAccessPrivateDnsZoneId": {
        "value": "${private_dns_zone_prefix}privatelink.blob.core.windows.net"
      },
      "azureCognitiveServicesPrivateDnsZoneId": {
        "value": "${private_dns_zone_prefix}privatelink.cognitiveservices.azure.com"
      },
      "azureIotHubsPrivateDnsZoneId": {
        "value": "${private_dns_zone_prefix}privatelink.azure-devices.net"
      },
      "azureEventGridDomainsPrivateDnsZoneId": {
        "value": "${private_dns_zone_prefix}privatelink.eventgrid.azure.net"
      },
      "azureRedisCachePrivateDnsZoneId": {
        "value": "${private_dns_zone_prefix}privatelink.redis.cache.windows.net"
      },
      "azureAcrPrivateDnsZoneId": {
        "value": "${private_dns_zone_prefix}privatelink.azurecr.io"
      },
      "azureEventHubNamespacePrivateDnsZoneId": {
        "value": "${private_dns_zone_prefix}privatelink.servicebus.windows.net"
      },
      "azureMachineLearningWorkspacePrivateDnsZoneId": {
        "value": "${private_dns_zone_prefix}privatelink.api.azureml.ms"
      },
      "azureServiceBusNamespacePrivateDnsZoneId": {
        "value": "${private_dns_zone_prefix}privatelink.servicebus.windows.net"
      },
      "azureCognitiveSearchPrivateDnsZoneId": {
        "value": "${private_dns_zone_prefix}privatelink.search.windows.net"
      }
    },
    "policyDefinitionId": "${root_scope_resource_id}/providers/Microsoft.Authorization/policySetDefinitions/Deploy-Private-DNS-Zones",
    "scope": "${current_scope_resource_id}",
    "enforcementMode": null
  },
  "location": "${default_location}",
  "identity": {
    "type": "SystemAssigned"
  }
}