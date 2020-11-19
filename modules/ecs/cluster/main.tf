locals {
  current_account_id = data.aws_caller_identity.current.account_id
}

data "aws_caller_identity" "current" {}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "nerves-hub-${var.environment}"

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

# This is created for all load balancers in the cluster, so we can whitelist
# inbound from these load balancers on the instance security group
resource "aws_security_group" "lb_security_group" {
  name        = "${aws_ecs_cluster.ecs_cluster.name}-load-balancer"
  description = "${aws_ecs_cluster.ecs_cluster.name} load balancers"
  vpc_id      = var.aws_vpc_id

  ingress {
    protocol  = "tcp"
    from_port = 80
    to_port   = 80

    cidr_blocks = var.allow_list
  }

  ingress {
    protocol  = "tcp"
    from_port = 443
    to_port   = 443

    cidr_blocks = var.allow_list
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_log_group" "app" {
  name              = aws_ecs_cluster.ecs_cluster.name
  retention_in_days = terraform.workspace == "staging" ? 1 : var.log_retention
}
