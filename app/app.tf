## KMS Encryption keys
resource "aws_kms_key" "app_enc_key" {
  description             = "Application data bucket encryption key"
  deletion_window_in_days = 30

  tags = {
    Origin = "Terraform"
  }
}

resource "aws_kms_key" "db_enc_key" {
  description             = "DB encryption key"
  deletion_window_in_days = 30

  tags = {
    Origin = "Terraform"
  }
}

## Task execution role
data "aws_iam_policy_document" "ecs_tasks_execution_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_tasks_execution_role" {
  name               = "nerves-hub-${terraform.workspace}-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_execution_role.json
}


resource "aws_iam_role_policy_attachment" "ecs_tasks_execution_role_policy" {
  role       = aws_iam_role.ecs_tasks_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Security Groups
resource "aws_security_group" "web_security_group" {
  name        = "nerves-hub-${terraform.workspace}-web-sg"
  description = "nerves-hub-${terraform.workspace}-web-sg"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Environment = terraform.workspace
    Name        = "nerves-hub-${terraform.workspace}-web-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "web_security_group_all_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_security_group.id
}

resource "aws_security_group_rule" "web_security_group_lb_ingress" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.web_security_group.id
  source_security_group_id = module.ecs_cluster.lb_security_group_id
}

resource "aws_security_group_rule" "web_security_group_ssl_lb_ingress" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.web_security_group.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "web_security_group_epmd_ingress" {
  type                     = "ingress"
  from_port                = 4369
  to_port                  = 4369
  protocol                 = "tcp"
  security_group_id        = aws_security_group.web_security_group.id
  source_security_group_id = aws_security_group.web_security_group.id
}

resource "aws_security_group_rule" "web_security_group_disterl_ingress" {
  type                     = "ingress"
  from_port                = 9100
  to_port                  = 9155
  protocol                 = "tcp"
  security_group_id        = aws_security_group.web_security_group.id
  source_security_group_id = aws_security_group.web_security_group.id
}

#Database
module "web_db" {
  source = "../modules/rds"

  name              = "nerves_hub_web"
  identifier        = "nerves-hub-${terraform.workspace}-web"
  username          = var.db_username
  password          = var.db_password
  instance_class    = var.db_instance_class
  allocated_storage = var.db_allocated_storage
  subnet_group      = aws_db_subnet_group.db.name
  engine_version    = var.db_engine_version
  vpc_id            = module.vpc.vpc_id
  kms_key           = aws_kms_key.db_enc_key.arn
  security_groups   = aws_security_group.web_security_group.id
}

# Storage
resource "aws_s3_bucket" "web_firmware_transfer_logs" {
  bucket = "${var.bucket_prefix}-${terraform.workspace}-transfer-logs"
  acl    = "log-delivery-write"

  versioning {
    enabled = false
  }

  tags = {
    Origin = "Terraform"
  }
}

