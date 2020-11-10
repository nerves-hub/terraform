resource "aws_ecs_cluster" "ecs_cluster" {
  name = "nerves-hub-${var.environment}"

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

resource "aws_iam_role" "ecs_runtime" {
  name               = "${var.app_name}-${var.role_name}"
  assume_role_policy = data.aws_iam_policy_document.assume_ecs_role.json

  tags = var.tags
}

data "aws_iam_policy_document" "assume_ecs_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["ecs-tasks.amazonaws.com", "ecs.amazonaws.com"]
      type        = "Service"
    }
  }
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

    cidr_blocks = [element(var.whitelist, count.index)]
  }

  ingress {
    protocol  = "tcp"
    from_port = 443
    to_port   = 443

    cidr_blocks = [element(var.whitelist, count.index)]
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

data "aws_iam_policy_document" "ecs_runtime" {
  statement {
    actions = [
      "kms:Decrypt",
    ]

    resources = [
      var.kms_key_arn,
    ]
  }

  statement {
    actions = [
      "logs:PutLogEvents",
      "logs:CreateLogStream",
    ]

    resources = [
      aws_cloudwatch_log_group.app.arn,
      "${aws_cloudwatch_log_group.app.arn}:*",
    ]
  }

  statement {
    actions = [
      "ssm:GetParameters",
    ]

    resources = [
      "arn:aws:ssm:${var.aws_region}:${var.current_account_id}:parameter/${var.app_name}/*",
    ]
  }

  statement {
    actions = [
      "ecs:ListClusters",
      "ecs:ListContainerInstances",
      "ecs:DescribeContainerInstances",
    ]
    resources = [
      aws_ecs_cluster.ecs_cluster.arn,
    ]
  }
}

resource "aws_cloudwatch_log_group" "app" {
  name              = aws_ecs_cluster.ecs_cluster.name
  retention_in_days = terraform.workspace == "staging" ? 1 : var.log_retention
}
