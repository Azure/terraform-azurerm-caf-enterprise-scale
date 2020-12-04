#
# Makefile
#

# Terraform

tf-init:
	terraform init

tf-plan:
	terraform plan

tf-apply:
	terraform apply

# Sentinel

sn-apply:
	sentinel apply

sn-test:
	sentinel test




