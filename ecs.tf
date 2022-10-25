resource "aws_ecs_cluster" "portfolio-ecs-cluster" {
  name = "portfolio-ecs-cluster"
}

resource "aws_ecs_task_definition" "portfolio" {
  family                   = "portfolio"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = "arn:aws:iam::${var.aws_account_id}:role/ecsTaskExecutionRole"
  cpu                      = 1024
  memory                   = 2048
  container_definitions    = file("./task-definitions/app-nginx.json")
}

resource "aws_ecs_service" "portfolio-alb-service" {
  cluster                            = aws_ecs_cluster.portfolio-ecs-cluster.id
  launch_type                        = "FARGATE"
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  name                               = "portfolio-alb-service"
  task_definition                    = aws_ecs_task_definition.portfolio.arn
  desired_count                      = 2
  enable_ecs_managed_tags            = true
  health_check_grace_period_seconds  = 3600

  load_balancer {
    target_group_arn = aws_alb_target_group.portfolio-ecs-target.arn
    container_name   = "nginx"
    container_port   = 80
  }

  network_configuration {
    assign_public_ip = true
    subnets = [
      aws_subnet.ecs_portfolio_public_subnet1.id
    ]
    security_groups = [
      aws_security_group.ecs_portfolio_security.id
    ]
  }
}