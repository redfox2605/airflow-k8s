variable "team_env" {}
variable "iam_role_name" {}
variable "airflow_policy_name" {}
variable "kube_context" {}


variable "configuration_set_name" {
  default = "airflow"
}

variable "enabled_matching_type" {
  default = [
    "reject",
    "bounce",
    "complaint"
  ]
}

variable "event_destination" {
  default = "sns"
}


locals {
  common_tags = {
    "product"             = "airflow"
    "environment"         = var.team_env
    "owner"               = "myteam.bu@mydomain"
  }
  destination_is_sns  = var.event_destination == "sns" ? 1 : 0
  ses_config_set_name = "event-destination-${var.configuration_set_name}"
  sns_name            = "ses-event-destination-${var.configuration_set_name}"
  sqs_name            = "ses-event-destination-${var.configuration_set_name}"
}
