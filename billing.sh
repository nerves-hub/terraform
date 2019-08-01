# Create a new staging workspace
terraform workspace switch staging base

# Construct billing app
terraform init billing
terraform apply billing
