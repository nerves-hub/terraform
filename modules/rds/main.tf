# RDS instance security group
resource "aws_security_group" "rds_security_group" {
  name        = "${var.identifier}-db-sg"
  description = "${var.identifier}-db-sg"
  vpc_id      = var.vpc_id

  tags = {
    Environment = terraform.workspace
    Name        = "${var.identifier}-db-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_instance" "default" {
  identifier                 = var.identifier
  name                       = var.name
  publicly_accessible        = false
  apply_immediately          = true
  storage_encrypted          = true
  kms_key_id                 = var.kms_key
  allocated_storage          = var.allocated_storage
  storage_type               = "gp2"
  engine                     = "postgres"
  engine_version             = var.engine_version
  instance_class             = var.instance_class
  username                   = var.username
  password                   = var.password
  backup_retention_period    = 1
  db_subnet_group_name       = var.subnet_group
  auto_minor_version_upgrade = true
  deletion_protection        = false
  multi_az                   = false
  skip_final_snapshot        = true

  vpc_security_group_ids = [
    aws_security_group.rds_security_group.id,
  ]

  lifecycle {
    ignore_changes = [
      name
    ]
  }

  tags = {
    Environment = terraform.workspace
    Name        = "${var.identifier}-db"
  }
}
