data "aws_subnet_ids" "db_subnet" {
  vpc_id = module.vpc.vpc_id
  filter {
    name   = "tag:Name"
    values = ["nerves-hub-${terraform.workspace}-db-*"]
  }
}

resource "aws_db_subnet_group" "db" {
  name       = "db"
  subnet_ids = data.aws_subnet_ids.db_subnet.ids

  tags = {
    Name = "DB subnet group"
  }
  depends_on = [
    data.aws_subnet_ids.db_subnet
  ]
  lifecycle {
    ignore_changes = [subnet_ids]
  }
}
