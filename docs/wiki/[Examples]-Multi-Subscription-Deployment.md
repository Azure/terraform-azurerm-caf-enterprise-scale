
### Deploying Resources across multiple subscriptions (Level 300)
> NOTE: Terraform is unable to deploy resources across multiple Subscriptions using a single provider configuration.

You must be authenticated to the subscription where you want these resources deployed so by setting `deploy_management_resources` to true, you must also ensure you are running your module deployment against the management Subscription. In the event you are deploying resources across several subscriptions simultaneously, you could leverage multiple subscriptions at the provider level:

```hcl
provider "azurerm" {
subscription_id = local.subscriptions.management_subscription_id
tenant_id       = local.tenant_id
features {}
}

provider "azurerm" {
  alias           = "connectivity"
  subscription_id = local.subscriptions.connectivity_subscription_id
  tenant_id       = local.tenant_id
  features {}
}
```
