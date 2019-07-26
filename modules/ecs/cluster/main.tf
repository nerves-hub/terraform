resource "aws_ecs_cluster" "ecs_cluster" {
  name = "nerves-hub-${var.environment}"

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

resource "aws_cloudwatch_log_group" "app" {
  name = aws_ecs_cluster.ecs_cluster.name
  retention_in_days = terraform.workspace == "staging" ? 1 : var.log_retention
}
