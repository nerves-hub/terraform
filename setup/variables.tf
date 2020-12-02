# AWS
variable "profile" {
  description = "AWS profile"
}
variable "region" {
  description = "AWS Region"
}
variable "operators" {
  type = "list"
}

# Terraform state
variable "bucket" {
  description = "AWS S3 Bucket name for Terraform state"
}
variable "dynamodb_table" {
  description = "AWS DynamoDB table for state locking"
}
variable "key" {
  description = "Key for Terraform state at S3 bucket"
}

# Database
variable "db_username" {
  description = "Database username"
}

variable "db_password" {
  description = "Database password"
}

variable "db_allocated_storage" {
  default = 20
}

variable "db_instance_class" {
  description = "The Instance class of the Postgres database server"
  default     = "db.t2.small"
}
variable "db_engine_version" {
  description = "The Engine version of the Postgres database server"
  default     = "11.4"
}

variable "bucket_prefix" {
  description = "AWS S3 Bucket prefix for application state buckets"
}

variable "erl_cookie" {
  description = "The Erlang distribution cookie value"
}

variable "ca_service_desired_count" {
  description = "The number of NervesHubCA containers to run"
  default     = "1"
}

variable "ca_image" {
  description = "The docker image of the nerves_hub_ca app"
  default     = "nerveshub/nerves_hub_ca:latest"
}

variable "ca_db_name" {
  description = "The name of the CA database"
  default     = "nerves_hub_ca"
}

variable "log_retention" {
  description = "Cloud watch log retention days"
  default     = 90
}

variable "domain" {
  description = "The domain name"
}

variable "web_db_name" {
  description = "The name of the web database"
  default     = "nerves_hub_web"
}

variable "web_secret_key_base" {
  description = "The secret key base for sessions"
}

variable "web_smtp_username" {
  description = "The SES SMTP username"
}

variable "web_smtp_password" {
  description = "The SES SMTP password"
}

variable "www_image" {
  description = "The docker image of the nerves_hub_www app"
  default     = "nerveshub/nerves_hub_www:latest"
}

variable "www_service_desired_count" {
  description = "The number of NervesHubWWW containers to run"
  default     = "1"
}

variable "www_live_view_signing_salt" {
  description = "The signing salt to use for Phoenix LiveView"
}

variable "device_image" {
  description = "The docker image of the nerves_hub_device app"
  default     = "nerveshub/nerves_hub_device:latest"
}

variable "device_service_desired_count" {
  description = "The number of NervesHubDevice containers to run"
  default     = "1"
}

variable "api_image" {
  description = "The docker image of the nerves_hub_api app"
  default     = "nerveshub/nerves_hub_api:latest"
}

variable "api_service_desired_count" {
  description = "The number of NervesHubAPI containers to run"
  default     = "1"
}

variable "allow_list_ipv4" {
  description = "The allowed list of IPs for accessing the cluster"
  default     = ["0.0.0.0/0"]
}

variable "billing_enabled" {
  description = "Enable billing?"
  default     = false
}

variable "billing_image" {
  description = "The docker image of the nerves_hub_billing app"
  default     = "nerveshub/nerves_hub_billing:latest"
}

variable "billing_service_desired_count" {
  description = "The number of NervesHubBilling containers to run"
  default     = "1"
}
