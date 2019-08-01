variable "aws_region" {
  description = "The AWS region to create things in."
}

variable "aws_vpc_id" {
  description = "VPC id"
}

variable "environment" {
  description = "Deploy environment"
}

variable "aws_private_subnet_ids" {
  description = "Subnet ids"
}

variable "aws_public_subnet_ids" {
  description = "Subnet ids"
}

variable "log_retention" {
  description = "Cloud watch log retention days"
}

variable "whitelist" {
  description = "IPs that are allowed to access the cluster from load balancers"
}
