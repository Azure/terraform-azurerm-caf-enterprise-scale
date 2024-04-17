<!-- markdownlint-disable first-line-h1 -->
## Overview

The `v5.2.0` release makes the following breaking changes:

1. The `threat_intelligence_allowlist` data type has changed from `list` to `map`.

### `threat_intelligence_allowlist` data type change

Existing users that define a `threat_intelligence_allowlist` should update their configuration to use the new `map` data type. For using suppling an empty value, use an empty map `{}`.

```hcl
threat_intelligence_allowlist = {}
```

**Full Changelog**: [v5.1.0...v5.2.0](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/compare/v5.1.0...v5.2.0)

## Next steps

Take a look at the latest [User Guide](User-Guide) documentation and our [Examples](Examples) to understand the latest module configuration options, and review your implementation against the changes documented on this page.

## Need help?

If you're running into problems with the upgrade, please let us know via the [GitHub Issues](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues).
We will do our best to point you in the right direction.
