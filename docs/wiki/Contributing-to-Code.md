Please ensure you have read our [Contributing](./Contributing) page before going any further.

## Checklist

- Fixes a bug or feature reported and accepted in our [Issues][Issues] log
- New features should be relevant to, and improve upon, existing core functionality
- PR contains updated [Unit Tests][Unit-Tests] where appropriate
- PR contains updated [E2E Tests][E2E-Tests] where appropriate
- PR contains documentation update
- PR is able to pass all [Unit Tests][Unit-Tests] and [E2E Tests][E2E-Tests]
- PR is rebased against the latest `main` branch
- PR is squashed into one commit per logical change
- PR commit message should be concise but descriptive (will be used to generate release notes)

<!--Reference links in article-->

[Issues]: https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues "Our issues log"
[Unit-Tests]: https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/blob/main/tests/pipelines/tests-unit.yml "Unit tests YAML"
[E2E-Tests]: https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/blob/main/tests/pipelines/tests-e2e.yml "E2E tests YAML"