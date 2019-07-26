locals {
  subnet = "${terraform.workspace == "staging" ? 10 : 20}"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "nerves-hub-${terraform.workspace}"

  cidr = "10.${local.subnet}.0.0/16"

  azs                 = ["us-east-1a", "us-east-1b"]
  private_subnets     = ["10.${local.subnet}.1.0/24", "10.${local.subnet}.2.0/24"]
  public_subnets      = ["10.${local.subnet}.11.0/24", "10.${local.subnet}.12.0/24"]
  database_subnets    = ["10.${local.subnet}.21.0/24", "10.${local.subnet}.22.0/24"]

  create_database_subnet_group = true
  enable_nat_gateway           = true
  enable_vpn_gateway           = false
  enable_s3_endpoint           = false
  enable_dhcp_options          = true
  enable_dns_hostnames         = true
  enable_dns_support           = true
  tags = {
    Owner       = "nerves-hub"
    Environment = "${terraform.workspace}"
  }
}
