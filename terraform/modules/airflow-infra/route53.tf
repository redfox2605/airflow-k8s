resource "aws_route53_record" "airflow" {
  zone_id = data.aws_route53_zone.my_domain.zone_id
  name    = "airflow"
  type    = "CNAME"
  ttl     = "300"

  # here comes the ingress domain and the context
  records = ["ingress.${var.kube_context}.mydomain"]
}
