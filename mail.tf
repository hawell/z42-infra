# Provides an SES domain identity resource
resource "aws_ses_domain_identity" "ses_domain" {
  domain = "chordsoft.org"
}

resource "aws_ses_domain_mail_from" "main" {
  domain           = aws_ses_domain_identity.ses_domain.domain
  mail_from_domain = "mail.chordsoft.org"
}


# Example Route53 MX record
#resource "aws_route53_record" "example_ses_domain_mail_from_mx" {
#  zone_id = aws_route53_zone.example.id
#  name    = aws_ses_domain_mail_from.main.mail_from_domain
#  type    = "MX"
#  ttl     = "600"
#  records = ["10 feedback-smtp.us-east-1.amazonses.com"] # Change to the region in which `aws_ses_domain_identity.example` is created
#}

# Example Route53 TXT record for SPF
#resource "aws_route53_record" "example_ses_domain_mail_from_txt" {
#  zone_id = aws_route53_zone.example.id
#  name    = aws_ses_domain_mail_from.main.mail_from_domain
#  type    = "TXT"
#  ttl     = "600"
#  records = ["v=spf1 include:amazonses.com -all"]
#}

#resource "aws_route53_record" "spf_domain" {
#  zone_id = data.aws_route53_zone.main.zone_id
#  name    = var.domain
#  type    = "TXT"
#  ttl     = "600"
#  records = ["v=spf1 include:amazonses.com -all"]
#}

resource "aws_ses_domain_dkim" "ses_domain_dkim" {
  domain = join("", aws_ses_domain_identity.ses_domain.*.domain)
}

#resource "aws_route53_record" "amazonses_dkim_record" {
#  count   = 3
#  zone_id = data.aws_route53_zone.main.zone_id
#  name    = "${element(aws_ses_domain_dkim.ses_domain_dkim.dkim_tokens, count.index)}._domainkey.${var.domain}"
#  type    = "CNAME"
#  ttl     = "600"
#  records = ["${element(aws_ses_domain_dkim.ses_domain_dkim.dkim_tokens, count.index)}.dkim.amazonses.com"]
#}

output "dkim_tokens" {
  value = aws_ses_domain_dkim.ses_domain_dkim.dkim_tokens
}

# Provides an IAM access key. This is a set of credentials that allow API requests to be made as an IAM user.
resource "aws_iam_user" "user" {
  name = "NotificationIAMUser"
}

# Provides an IAM access key. This is a set of credentials that allow API requests to be made as an IAM user.
resource "aws_iam_access_key" "access_key" {
  user = aws_iam_user.user.name
}

# Attaches a Managed IAM Policy to SES Email Identity resource
data "aws_iam_policy_document" "policy_document" {
  statement {
    actions   = ["ses:SendEmail", "ses:SendRawEmail"]
    resources = [aws_ses_domain_identity.ses_domain.arn]
  }
}

# Provides an IAM policy attached to a user.
resource "aws_iam_policy" "policy" {
  name   = "NotificationIAMPolicy"
  policy = data.aws_iam_policy_document.policy_document.json
}

# Attaches a Managed IAM Policy to an IAM user
resource "aws_iam_user_policy_attachment" "user_policy" {
  user       = aws_iam_user.user.name
  policy_arn = aws_iam_policy.policy.arn
}


# IAM user credentials output
output "smtp_username" {
  value = aws_iam_access_key.access_key.id
}

output "smtp_password" {
  value     = aws_iam_access_key.access_key.ses_smtp_password_v4
  sensitive = true
}

