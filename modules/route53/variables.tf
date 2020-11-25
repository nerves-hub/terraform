variable "api_lb" {}
variable "device_lb" {}
variable "www_lb" {}
variable "api_dns_record_name" {}
variable "device_dns_record_name" {}
variable "www_dns_record_name" {}
variable "dns_zone" {}

variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type        = map(string)
  default = {
    terraform = true
  }
}
