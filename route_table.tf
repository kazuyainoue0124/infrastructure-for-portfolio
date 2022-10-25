resource "aws_route_table" "ecs_portfolio_route" {
  vpc_id = aws_vpc.ecs_portfolio_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecs_portfolio_igw.id
  }

  tags = {
    Name = "ecs_portfolio_route"
  }
}

resource "aws_route_table_association" "ecs_portfolio_public_subnet1" {
  subnet_id      = aws_subnet.ecs_portfolio_public_subnet1.id
  route_table_id = aws_route_table.ecs_portfolio_route.id
}

resource "aws_route_table_association" "ecs_portfolio_public_subnet2" {
  subnet_id      = aws_subnet.ecs_portfolio_public_subnet2.id
  route_table_id = aws_route_table.ecs_portfolio_route.id
}