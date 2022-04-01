## Overview

[**disable_telemetry**](#overview) `bool` (optional)

> Telemetry tracking was added to release `1.2.0` of the module

Microsoft can identify the deployments of this module with the deployed Azure resources.
Microsoft can correlate these resources used to support the deployments.
Microsoft collects this information to provide the best experiences with their products and to operate their business.
The telemetry is collected through customer usage attribution.
The data is collected and governed by Microsoft's privacy policies, located at the trust center.

To disable this tracking, we have included a variable called `disable_telemetry` with a simple boolean flag. The default value is `false` which does not disable the telemetry.
If you would like to disable this tracking, then simply set this value to `true` and this module will not create the telemetry tracking resources and therefore telemetry tracking will be disabled.

For example, to disable telemetry tracking, you can add this variable to the module declaration:

```terraform
module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "1.2.0"

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

## Telemetry Details

Telemetry is comprised of up to four empty ARM deployments that are targetted to the Azure subscriptions defined by the providers.
Each deployment contains a unique id (known as the PID) that is used to identity the particular module that is in use.

| Module Name | PID | Provider alias |
| - | - | - |
| Core | `36dcde81-8c33-4da0-8dc3-265381502ccb` | `default` |
| Connectivity | `97603aac-98f8-4a55-92fc-4c78378c9ba5` | `connectivity` |
| Identity | `67becfb7-b296-43a9-ba38-0b5c19cb065a` | `identity` |
| Management | `6fffb9f9-2691-412a-837e-3f72dcfe70cb` | `management` |

> Note: Identity is currently disabled until we deploy identity resources

### ARM Deployment Naming

The ARM deployment name is constricted as follows:

`pid-<UUID>_<module_version>_<bitfield>_<random_id>`

| Field | Description |
| - | - |
| `UUID` | A unique id to identify the Terraform (sub)module in use |
| `module_version` | The version of the module in use |
| `bitfield` | An bitfield of 8 bits (two hexadecimal digits) that exposes module features in use. See next section for details |
| `random_id` | A random id specific to the module instance to enable correlation between the sub modules |

### Bitfield Composition

The four deployments expose high level feature configuration as described in the below tables:
#### Core module

| Bit | Value (hex) | Description |
| - | - | - |
| 1 (LSB) | 01 | `deploy_core_landing_zones` is enabled |
| 2 | 02 | `deploy_corp_landing_zones` is enabled |
| 3 | 04 | `deploy_online_landing_zones` is enabled |
| 4 | 08 | `deploy_sap_landing_zones` is enabled |
| 5 | 10 | Number of `custom_landing_zones` > 0  |

#### Connectivity module

| Bit | Value (hex) | Description |
| - | - | - |
| 1 (LSB) | 01 | Number of hub networks is > 0 |
| 2 | 02 | Number of VWAN hub networks is > 0 |
| 3 | 04 | DDOS Standard is enabled |
| 4 | 08 | DNS zone deployment is enabled |

#### Management module

| Bit | Value (hex) | Description |
| - | - | - |
| 1 (LSB) | 01 | Log Analytics deployment is enabled |
| 2 | 02 | Defender for cloud (Azure Security Center) deployment is enabled |

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

#### Identity module

> Currently disabled as we do not deploy any resources to the identity subscription

[this_page]: # "Link for the current page."
