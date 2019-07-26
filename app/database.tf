module "rds" {
  source = "../modules/rds"

  username               = var.db_username
  password               = var.db_password
  instance_class         = var.db_instance_class
  allocated_storage      = var.db_allocated_storage
  subnet_group           = "nerveshub-${terraform.workspace}"
  engine_version         = var.db_engine_version
  vpc_id                 = module.vpc.vpc_id
  kms_key                = aws_kms_key.db_enc_key.id
}
