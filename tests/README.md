# Test Framework for the Azure landing zones Terraform module

This folder contains code relating to the test framework for this module.
Testing is currently performed in the following stages:

1. Code Review (GitHub Actions)
1. Unit Tests (Azure Pipelines)
1. E2E Tests (Azure Pipelines)
1. Update Test Baseline (Azure Pipelines)

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

The `Code Review` GitHub Action runs automatically upon each commit to branches in the repository (including forks) other than `main`, `patch-library` and `release/**`.
This is also a mandatory check on all PR's being raised against the `main` branch, enforced using branch protection rules.

## Unit Tests (Azure Pipelines)

As linting only let's you know if the code is well written (according to a pre-determined set of standards), we also need to determine whether the code generates a valid Terraform plan.

To verify this, we have a set of unit tests which run additional checks against the module using a series of test deployments.

To give assurance that the module works with the specified range of supported versions of Terraform and the Azure provider, we use a [matrix strategy](#multi-job-configuration-matrix-strategy)) to automatically generate parallel running jobs for each version combination.

The Unit Tests consist of the following tasks:

<!-- markdownlint-disable no-inline-html -->
| *Task Name* | *Description* |
| --- | --- |
| **Install Terraform Pre-requisites** | Ensures the required version of Terraform is installed on the agent. |
| **Prepare Terraform Environment** | Retrieves credentials for the target test environment and sets a unique value for the `root_id` input variable.<sup>1</sup> |
| **Terraform Linting (terraform fmt)** | Runs `terraform fmt` against the entire repository in `-check` mode to ensure Terraform code is correctly formatted. |
| **Install OPA/Conftest Pre-requisites** | Ensure the required version of `Conftest` and `jq` are installed on the agent. |
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
<!-- markdownlint-enable no-inline-html -->

The `Unit Tests` Azure Pipeline is a mandatory check on all PR's being raised against the `main` branch, enforced using branch protection rules.
To maintain security of the test environment, the `Unit Tests` Azure Pipeline must be manually initiated by a repository Admin or Maintainer once the submitted code changes have been reviewed.
This is a security step as outlined below in the [Why Azure Pipelines](#why-azure-pipelines) section of this page.

To run the `Unit Tests` Azure Pipeline, a repository Admin or Maintainer can add the comment `/azp run unit` to the PR.

## E2E Tests (Azure Pipelines)

In addition to the Unit Tests, we have a set of full end-to-end tests.
These are based on the same test modules as the Unit Tests, but run a full cycle of resource deployments using `terraform apply`, followed by a clean-up using `terraform destroy`.

The E2E Test workflow is designed to run the test modules in sequence, simulating an update scenario typical to how we might expect a customer to use this module.
This approach gives assurance that the module works for both new deployments, and updates to existing deployments.
It also allows us to verify that the module is able to successful destroy resources.

The E2E Tests consist of the following tasks:

<!-- markdownlint-disable no-inline-html -->
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
<!-- markdownlint-enable no-inline-html -->

The `E2E Tests` Azure Pipeline is an optional check for PR's being raised against the `main` branch.
Although not enforced through branch protection rules, this test should always be run before merging any code changes to the repository which could impact the functionality of the module.
This test can be skipped for PRs containing documentation changes only.
To maintain security of the test environment, the `E2E Tests` Azure Pipeline must be manually initiated by a repository Admin or Maintainer once the submitted code changes have been reviewed.
This is a security step as outlined below in the [Why Azure Pipelines](#why-azure-pipelines) section of this page.

To run the `E2E Tests` Azure Pipeline, a repository Admin or Maintainer can add the comment `/azp run e2e` to the PR.

## Update Test Baseline (Azure Pipelines)

To provide a test baseline for the OPA checks within the `Unit Tests` Azure Pipeline, each test module contains a `baseline_values.json` file which is the JSON output of `terraform plan` containing a known good configuration.

These files must be updated when changes are made to the module to ensure it reflects the new plan.

The `Update Tests Baseline` Azure Pipeline ensures this is done in a consistent manner against the test environment.

The E2E Tests consist of the following tasks:

| *Task Name* | *Description* |
| --- | --- |
| **Checkout** | Set with `persistCredentials: true` to ensure the OAuth credentials used for accessing the GitHub repository are available for other tasks. |
| **Update OPA baseline values** | Sequentially run through each test module, generating a Terraform plan to update the corresponding `baseline_values.json` files. |
| **Merge changes to repository** | Runs `git` commands to ensure the updated `baseline_values.json` files are added to the PR when changes are detected. |

To run the `Update Tests Baseline` Azure Pipeline, a repository Admin or Maintainer can add the comment `/azp run update` to the PR.
This should be run before the `Unit Tests` Azure Pipeline, and the generated `git diff` must be reviewed to understand the impact of the changes on the plan.

> **IMPORTANT:** If unexpected changes are observed in the `git diff` for any `baseline_values.json` files, the code should be reviewed and updated to ensure the module is functioning as expected.

## Why Azure Pipelines?

The Unit Tests, E2E Tests, and Update Test Baseline workflows need valid Azure credentials to authenticate with the Azure platform for Terraform to work.
These tests are run on Azure Pipelines as a security measure, allowing contributed code from forked repositories to be reviewed before tests are manually triggered by a repository contributor using [comment triggers](https://learn.microsoft.com/azure/devops/pipelines/repos/github?view=azure-devops&tabs=yaml#comment-triggers).
Although GitHub Actions could technically run these jobs, GitHub prevents access to secrets for jobs triggered from forks as s security measure.
Using this approach ensures a repository Admin or Maintainer is always in control of code changes being run against our test environment.

## Multi-job configuration (`matrix` strategy)

Azure Pipelines provides the option to define a [multi-job configuration](https://learn.microsoft.com/azure/devops/pipelines/process/phases?view=azure-devops&tabs=yaml#multi-job-configuration).
This enables multi-configuration testing to be implemented from a common set of tasks, with the benefit of running multiple jobs on multiple agents in parallel.

Our implementation uses a programmatically generated `matrix` strategy to ensure we can meet our testing requirements.
This is designed to ensure the module works with different combinations of Terraform and Azure provider versions.
The strategy is generated by a [PowerShell script](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/blob/main/tests/scripts/azp-strategy.ps1), and is used by both the Unit and E2E tests.

The current strategy consists of running tests against the following version combinations:

- Terraform versions:
  - Minimum version supported by the module (`1.7.0`)
- Azure provider for Terraform versions:
  - Minimum version supported by the module (`v3.107.0`)
  - Latest version

The latest versions are determined programmatically by querying the publisher APIs.
This negates the need to update the code or pipeline to ensure the latest version is being tested.

With the frequency at which we run tests these combinations give reasonable assurance that the module will work with all version combinations up to the latest versions, not withstanding any  which temporarily introduce bugs.

The `matrix` strategy also uses the [Microsoft.Subscription/aliases@2021-10-01](https://learn.microsoft.com/rest/api/subscription/2020-09-01/alias) API to map Subscriptions to each job within the Matrix.
This ensures that each job has dedicated Subscriptions to deploy resources into, and place within the Management Group hierarchy.
In combination with the dedicated SPN per job, this also increases the API rate limits available to the pipeline.