resource "aws_s3_bucket" "web_application_data" {
  bucket = "${var.bucket_prefix}-${terraform.workspace}-web"
  acl    = "private"

  versioning {
    enabled = false
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.app_enc_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  logging {
    target_bucket = aws_s3_bucket.web_firmware_transfer_logs.id
    target_prefix = "/"
  }

  tags = {
    Origin = "Terraform"
  }
}

resource "aws_s3_bucket_public_access_block" "web_application_data" {
  bucket = aws_s3_bucket.web_application_data.id

  block_public_acls   = true
  block_public_policy = true

  depends_on = [
    aws_s3_bucket.web_application_data
  ]
}

resource "aws_s3_bucket_object" "web_application_data_firmware" {
  bucket     = aws_s3_bucket.web_application_data.id
  acl        = "private"
  key        = "firmware/"
  source     = "/dev/null"
  kms_key_id = aws_kms_key.app_enc_key.arn
}

# DNS
data "aws_route53_zone" "dns_zone" {
  name         = terraform.workspace == "production" ? "${var.domain}." : "${terraform.workspace}.${var.domain}."
  private_zone = false
}

resource "aws_service_discovery_private_dns_namespace" "local_dns_namespace" {
  name        = "${terraform.workspace}.nerves-hub.local"
  description = terraform.workspace
  vpc         = module.vpc.vpc_id
}

# Database
module "ca_db" {
  source = "../modules/rds"

  name              = "nerves_hub_ca"
  identifier        = "nerves-hub-${terraform.workspace}-ca"
  username          = var.db_username
  password          = var.db_password
  instance_class    = var.db_instance_class
  allocated_storage = var.db_allocated_storage
  subnet_group      = aws_db_subnet_group.db.name
  engine_version    = var.db_engine_version
  vpc_id            = module.vpc.vpc_id
  kms_key           = aws_kms_key.db_enc_key.arn
  security_groups   = module.ca.security_group_id
}

module "ca" {
  source = "../modules/ca"

  account_id = data.aws_caller_identity.current.account_id
  region     = var.region
  domain     = var.domain

  vpc       = module.vpc
  cluster   = module.ecs_cluster
  db        = module.ca_db
  log_group = module.ecs_cluster.log_group_name

  task_execution_role = aws_iam_role.ecs_tasks_execution_role
  docker_image        = var.ca_image
  service_count       = var.ca_service_desired_count
  kms_key             = aws_kms_key.app_enc_key
  bucket_prefix       = var.bucket_prefix
  web_security_group  = aws_security_group.web_security_group

  erl_cookie          = var.erl_cookie
  local_dns_namespace = aws_service_discovery_private_dns_namespace.local_dns_namespace
}

module "www" {
  source = "../modules/www"

  account_id = data.aws_caller_identity.current.account_id
  region     = var.region
  domain     = var.domain

  kms_key         = aws_kms_key.app_enc_key
  vpc             = module.vpc
  cluster         = module.ecs_cluster
  public_dns_zone = data.aws_route53_zone.dns_zone

  lb_security_group_id   = module.ecs_cluster.lb_security_group_id
  task_security_group_id = aws_security_group.web_security_group.id

  db        = module.web_db
  log_group = module.ecs_cluster.log_group_name

  erl_cookie             = var.erl_cookie
  live_view_signing_salt = var.www_live_view_signing_salt
  app_bucket             = aws_s3_bucket.web_application_data.bucket
  ca_bucket              = module.ca.bucket
  log_bucket             = aws_s3_bucket.web_firmware_transfer_logs.bucket
  secret_key_base        = var.web_secret_key_base
  smtp_username          = var.web_smtp_username
  smtp_password          = var.web_smtp_password

  task_execution_role = aws_iam_role.ecs_tasks_execution_role
  docker_image        = var.www_image
  service_count       = var.www_service_desired_count
}

module "api" {
  source = "../modules/api"

  account_id = data.aws_caller_identity.current.account_id
  region     = var.region
  domain     = var.domain

  kms_key         = aws_kms_key.app_enc_key
  vpc             = module.vpc
  cluster         = module.ecs_cluster
  public_dns_zone = data.aws_route53_zone.dns_zone

  task_security_group_id = aws_security_group.web_security_group.id

  db        = module.web_db
  log_group = module.ecs_cluster.log_group_name

  erl_cookie      = var.erl_cookie
  app_bucket      = aws_s3_bucket.web_application_data.bucket
  ca_bucket       = module.ca.bucket
  ca_host         = module.ca.host
  log_bucket      = aws_s3_bucket.web_firmware_transfer_logs.bucket
  secret_key_base = var.web_secret_key_base
  smtp_username   = var.web_smtp_username
  smtp_password   = var.web_smtp_password

  task_execution_role = aws_iam_role.ecs_tasks_execution_role
  docker_image        = var.api_image
  service_count       = var.api_service_desired_count
}

module "device" {
  source = "../modules/device"

  account_id = data.aws_caller_identity.current.account_id
  region     = var.region
  domain     = var.domain

  kms_key         = aws_kms_key.app_enc_key
  vpc             = module.vpc
  cluster         = module.ecs_cluster
  public_dns_zone = data.aws_route53_zone.dns_zone

  task_security_group_id = aws_security_group.web_security_group.id

  db        = module.web_db
  log_group = module.ecs_cluster.log_group_name

  erl_cookie      = var.erl_cookie
  app_bucket      = aws_s3_bucket.web_application_data.bucket
  ca_bucket       = module.ca.bucket
  ca_host         = module.ca.host
  log_bucket      = aws_s3_bucket.web_firmware_transfer_logs.bucket
  secret_key_base = var.web_secret_key_base
  smtp_username   = var.web_smtp_username
  smtp_password   = var.web_smtp_password

  task_execution_role = aws_iam_role.ecs_tasks_execution_role
  docker_image        = var.device_image
  service_count       = var.device_service_desired_count
}
