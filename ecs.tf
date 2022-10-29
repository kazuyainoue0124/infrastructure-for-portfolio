resource "aws_ecs_cluster" "portfolio-cluster" {
  name = "portfolio-cluster"
}

resource "aws_ecs_task_definition" "portfolio_task" {
  family                   = "portfolio_task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = "arn:aws:iam::${var.aws_account_id}:role/ecsTaskExecutionRole"
  cpu                      = 1024
  memory                   = 2048
  container_definitions    = file("./task-definitions/app-nginx.json")
}

resource "aws_ecs_service" "portfolio-alb-service" {
  cluster                            = "arn:aws:ecs:ap-northeast-1:${var.aws_account_id}:cluster/portfolio-cluster"
  launch_type                        = "FARGATE"
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  name                               = "portfolio-alb-service"
  task_definition                    = aws_ecs_task_definition.portfolio_task.arn
  desired_count                      = 2
  enable_ecs_managed_tags            = true
  health_check_grace_period_seconds  = 3600

  load_balancer {
    target_group_arn = aws_alb_target_group.portfolio-target.arn
    container_name   = "nginx"
    container_port   = 80
  }

  network_configuration {
    assign_public_ip = true
    subnets = [
      aws_subnet.portfolio_public_subnet1.id
    ]
    security_groups = [
      aws_security_group.portfolio_ecs_security.id
    ]
  }
}