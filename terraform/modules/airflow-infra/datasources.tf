# Required to send emails
data "aws_route53_zone" "my_domain" {
  name = "my domain"
}

data "aws_iam_policy_document" "sns_to_sqs" {
  count = local.destination_is_sns

  statement {
    sid    = "SnsSendMessageAccess"
    effect = "Allow"
    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
    actions   = ["sqs:SendMessage"]
    resources = [aws_sqs_queue.airflow_sqs[0].arn]
    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [aws_sns_topic.airflow_sns[0].arn]
    }
  }
}
