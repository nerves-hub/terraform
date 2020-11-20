# Billing
module "billing_db" {
  source = "../modules/rds"

  name              = "nerves_hub_billing"
  identifier        = "nerves-hub-${terraform.workspace}-billing"
  username          = var.db_username
  password          = var.db_password
  instance_class    = var.db_instance_class
  allocated_storage = var.db_allocated_storage
  subnet_group      = aws_db_subnet_group.db.name
  engine_version    = var.db_engine_version
  vpc_id            = module.vpc.vpc_id
  kms_key           = aws_kms_key.db_enc_key.arn
}

module "billing" {
  source = "../modules/billing"

  account_id = data.aws_caller_identity.current.account_id
  region     = var.region
  domain     = var.domain

  vpc        = module.vpc
  cluster    = module.ecs_cluster
  db         = module.billing_db
  log_group  = module.ecs_cluster.log_group_name
  app_bucket = aws_s3_bucket.web_application_data.bucket
  ca_bucket  = module.ca.bucket

  task_execution_role = aws_iam_role.ecs_tasks_execution_role
  docker_image        = var.billing_image
  service_count       = var.billing_service_desired_count
  kms_key             = aws_kms_key.app_enc_key
  bucket_prefix       = var.bucket_prefix
  web_security_group  = aws_security_group.web_security_group

  erl_cookie          = var.erl_cookie
  local_dns_namespace = aws_service_discovery_private_dns_namespace.local_dns_namespace
}
