output "lb_security_group_id" {
  value = aws_security_group.lb_security_group.id
}

output "instance_security_group_id" {
  value = aws_security_group.instance_security_group.id
}
