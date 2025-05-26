resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.terraform-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public_internet_gateway.id
  }
  tags = {
    Name = "RT_Public_For_Terraform"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.terraform-vpc.id
  depends_on = [aws_nat_gateway.nat_gateway]
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
    Name = "RT_Private_For_Terraform"
  }
}
# resource "aws_route" "private_nat_gateway" {
#     count = length(var.cidr_private_subnet)
#   route_table_id = aws_route_table.private_route_table.id
#   destination_cidr_block = element(var.cidr_private_subnet, count.index)
#   depends_on = [aws_nat_gateway.nat_gateway]
#   nat_gateway_id = aws_nat_gateway.nat_gateway.id
# }