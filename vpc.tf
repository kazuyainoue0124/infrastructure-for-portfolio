resource "aws_vpc" "ecs_portfolio_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = false
  enable_dns_support   = true
  tags = {
    Name = "ecs_portfolio_vpc"
  }
}