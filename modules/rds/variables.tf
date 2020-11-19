variable "name" {

}

variable "identifier" {

}

variable "username" {

}
variable "password" {

}

variable "vpc_id" {

}

variable "kms_key" {

}

variable "allocated_storage" {
  type = number
}

variable "instance_class" {
  description = "The Instance class of the Postgres database server"
}
variable "engine_version" {
  description = "The Engine version of the Postgres database server"
}

variable "subnet_group" {
  description = "DB subnet group"
}

variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type        = map(string)
  default = {
    terraform = true
  }
}

variable "security_groups" {
  default = [""]
}

variable "cidr_blocks" {
  default = [""]
}