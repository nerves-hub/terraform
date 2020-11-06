locals {
  subnet = {
    # Add your terraform workspaces and associated subnet here
    "production" = 20
    "staging"    = 10
  }
}

module "vpc" {
  source               = "../modules/vpc/"
  name                 = "nerves-hub-${terraform.workspace}"
  cidr                 = "10.${local.subnet[terraform.workspace]}.0.0/16"
  azs                  = ["us-east-1a", "us-east-1b"]
  public_subnets       = ["10.${local.subnet[terraform.workspace]}.1.0/24", "10.${local.subnet[terraform.workspace]}.2.0/24"]
  private_subnets      = ["10.${local.subnet[terraform.workspace]}.11.0/24", "10.${local.subnet[terraform.workspace]}.12.0/24"]
  database_subnets     = ["10.${local.subnet[terraform.workspace]}.21.0/24", "10.${local.subnet[terraform.workspace]}.22.0/24"]
  enable_dhcp_options  = true
  enable_dns_hostnames = true

  tags = {
    Owner       = "nerves-hub-${terraform.workspace}"
    Environment = terraform.workspace
  }
}
