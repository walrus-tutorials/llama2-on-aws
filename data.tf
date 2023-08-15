data "aws_vpc" "selected" {
  count       = var.vpc_name != "" ? 1 : 0
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_security_group" "selected" {
  count       = var.security_group_name != "" ? 1 : 0
  name = var.security_group_name
  vpc_id = data.aws_vpc.selected.0.id
}

data "aws_subnets" "selected" {
  count       = var.vpc_name != "" ? 1 : 0
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.0.id]
  }
}
