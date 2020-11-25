locals {
  app_name = "nerves_hub_api"
}

resource "random_integer" "target_group_id" {
  min = 1
  max = 999
}

# Load Balancer
resource "aws_lb_target_group" "api_lb_tg" {
  name                 = "nerves-hub-${terraform.workspace}-api-tg-${random_integer.target_group_id.result}"
  port                 = 443
  protocol             = "TCP"
  target_type          = "ip"
  vpc_id               = var.vpc.vpc_id
  deregistration_delay = 120

  health_check {
    protocol = "TCP"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb" "api_lb" {
  name               = "nerves-hub-${terraform.workspace}-api-lb"
  internal           = false
  load_balancer_type = "network"
  subnets            = var.vpc.public_subnets

  tags = {
    Environment = terraform.workspace
  }
}

resource "aws_lb_listener" "api_lb_listener" {
  load_balancer_arn = aws_lb.api_lb.arn
  port              = "443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_lb_tg.arn
  }
}

resource "aws_route53_record" "api_dns_record" {
  zone_id = var.public_dns_zone.zone_id
  name    = terraform.workspace == "production" ? "api.${var.domain}." : "api.${terraform.workspace}.${var.domain}."
  type    = "A"

  alias {
    name                   = aws_lb.api_lb.dns_name
    zone_id                = aws_lb.api_lb.zone_id
    evaluate_target_health = false
  }

  depends_on = [
    aws_lb.api_lb
  ]
}

# SSM
resource "aws_ssm_parameter" "nerves_hub_api_ssm_secret_db_url" {
  name      = "/${local.app_name}/${terraform.workspace}/DATABASE_URL"
  type      = "SecureString"
  value     = "postgres://${var.db.username}:${var.db.password}@${var.db.endpoint}/${var.db.name}"
  overwrite = true
}

resource "aws_ssm_parameter" "nerves_hub_api_ssm_secret_erl_cookie" {
  name      = "/${local.app_name}/${terraform.workspace}/ERL_COOKIE"
  type      = "SecureString"
  value     = var.erl_cookie
  overwrite = true
}

resource "aws_ssm_parameter" "nerves_hub_api_ssm_s3_ssl_bucket" {
  name      = "/${local.app_name}/${terraform.workspace}/S3_SSL_BUCKET"
  type      = "String"
  value     = var.ca_bucket
  overwrite = true
}

resource "aws_ssm_parameter" "nerves_hub_api_ssm_s3_log_bucket_name" {
  name      = "/${local.app_name}/${terraform.workspace}/S3_LOG_BUCKET_NAME"
  type      = "String"
  value     = var.log_bucket
  overwrite = true
}

resource "aws_ssm_parameter" "nerves_hub_api_ssm_app_name" {
  name      = "/${local.app_name}/${terraform.workspace}/APP_NAME"
  type      = "String"
  value     = local.app_name
  overwrite = true
}

resource "aws_ssm_parameter" "nerves_hub_api_ssm_cluster" {
  name      = "/${local.app_name}/${terraform.workspace}/CLUSTER"
  type      = "String"
  value     = var.cluster.name
  overwrite = true
}

resource "aws_ssm_parameter" "nerves_hub_api_ssm_aws_region" {
  name      = "/${local.app_name}/${terraform.workspace}/AWS_REGION"
  type      = "String"
  value     = var.region
  overwrite = true
}

resource "aws_ssm_parameter" "nerves_hub_api_ssm_port" {
  name      = "/${local.app_name}/${terraform.workspace}/PORT"
  type      = "String"
  value     = 80
  overwrite = true
}

resource "aws_ssm_parameter" "nerves_hub_api_ssm_host" {
  name      = "/${local.app_name}/${terraform.workspace}/HOST"
  type      = "String"
  value     = "api.${terraform.workspace}.${var.domain}"
  overwrite = true
}

resource "aws_ssm_parameter" "nerves_hub_api_ssm_ca_host" {
  name      = "/${local.app_name}/${terraform.workspace}/CA_HOST"
  type      = "String"
  value     = var.ca_host
  overwrite = true
}

resource "aws_ssm_parameter" "nerves_hub_api_ssm_s3_bucket_name" {
  name      = "/${local.app_name}/${terraform.workspace}/S3_BUCKET_NAME"
  type      = "String"
  value     = var.app_bucket
  overwrite = true
}

resource "aws_ssm_parameter" "nerves_hub_api_ssm_secret_secret_key_base" {
  name      = "/${local.app_name}/${terraform.workspace}/SECRET_KEY_BASE"
  type      = "SecureString"
  value     = var.secret_key_base
  overwrite = true
}

resource "aws_ssm_parameter" "nerves_hub_api_ssm_ses_port" {
  name      = "/${local.app_name}/${terraform.workspace}/SES_PORT"
  type      = "String"
  value     = "587"
  overwrite = true
}

resource "aws_ssm_parameter" "nerves_hub_api_ssm_ses_server" {
  name      = "/${local.app_name}/${terraform.workspace}/SES_SERVER"
  type      = "String"
  value     = "email-smtp.${var.region}.amazonaws.com"
  overwrite = true
}

resource "aws_ssm_parameter" "nerves_hub_api_ssm_smtp_username" {
  name      = "/${local.app_name}/${terraform.workspace}/SMTP_USERNAME"
  type      = "SecureString"
  value     = var.smtp_password
  overwrite = true
}

