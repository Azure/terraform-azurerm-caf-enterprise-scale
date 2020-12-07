#
# Makefile
#

# Terraform

tf-generate:
	@echo "==> Running script..."
	./tests/scripts/tf-generate.sh

tf-replace:
	@echo "==> Running script..."
	./tests/scripts/tf-replace.sh

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

# Sentinel

# sn-apply:
# 	sentinel apply

# sn-test:
# 	sentinel test
