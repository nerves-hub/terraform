# NervesHub Terraform

## Setup

The NervesHub terraform scripts are organized to use terraform workspaces.
To get started, you should copy the `terraform.tfvars.example` file to
`terraform.tfvars` and change the values for your organization. You will
want to change the `bucket` value since this refers to an aws s3 bucket
that will be used to store the remote state for terraform. Once you have
your variables, you can initialize the setup by running `setup.sh`
