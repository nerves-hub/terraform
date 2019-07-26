# Create a new staging workspace
terraform workspace new staging base
terraform workspace switch staging base

# Construct staging app
terraform init app
terraform apply app
