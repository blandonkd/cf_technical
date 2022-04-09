resource "aws_acm_certificate" "public_cert" {
  domain_name       = "clientapp.com"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# resource "aws_route53_record" "client_app" {
#   zone_id = aws_route53_zone.primary.zone_id
#   name    = "www.example.com"
#   type    = "A"
#   ttl     = "300"
#   records = [aws_eip.lb.public_ip]
# }


data "aws_route53_zone" "example" {
  name         = "example.com"
  private_zone = false
}

resource "aws_route53_record" "example" {
  for_each = {
    for dvo in aws_acm_certificate.example.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.example.zone_id
}

resource "aws_acm_certificate_validation" "example" {
  certificate_arn         = aws_acm_certificate.example.arn
  validation_record_fqdns = [for record in aws_route53_record.example : record.fqdn]
}

resource "aws_lb_listener" "example" {
  # ... other configuration ...

  certificate_arn = aws_acm_certificate_validation.example.certificate_arn
}