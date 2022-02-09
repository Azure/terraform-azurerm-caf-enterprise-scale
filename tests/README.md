# Test Framework for the Terraform Module for Cloud Adoption Framework Enterprise-scale

This folder contains code relating to the test framework for this module.
Testing is currently performed in the following stages:

1. Code Review (GitHub Actions)
1. Unit Tests (Azure Pipelines)
1. E2E Tests (Azure Pipelines)

The decision to break testing up in this manner was to ensure developers get quick feedback when working on bug fixes and new features, whilst providing greater assurance that the latest updates work as expected and do not break existing functionality.

## Code Review (GitHub Actions)

The first quality check ensures all code complies with recommended coding practices.
We use [GitHub Super-Linter (v4.1.0)](https://github.com/github/super-linter/tree/v4.1.0) to perform this initial check across the code base.
By running this within a GitHub Action, anyone contributing to the code can get quick feedback on each commit pushed to GitHub.

GitHub Super-Linter is configured to run checks against the full codebase using the following Linters:

| *Language* | *Linter* |
| ---------- | -------- |
| **JSON** | [jsonlint](https://github.com/zaach/jsonlint) |
| **Markdown** | [markdownlint](https://github.com/igorshubovych/markdownlint-cli#readme) |
| **PowerShell** | [PSScriptAnalyzer](https://github.com/PowerShell/Psscriptanalyzer) |
| **Shell** | [Shellcheck](https://github.com/koalaman/shellcheck) / [executable bit check] / [shfmt](https://github.com/mvdan/sh) |
| **Terraform** | [tflint](https://github.com/terraform-linters/tflint) / [terrascan](https://github.com/accurics/terrascan) |
| **YAML** | [YamlLint](https://github.com/adrienverge/yamllint) |

This is also a mandatory check on all PR's being raised against the `main` branch.

## Unit Tests (Azure Pipelines)

As linting only let's you know if the code is well written (according to a pre-determined set of standards), we also need to determine whether the code generates a valid Terraform plan.

To verify this, we have a set of unit tests which run additional checks against the module using a series of test deployments.

To give assurance that the module works with the specified range of supported versions of Terraform and the Azure provider, we use a [matrix strategy](#multi_job_configuration_matrix_strategy)) to automatically generate parallel running jobs for each version combination.

The Unit Tests consist of the following tasks:

| *Task Name* | *Description* |
| --- | --- |
| **Install Terraform Pre-requisites** | Ensures the required version of Terraform is installed on the agent. |
| **Prepare Terraform Environment** | Retrieves credentials for the target test environment and sets a unique value for the `root_id` input variable.<sup>1</sup> |
| **Terraform Linting (terraform fmt)** | Runs `terraform fmt` against the entire repository in `-check` mode to ensure Terraform code is correctly formatted. |
| **Install OPA/Conftest Pre-requisites** | Ensure the required version of `Conftest`, `jq`, `yq` and `yamllint` are installed on the agent. |
| **Test 001 (terraform init) Baseline** | Initialize the root module for this test instance. |
| **Test 001 (terraform plan) Baseline** | Generate a Terraform plan for this test instance. |
| **Test 001 (conftest) Baseline** | Run Conftest to ensure the Terraform plan matches the expected configuration for this test instance. |
| **Test 002 (terraform init) Add Custom Core** | Initialize the root module for this test instance. |
| **Test 002 (terraform plan) Add Custom Core** | Generate a Terraform plan for this test instance. |
| **Test 002 (conftest) Add Custom Core** | Run Conftest to ensure the Terraform plan matches the expected configuration for this test instance. |
| **Test 003 (terraform init) Add Management and Connectivity** | Initialize the root module for this test instance. |
| **Test 003 (terraform plan) Add Management and Connectivity** | Generate a Terraform plan for this test instance. |
| **Test 003 (conftest) Add Management and Connectivity** | Run Conftest to ensure the Terraform plan matches the expected configuration for this test instance. |

<sup>1</sup> *Each job uses a dedicated SPN (with certificate based authentication) to connect to Azure.*
*This is to minimize the risk of API rate limiting when running highly parallel resource deployments in the pipeline.*

## E2E Tests (Azure Pipelines)

The E2E Tests consist of the following tasks:

| *Task Name* | *Description* |
| --- | --- |
| **Install Terraform Pre-requisites** | Ensures the required version of Terraform is installed on the agent. |
| **Prepare Terraform Environment** | Retrieves credentials for the target test environment and sets a unique value for the `root_id` input variable.<sup>1</sup> |
| **Terraform Linting (terraform fmt)** | Runs `terraform fmt` against the entire repository in `-check` mode to ensure Terraform code is correctly formatted. |
| **Test 001 (terraform init) Baseline** | Initialize the root module for this test instance. |
| **Test 001 (terraform plan) Baseline** | Generate a Terraform plan for this test instance. |
| **Test 001 (terraform apply) Baseline** | Apply the Terraform plan for this test instance. |
| **Test 002 (terraform init) Add Custom Core** | Initialize the root module for this test instance. |
| **Test 002 (terraform plan) Add Custom Core** | Generate a Terraform plan for this test instance. |
| **Test 002 (terraform apply) Add Custom Core** | Apply the Terraform plan for this test instance. |
| **Test 003 (terraform init) Add Management and Connectivity** | Initialize the root module for this test instance. |
| **Test 003 (terraform plan) Add Management and Connectivity** | Generate a Terraform plan for this test instance. |
| **Test 003 (terraform apply) Add Management and Connectivity** | Apply the Terraform plan for this test instance. |
| **Clean-up Test Environment (terraform destroy)** | Run `terraform destroy` to clean-up the test environment.<sup>2</sup> |

> <sup>1</sup> *Each job uses a dedicated SPN (with certificate based authentication) to connect to Azure.*
> *This is to minimize the risk of API rate limiting when running highly parallel resource deployments in the pipeline.*
>
> <sup>2</sup> *The* `terraform destroy` *task uses the* `always()` *condition to ensure the environment is cleaned-up if any of the previous tasks fail after a partial deployment.*

## Why Azure Pipelines?

The Unit Tests and E2E Tests need valid Azure credentials to authenticate with the Azure platform for Terraform to work.
These tests are run on Azure Pipelines as a security measure, allowing contributed code from forked repositories to be reviewed before tests are manually triggered by a repository contributor using [comment triggers](https://docs.microsoft.com/azure/devops/pipelines/repos/github?view=azure-devops&tabs=yaml#comment-triggers).
Although GitHub Actions could technically run these jobs, GitHub prevents access to secrets for jobs triggered from forks.

## Multi-job configuration (`matrix` strategy)

Azure Pipelines provides the option to define a [multi-job configuration](https://docs.microsoft.com/azure/devops/pipelines/process/phases?view=azure-devops&tabs=yaml#multi-job-configuration).
This enables multi-configuration testing to be implemented from a common set of tasks, with the benefit of running multiple jobs on multiple agents in parallel.

Our implementation uses a programmatically generated `matrix` strategy to ensure we can meet our testing requirements.
This is designed to ensure the module works with different combinations of Terraform and Azure provider versions.
The strategy is generated by a [PowerShell script](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/blob/main/tests/scripts/azp-strategy.ps1), and is used by both the Unit and E2E tests.

The current strategy consists of running tests against the following version combinations:

- Terraform versions:
  - Minimum version supported by the module (`0.15.0`)
  - Latest `0.15.x` version
  - Latest `1.0.x` version
- Azure provider for Terraform versions:
  - Minimum version supported by the module (`v2.77.0`)
  - Latest version

The latest versions are determined programmatically by querying the publisher APIs.
This negates the need to update the code or pipeline to ensure the latest version is being tested.

With the frequency at which we run tests these combinations give reasonable assurance that the module will work with all version combinations up to the latest versions, not withstanding any  which temporarily introduce bugs.

The `matrix` strategy also uses the [Microsoft.Subscription/aliases@2021-10-01](https://docs.microsoft.com/rest/api/subscription/2020-09-01/alias) API to map Subscriptions to each job within the Matrix.
This ensures that each job has dedicated Subscriptions to deploy resources into, and place within the Management Group hierarchy.
In combination with the dedicated SPN per job, this also increases the API rate limits available to the pipeline.
