variable "bootstrap" {
  description = "Whether bootstrap basic infra or not"

  default = 0
}

variable "operators" {
  type = "list"
}

variable "bucket" {}
variable "key" {}
variable "dynamodb_table" {}

variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type        = map(string)
  default = {
    terraform = true
  }
}