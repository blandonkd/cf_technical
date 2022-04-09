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