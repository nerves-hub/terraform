# resource "aws_security_group" "lb_security_group" {
#   name        = "nerveshub-${terraform.workspace}-lb-sg"
#   description = "nerveshub-${terraform.workspace}-lb-sg"
#   vpc_id      = var.vpc_id

#   tags = {
#     environment = terraform.workspace
#     servicename = "nerveshub-${terraform.workspace}"
#   }
# }
