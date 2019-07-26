resource "aws_ecs_cluster" "ecs_cluster" {
  name = "nerveshub-${var.environment}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy" "ecs_instance_role_policy" {
  name   = "ecs-instance-role-policy-${var.environment}"
  policy = file("${path.module}/templates/ecs-instance-role-policy.json")
  role   = aws_iam_role.ecs_role.id
}

resource "aws_iam_role" "ecs_role" {
  name               = "ecs-instance-role-${var.environment}"
  assume_role_policy = file("${path.module}/templates/ecs-role.json")
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "ecs-instance-profile-${var.environment}"
  path = "/"
  role = aws_iam_role.ecs_role.name
}

# This is created for all load balancers in the cluster, so we can whitelist
# inbound from these load balancers on the instance security group
resource "aws_security_group" "lb_security_group" {
  name = "${aws_ecs_cluster.ecs_cluster.name}-load-balancer"
  description = "${aws_ecs_cluster.ecs_cluster.name} load balancers"
  vpc_id = var.aws_vpc_id

  tags = {
    Name = "${aws_ecs_cluster.ecs_cluster.name}-load-balancer"
    Cluster = aws_ecs_cluster.ecs_cluster.name
    Terraform = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# allow inbound traffic from other instances in this cluster
# for cross service communications
resource "aws_security_group_rule" "lb_security_group_cluster_instances_ingress" {
  type = "ingress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  source_security_group_id = aws_security_group.instance_security_group.id
  security_group_id = aws_security_group.lb_security_group.id

  depends_on = [aws_security_group.instance_security_group]
}

resource "aws_security_group_rule" "lb_security_group_all_egress" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb_security_group.id
}

# ECS instance security group
# In the future we might open SSH access
resource "aws_security_group" "instance_security_group" {
  name = "${aws_ecs_cluster.ecs_cluster.name}-servers"
  description = "${aws_ecs_cluster.ecs_cluster.name} instances"
  vpc_id = var.aws_vpc_id

  tags = {
    Name = "${aws_ecs_cluster.ecs_cluster.name}-servers"
    Cluster = aws_ecs_cluster.ecs_cluster.name
    Terraform = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "instance_security_group_lb_ingress" {
  type = "ingress"
  from_port = 49153
  to_port = 65535
  protocol = "-1"
  source_security_group_id = aws_security_group.lb_security_group.id
  security_group_id = aws_security_group.instance_security_group.id
}

resource "aws_security_group_rule" "instance_security_group_all_egress" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.instance_security_group.id
}

# resource "aws_launch_configuration" "launch_config" {
#   name_prefix = "ecs-${var.environment}-launch-"
#   image_id = format("%s", data.aws_ami.ecs_ami.id)
#   instance_type = var.instance_type
#   enable_monitoring = true
#   key_name = "LT-after-tyler"
#   iam_instance_profile = aws_iam_instance_profile.ecs_instance_profile.name
#   security_groups = [aws_security_group.instance_security_group.id]
#   associate_public_ip_address = false
#   ebs_optimized = true
#   user_data = data.template_file.user_data.rendered

#   lifecycle {
#     create_before_destroy = true
#   }

#   root_block_device {
#     volume_type = "gp2"
#     volume_size = 15
#   }

#   ebs_block_device {
#     device_name = "/dev/xvdcz"
#     volume_type = "io1"
#     volume_size = 50
#     iops = 850
#     delete_on_termination = true
#     encrypted = true
#   }
# }

resource "aws_cloudwatch_log_group" "app" {
  name = aws_ecs_cluster.ecs_cluster.name
  retention_in_days = 90
}
