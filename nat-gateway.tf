resource "aws_eip" "nat_eip" {
  domain= "vpc"
}

resource "aws_nat_gateway" "nat_gateway" {
    # count = length(var.cidr_public_subnet)
  depends_on = [aws_eip.nat_eip]
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.aws_public_subnets[0].id
  tags = {
    "Name" = "Private_NAT_GW_Terraform"
  }
}
