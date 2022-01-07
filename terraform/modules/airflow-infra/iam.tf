resource "aws_iam_role" "iam_role_airflow" {
  name = var.iam_role_name
  # remeber to the policies for the role impersonation
  assume_role_policy = file("./modules/airflow-infra/assume_iam_role_by_kube.json")

  path = "/mydomain/k8s/"
}

resource "aws_iam_role_policy_attachment" "airflow_iam_policy_attachment" {
  role = aws_iam_role.iam_role_airflow.name
  policy_arn = aws_iam_policy.airflow_policy.arn
}
