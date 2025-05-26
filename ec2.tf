# data "aws_subnet" "public_subnet" {
#   filter {
#     name   = "tag:Name"
#     values = ["Public_Subnet1"]
#   }
#   depends_on = [
#     aws_route_table_association.public_subnet_asso
#   ]
# }

# resource "aws_instance" "MyEC2Instance" {
#     ami           = "ami-0e449927258d45bc4" # Amazon Linux 2 AMI
#     instance_type = "t2.micro"
#     key_name = aws_key_pair.app_key.key_name
#     # key_name = "test"
#     user_data = <<EOF
# #!/bin/bash
# yum -y update
# yum -y install nginx
# systemctl start nginx
# systemctl enable nginx
# EOF

#     tags = {
#         Name = "MyInstance"
#     }
#     subnet_id = data.aws_subnet.public_subnet.id
#     associate_public_ip_address = true
#     vpc_security_group_ids = [aws_security_group.SG_terraform-vpc.id]
# }

# resource "tls_private_key" "app_key" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
  
# }

# resource "aws_key_pair" "app_key" {
#   key_name   = "terra-app-key"    
#   public_key = tls_private_key.app_key.public_key_openssh
#   tags = {
#     Name = "app-key"
#   }
  
# }