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
  default = "db.t2.micro"
}
variable "db_engine_version" {
  description = "The Engine version of the Postgres database server"
  default = "11.4"
}
