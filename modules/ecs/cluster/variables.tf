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

variable "allow_list_ipv4" {
  description = "IPv4s that are allowed to access the cluster from load balancers"
}

variable "allow_list_ipv6" {
  description = "IPv6s that are allowed to access the cluster from load balancers"
  default     = []
}

variable "container_insights" {
  description = "ECS cluster container insights enabled or disabled"
  default     = true
}

variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type        = map(string)
  default = {
    terraform = true
  }
}
