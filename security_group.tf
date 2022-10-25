# 全体
resource "aws_security_group" "ecs_portfolio_security" {
  name        = "ecs_portfolio_security"
  description = "ecs_portfolio_security"
  vpc_id      = aws_vpc.ecs_portfolio_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ロードバランサー
resource "aws_security_group" "portfolio_ecs_alb_security" {
  name        = "portfolio_ecs_alb_security"
  description = "portfolio_ecs_alb_security"
  vpc_id      = aws_vpc.ecs_portfolio_vpc.id

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_portfolio_security.id]
  }
}

# データベース
resource "aws_security_group" "ecs_rds_portfolio_security" {
  name        = "ecs_rds_portfolio_security"
  description = "ecs_rds_portfolio_security"
  vpc_id      = aws_vpc.ecs_portfolio_vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_portfolio_security.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}