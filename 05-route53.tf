/*
  Public hosted zone
*/
data "aws_route53_zone" "hosted_zone_public" {
  name = var.hosted_zone_name
  private_zone = false
}

resource "aws_route53_record" "vpn_public1" {
  zone_id = data.aws_route53_zone.hosted_zone_public.zone_id
  name    = var.service
  type    = "A"
  ttl     = "300"
  multivalue_answer_routing_policy = true
  records = [aws_eip.vpn1.public_ip]
  set_identifier = "vpn1"
}

resource "aws_route53_record" "vpn_public2" {
  zone_id = data.aws_route53_zone.hosted_zone_public.zone_id
  name    = var.service
  type    = "A"
  ttl     = "300"
  multivalue_answer_routing_policy = true
  records = [aws_eip.vpn2.public_ip]
  set_identifier = "vpn2"
}
