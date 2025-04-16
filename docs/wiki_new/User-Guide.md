<!-- BEGIN_TF_DOCS -->
## Required Inputs

The following input variables are required:

### <a name="input_default_location"></a> [default\_location](#input\_default\_location)

Description: Must be specified, e.g `eastus`. Will set the Azure region in which region bound resources will be deployed. Please see: https://azure.microsoft.com/en-gb/global-infrastructure/geographies/

Type: `string`

### <a name="input_root_parent_id"></a> [root\_parent\_id](#input\_root\_parent\_id)

Description: The root\_parent\_id is used to specify where to set the root for all Landing Zone deployments. Usually the Tenant ID when deploying the core Enterprise-scale Landing Zones.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_archetype_config_overrides"></a> [archetype\_config\_overrides](#input\_archetype\_