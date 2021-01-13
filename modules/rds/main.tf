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

  tags = merge(var.tags, {
    Name = "${var.identifier}-db-sg"
  })

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
  option_group_name          = aws_db_option_group.this.name
  parameter_group_name       = aws_db_parameter_group.this.name
  skip_final_snapshot        = true

  performance_insights_enabled    = var.performance_insights
  enabled_cloudwatch_logs_exports = var.cloudwatch_log_exports

  monitoring_interval = var.monitoring_interval
  monitoring_role_arn = var.enhanced_monitoring ? join(", ", aws_iam_role.enhanced_monitoring.*.arn) : null

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

resource "aws_db_parameter_group" "this" {
  name_prefix = "${var.identifier}-"
  description = "Database Parameter Group for ${var.identifier}"
  family      = var.family

  dynamic "parameter" {
    for_each = var.parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = lookup(parameter.value, "apply_method", null)
    }
  }

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_option_group" "this" {
  name_prefix              = "${var.identifier}-"
  option_group_description = "Database Option group for ${var.identifier}"
  engine_name              = "postgres"
  major_engine_version     = var.major_engine_version

  dynamic "option" {
    for_each = var.options
    content {
      option_name                    = option.value.option_name
      port                           = lookup(option.value, "port", null)
      version                        = lookup(option.value, "version", null)
      db_security_group_memberships  = lookup(option.value, "db_security_group_memberships", null)
      vpc_security_group_memberships = lookup(option.value, "vpc_security_group_memberships", null)

      dynamic "option_settings" {
        for_each = lookup(option.value, "option_settings", [])
        content {
          name  = lookup(option_settings.value, "name", null)
          value = lookup(option_settings.value, "value", null)
        }
      }
    }
  }

  tags = var.tags

  timeouts {
    delete = lookup(var.timeouts, "delete", null)
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "enhanced_monitoring" {
  count              = var.enhanced_monitoring ? 1 : 0
  name               = "nerves-hub-rds-enhanced-monitoring-${terraform.workspace}"
  assume_role_policy = data.aws_iam_policy_document.enhanced_monitoring_assume_role_policy[count.index].json
  tags               = var.tags
}

data "aws_iam_policy_document" "enhanced_monitoring_assume_role_policy" {
  count = var.enhanced_monitoring ? 1 : 0
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "enhanced_monitoring" {
  count      = var.enhanced_monitoring ? 1 : 0
  role       = aws_iam_role.enhanced_monitoring[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}