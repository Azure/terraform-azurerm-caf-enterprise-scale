<!-- markdownlint-disable first-line-heading first-line-h1 -->
The [Azure landing zones Terraform module][alz_tf_registry] provides an opinionated approach for deploying and managing the core platform capabilities of [Azure landing zones architecture][alz_architecture] using Terraform, with a focus on the central resource hierarchy:

![Azure landing zone conceptual architecture][alz_tf_overview]

Depending on selected options, this module can deploy different sets of resources based on the following capabilities:

- [Core Resources][wiki_core_resources]
- [Management Resources][wiki_management_resources]
- [Connectivity Resources][wiki_connectivity_resources]
- [Identity Resources][wiki_identity_resources]

Please click on each of the above links for more details.

## Design areas

The module provides a consistent approach for deploying and managing resources relating to the following design areas:

- [Resource organization][alz_hierarchy]
  - Create the Management Group resource hierarchy
  - Assign Subscriptions to Management Groups
  - Create custom Policy Assignments, Policy Definitions and Policy Set Definitions (Initiatives)
- [Identity and access management][alz_identity]
  - Secure the identity subscription using Azure Policy
  - Create custom Role Assignments and Role Definitions
- [Management][alz_management]
  - Create a central Log Analytics workspace and Automation Account
  - Link Log Analytics workspace to the Automation Account
  - Deploy recommended Log Analytics Solutions
  - Enable Microsoft Defender for Cloud
- [Network topology and connectivity][alz_connectivity]
  - Create a centralized hub network
    - Traditional Azure networking topology (hub and spoke)
    - Virtual WAN network topology (Microsoft-managed)
  - Secure network design
    - Azure Firewall
    - DDoS Network Protection
  - Hybrid connectivity
    - Azure Virtual Network Gateway
    - Azure ExpressRoute Gateway
  - Centrally managed DNS zones

## Next steps

Check out the [User Guide](User-Guide), or go straight to our [Examples](Examples).

 [//]: # (*****************************)
 [//]: # (INSERT IMAGE REFERENCES BELOW)
 [//]: # (*****************************)

[alz_tf_overview]: media/alz-tf-module-overview.png "A conceptual architecture diagram highlighting the design areas covered by the Azure landing zones Terraform module."

 [//]: # (************************)
 [//]: # (INSERT LINK LABELS BELOW)
 [//]: # (************************)

[alz_tf_registry]:  https://registry.terraform.io/modules/Azure/caf-enterprise-scale/azurerm/latest "Terraform Registry: Azure landing zones Terraform module"
[alz_architecture]: https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone#azure-landing-zone-conceptual-architecture
[alz_hierarchy]:    https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org
[alz_management]:   https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/management
[alz_connectivity]: https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/network-topology-and-connectivity
[alz_identity]:     https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access

[wiki_core_resources]:         %5BUser-Guide%5D-Core-Resources "Wiki - Core Resources"
[wiki_management_resources]:   %5BUser-Guide%5D-Management-Resources "Wiki - Management Resources"
[wiki_connectivity_resources]: %5BUser-Guide%5D-Connectivity-Resources "Wiki - Connectivity Resources"
[wiki_identity_resources]:     %5BUser-Guide%5D-Identity-Resources "Wiki - Identity Resources"
