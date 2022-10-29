resource "aws_db_subnet_group" "portfolio_rds_subnet_group" {
  name        = "portfolio_rds_subnet_group"
  description = "portfolio_rds_subnet_group"
  subnet_ids = [
    aws_subnet.portfolio_private_subnet1.id,
    aws_subnet.portfolio_private_subnet2.id
  ]
}

resource "aws_db_instance" "portfolio-db" {
  identifier        = "portfolio-db"
  engine            = "mysql"
  engine_version    = "8.0.28"
  instance_class    = "db.t2.micro"
  allocated_storage = 200
  storage_type      = "gp2"
  # db_name                             = var.database_name
  username                            = var.database_username
  password                            = var.database_password
  port                                = 3306
  multi_az                            = false
  skip_final_snapshot                 = true
  copy_tags_to_snapshot               = true
  customer_owned_ip_enabled           = false
  deletion_protection                 = false
  enabled_cloudwatch_logs_exports     = []
  iam_database_authentication_enabled = false
  iops                                = 0
  max_allocated_storage               = 1000
  storage_encrypted                   = false
  tags                                = {}

  vpc_security_group_ids = [aws_security_group.portfolio_rds_security.id]
  db_subnet_group_name   = aws_db_subnet_group.portfolio_rds_subnet_group.name
}