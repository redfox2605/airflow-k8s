.PHONY: \
    tf-get \
    tf-plan \
    tf-apply \
    tf-destroy \
    tf-init \
    tf-refresh \
    tf-output

.DEFAULT_GOAL := help

##########################################################################################
# Config
##########################################################################################

MAKEFLAGS =+ -rR --warn-undefined-variables

define PRINT_HELP_PYSCRIPT
import re, sys

for line in sys.stdin:
        match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
        if match:
                target, help = match.groups()
                print("%-20s %s" % (target, help))
endef

ifndef TEAM
TEAM=myTeam
endif

ifndef ENV
ENV := Dev
export TF_VAR_aws_env = dev
else
ENV := $(shell echo ${ENV} | awk '{print toupper(substr($$0,1,1)) tolower(substr($$0,2))}')
export TF_VAR_aws_env = prod
endif

ifndef REGION
REGION := eu-west-1
endif

ifdef TARGET
TARGET := "-target=${TARGET}"
endif

PROFILE := Admin$(TEAM)$(ENV)
ACCOUNT_ID := $(shell AWS_PROFILE=$(PROFILE) aws sts get-caller-identity --query Account --output text)

BUCKET_NAME := terraform-state-$(ACCOUNT_ID)
PLAN_NAME := terraform/k8s-airflow
LOCKS_TABLE := terraform_locks
TF_VARS := -var 'region=$(REGION)' \
  -var 'team_name=$(TEAM)' \
  -var 'team_env=$(ENV)'

$(info Using Account: $(PROFILE))
$(info Using Account ID: $(ACCOUNT_ID))
$(info Using ENV: $(TF_VAR_aws_env))
$(info Using Region: $(REGION))


##########################################################################################
# Terraform tasks
##########################################################################################

tf-get:
	@cd terraform && \
	AWS_PROFILE=$(PROFILE) AWS_DEFAULT_REGION=$(REGION) \
	terraform get -update

tf-plan:
	@cd terraform && \
	AWS_PROFILE=$(PROFILE) AWS_DEFAULT_REGION=$(REGION) \
	terraform plan $(TF_VARS)

tf-apply:
	@cd terraform && \
	AWS_PROFILE=$(PROFILE) AWS_DEFAULT_REGION=$(REGION) \
	terraform apply $(TF_VARS)

tf-refresh:
	@cd terraform && \
	AWS_PROFILE=$(PROFILE) AWS_DEFAULT_REGION=$(REGION) \
	terraform refresh $(TF_VARS)

tf-destroy:
	@cd terraform && \
	AWS_PROFILE=$(PROFILE) AWS_DEFAULT_REGION=$(REGION) \
	terraform destroy $(TF_VARS)

tf-output:
	@cd terraform && \
	AWS_PROFILE=$(PROFILE) AWS_DEFAULT_REGION=$(REGION) \
	terraform output $(TF_VARS)

tf-init:
	@cd terraform && \
	terraform init -backend-config="profile=$(PROFILE)" \
	  -backend-config="region=$(REGION)" \
		-backend-config="bucket=$(BUCKET_NAME)" \
		-backend-config="dynamodb_table=$(LOCKS_TABLE)" \
		-backend-config="key=$(PLAN_NAME)/$(REGION).tfstate" \
		-reconfigure

tf-apply-infra-route53:
	@cd terraform && \
	AWS_PROFILE=$(PROFILE) AWS_DEFAULT_REGION=$(REGION) \
    terraform apply $(TF_VARS) -target=module.infra-route53

tf-apply-infra-airflow:
	@cd terraform && \
	AWS_PROFILE=$(PROFILE) AWS_DEFAULT_REGION=$(REGION) \
	terraform apply $(TF_VARS) -target=module.airflow-infra

tf-destroy-airflow:
	@cd terraform && \
	AWS_PROFILE=$(PROFILE) AWS_DEFAULT_REGION=$(REGION) \
	terraform destroy $(TF_VARS) -target=module.airflow-infra


