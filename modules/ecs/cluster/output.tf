output "lb_security_group_id" {
  value = aws_security_group.lb_security_group.id
}

output "name" {
  value = aws_ecs_cluster.ecs_cluster.name
}

output "arn" {
  value = aws_ecs_cluster.ecs_cluster.arn
}

output "log_group_name" {
  value = aws_cloudwatch_log_group.app.name
}

output "log_group_arn" {
  value = aws_cloudwatch_log_group.app.arn
}
