<!-- markdownlint-disable first-line-h1 -->
## Overview

The module can be customized using the input variables listed below (click on each `input name` for more details).

To provide the depth of configuration options needed by the module without creating too many different input variables, we decided to use a number of complex `object({})` type variables.
Whilst these may look intimidating at first, these are all configured with default values and only need to be updated if you want to start customizing the deployment.
In all cases, the default values can simply be copied into your configuration and edited as required.

> To make your code easier to maintain, we recommend using [Local Values][local_values] in your root module to store custom values, rather than putting these in-line within the module block.
> This helps to improve readability of the module block, and also makes these values re-usable when using multiple instances of the module to build out your Azure landing zone.
> Only use [Input Variables][input_variables] for simple values which need to be changed across multiple deployments (e.g. environment-specific values).

## Variable Documentation

We have now moved to using terraform-docs to generate the variable documentation for this module. Please see the `README.md` file in the root of this repository for more details.

[local_values]:    https://www.terraform.io/docs/language/values/locals.html "Local Values"
[input_variables]: https://www.terraform.io/docs/language/values/variables.html "Input Variables"
