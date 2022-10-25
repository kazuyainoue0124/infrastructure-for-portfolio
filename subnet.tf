resource "aws_subnet" "ecs_portfolio_public_subnet1" {
  vpc_id                  = aws_vpc.ecs_portfolio_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "ecs_portfolio_public_subnet1"
  }
}

resource "aws_subnet" "ecs_portfolio_public_subnet2" {
  vpc_id                  = aws_vpc.ecs_portfolio_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = false

  tags = {
    Name = "ecs_portfolio_public_subnet2"
  }
}

resource "aws_subnet" "ecs_portfolio_private_subnet1" {
  vpc_id                  = aws_vpc.ecs_portfolio_vpc.id
  cidr_block              = "10.0.10.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "ecs_portfolio_private_subnet1"
  }
}

resource "aws_subnet" "ecs_portfolio_private_subnet2" {
  vpc_id                  = aws_vpc.ecs_portfolio_vpc.id
  cidr_block              = "10.0.11.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = false

  tags = {
    Name = "ecs_portfolio_private_subnet2"
  }
}