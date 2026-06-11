<!-- markdownlint-disable first-line-h1 -->
## Azure landing zones Terraform module FAQ

This article answers frequently asked questions relating to the Azure landing zones Terraform module.

- [Questions about the architecture](#questions-about-the-architecture)
- [Questions about the module](#questions-about-the-module)
  - [How do I troubleshoot module errors?](#how-do-i-troubleshoot-module-errors)
  - [How much does a typical deployment cost?](#how-much-does-a-typical-deployment-cost)

> If you have a question not listed here, please raise an [issue][github_issues] and we'll do our best to help.

### Questions about the architecture

Questions relating to the architecture can be found in the [Azure landing zone frequently asked questions (FAQ)](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/enterprise-scale/faq) page on the Cloud Adoption Framework site.

### Questions about the module

#### How do I troubleshoot module errors?

There are various reasons why you might get an error when using this module.
To minimize errors caused by the module, we do our best to test the module before cutting a release.

If you observe an error, the first place to look is in our [Troubleshooting][wiki_troubleshooting] guide.

If the error you are seeing is not documented here, please check our existing issues before raising a new issue.

#### How much does a typical deployment cost?

The Azure landing zones Terraform module covers many different deployment scenarios, so costs can vary dramatically depending on what options are configured.

Some of these costs can come from resources deployed directly by the module.
Other costs may be incurred when Azure Policy performs remediation of non-compliant resources within scope of the deployment.

If you are looking to reduce costs as part of evaluating the module, we recommend assessing whether your evaluation needs to implement the following common resources which can incur the highest costs include:

- Microsoft Defender for Cloud
- Azure DDoS Network Protection
- Azure Firewall
- Azure Virtual Network Gateway (ExpressRoute/VPN)

Although our examples try to minimize the use of these resources and to use lower cost SKUs where applicable, please take care to ensure you understand which resources are being deployed and the associated costs these will incur.

In large environments, costs can also increase when large volumes of data are being stored in the Log Analytics workspace.

To see further guidance regarding costs for Azure landing zones, please refer to our [pricing guidance][alz_pricing] page.

### General questions

#### With the upcoming release of the new Azure Landing Zones [AVM](https://aka.ms/avm) module, what is the future for this module and what should I do today?

The Azure Landing Zones Terraform module (`caf-enterprise-scale`) is still our recommendation for customers looking to accelerate deployments.

We are working on a new set of more focussed modules that can be combined like Lego bricks to achieve the outcome you are looking for. These will be published as AVM modules. However, these are not all ready yet. We will publish guidance on the roadmap (including migration advice) in the coming months.

We do want to reassure customers that the caf-enterprise-scale module will remain supported once we release the new set of modules.

 [//]: # (************************)
 [//]: # (INSERT LINK LABELS BELOW)
 [//]: # (************************)

[github_issues]: https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues "Azure landing zones Terraform module - Issues"
[alz_pricing]:   https://github.com/Azure/Enterprise-Scale/wiki/What-is-Enterprise-Scale#pricing "Azure landing zones pricing guidance"

[wiki_troubleshooting]: Troubleshooting "Wiki - Troubleshooting"
