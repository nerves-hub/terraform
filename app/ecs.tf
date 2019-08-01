module "ecs_cluster" {
  source = "../modules/ecs/cluster"

  aws_region             = var.region
  aws_vpc_id             = module.vpc.vpc_id
  environment            = terraform.workspace
  aws_private_subnet_ids = module.vpc.private_subnets
  aws_public_subnet_ids  = module.vpc.public_subnets
  log_retention          = var.log_retention
  whitelist              = var.whitelist
}
