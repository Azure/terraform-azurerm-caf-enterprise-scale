# Test suite for CAF Terraform Module

The CAF Terraform Module is able to deploy different groups of resources depending on the selected options. The module also requires a minimum azurerm provider version of `2.41.0` and it is compatible with a selection of Terraform versions, as described in the module's official wiki page.

[Open Policy Agent](https://www.openpolicyagent.org/docs/latest) is an open source, general-purpose policy engine that unifies policy enforcement across the stack.

We are using Open Policy Agent to test and validate the hcl code generates the expected values and also to verify that recent code changes haven't altered existing functionality.

## Resources

With OPA being the policy engine, a set of utilities is required to complete the testing process:

- [jq](https://stedolan.github.io/jq/), a json parser
- [yq](https://github.com/mikefarah/yq), a yaml parser
- [yamllint](https://yamllint.readthedocs.io/en/stable/), a yaml linter
- [Conftest](https://www.conftest.dev/), automation utility for Open Policy Agent

## How it works

**Workstation:**

We are using `terraform plan` to generate a plan and we convert that plan to \*.json file. We then extract the module(s) planned_values and we validate they are equal to the plan's changed_values.

**Automation Pipelines:**

We then upload `planned_values.json` to our github repo. Automation pipelines update some of the values like `root_id` and `root_name` with the values used in our runners. The updated `planned_values.json` is used to generate a yaml file which is used from Conftest, OPA's automation utility, as `--data` input.

Conftest, using a set of rules described in `opa/policy` directory, validates the values in `--data` input against the terraform's generated plan for each terraform version and for each terraform provider.

## Usage

**From your workstation:**

**Option 1:**

Navigate to the modules `tests/scripts` directory.

- In the `scripts` directory, execute `opa-values-generator.*`, based on your OS.

  - For Linux: `./opa-values-generator.sh`

  - For Windows: `.\opa-values-generator.ps1`

The script will try to install all the missing utilities, run `terraform plan` and execute `conftest`.

- Choose **y** or **n** and follow the cmd prompt.

**Option 2:**

Navigate to the modules `tests` directory.

- create a new dir: `mkdir deployment_2 && cd deployment_2`

- create a new file: `touch main.tf`

- Copy paste the terraform code from the [Deploy-Default-Configuration](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Default-Configuration) example in your `deployment_2/main.tf`

- From the `deployment` directory, copy paste the `variables.tf` file in your `deployment_2` directory.

- In your `tests/scripts/opa-values-generator.sh`, update the path in line 26:
  **MODULE_PATH="../deployment_2"**

- In your terminal, go to `tests/scripts` directory and execute `./opa-values-generator.sh`

- Answer **y** in: `Do you want to prepare files for repository (y/n)?`

- Delete dir `deployment_2`

- In your `tests/scripts/opa-values-generator.sh`, update the path back to the original value in line 26:
  **MODULE_PATH="../deployment"**
