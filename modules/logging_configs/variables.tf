variable "app_name" {
  type = string
}

variable "task_name" {
  type = string
}

variable "datadog_image" {
  type = string
}

variable "region" {
  type        = string
  description = "The AWS Region"
}

variable "datadog_key_arn" {
  description = "Datadog Key ARN"
  type        = string
}

variable "docker_image_tag" {
  description = "Docker Image Tag of Application"
  type        = string
}