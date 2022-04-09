# resource "aws_acm_certificate" "public_cert" {
#   domain_name       = "clientapp.com"
#   validation_method = "DNS"

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_acm_certificate_validation" "public_cert" {
#   certificate_arn         = aws_acm_certificate.public_cert.arn
#   validation_record_fqdns = [for record in aws_route53_record.pub_cert_validation : record.fqdn]
# }