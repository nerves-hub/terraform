output "bucket" {
  value = aws_s3_bucket.ca_application_data.bucket
}

output "host" {
  value = "${aws_service_discovery_service.ca_service_discovery.name}.${var.local_dns_namespace.name}"
}
