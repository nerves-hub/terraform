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
variable "bucket_prefix" {
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
  default = "db.t2.small"
}
variable "db_engine_version" {
  description = "The Engine version of the Postgres database server"
  default = "11.4"
}

variable "erl_cookie" {
  description = "The Erlang distribution cookie value"
}

variable "ca_service_desired_count" {
  description = "The number of NervesHubCA containers to run"
  default = "1"
}

variable "ca_image" {
  description = "The docker image of the nerves_hub_ca app"
  default = "nerveshub/nerves_hub_ca:latest"
}

variable "log_retention" {
  description = "Cloud watch log retention days"
  default = 90
}
