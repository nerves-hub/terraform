# nerves_hub_www

# TODO: Loadbalancer, ssl cert, dns, log bucket, app bucket folders

# Load Balancer
resource "aws_lb_target_group" "www_lb_tg" {
  name     = "nerves-hub-${terraform.workspace}-www-tg"
  port     = 80
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = module.vpc.vpc_id

  health_check {
    interval = 20
    timeout = 10
    healthy_threshold = 3
    unhealthy_threshold = 3
    matcher = "200-399"
  }
}

resource "aws_lb" "www_lb" {
  name               = "nerves-hub-${terraform.workspace}-www-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.ecs_cluster.lb_security_group_id]
  subnets            = module.vpc.public_subnets
  tags = {
    Environment = terraform.workspace
  }
}

resource "aws_lb_listener" "www_lb_listener" {
  load_balancer_arn = "${aws_lb.www_lb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.www_lb_tg.arn}"
  }
}

resource "aws_route53_record" "www_dns_record" {
  zone_id = data.aws_route53_zone.dns_zone.zone_id
  name    = terraform.workspace == "production" ? "www.${var.domain}." : "www.${terraform.workspace}.${var.domain}."
  type    = "A"

  alias {
    name                   = aws_lb.www_lb.dns_name
    zone_id                = aws_lb.www_lb.zone_id
    evaluate_target_health = false
  }

  depends_on = [
    aws_lb.www_lb
  ]
}

data "aws_acm_certificate" "www_certificate" {
  domain   = "www.${terraform.workspace}.${var.domain}"
  statuses = ["ISSUED"]
}

resource "aws_lb_listener" "www_ssl_lb_listener" {
  load_balancer_arn = aws_lb.www_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.www_certificate.arn

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.www_lb_tg.arn}"
  }
}

# SSM
resource "aws_ssm_parameter" "nerves_hub_www_ssm_secret_db_url" {
  name      = "/nerves_hub_www/${terraform.workspace}/DATABASE_URL"
  type      = "SecureString"
  value     = "postgres://${var.db_username}:${var.db_password}@${module.web_db.endpoint}/${var.web_db_name}"
  overwrite = true
}

resource "aws_ssm_parameter" "nerves_hub_www_ssm_secret_live_view_signing_salt" {
  name      = "/nerves_hub_www/${terraform.workspace}/LIVE_VIEW_SIGNING_SALT"
  type      = "SecureString"
  value     = var.www_live_view_signing_salt
  overwrite = true
}

resource "aws_ssm_parameter" "nerves_hub_www_ssm_secret_erl_cookie" {
  name      = "/nerves_hub_www/${terraform.workspace}/ERL_COOKIE"
  type      = "SecureString"
  value     = var.erl_cookie
  overwrite = true
}

resource "aws_ssm_parameter" "nerves_hub_www_ssm_s3_ssl_bucket" {
  name      = "/nerves_hub_www/${terraform.workspace}/S3_SSL_BUCKET"
  type      = "String"
  value     = aws_s3_bucket.ca_application_data.bucket
  overwrite = true
}

resource "aws_ssm_parameter" "nerves_hub_www_ssm_app_name" {
  name      = "/nerves_hub_www/${terraform.workspace}/APP_NAME"
  type      = "String"
  value     = "nerves_hub_www"
  overwrite = true
}


resource "aws_ssm_parameter" "nerves_hub_www_ssm_cluster" {
  name      = "/nerves_hub_www/${terraform.workspace}/CLUSTER"
  type      = "String"
  value     = terraform.workspace == "production" ? "nerves-hub" : "nerves-hub-${terraform.workspace}"
  overwrite = true
}

resource "aws_ssm_parameter" "nerves_hub_www_ssm_aws_region" {
  name      = "/nerves_hub_www/${terraform.workspace}/AWS_REGION"
  type      = "String"
  value     = var.region
  overwrite = true
}

resource "aws_ssm_parameter" "nerves_hub_www_ssm_port" {
  name      = "/nerves_hub_www/${terraform.workspace}/PORT"
  type      = "String"
  value     = 80
  overwrite = true
}

resource "aws_ssm_parameter" "nerves_hub_www_ssm_host" {
  name      = "/nerves_hub_www/${terraform.workspace}/HOST"
  type      = "String"
  value     = "www.${terraform.workspace}.${var.domain}"
  overwrite = true
}

resource "aws_ssm_parameter" "nerves_hub_www_ssm_s3_bucket_name" {
  name      = "/nerves_hub_www/${terraform.workspace}/S3_BUCKET_NAME"
  type      = "String"
  value     = aws_s3_bucket.web_application_data.bucket
  overwrite = true
}

resource "aws_ssm_parameter" "nerves_hub_www_ssm_s3_log_bucket_name" {
  name      = "/nerves_hub_www/${terraform.workspace}/S3_LOG_BUCKET_NAME"
  type      = "String"
  value     = aws_s3_bucket.web_firmware_transfer_logs.bucket
  overwrite = true
}

