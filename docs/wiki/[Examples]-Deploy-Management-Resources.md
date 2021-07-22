## Overview
This example will deploy resources for centrally managing the Enterprise Scale Landing Zone. This module will deploy the following resources with default configurations that can be adjusted once you are up and going in the subscription of your specification:


* resource group
* log analytics workspace
* automation account
* linked service to the analytics automation account



The module then goes onto configure Deploy if Not Exist policies to enable features within Log Analytics and Sentinel including
but not limited to:
* enabling monitoring for arc
* enabling monitoring for vms
* enabling monitoring for vmss
* enabling defender for dns
* much more...



> PREREQUISITE: Ensure the module version is set version  0.2.0 or greater
```hcl
     module "enterprise_scale" {
      source = "Azure/caf-enterprise-scale/azurerm"
      version = "0.3.3"

     }
```

If upgrading to a later version of this module, make sure to run `terraform init`

To initiate the resource creation,  `deploy_managagement_resources` must be set to true. The  `subscription_id_management` is a required variable so that the resources have somewhere to land. Enabling these two variables will deploy ~200 resources mostly consisting of Deploy if Not Exist policies and RBAC permissions.

## Example root module
```hcl
    data "azurerm_client_config" current {}

    module "enterprise_scale" {
      source = "Azure/caf-enterprise-scale/azurerm"

      version = "0.3.3"


    root_parent_id = data.azurerm_client_config.current.tenant_id
    root_id = "contoso" 
    root_name = "Contoso"
    deploy_management_resources = "true" 
    subscription_id_management = "XXXXXX-XXXX-XXXX-XXXX-XXXXXXX" //Required variable
    
    }

```
