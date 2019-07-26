## KMS Encryption keys
resource "aws_kms_key" "app_enc_key" {
  description             = "Application data bucket encryption key"
  deletion_window_in_days = 30

  tags = {
    Origin = "Terraform"
  }
}

## Execution roles
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
  role = aws_iam_role.ecs_tasks_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
