# 全体
resource "aws_security_group" "portfolio_ecs_security" {
  name        = "portfolio_ecs_security"
  description = "portfolio_ecs_security"
  vpc_id      = aws_vpc.portfolio_vpc.id

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
resource "aws_security_group" "portfolio-alb-security" {
  name        = "portfolio-alb-security"
  description = "portfolio-alb-security"
  vpc_id      = aws_vpc.portfolio_vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.portfolio_ecs_security.id]
  }
}

# データベース
resource "aws_security_group" "portfolio_rds_security" {
  name        = "portfolio_rds_security"
  description = "portfolio_rds_security"
  vpc_id      = aws_vpc.portfolio_vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.portfolio_ecs_security.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}