resource "aws_ssm_parameter" "nerves_hub_www_ssm_secret_secret_key_base" {
  name      = "/nerves_hub_www/${terraform.workspace}/SECRET_KEY_BASE"
  type      = "SecureString"
  value     = var.web_secret_key_base
  overwrite = true
}

resource "aws_ssm_parameter" "nerves_hub_www_ssm_ses_port" {
  name      = "/nerves_hub_www/${terraform.workspace}/SES_PORT"
  type      = "String"
  value     = "587"
  overwrite = true
}

resource "aws_ssm_parameter" "nerves_hub_www_ssm_ses_server" {
  name      = "/nerves_hub_www/${terraform.workspace}/SES_SERVER"
  type      = "String"
  value     = "email-smtp.${var.region}.amazonaws.com"
  overwrite = true
}

resource "aws_ssm_parameter" "nerves_hub_www_ssm_smtp_username" {
  name      = "/nerves_hub_www/${terraform.workspace}/SMTP_USERNAME"
  type      = "SecureString"
  value     = var.web_smtp_password
  overwrite = true
}

resource "aws_ssm_parameter" "nerves_hub_www_ssm_secret_smtp_password" {
  name      = "/nerves_hub_www/${terraform.workspace}/SMTP_PASSWORD"
  type      = "SecureString"
  value     = var.web_smtp_username
  overwrite = true
}

# Roles
## Task role
resource "aws_iam_role" "www_task_role" {
  name = "nerves-hub-${terraform.workspace}-www-role"

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

data "aws_iam_policy_document" "www_iam_policy" {
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
      "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter/nerves_hub_www/${terraform.workspace}*"
    ]
  }

  statement {
    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.web_application_data.bucket}",
      "arn:aws:s3:::${aws_s3_bucket.ca_application_data.bucket}"
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
      "arn:aws:s3:::${aws_s3_bucket.web_application_data.bucket}/*"
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
      "arn:aws:s3:::${aws_s3_bucket.ca_application_data.bucket}/ssl/*"
    ]
  }

  statement {
    actions = [
      "kms:Decrypt",
    ]

    resources = [
      aws_kms_key.app_enc_key.arn,
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


resource "aws_iam_policy" "www_task_policy" {
  name = "nerves-hub-${terraform.workspace}-www-task-policy"
  policy = data.aws_iam_policy_document.www_iam_policy.json
}

resource "aws_iam_role_policy_attachment" "www_role_policy_attach" {
  role = aws_iam_role.www_task_role.name
  policy_arn = aws_iam_policy.www_task_policy.arn
}

# ECS
resource "aws_ecs_task_definition" "www_task_definition" {
  family = "nerves-hub-${terraform.workspace}-www"
  task_role_arn = aws_iam_role.www_task_role.arn
  execution_role_arn = aws_iam_role.ecs_tasks_execution_role.arn

  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu = "256"
  memory = "512"

  container_definitions = <<DEFINITION
   [
     {
       "portMappings": [
         {
           "hostPort": 80,
           "protocol": "tcp",
           "containerPort": 80
         }
       ],
       "networkMode": "awsvpc",
       "image": "${var.www_image}",
       "essential": true,
       "privileged": false,
       "name": "nerves_hub_www",
       "environment": [
         {
           "name": "ENVIRONMENT",
           "value": "${terraform.workspace}"
         },
         {
           "name": "APP_NAME",
           "value": "nerves_hub_www"
         }
       ],
       "logConfiguration": {
         "logDriver": "awslogs",
         "options": {
           "awslogs-region": "${var.region}",
           "awslogs-group": "${module.ecs_cluster.log_group}",
           "awslogs-stream-prefix": "nerves_hub_www"
         }
       }
     }
   ]

DEFINITION

}

resource "aws_ecs_service" "www_ecs_service" {
  name    = "nerves-hub-www"
  cluster = module.ecs_cluster.arn

  # this needs to be toggled on to update anything in the task besides container (e.g. CPU, memory, etc)
  # task_definition = "${aws_ecs_task_definition.ca_task_definition.family}:${max("${aws_ecs_task_definition.ca_task_definition.revision}", "${data.aws_ecs_task_definition.ca_task_definition.revision}")}"
  # task_definition = "${aws_ecs_task_definition.ca_task_definition.family}:${aws_ecs_task_definition.ca_task_definition.revision}"

  task_definition = aws_ecs_task_definition.www_task_definition.arn
  desired_count   = var.www_service_desired_count

  deployment_minimum_healthy_percent = "100"
  deployment_maximum_percent         = "200"
  launch_type = "FARGATE"

  health_check_grace_period_seconds = 300

  load_balancer {
    target_group_arn = aws_lb_target_group.www_lb_tg.arn
    container_name = "nerves_hub_www"
    container_port = 80
  }

  network_configuration {
    security_groups = [aws_security_group.web_security_group.id]
    subnets         = module.vpc.private_subnets
  }

  # After the first setup, we want to ignore this so deploys aren't reverted
  lifecycle {
    ignore_changes = [task_definition] # create_before_destroy = true
  }

  depends_on      = [
    aws_iam_role.www_task_role,
    aws_lb_listener.www_lb_listener
  ]
}
