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

# AZ CLI

az-login:
	@echo "==> Running script..."
	./tests/scripts/az-login.sh

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

opa-values-generator:
	@echo "==> Running script..."
	cd "$(BUILD_REPOSITORY_LOCALPATH)/tests/scripts"
	./opa-values-generator.ps1
	cd "$(BUILD_REPOSITORY_LOCALPATH)"

# Git Commands

git-merge-changes:
	@echo "==> Running script..."
	./tests/scripts/git-merge-changes.sh