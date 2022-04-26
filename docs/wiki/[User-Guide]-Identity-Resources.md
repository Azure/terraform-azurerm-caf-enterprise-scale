## Overview

The module enables deployment and configuration of Azure Policy to control governance over the [Identity and access management][ESLZ-Identity] Subscription.

![Enterprise-scale Identity Landing Zone Architecture][TFAES-Identity]

No additional resources are deployed by this capability, however policy settings relating to the `Identity` Management Group can now be easily updated via the `configure_identity_resources` input variable.

Please refer to the [Deploy Identity Resources][wiki_deploy_identity_resources] page on our Wiki for more information about how to use this capability.

 [//]: # (*****************************)
 [//]: # (INSERT IMAGE REFERENCES BELOW)
 [//]: # (*****************************)

[TFAES-Identity]: ./media/terraform-caf-enterprise-scale-identity.png "Diagram showing the Identity resources for Azure landing zones architecture deployed by this module."

 [//]: # (************************)
 [//]: # (INSERT LINK LABELS BELOW)
 [//]: # (************************)

[ESLZ-Identity]: https://docs.microsoft.com/azure/cloud-adoption-framework/ready/enterprise-scale/identity-and-access-management

[wiki_deploy_identity_resources]: ./%5BExamples%5D-Deploy-Identity-Resources "Wiki - Deploy Identity Resources"
