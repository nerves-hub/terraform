module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.63"

  name = var.name
  cidr = "10.${var.subnet}.0.0/16"

  azs                 = var.azs
  private_subnets     = ["10.${var.subnet}.1.0/24", "10.${var.subnet}.2.0/24", "10.${var.subnet}.3.0/24"]
  public_subnets      = ["10.${var.subnet}.101.0/24", "10.${var.subnet}.102.0/24", "10.${var.subnet}.103.0/24"]
  database_subnets    = ["10.${var.subnet}.201.0/24", "10.${var.subnet}.202.0/24", "10.${var.subnet}.203.0/24"]

  create_database_subnet_group     = var.create_database_subnet_group
  enable_nat_gateway               = var.enable_nat_gateway
  single_nat_gateway               = var.single_nat_gateway
  enable_vpn_gateway               = var.enable_vpn_gateway
  enable_s3_endpoint               = var.enable_s3_endpoint
  enable_dhcp_options              = var.enable_dhcp_options
  enable_dns_hostnames             = var.enable_dns_hostnames
  enable_dns_support               = var.enable_dns_support
  one_nat_gateway_per_az           = var.one_nat_gateway_per_az
  manage_default_vpc               = var.manage_default_vpc
  default_vpc_name                 = "${var.name}-default-vpc"
  default_vpc_enable_dns_hostnames = var.default_vpc_enable_dns_hostnames

  tags = var.tags
}
