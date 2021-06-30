
 This document aims to provide prescriptive guidance on using a management module to deploy a management subscription geared towards production workloads incorporating key resources for central management of the platform, a core design design principle for Enterprise-Scale landing zones.
 As the platform continues to expand, securing, logging, and monitoring from a central location is key to maintaining overarching, large scale management.

A dedicated log analytics will aggregate logs such as user access, performance, network flow, amongst others to store and parse automatically whenever a new landing zone is created.

Also, the ability to deploy threat manager, patch systems, monitor resource health, and remediate are also key in making sure that there are consistent standards set across the landing zone for ease of operational visibility and governance.

Terraform Module for Cloud Adoption Framework Enterprise-scale leverages the creation of management resources in a dedicated Management subscription that you provide in the code. This module makes use of many `DeployIfNotExists` policies to create Azure Security Center (ASC), Log Analytics, and an Automation Account with a Linked Service.

Management resources created by these policies are outside the scope of terraform, so these resources may still exists if running terraform-destroy. It is recommended to deploy all the resources in a single, uniform resource group for ease of deletion if from that scope.
# Considerations

Please ensure you are using version 0.3.3 of this module. Running with a lesser version and updating it later may result in deployment errors.

 A specific variable needs to be defined for the management subscription `subscription_management_id` and should be a data source so that it can be referenced by the code as needed.

If deploying the module as part of code that deploys multiple subscriptions (e.g core landing zone - identity, connectivity), the subscription_id's should be set as their own local vars under separate providers. This is covered in the advanced examples found here: ./%5BExamples%5D-Multi-Subscription-Deployment.md (experimental)

If `deploy_core_landing_zone` is set to false, the code will not deploy any enterprise-scale management groups, so this must be defined in order to use and conform with Enterprise-Scale management group structure standards as found in the Contoso reference architecture.

Support for additional customizations to the management groups hierarchies supported by this repo will be covered in later revisions.

For single provider deployments, the module is enabled by setting the `deployment_management_resources` variable to true as found in this example: [deploy_management_resources]: ./%5BVariables%5D-deploy_management_resources

