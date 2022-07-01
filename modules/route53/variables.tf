variable "api_lb" {}
variable "device_lb" {}
variable "www_lb" {}
variable "api_dns_record_name" {}
variable "device_dns_record_name" {}
variable "www_dns_record_name" {}
variable "dns_zone" {}
variable "is_api_alb" {
  description = "Whether or not the api has an application load balancer"
  default     = false
}
