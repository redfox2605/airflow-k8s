resource "aws_sqs_queue" "airflow_sqs" {
  count = local.destination_is_sns

  name = local.sqs_name
  tags = local.common_tags
}

resource "aws_sqs_queue_policy" "airflow_sqs_policy" {
  count = local.destination_is_sns

  queue_url = aws_sqs_queue.airflow_sqs[0].id
  policy    = data.aws_iam_policy_document.sns_to_sqs[0].json
}
