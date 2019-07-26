provider "aws" {
  profile = var.profile
  region  = var.region
  version = "~> 2.20"
}

provider "template" {
  version = "~> 2.1"
}

module "backend" {
  source = "../modules/backend"

  bootstrap      = terraform.workspace == "base" ? 1 : 0
  operators      = var.operators
  bucket         = "${var.bucket_prefix}-terraform-state"
  dynamodb_table = var.dynamodb_table
  key            = var.key
}

data "aws_caller_identity" "current" {}
