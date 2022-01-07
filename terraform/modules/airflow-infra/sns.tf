resource "aws_sns_topic" "airflow_sns" {
  count = local.destination_is_sns

  name = local.sns_name
  tags = local.common_tags
}

resource "aws_sns_topic_subscription" "airflow_sns_subscription" {
  count = local.destination_is_sns

  topic_arn = aws_sns_topic.airflow_sns[0].arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.airflow_sqs[0].arn
}
