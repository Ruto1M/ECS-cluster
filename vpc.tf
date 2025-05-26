resource "aws_vpc" "terraform-vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "VPC-terraform-new_vpc"
  }
}


