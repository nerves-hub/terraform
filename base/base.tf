# Database KMS Key

resource "aws_kms_key" "db_enc_key" {
  description             = "DB encryption key"
  deletion_window_in_days = 30

  tags = {
    Origin = "Terraform"
  }
}
