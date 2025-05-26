resource "aws_lb" "application_load_balancer" {
  name               = "terraform-vpc-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.SG_terraform-vpc.id]
  subnets            = [aws_subnet.aws_public_subnets[0].id, aws_subnet.aws_public_subnets[1].id]
  enable_deletion_protection = false

  tags   = {
    Name = "terraform-vpc-alb"
  }
}
resource "aws_lb_target_group" "alb_target_group" {
  name        = "terra-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.terraform-vpc.id

  health_check {
    enabled             = true
    interval            = 300
    path                = "/"
    timeout             = 60
    matcher             = 200
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }

  lifecycle {
    create_before_destroy = true
  }
}
#create image target group for java app
resource "aws_lb_target_group" "java_app_target_group" {
  name        = "java-app-tg"
  target_type = "ip"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = aws_vpc.terraform-vpc.id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    timeout             = 5
    matcher             = 200
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }

  lifecycle {
    create_before_destroy = true
  }
}
#create image target group for node app
resource "aws_lb_target_group" "node_app_target_group" {
  name        = "node-app-tg"
  target_type = "ip"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.terraform-vpc.id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    timeout             = 5
    matcher             = 200
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }

  lifecycle {
    create_before_destroy = true
  }
}

# create a listener on port 80 with redirect action
resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  # default_action {
  #   type ="fixed-response"
  #   fixed_response {
  #     content_type = "text/plain"
  #     status_code = "404"
  #     message_body = "Not Found, try /nodeapp or /javaapp"
  #   }
  # }
  # default_action{
  #   type             = "forward"
  #   target_group_arn = aws_lb_target_group.java_app_target_group.arn
  # }
    default_action{
    type             = "forward"
    target_group_arn = aws_lb_target_group.node_app_target_group.arn
  }
}
# create a listener rule for java app
resource "aws_lb_listener_rule" "java_app_listener_rule" {
  listener_arn = aws_lb_listener.alb_http_listener.arn
  priority     = 100
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.java_app_target_group.arn
  }
  condition {
    path_pattern {
       values = ["/"]
    }
  }
}

# create a listener rule for node app
resource "aws_lb_listener_rule" "node_app_listener_rule" {
  listener_arn = aws_lb_listener.alb_http_listener.arn
  priority     = 200

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.node_app_target_group.arn
  }

  condition {
    path_pattern {
      values = ["//"]
    }
  }
}

# # attach the target group to the ec2 instance
# resource "aws_lb_target_group_attachment" "alb_target_group_attachment" {
#   target_group_arn = aws_lb_target_group.alb_target_group.arn
#   target_id        = aws_instance.MyEC2Instance.id
#   port             = 80
# }
# resource "aws_lb_target_group_attachment" "alb_target_group_attachment2nd" {
#   target_group_arn = aws_lb_target_group.alb_target_group.arn
#   target_id        = aws_instance.MyEC2ndInstance.id
#   port             = 80
# }