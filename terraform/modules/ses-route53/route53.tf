resource "aws_route53_record" "_amazonses_mydomain" {
  zone_id = data.aws_route53_zone.my_domain.zone_id
  name    = "_amazonses.${aws_ses_domain_identity.my_domain_identity.domain}"
  type    = "TXT"
  ttl     = "600"

  records = [
    aws_ses_domain_identity.my_domain_identity.verification_token,
  ]
}

resource "aws_route53_record" "_domainkey_domain_tech" {
  count = 3

  zone_id = data.aws_route53_zone.my_domain.zone_id
  name    = "${aws_ses_domain_dkim.myteam_domain_tech.dkim_tokens[count.index]}._domainkey.${aws_ses_domain_identity.my_domain_identity.domain}"
  type    = "CNAME"
  ttl     = "600"

  records = [
    "${aws_ses_domain_dkim.myteam_domain_tech.dkim_tokens[count.index]}.dkim.amazonses.com.",
  ]
}

resource "aws_route53_record" "txt_my_team_tech" {
  zone_id = data.aws_route53_zone.my_domain.zone_id
  name    = aws_ses_domain_identity.my_domain_identity.domain
  type    = "TXT"
  ttl     = "600"

  records = [
    var.spf_entry
  ]
}
