output "lb_zone_id" {
  value = aws_lb.api_lb.zone_id
}

output "lb_dns_name" {
  value = aws_lb.api_lb.dns_name
}

output "host_name" {
  value = aws_ssm_parameter.nerves_hub_api_ssm_host.value
}