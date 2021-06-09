output "bucket" {
  value = aws_s3_bucket.ca_application_data.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.ca_application_data.arn
}

output "host" {
  value = "${aws_service_discovery_service.ca_service_discovery.name}.${var.local_dns_namespace.name}"
}

output "security_group_id" {
  value = aws_security_group.ca_security_group.id
}