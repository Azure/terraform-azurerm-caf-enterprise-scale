#
# Makefile
#

# Azure Pipelines

azp-strategy:
	@echo "==> Running script..."
	./tests/scripts/azp-strategy.ps1

azp-backend:
	@echo "==> Running script..."
	./tests/scripts/azp-backend.sh

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
	./tests/scripts/opa-install-linux.sh

opa-run-tests:
	@echo "==> Running script..."
	./tests/scripts/opa-run-tests.sh

opa-update-values:
	@echo "==> Running script..."
	./tests/scripts/opa-update-values.ps1 -GENERATE_AUTO_TFVARS

opa-update-git:
	@echo "==> Running script..."
	./tests/scripts/opa-update-git.sh