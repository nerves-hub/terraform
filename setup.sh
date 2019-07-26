#!/usr/bin/env bash

#
# this script is used for bootstraping the project base infrastructure
#

# Base Workspace
terraform workspace new base setup
terraform workspace select base setup

# create base infra
terraform init setup
terraform apply setup

# migrate local state to the remote with the s3 bucket and dynamodb table
terraform init -backend-config=terraform.tfvars base
rm -rf terraform.tfstate.d
