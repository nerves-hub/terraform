data "aws_route53_zone" "dns_zone" {
  name         = var.dns_zone
  private_zone = false
}

resource "aws_route53_record" "device_dns_record" {
  zone_id = data.aws_route53_zone.dns_zone.zone_id
  name    = var.device_dns_record_name
  type    = "A"

  alias {
    name                   = var.device_lb.lb_dns_name
    zone_id                = var.device_lb.lb_zone_id
    evaluate_target_health = false
  }
}


resource "aws_route53_record" "api_dns_record" {
  zone_id = data.aws_route53_zone.dns_zone.zone_id
  name    = var.api_dns_record_name
  type    = "A"

  alias {
    name                   = var.is_api_alb ? var.api_lb.alb_dns_name : var.api_lb.lb_dns_name
    zone_id                = var.is_api_alb ? var.api_lb.alb_zone_id : var.api_lb.lb_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_dns_record" {
  zone_id = data.aws_route53_zone.dns_zone.zone_id
  name    = var.www_dns_record_name
  type    = "A"

  alias {
    name                   = var.www_lb.lb_dns_name
    zone_id                = var.www_lb.lb_zone_id
    evaluate_target_health = false
  }
}
