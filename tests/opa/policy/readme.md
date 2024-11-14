# Test suite for Azure landing zones Terraform module

The Azure landing zones Terraform module is able to deploy different groups of resources depending on the selected options. The module also requires a minimum AzureRM provider version of `v3.74.0` and it is compatible with a selection of Terraform versions, as described in the module's official wiki page.

[Open Policy Agent](https://www.openpolicyagent.org/docs/latest) is an open source, general-purpose policy engine that unifies policy enforcement across the stack.

We are using Open Policy Agent to test and validate the hcl code generates the expected values and also to verify that recent code changes haven't altered existing functionality.

## Resources

With OPA being the policy engine, a set of utilities is required to complete the testing process:

- [jq](https://stedolan.github.io/jq/), a json parser
- [Conftest](https://www.conftest.dev/), automation utility for Open Policy Agent

## How it works

**Workstation:**

We are using `terraform plan` to generate a reference plan for each test module in a controlled environment.
We save that plan in `json` format to `baseline_values.json` within the test module folder.
Each time we update the module, we update `baseline_values.json` using the `opa-values-generator.ps1` script and use `git-diff` to compare the differences.
This allows us to ensure that each update to the module makes only the expected changes against our control.

We also test the dynamically generated plan against the `baseline_values.json` reference to validate the tests (written in `rego`).

**Automation Pipelines:**

We store `baseline_values.json` for each test module in our GitHub repository.
During testing, the automation pipeline updates some of the values like `root_id` and `root_name` with the values used in each test deployment.
The updated `baseline_values.json` is used by Conftest (OPA's automation utility) as `--data` input.

The output from `terraform plan` is converted to `json` and used by Conftest as the input to test.

Conftest uses a set of rules described in `opa/policy` directory, validates the values in `--data` input against the `terraform plan` input for each combination of Terraform and AzureRM provider versions specified in the test strategy.

## Usage

**From your workstation:**

Navigate to the modules `tests/scripts` directory.

- In the `scripts` directory, execute `opa-values-generator.*`, based on your OS.

  - For Linux: \<_pending support_>
  - For MacOS: \<_pending support_>
  - For Windows: `.\opa-values-generator.ps1`

The script will try to install all the missing utilities, run `terraform plan` and execute `conftest`.
