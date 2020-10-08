# nerves_hub_ca

# Security Groups
resource "aws_security_group" "billing_security_group" {
  name        = "nerves-hub-${terraform.workspace}-billing-sg"
  description = "nerves-hub-${terraform.workspace}-billing-sg"
  vpc_id      = var.vpc.vpc_id

  tags = {
    Environment = terraform.workspace
    Name        = "nerves-hub-${terraform.workspace}-billing-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "billing_security_group_all_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.billing_security_group.id
}

resource "aws_security_group_rule" "billing_security_group_web_ingress" {
  type                     = "ingress"
  from_port                = 8443
  to_port                  = 8443
  protocol                 = "tcp"
  source_security_group_id = var.web_security_group.id
  security_group_id        = aws_security_group.billing_security_group.id
}

resource "aws_security_group_rule" "db_security_group_billing_ingress" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.billing_security_group.id
  security_group_id        = var.db.security_group.id
}

resource "aws_security_group_rule" "db_security_group_billing_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = var.db.security_group.id
}

# SSM
resource "aws_ssm_parameter" "nerves_hub_billing_ssm_secret_db_url" {
  name      = "/nerves_hub_billing/${terraform.workspace}/DATABASE_URL"
  type      = "SecureString"
  value     = "postgres://${var.db.username}:${var.db.password}@${var.db.endpoint}/${var.db.name}"
  overwrite = true
}

resource "aws_ssm_parameter" "nerves_hub_billing_ssm_secret_erl_cookie" {
  name      = "/nerves_hub_billing/${terraform.workspace}/ERL_COOKIE"
  type      = "SecureString"
  value     = var.erl_cookie
  overwrite = true
}

resource "aws_ssm_parameter" "nerves_hub_billing_ssm_s3_bucket" {
  name      = "/nerves_hub_billing/${terraform.workspace}/S3_BUCKET"
  type      = "String"
  value     = var.ca_bucket
  overwrite = true
}

resource "aws_ssm_parameter" "nerves_hub_billing_ssm_app_name" {
  name      = "/nerves_hub_billing/${terraform.workspace}/APP_NAME"
  type      = "String"
  value     = "nerves_hub_billing"
  overwrite = true
}

resource "aws_ssm_parameter" "nerves_hub_billing_ssm_host" {
  name      = "/nerves_hub_billing/${terraform.workspace}/HOST"
  type      = "String"
  value     = "billing.${terraform.workspace}.${var.domain}"
  overwrite = true
}

resource "aws_s3_bucket_object" "web_application_data_billing" {
  bucket     = var.app_bucket
  acl        = "private"
  key        = "billing/"
  source     = "/dev/null"
  kms_key_id = var.kms_key.arn
}

# Roles
## Task role
resource "aws_iam_role" "billing_task_role" {
  name = "nerves-hub-${terraform.workspace}-billing-role"

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

data "aws_iam_policy_document" "billing_iam_policy" {
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
      "arn:aws:ssm:${var.region}:${var.account_id}:parameter/nerves_hub_billing/${terraform.workspace}*",
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
      "arn:aws:s3:::${var.app_bucket}/billing/*"
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


resource "aws_iam_policy" "billing_task_policy" {
  name   = "nerves-hub-${terraform.workspace}-billing-task-policy"
  policy = data.aws_iam_policy_document.billing_iam_policy.json
}

resource "aws_iam_role_policy_attachment" "billing_role_policy_attach" {
  role       = aws_iam_role.billing_task_role.name
  policy_arn = aws_iam_policy.billing_task_policy.arn
}

# Service discovery


resource "aws_service_discovery_service" "billing_service_discovery" {
  name = "billing"

  dns_config {
    namespace_id = var.local_dns_namespace.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

# ECS
resource "aws_ecs_task_definition" "billing_task_definition" {
  family             = "nerves-hub-${terraform.workspace}-billing"
  task_role_arn      = aws_iam_role.billing_task_role.arn
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
           "hostPort": 8443,
           "protocol": "tcp",
           "containerPort": 8443
         }
       ],
       "networkMode": "awsvpc",
       "image": "${var.docker_image}",
       "essential": true,
       "privileged": false,
       "name": "nerves_hub_billing",
       "environment": [
         {
           "name": "ENVIRONMENT",
           "value": "${terraform.workspace}"
         }
       ],
       "logConfiguration": {
         "logDriver": "awslogs",
         "options": {
           "awslogs-region": "${var.region}",
           "awslogs-group": "${var.log_group}",
           "awslogs-stream-prefix": "nerves_hub_billing"
         }
       }
     }
   ]

DEFINITION

}

resource "aws_ecs_service" "billing_ecs_service" {
  name    = "nerves-hub-billing"
  cluster = var.cluster.arn

  # this needs to be toggled on to update anything in the task besides container (e.g. CPU, memory, etc)
  # task_definition = "${aws_ecs_task_definition.billing_task_definition.family}:${max("${aws_ecs_task_definition.billing_task_definition.revision}", "${data.aws_ecs_task_definition.billing_task_definition.revision}")}"
  # task_definition = "${aws_ecs_task_definition.billing_task_definition.family}:${aws_ecs_task_definition.billing_task_definition.revision}"

  task_definition = aws_ecs_task_definition.billing_task_definition.arn
  desired_count   = var.service_count

  deployment_minimum_healthy_percent = "100"
  deployment_maximum_percent         = "200"
  launch_type                        = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.billing_security_group.id]
    subnets         = var.vpc.private_subnets
  }

  service_registries {
    registry_arn = aws_service_discovery_service.billing_service_discovery.arn
  }

  # After the first setup, we want to ignore this so deploys aren't reverted
  lifecycle {
    ignore_changes = [task_definition] # create_before_destroy = true
  }

  depends_on = [
    aws_iam_role.billing_task_role
  ]
}
