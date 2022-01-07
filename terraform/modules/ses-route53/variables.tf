variable "team_env" {}

variable "mail_domain" {
  default = "mydomain.tech"
}

variable "spf_entry" {
  default = "v=spf1 include:amazonses.com ~all"
}
