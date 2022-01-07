resource "aws_ses_domain_identity" "my_domain_identity" {
  domain = "mydomain.tech"
}

resource "aws_ses_domain_identity_verification" "myteam_domain_tech" {
  domain = aws_ses_domain_identity.my_domain_identity.domain

  depends_on = [
    aws_route53_record._amazonses_mydomain,
  ]
}

resource "aws_ses_domain_dkim" "myteam_domain_tech" {
  domain = aws_ses_domain_identity.my_domain_identity.domain
}
