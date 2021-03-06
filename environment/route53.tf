#  resource "aws_route53_record" "client_app" {
#   zone_id = aws_route53_zone.clien_app.zone_id
#   name    = "www.clientapp.com"
#   type    = "A"
#   ttl     = "300"
#   records = [aws_eip.lb.public_ip]
# }

resource "aws_route53_zone" "clien_app" {
  name = "clientapp.com"
}

# resource "aws_route53_record" "pub_cert_validation" {
#   for_each = {
#     for dvo in aws_acm_certificate.public_cert.domain_validation_options : dvo.domain_name => {
#       name   = dvo.resource_record_name
#       record = dvo.resource_record_value
#       type   = dvo.resource_record_type
#     }
#   }

#   allow_overwrite = true
#   name            = each.value.name
#   records         = [each.value.record]
#   ttl             = 60
#   type            = each.value.type
#   zone_id         = aws_route53_zone.clien_app.zone_id
# }