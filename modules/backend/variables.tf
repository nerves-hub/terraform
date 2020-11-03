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

variable "s3_access_log_bucket" {
  type        = string
  description = "What bucket to write access logs to"
}

variable "s3_prefix" {
  type        = string
  description = "S3 bucket name prefix"
}