resource "aws_ssm_parameter" "nerves_hub_api_ssm_secret_smtp_password" {
  name      = "/${local.app_name}/${terraform.workspace}/SMTP_PASSWORD"
  type      = "SecureString"
  value     = var.smtp_username
  overwrite = true
}

# Roles
## Task role
resource "aws_iam_role" "api_task_role" {
  name = "nerves-hub-${terraform.workspace}-api-role"

  assume_role_policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
     {
       "Sid": "",
       "Effect": "Allow",
       "Principal": {
         "Service": "ecs-tasks.amazonaws.com"
       },
       "Action": "sts:AssumeRole"
     }
  ]
}
EOF

}

data "aws_iam_policy_document" "api_iam_policy" {
  statement {
    sid = "1"

    actions = [
      "ssm:DescribeParameters",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "ssm:GetParameters",
      "ssm:GetParametersByPath",
    ]

    resources = [
      "arn:aws:ssm:${var.region}:${var.account_id}:parameter/${local.app_name}/${terraform.workspace}*"
    ]
  }

  statement {
    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::${var.app_bucket}",
      "arn:aws:s3:::${var.ca_bucket}"
    ]
  }

  statement {
    actions = [
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:GetObjectTagging",
      "s3:GetObjectTorrent",
      "s3:GetObjectVersion",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionTagging",
      "s3:GetObjectVersionTorrent",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:PutObjectTagging",
      "s3:PutObjectVersionAcl",
      "s3:PutObjectVersionTagging",
    ]

    resources = [
      "arn:aws:s3:::${var.app_bucket}/*"
    ]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:GetObjectTagging",
      "s3:GetObjectTorrent",
      "s3:GetObjectVersion",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionTagging",
      "s3:GetObjectVersionTorrent"
    ]

    resources = [
      "arn:aws:s3:::${var.ca_bucket}/ssl/*"
    ]
  }

  statement {
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey"
    ]

    resources = [
      var.kms_key.arn,
    ]
  }

  statement {
    actions = [
      "ecs:DeregisterContainerInstance",
      "ecs:DiscoverPollEndpoint",
      "ecs:Poll",
      "ecs:RegisterContainerInstance",
      "ecs:StartTelemetrySession",
      "ecs:UpdateContainerInstancesState",
      "ecs:Submit*",
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "ecs:RegisterContainerInstance",
      "ecs:DeregisterContainerInstance",
      "ecs:DiscoverPollEndpoint",
      "ecs:StartTask",
      "ecs:ListTasks",
      "ecs:ListServices",
      "ecs:DescribeServices",
      "ecs:DescribeTasks",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "api_task_policy" {
  name   = "nerves-hub-${terraform.workspace}-api-task-policy"
  policy = data.aws_iam_policy_document.api_iam_policy.json
}

resource "aws_iam_role_policy_attachment" "api_role_policy_attach" {
  role       = aws_iam_role.api_task_role.name
  policy_arn = aws_iam_policy.api_task_policy.arn
}

# ECS
resource "aws_ecs_task_definition" "api_task_definition" {
  family             = "nerves-hub-${terraform.workspace}-api"
  task_role_arn      = aws_iam_role.api_task_role.arn
  execution_role_arn = var.task_execution_role.arn

  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = <<DEFINITION
   [
     {
       "portMappings": [
         {
           "hostPort": 443,
           "protocol": "tcp",
           "containerPort": 443
         }
       ],
       "networkMode": "awsvpc",
       "image": "${var.docker_image}",
       "essential": true,
       "privileged": false,
       "name": "${local.app_name}",
       "environment": [
         {
           "name": "ENVIRONMENT",
           "value": "${terraform.workspace}"
         },
         {
           "name": "APP_NAME",
           "value": "${local.app_name}"
         }
       ],
       "logConfiguration": {
         "logDriver": "awslogs",
         "options": {
           "awslogs-region": "${var.region}",
           "awslogs-group": "${var.log_group}",
           "awslogs-stream-prefix": "${local.app_name}"
         }
       }
     }
   ]

DEFINITION

}

resource "aws_ecs_service" "api_ecs_service" {
  name    = "nerves-hub-api"
  cluster = var.cluster.arn

  # this needs to be toggled on to update anything in the task besides container (e.g. CPU, memory, etc)
  # task_definition = "${aws_ecs_task_definition.api_task_definition.family}:${max("${aws_ecs_task_definition.api_task_definition.revision}", "${data.aws_ecs_task_definition.api_task_definition.revision}")}"
  # task_definition = "${aws_ecs_task_definition.api_task_definition.family}:${aws_ecs_task_definition.api_task_definition.revision}"

  task_definition = aws_ecs_task_definition.api_task_definition.arn
  desired_count   = var.service_count

  deployment_minimum_healthy_percent = "100"
  deployment_maximum_percent         = "200"
  launch_type                        = "FARGATE"

  health_check_grace_period_seconds = 300

  load_balancer {
    target_group_arn = aws_lb_target_group.api_lb_tg.arn
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

  depends_on = [
    aws_iam_role.api_task_role,
    aws_lb_listener.api_lb_listener
  ]
}
