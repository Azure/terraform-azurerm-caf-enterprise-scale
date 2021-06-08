[In Progress]

Centrally managing the platform is a core design design principle for Enterprise Scale landing zones. As your platform continues to expand,securing, logging, and monitoring from a central location is key to maintaining governance at scale.

A dedicated log analytics will aggregate logs such as user access, performance, network flow logs, and many others to store and parse automatically whenever a new landing zone is created. Also the ability to deploy threat manager, patch systems, monitor resource health, and remediate are also key in making sure that there are consistent standards set across the landing zone for ease of operational visibility and management.

The Enterprise Scale Terraform CAF module leverages the creation of management resources in the dedicated Management subscription that your
provide in the code. This module makes use of many Deploy If Not Exist policies to create Azure Security Center (ASC), Log Analytics, and an automation account with a linked service.

