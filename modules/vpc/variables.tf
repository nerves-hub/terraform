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
  default     = "nerves-hub"
}

variable "subnet" {
  description = ""
  type = map(string)
}

variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
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

