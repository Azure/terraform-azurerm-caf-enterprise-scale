## Overview

[**deploy_core_landing_zones**](#overview) `bool` (optional)

If set to true, will include the core Enterprise-scale Management Group hierarchy.

## Default value

`true`

## Validation

None

## Usage

Set the value to true or false.
If set to _false_ with all the other values as _default_, the module will deploy no resources.
This is for advanced scenarios such as:

- [Nested deployments][wiki_deploy_using_module_nesting]
- Landing zone resources:
  - [Management][wiki_management_resources]
  - [Connectivity][wiki_connectivity_resources]

```hcl
  deploy_core_landing_zones = false
```

> Important: If changed to _false_ after initial deployment, terraform will destroy all core Enterprise-scale Management Groups and Management Group scoped resources.

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

[this_page]: # "Link for the current page."

[wiki_management_resources]:        ./%5BUser-Guide%5D-Management-Resources "Wiki - Management Resources"
[wiki_connectivity_resources]:      ./%5BUser-Guide%5D-Connectivity-Resources "Wiki - Connectivity Resources"
[wiki_deploy_using_module_nesting]: ./%5BExamples%5D-Deploy-Using-Module-Nesting "Wiki - Deploy Using Module Nesting"
