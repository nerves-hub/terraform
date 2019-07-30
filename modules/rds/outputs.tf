output "endpoint" {
  value = aws_db_instance.default.endpoint
}

output "security_group" {
  value = aws_security_group.rds_security_group
}
