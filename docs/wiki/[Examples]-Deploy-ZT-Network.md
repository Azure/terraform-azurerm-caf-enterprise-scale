# Azure landing zone Terraform deployment with Zero Trust network principles (Hub and Spoke)

This guide will review how to deploy the Azure landing zone Terraform accelerator with a jump start on Zero Trust Networking Principles for Azure landing zones.

For more information on Zero Trust security model and principles visit [Embrace proactive security with Zero Trust](/security/business/zero-trust).

Deploying Zero Trust network principles with the Terraform deployment will involve setting certain module variables to a value.  Some of these are already the default values, and do not need to be changed.  Others will need to be changed from their default values.  These variables reside in the [variables.tf](../../variables.tf) file and can be provided at run time, or replaced/overridden for your deployment.

## Configure Connectivity resources

In the *configure_connectivity_resources* variable's *ddos_protection_plan* object,  you will set the following:

| Variable | Zero Trust Value | Default Value |
|---|---|---|
| enabled | **TRUE** | FALSE |

This will deploy a DDoS Protection Plan to use to protect your networking resources from DDoS Attacks.

Next, in the *configure_connectivity_resources* variable's *hub_networks* object,  you will set the following:

| Variable | Zero Trust Value | Default Value |
|---|---|---|
| enabled | TRUE | TRUE |
| link_to_ddos_protection_plan | **TRUE** | FALSE |

These settings will ensure that a hub network is deployed, and that it is liked to the DDoS Protection Plan.

Lastly, in the *configure_connectivity_resources* variable's *azure_firewall* object,  you will set the following:

| Variable | Zero Trust Value | Default Value |
|---|---|---|
| enabled | **TRUE** | FALSE |
| sku_tier | **Premium** | *empty* |

This will deploy an Azure Firewall in to your hub network, with the appropriate SKU to perform TLS inspection on traffic.

## Configure Identity resources

In the *configure_identity_resources* variable object, set the following:

| Variable | Zero Trust Value | Default Value |
|---|---|---|
| enable_deny_public_ip | TRUE | TRUE |
| enable_deny_rdp_from_internet | TRUE | TRUE |
| enable_deny_subnet_without_nsg | TRUE | TRUE |

This will set policy controls to ensure good network practices are in place, by preventing you from creating public IPs in the identity subscription, denying the creation of subnets without Network Security Groups, and by preventing inbound RDP from the internet to VMs in the identity subscription.

## Configure Defender

In the *configure_management_resources* variable's *security_center* object, set the following:

| Variable | Zero Trust Value | Default Value |
|---|---|---|
| enable_defender_for_dns | TRUE | TRUE |

This is not needed for Zero Trust Telemetry, but is a valuable setting to protect your organization from DNS injection.  Review [Defender for DNS](https://learn.microsoft.com/azure/defender-for-cloud/defender-for-dns-introduction) for more information.
