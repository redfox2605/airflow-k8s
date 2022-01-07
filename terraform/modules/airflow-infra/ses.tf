resource "aws_ses_configuration_set" "airflow_configuration_set" {
  name = var.configuration_set_name
}

resource "aws_ses_event_destination" "sns" {
  count = local.destination_is_sns

  name                   = local.ses_config_set_name
  configuration_set_name = aws_ses_configuration_set.airflow_configuration_set.name
  enabled                = true
  matching_types         = var.enabled_matching_type

  sns_destination {
    topic_arn = aws_sns_topic.airflow_sns[0].arn
  }
}
