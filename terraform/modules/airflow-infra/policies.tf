data "aws_caller_identity" "default" {}

data "aws_iam_policy_document" "airflow_policy" {

  statement {
    actions = [
      "sts:AssumeRole"
    ]

    resources = ["*",
    ]
  }

  statement {
    actions = [
      "glue:*",
      "athena:*"
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "s3:*"
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "SES:SendEmail",
      "SES:SendRawEmail"
    ]
    resources = [
      "arn:aws:ses:eu-west-1:${data.aws_caller_identity.default.account_id}:identity/my_domain",

    ]
  }

}

resource "aws_iam_policy" "airflow_policy" {
  name = var.airflow_policy_name
  path = "/mydomain/k8s/"

  policy = data.aws_iam_policy_document.airflow_policy.json
}