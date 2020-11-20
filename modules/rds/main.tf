# RDS instance security group
resource "aws_security_group" "rds_security_group" {
  name        = "${var.identifier}-db-sg"
  description = "Database security group for ${var.identifier}"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.security_groups != [""] ? [var.security_groups] : []
    content {
      from_port = 5432
      protocol  = "tcp"
      to_port   = 5432
      security_groups = flatten([
        ingress.value
      ])
    }
  }

  dynamic "ingress" {
    for_each = var.cidr_blocks != [""] ? [var.cidr_blocks] : []
    content {
      from_port = 5432
      protocol  = "tcp"
      to_port   = 5432
      cidr_blocks = flatten([
        ingress.value
      ])
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags

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
  backup_retention_period    = var.backup_retention_period
  db_subnet_group_name       = var.subnet_group
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  deletion_protection        = var.deletion_protection
  multi_az                   = var.multi_az
  copy_tags_to_snapshot      = var.copy_tags_to_snapshot
  option_group_name          = var.option_group_name
  parameter_group_name       = var.parameter_group_name
  skip_final_snapshot        = true

  performance_insights_enabled    = var.performance_insights
  enabled_cloudwatch_logs_exports = var.cloudwatch_log_exports

  vpc_security_group_ids = [
    aws_security_group.rds_security_group.id,
  ]

  lifecycle {
    ignore_changes = [
      name
    ]
  }

  tags = var.tags
}
