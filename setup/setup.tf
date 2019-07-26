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
  bucket         = var.bucket
  dynamodb_table = var.dynamodb_table
  key            = var.key
}

data "terraform_remote_state" "base" {
  backend   = "s3"
  workspace = terraform.workspace

  config = {
    bucket         = var.bucket
    key            = var.key
    region         = var.region
    dynamodb_table = var.dynamodb_table
  }
}
