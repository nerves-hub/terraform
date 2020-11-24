output "api_dns_record_name" {
  value = aws_route53_record.api_dns_record.name
}

output "device_dns_record_name" {
  value = aws_route53_record.device_dns_record.name
}

output "www_dns_record_name" {
  value = aws_route53_record.www_dns_record.name
}