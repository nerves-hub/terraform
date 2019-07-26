# NervesHubCA

# Security Groups
resource "aws_security_group" "ca_security_group" {
  name        = "nerves-hub-${terraform.workspace}-ca-sg"
  description = "nerves-hub-${terraform.workspace}-ca-sg"
  vpc_id      = module.vpc.vpc_id

  tags = {
    environment = terraform.workspace
    servicename = "nerves-hub-${terraform.workspace}-ca"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "ca_security_group_all_egress" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ca_security_group.id
}

# Database
module "rds" {
  source = "../modules/rds"

  name                   = "nerves_hub_ca"
  identifier             = "nerves-hub-ca-${terraform.workspace}"
  username               = var.db_username
  password               = var.db_password
  instance_class         = var.db_instance_class
  allocated_storage      = var.db_allocated_storage
  subnet_group           = aws_db_subnet_group.db.name
  engine_version         = var.db_engine_version
  vpc_id                 = module.vpc.vpc_id
  kms_key                = aws_kms_key.db_enc_key.arn
}

# Storage
resource "aws_s3_bucket" "ca_application_data" {
  bucket = "${var.bucket_prefix}-${terraform.workspace}-ca"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "expire"
    enabled = true

    noncurrent_version_expiration {
      days = 90
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.app_enc_key.arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = {
    Origin = "Terraform"
  }
}

resource "aws_s3_bucket_public_access_block" "application_data" {
  bucket = aws_s3_bucket.ca_application_data.id

  block_public_acls   = true
  block_public_policy = true

  depends_on = [
    aws_s3_bucket.ca_application_data
  ]
}

# SSM
resource "aws_ssm_parameter" "nerves_hub_ca_ssm_secret_db_url" {
  name      = "/nerves_hub_ca/${terraform.workspace}/DATABASE_URL"
  type      = "SecureString"
  value     = "postgres://${var.db_username}:${var.db_password}@${module.rds.endpoint}/nerves_hub_ca"
  overwrite = true
  lifecycle {
    ignore_changes = [
      "value",
    ]
  }
}

resource "aws_ssm_parameter" "nerves_hub_ca_ssm_secret_erl_cookie" {
  name      = "/nerves_hub_ca/${terraform.workspace}/ERL_COOKIE"
  type      = "SecureString"
  value     = var.erl_cookie
  overwrite = true
  lifecycle {
    ignore_changes = [
      "value",
    ]
  }
}

resource "aws_ssm_parameter" "nerves_hub_ca_ssm_s3_bucket" {
  name      = "/nerves_hub_ca/${terraform.workspace}/S3_BUCKET"
  type      = "String"
  value     = aws_s3_bucket.ca_application_data.bucket
  overwrite = true
  lifecycle {
    ignore_changes = [
      "value",
    ]
  }
}

resource "aws_ssm_parameter" "nerves_hub_ca_ssm_app_name" {
  name      = "/nerves_hub_ca/${terraform.workspace}/APP_NAME"
  type      = "String"
  value     = "nerves_hub_ca"
  overwrite = true
  lifecycle {
    ignore_changes = [
      "value",
    ]
  }
}

# Roles
## Task role
resource "aws_iam_role" "ca_task_role" {
  name = "nerves-hub-${terraform.workspace}-ca-role"

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

data "aws_iam_policy_document" "app_iam_policy" {
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
      "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter/nerves_hub_ca/${terraform.workspace}*",
    ]
  }

  statement {
    actions = [
      "s3:ListBucket",
    ]

    resources = [
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
      "arn:aws:s3:::${aws_s3_bucket.ca_application_data.bucket}/*"
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


resource "aws_iam_policy" "ca_task_policy" {
  name = "nerves-hub-${terraform.workspace}-ca-task-policy"
  policy = data.aws_iam_policy_document.app_iam_policy.json
}

resource "aws_iam_role_policy_attachment" "role_policy_attach" {
  role = aws_iam_role.ca_task_role.name
  policy_arn = aws_iam_policy.ca_task_policy.arn
}


# ECS
resource "aws_ecs_task_definition" "ca_task_definition" {
  family = "nerves-hub-${terraform.workspace}-ca"
  task_role_arn = aws_iam_role.ca_task_role.arn
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
           "hostPort": 8443,
           "protocol": "tcp",
           "containerPort": 8443
         }
       ],
       "networkMode": "awsvpc",
       "image": "${var.ca_image}",
       "essential": true,
       "privileged": false,
       "name": "nerves_hub_ca",
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
           "awslogs-group": "${module.ecs_cluster.log_group}",
           "awslogs-stream-prefix": "nerves_hub_ca"
         }
       }
     }
   ]

DEFINITION

}

resource "aws_ecs_service" "ca_ecs_service" {
  name    = "nerves-hub-ca"
  cluster = module.ecs_cluster.arn

  # this needs to be toggled on to update anything in the task besides container (e.g. CPU, memory, etc)
  # task_definition = "${aws_ecs_task_definition.ca_task_definition.family}:${max("${aws_ecs_task_definition.ca_task_definition.revision}", "${data.aws_ecs_task_definition.ca_task_definition.revision}")}"
  # task_definition = "${aws_ecs_task_definition.ca_task_definition.family}:${aws_ecs_task_definition.ca_task_definition.revision}"

  task_definition = aws_ecs_task_definition.ca_task_definition.arn
  desired_count   = var.ca_service_desired_count

  deployment_minimum_healthy_percent = "100"
  deployment_maximum_percent         = "200"
  launch_type                        = "FARGATE"
  network_configuration {
    security_groups = [aws_security_group.ca_security_group.id]
    subnets         = module.vpc.private_subnets
  }

  # After the first setup, we want to ignore this so deploys aren't reverted
  lifecycle {
    ignore_changes = [task_definition] # create_before_destroy = true
  }
}
