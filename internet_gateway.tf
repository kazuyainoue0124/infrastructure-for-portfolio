resource "aws_internet_gateway" "ecs_portfolio_igw" {
  vpc_id = aws_vpc.ecs_portfolio_vpc.id

  tags = {
    Name = "ecs_portfolio_igw"
  }
}