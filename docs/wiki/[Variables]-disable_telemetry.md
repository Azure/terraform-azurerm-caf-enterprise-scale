<!-- markdownlint-disable first-line-h1 -->
## Overview

[**disable_telemetry**](#overview) `bool` (optional)

> Telemetry was added to release `2.0.0` of the module

Microsoft can identify the deployments of this module with the deployed Azure resources.
Microsoft can correlate these resources used to support the deployments.
Microsoft collects this information to provide the best experiences with their products and to operate their business.
The telemetry is collected through customer usage attribution.
The data is collected and governed by Microsoft's privacy policies, located at the trust center.

For more information see the [customer usage attribution documentation](https://docs.microsoft.com/azure/marketplace/azure-partner-customer-usage-attribution)

To disable this tracking, we have included a variable with the name `disable_telemetry` with a simple boolean flag. The default value is `false` which does not disable the telemetry.
If you would like to disable this tracking, then simply set this value to `true` and this module will not create the telemetry tracking resources and therefore telemetry tracking will be disabled.

For example, to disable telemetry tracking, you can add this variable to the module declaration:

```terraform
module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "2.0.0"

  disable_telemetry = true
}
```

## Default value

`false`

## Validation

None

## Usage

```terraform
disable_telemetry = true
```

## Telemetry details

Telemetry is comprised of up to four empty ARM deployments that are targetted to the Azure subscriptions defined by the providers.
Each deployment contains a unique id (known as the PID) that is used to identity the particular module that is in use.
A [bit field](https://en.wikipedia.org/wiki/Bit_field) is also used to identity module features that are in use.

| Module Name | PID | Provider alias |
| - | - | - |
| Core | `36dcde81-8c33-4da0-8dc3-265381502ccb` | `default` |
| Connectivity | `97603aac-98f8-4a55-92fc-4c78378c9ba5` | `connectivity` |
| Identity | `67becfb7-b296-43a9-ba38-0b5c19cb065a` | `identity` |
| Management | `6fffb9f9-2691-412a-837e-3f72dcfe70cb` | `management` |

> **NOTE:** Identity is currently disabled until we deploy identity resources

### ARM deployment naming

The ARM deployment name is constructed as follows:

`pid-<UUID>_<module_version>_<bitfield>_<random_id>`

| Field | Description |
| - | - |
| `UUID` | A unique id to identify the Terraform (sub)module in use |
| `module_version` | The version of the module in use |
| `bitfield` | A bit field of 16 bits (four hexadecimal digits) that exposes module features in use. See [next section](#bit-field-composition) for details |
| `random_id` | A random id specific to the module instance to enable correlation between the sub modules |

### Bit field composition

The four deployments expose high level feature configuration as described in the below tables:

#### Core module

| Bit | Value (hex) | Description |
| - | - | - |
| 1 (LSB) | 01 | `deploy_core_landing_zones` is `true` |
| 2 | 02 | `deploy_corp_landing_zones` is `true` |
| 3 | 04 | `deploy_online_landing_zones` is `true` |
| 4 | 08 | `deploy_sap_landing_zones` is `true` |
| 5 | 10 | Number of `custom_landing_zones` > 0  |

#### Connectivity module

| Bit | Value (hex) | Description |
| - | - | - |
| 1 (LSB) | 01 | Number of `configure_connectivity_resources.settings.hub_networks`  > 0 |
| 2 | 02 | Number of `configure_connectivity_resources.settings.vwan_hub_networks`  > 0 |
| 3 | 04 | `configure_connectivity_resources.settings.ddos_protection_plan.enabled` is `true`  |
| 4 | 08 | `configure_connectivity_resources.settings.dns` is `true` |

#### Management module

| Bit | Value (hex) | Description |
| - | - | - |
| 1 (LSB) | 01 | `configure_management_resources.settings.log_analytics.enabled` is `true` |
| 2 | 02 | `configure_management_resources.settings.security_center.enabled` is `true` |

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

#### Identity module

> Currently disabled as we do not deploy any resources to the identity subscription

### Example of bit field representation

Taking the following example from the `core` module:

`pid-36dcde81-8c33-4da0-8dc3-265381502ccb-v2.0.0-000b-83a3fc`

The bit field value is `000b`, which is hexadecimal.
In binary `000b` hexadecimal is represented as `0000000000001011`.
This means that bits 1, 2 and 4 are set (we read from right to left).
Looking in the table for the core module: bits 1, 2 and 4 are the `deploy_core_landing_zones`, `deploy_corp_landing_zones` and `deploy_sap_landing_zones` features.

[this_page]: # "Link for the current page."
