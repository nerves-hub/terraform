# NervesHub Terraform

## Setup

The NervesHub terraform scripts are organized to use terraform workspaces.
To get started, you should copy the `terraform.tfvars.example` file to
`terraform.tfvars` and change the values for your organization. You will
want to change the `bucket` value since this refers to an aws s3 bucket
that will be used to store the remote state for terraform. Once you have
your variables, you can initialize the setup by running `setup.sh`

You will need to have your aws credentials in the `~/.aws/credentials` file
using the profile name you defined in the `terraform.tfvars` file.

Answer `yes` to create the initial infrastructure.

```text
Do you want to perform these actions in workspace "base"?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes
```

Answer yes to migrate the state to the remote

```text
Do you want to migrate all workspaces to "s3"?
  Both the existing "local" backend and the newly configured "s3" backend
  support workspaces. When migrating between backends, Terraform will copy
  all workspaces (with the same names). THIS WILL OVERWRITE any conflicting
  states in the destination.

  Terraform initialization doesn't currently migrate only select workspaces.
  If you want to migrate a select number of workspaces, you must manually
  pull and push those states.

  If you answer "yes", Terraform will migrate all states. If you answer
  "no", Terraform will abort.

  Enter a value: yes
```
