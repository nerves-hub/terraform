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

variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type        = map(string)
  default = {
    terraform = true
  }
}

variable "app_name" {
  description = "Name of the app"
  type        = string
}


variable "kms_key_arn" {
  description = "The arn of the kms key"
  type        = string
}