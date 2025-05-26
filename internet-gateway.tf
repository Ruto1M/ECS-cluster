resource "aws_internet_gateway" "public_internet_gateway" {
  vpc_id = aws_vpc.terraform-vpc.id
  tags = {
    Name = "IGW_terraform_Project"
  }
}