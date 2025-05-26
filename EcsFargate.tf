resource "aws_ecs_cluster" "main" {
  name = "my-fargate-cluster"
}

resource "aws_ecs_task_definition" "terra_app_container" {
  family                   = "app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture = "ARM64"
  }
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([{
    name      = "java-app"
    image     = "public.ecr.aws/m8r1w2k3/new-java-app:10"
    cpu    = 256
    memory = 512
    essential = true
    portMappings = [{
      containerPort = 8080
      hostPort      = 8080
    }]
  },{
    name      = "node-app"
    image     = "public.ecr.aws/m8r1w2k3/new-node-app:10"
    cpu       = 256
    memory    = 512
    essential = true
    portMappings = [{
      containerPort = 3000
      hostPort      = 3000
      protocol    = "tcp"
    }]
  }
  ])
}

resource "aws_ecs_service" "java" {
  name            = "my-fargate-java-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.terra_app_container.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.aws_private_subnets[0].id]
    security_groups  = [aws_security_group.SG_terraform-vpc.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.java_app_target_group.arn
    container_name   = "java-app"
    container_port   = 8080
  }
depends_on = [ aws_lb_listener_rule.java_app_listener_rule, aws_lb_listener_rule.node_app_listener_rule ]
}

resource "aws_ecs_service" "node" {
  name            = "my-fargate-node-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.terra_app_container.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.aws_private_subnets[1].id]
    security_groups  = [aws_security_group.SG_terraform-vpc.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.node_app_target_group.arn
    container_name   = "node-app"
    container_port   = 3000
  }
depends_on = [ aws_lb_listener_rule.node_app_listener_rule, aws_lb_listener_rule.java_app_listener_rule ]
}