variable "account_id" {}
variable "region" {}
variable "kms_key" {}
variable "vpc" {}
variable "task_security_group_id" {}
variable "host_name" {}
variable "db" {}
variable "docker_image" {}
variable "erl_cookie" {}
variable "app_bucket" {}
variable "log_bucket" {}
variable "ca_bucket" {}
variable "ca_host" {}
variable "cluster" {}
variable "secret_key_base" {}
variable "smtp_username" {}
variable "smtp_password" {}
variable "service_count" {
  default = 0
}
variable "api_public_service_count" {
  default = 0
}
variable "cpu" {
  type        = string
  description = "CPU resource allocation"
  default     = "256"
}
variable "memory" {
  type        = string
  description = "Memory resource allocation"
  default     = "512"
}
variable "task_execution_role" {}
variable "allow_list_ipv4" {
  default = []
}
variable "allow_list_ipv6" {
  default = []
}
variable "alb" {
  default = false
}
variable "nlb" {
  default = true
}
variable "certificate_arn" {
  default = ""
}
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
  default = "nerves-hub-api-nlb"
}

variable "internal_lb" {
  description = "Whether or not the load balancer is internal"
  default     = false
}
variable "internal_alb" {
  description = "Whether or not the application load balancer is internal"
  default     = false
}
variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type        = map(string)
  default = {
    terraform = true
  }
}

variable "datadog_image" {
  description = "Datadog container image"
  type        = string
}

variable "docker_image_tag" {
  description = "Docker Image tag for API Application"
  type        = string
}

variable "datadog_key_arn" {
  description = "Datadog Key"
  type        = string
}