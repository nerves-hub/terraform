variable "account_id" {}
variable "region" {}
variable "host_name" {}
variable "vpc" {}
variable "cluster" {}
variable "db" {}
variable "kms_key" {}
variable "bucket_prefix" {}
variable "docker_image" {}
variable "service_count" {}
variable "task_execution_role" {}
variable "erl_cookie" {}
variable "web_security_group" {}
variable "local_dns_namespace" {}
variable "s3_versioning" {
  default = false
}

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
  default     = ""
}

variable "s3_prefix" {
  type        = string
  description = "S3 bucket name prefix"
  default     = ""
}

variable "datadog_image" {
  description = "Datadog container image"
  type        = string
}

variable "docker_image_tag" {
  description = "Docker Image tag for CA Application"
  type        = string
}

variable "datadog_key_arn" {
  description = "Datadog Key"
  type        = string
}