# Load Balancer
resource "aws_lb_target_group" "api_alb_tg" {
  count                = var.alb ? 1 : 0
  name                 = "nerves-hub-${terraform.workspace}-api-tg"
  port                 = 443
  protocol             = "HTTPS"
  target_type          = "ip"
  vpc_id               = var.vpc.vpc_id
  deregistration_delay = 120

  health_check {
    interval            = 20
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-399"
    protocol            = "HTTPS"
    path                = "/health"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

resource "aws_lb" "api_alb" {
  count              = var.alb ? 1 : 0
  name               = "nerves-hub-${terraform.workspace}-api-alb"
  internal           = var.internal_alb
  load_balancer_type = "application"
  security_groups    = [aws_security_group.port80_lb_security_group[count.index].id, aws_security_group.port443_lb_security_group[count.index].id]
  subnets            = var.vpc.public_subnets

  access_logs {
    enabled = var.access_logs
    bucket  = var.access_logs_bucket
    prefix  = var.access_logs_prefix
  }

  tags = var.tags
}

resource "aws_lb_listener" "http_alb_listener" {
  count             = var.alb ? 1 : 0
  load_balancer_arn = aws_lb.api_alb[count.index].arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https_alb_listener" {
  count             = var.alb ? 1 : 0
  load_balancer_arn = aws_lb.api_alb[count.index].arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_alb_tg[count.index].arn
  }
}

resource "aws_security_group" "port80_lb_security_group" {
  count       = var.alb ? 1 : 0
  name        = "nerves-hub-${terraform.workspace}-api-alb-port80"
  description = "nerves-hub ${terraform.workspace} alb port 80"
  vpc_id      = var.vpc.vpc_id

  ingress {
    protocol  = "tcp"
    from_port = 80
    to_port   = 80

    cidr_blocks      = var.allow_list_ipv4
    ipv6_cidr_blocks = var.allow_list_ipv6
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  tags = merge(var.tags, {
    Name = "nerves-hub-${terraform.workspace}-api alb"
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "port443_lb_security_group" {
  count       = var.alb ? 1 : 0
  name        = "nerves-hub-${terraform.workspace}-api-alb-port443"
  description = "nerves-hub ${terraform.workspace} alb port 443"
  vpc_id      = var.vpc.vpc_id

  ingress {
    protocol  = "tcp"
    from_port = 443
    to_port   = 443

    cidr_blocks      = var.allow_list_ipv4
    ipv6_cidr_blocks = var.allow_list_ipv6
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  tags = merge(var.tags, {
    Name = "nerves-hub-${terraform.workspace}-api alb"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# Service
resource "aws_ecs_service" "api_public_ecs_service" {
  count   = var.alb ? 1 : 0
  name    = "nerves-hub-api-public"
  cluster = var.cluster.arn

  # this needs to be toggled on to update anything in the task besides container (e.g. CPU, memory, etc)
  # task_definition = "${aws_ecs_task_definition.api_task_definition.family}:${max("${aws_ecs_task_definition.api_task_definition.revision}", "${data.aws_ecs_task_definition.api_task_definition.revision}")}"
  # task_definition = "${aws_ecs_task_definition.api_task_definition.family}:${aws_ecs_task_definition.api_task_definition.revision}"

  task_definition = aws_ecs_task_definition.api_task_definition.arn
  desired_count   = var.api_public_service_count
  propagate_tags  = "TASK_DEFINITION"

  deployment_minimum_healthy_percent = "100"
  deployment_maximum_percent         = "200"
  launch_type                        = "FARGATE"

  health_check_grace_period_seconds = 300

  load_balancer {
    target_group_arn = aws_lb_target_group.api_alb_tg[count.index].arn
    container_name   = local.app_name
    container_port   = 443
  }

  network_configuration {
    security_groups = [var.task_security_group_id]
    subnets         = var.vpc.private_subnets
  }

  # After the first setup, we want to ignore this so deploys aren't reverted
  lifecycle {
    ignore_changes = [task_definition] # create_before_destroy = true
  }

  tags = var.tags

  depends_on = [
    aws_iam_role.api_task_role,
    aws_lb_listener.http_alb_listener,
    aws_lb_listener.https_alb_listener
  ]
}