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
  subnet               = local.subnet[terraform.workspace]
  enable_dhcp_options  = true
  enable_dns_hostnames = true

  tags = {
    Owner       = "nerves-hub-${terraform.workspace}"
    Environment = terraform.workspace
  }
}
