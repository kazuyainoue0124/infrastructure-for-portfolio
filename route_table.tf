resource "aws_route_table" "portfolio_route" {
  vpc_id = aws_vpc.portfolio_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.portfolio_igw.id
  }

  tags = {
    Name = "portfolio_route"
  }
}

resource "aws_route_table_association" "portfolio_public_subnet1" {
  subnet_id      = aws_subnet.portfolio_public_subnet1.id
  route_table_id = aws_route_table.portfolio_route.id
}

resource "aws_route_table_association" "portfolio_public_subnet2" {
  subnet_id      = aws_subnet.portfolio_public_subnet2.id
  route_table_id = aws_route_table.portfolio_route.id
}