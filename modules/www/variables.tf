variable "account_id" {}
variable "region" {}
variable "kms_key" {}
variable "vpc" {}
variable "lb_security_group_id" {}
variable "task_security_group_id" {}
variable "host_name" {}
variable "db" {}
variable "log_group" {}
variable "docker_image" {}
variable "live_view_signing_salt" {}
variable "erl_cookie" {}
variable "app_bucket" {}
variable "log_bucket" {}
variable "ca_bucket" {}
variable "cluster" {}
variable "secret_key_base" {}
variable "smtp_username" {}
variable "smtp_password" {}
variable "service_count" {}
variable "task_execution_role" {}
variable "certificate_arn" {}

variable "from_email" {
  default = "no-reply@nerves-hub.org"
}

variable "access_logs" {
  default = false
}

variable "access_logs_bucket" {
  default = ""
}

variable "access_logs_prefix" {
  default = "nerves-hub-www-alb"
}

variable "internal_lb" {
  description = "Whether or not the load balancer is internal"
  default     = false
}

variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type        = map(string)
  default = {
    terraform = true
  }
}

variable "app_name" {
  type = string
}

variable "datadog_image" {
  description = "Datadog container image"
  type        = string
}

variable "datadog_key_arn" {
  description = "Datadog Key"
  type        = string
}

variable "docker_image_tag" {
  description = "Docker Image Tag of WWW Application"
  type        = string
}