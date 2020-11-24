output "lb_zone_id" {
  value = aws_lb.www_lb.zone_id
}

output "lb_dns_name" {
  value = aws_lb.www_lb.dns_name
}

output "host_name" {
  value = aws_ssm_parameter.nerves_hub_www_ssm_host.value
}