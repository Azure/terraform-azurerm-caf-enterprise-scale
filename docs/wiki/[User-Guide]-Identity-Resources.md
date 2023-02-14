<!-- markdownlint-disable first-line-h1 -->
## Overview

The module provides an option to configure policies relating to the [identity and access management][alz_identity] landing zone. It also ensures that the specified subscription is placed in the right management group.

![Overview of the Azure landing zones identity resources][alz_identity_overview]

This capability doesn't deploy any resources. If you want to update policy settings related to the identity management group, use the `configure_identity_resources` input variable.

Please refer to the [Deploy Identity Resources][wiki_deploy_identity_resources] page on our Wiki for more information about how to use this capability.

 [//]: # (*****************************)
 [//]: # (INSERT IMAGE REFERENCES BELOW)
 [//]: # (*****************************)

[alz_identity_overview]: media/terraform-caf-enterprise-scale-identity.png "A conceptual architecture diagram focusing on the identity resources for an Azure landing zone."

 [//]: # (************************)
 [//]: # (INSERT LINK LABELS BELOW)
 [//]: # (************************)

[alz_identity]: https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access

[wiki_deploy_identity_resources]: %5BExamples%5D-Deploy-Identity-Resources "Wiki - Deploy Identity Resources"
