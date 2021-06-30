output "username" {
  value = aws_db_instance.default.username
}

output "password" {
  value = aws_db_instance.default.password
}

output "name" {
  value = aws_db_instance.default.name
}

output "endpoint" {
  value = aws_db_instance.default.endpoint
}

output "security_group" {
  value = aws_security_group.rds_security_group
}

output "security_group_id" {
  value = aws_security_group.rds_security_group.id
}

output "db_arn" {
  value = aws_db_instance.default.arn
}