variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type        = map(string)
  default = {
    terraform = true
  }
}

variable "name" {
  description = "The application name"
  type        = string
}

variable "cidr" {
  description = "The CIDR block for the vpc"
  type        = string
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
}

variable "database_subnets" {
  description = "A list of database subnets"
  type        = list(string)
}

variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
}

variable "create_database_subnet_group" {
  type    = bool
  default = true
}

variable "enable_nat_gateway" {
  type    = bool
  default = true
}

variable "single_nat_gateway" {
  type    = bool
  default = false
}

variable "enable_vpn_gateway" {
  type    = bool
  default = false
}

variable "enable_s3_endpoint" {
  type    = bool
  default = false
}

variable "enable_dhcp_options" {
  type    = bool
  default = false
}

variable "enable_dns_hostnames" {
  type    = bool
  default = false
}

variable "enable_dns_support" {
  type    = bool
  default = true
}

variable "one_nat_gateway_per_az" {
  type    = bool
  default = false
}

variable "manage_default_vpc" {
  type    = bool
  default = false
}

variable "default_vpc_name" {
  type    = string
  default = ""
}

variable "default_vpc_enable_dns_hostnames" {
  type    = bool
  default = false
}

