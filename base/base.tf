# Database KMS Key

resource "aws_kms_key" "db_enc_key" {
  description             = "DB encryption key"
  deletion_window_in_days = 30

  tags = {
    Origin = "Terraform"
  }
}

data "terraform_remote_state" "base" {
  backend   = "s3"
  workspace = terraform.workspace

  config = {
    bucket         = "${var.bucket_prefix}-terraform-state"
    key            = var.key
    region         = var.region
    dynamodb_table = var.dynamodb_table
  }
}
