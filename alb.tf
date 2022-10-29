resource "aws_alb" "portfolio-alb" {
  name            = "portfolio-alb"
  security_groups = [aws_security_group.portfolio-alb-security.id]

  subnets = [
    "${aws_subnet.portfolio_public_subnet1.id}",
    "${aws_subnet.portfolio_public_subnet2.id}"
  ]

  internal                   = false
  enable_deletion_protection = false
}

resource "aws_alb_target_group" "portfolio-target" {
  name                 = "portfolio-target"
  port                 = 80
  depends_on           = [aws_alb.portfolio-alb]
  target_type          = "ip"
  protocol             = "HTTP"
  vpc_id               = aws_vpc.portfolio_vpc.id
  deregistration_delay = "300"

  health_check {
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 120
    unhealthy_threshold = 2
    matcher             = "200"
    healthy_threshold   = 5
  }
}

resource "aws_alb_listener" "portfolio-alb-listener" {
  load_balancer_arn = "arn:aws:elasticloadbalancing:ap-northeast-1:${var.aws_account_id}:loadbalancer/app/portfolio-alb/b636f4ba3a3530d5"
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:ap-northeast-1:${var.aws_account_id}:certificate/88774e63-2a21-4115-b5fe-a0ca38bd0161"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.portfolio-target.arn
  }
}

resource "aws_alb_listener_rule" "portfolio-alb-listener-rule" {
  depends_on   = [aws_alb_target_group.portfolio-target]
  listener_arn = aws_alb_listener.portfolio-alb-listener.arn
  priority     = 99999

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.portfolio-target.arn
  }

  condition {
    path_pattern {
      values = ["/"]
    }
  }
}