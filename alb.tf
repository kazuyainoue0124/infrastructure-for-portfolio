resource "aws_alb" "portfolio-ecs-alb" {
  name            = "portfolio-ecs-alb"
  security_groups = [aws_security_group.portfolio_ecs_alb_security.id]

  subnets = [
    "${aws_subnet.ecs_portfolio_public_subnet1.id}",
    "${aws_subnet.ecs_portfolio_public_subnet2.id}"
  ]

  internal                   = false
  enable_deletion_protection = false
}

resource "aws_alb_target_group" "portfolio-ecs-target" {
  name                 = "portfolio-ecs-target"
  port                 = 80
  depends_on           = [aws_alb.portfolio-ecs-alb]
  target_type          = "ip"
  protocol             = "HTTP"
  vpc_id               = aws_vpc.ecs_portfolio_vpc.id
  deregistration_delay = 60

  health_check {
    interval            = 121
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 120
    unhealthy_threshold = 2
    matcher             = "200"
    healthy_threshold   = 5
  }
}

resource "aws_alb_listener" "portfolio-ecs-alb-listener" {
  load_balancer_arn = "arn:aws:elasticloadbalancing:ap-northeast-1:620871201833:loadbalancer/app/portfolio-ecs-alb/766f35d9857a5a66"
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:ap-northeast-1:620871201833:certificate/88774e63-2a21-4115-b5fe-a0ca38bd0161"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.portfolio-ecs-target.arn
  }
}

resource "aws_alb_listener_rule" "portfolio-ecs-alb-listener-rule" {
  depends_on   = [aws_alb_target_group.portfolio-ecs-target]
  listener_arn = aws_alb_listener.portfolio-ecs-alb-listener.arn
  priority     = 99999

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.portfolio-ecs-target.arn
  }

  condition {
    path_pattern {
      values = ["/"]
    }
  }
}