resource "aws_security_group" "SG_terraform-vpc" {
  egress = [
    {
      cidr_blocks      = [ "0.0.0.0/0", ]
      description      = "Allows all outbound Traffic"
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
  ingress                = [
    {
      cidr_blocks      = [ "0.0.0.0/0", ]
      description      = "SSH"
      from_port        = 22
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 22
    },
    
    {
      description = "HTTP"
      cidr_blocks      = [ "0.0.0.0/0", ]
      description      = ""
      from_port        = 80
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 80
    },
    {
      description = "HTTP 8080"
      cidr_blocks      = [ "0.0.0.0/0", ]
      description      = "Java-App"
      from_port        = 8080
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 8080
    },
    {
      description = "HTTP 3000"
      cidr_blocks      = [ "0.0.0.0/0", ]
      description      = "node-app"
      from_port        = 3000
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 3000
    }
  ]


  vpc_id = aws_vpc.terraform-vpc.id
  depends_on = [aws_vpc.terraform-vpc]
  tags = {
    Name = "SG_terraform-vpc"
  }
}