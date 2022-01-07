terraform {
  required_version = "~> 0.12.29"
  backend "s3" {}
}

provider "aws" {
  version = "~> 3.8.0"
  region  = var.region
}

data "aws_caller_identity" "default" {}

module "infra-route53" {
  source = "./modules/ses-route53"
  team_env = var.aws_env
}

module "airflow_infra" {
  source = "./modules/airflow-infra"
  airflow_policy_name    = "airflow-policy"
  iam_role_name          = "airflow-role"
  kube_context = "dev"
  team_env = "dev"
}
