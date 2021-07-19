#
# Makefile
#

# Azure Pipelines

azp-strategy:
	@echo "==> Running script..."
	./tests/scripts/azp-strategy.ps1

azp-spn-generator:
	@echo "==> Running script..."
	./tests/scripts/azp-spn-generator.sh

# Terraform

tf-install:
	@echo "==> Running script..."
	./tests/scripts/tf-install.sh

tf-prepare:
	@echo "==> Running script..."
	./tests/scripts/tf-prepare.sh

tf-fmt:
	@echo "==> Running script..."
	./tests/scripts/tf-fmt.sh

tf-init:
	@echo "==> Running script..."
	./tests/scripts/tf-init.sh

tf-plan:
	@echo "==> Running script..."
	./tests/scripts/tf-plan.sh

tf-apply:
	@echo "==> Running script..."
	./tests/scripts/tf-apply.sh

tf-destroy:
	@echo "==> Running script..."
	./tests/scripts/tf-destroy.sh

# OPA Conftest

opa-install:
	@echo "==> Running script..."
	./tests/scripts/opa-install.sh

opa-run-tests:
	@echo "==> Running script..."
	./tests/scripts/opa-run-tests.sh