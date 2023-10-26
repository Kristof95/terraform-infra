resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Main VPC"
  }
}

resource "aws_subnet" "main-public" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "${var.AWS_REGION}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet - ${var.AWS_REGION}a"
  }
}

resource "aws_subnet" "main-private" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "${var.AWS_REGION}a"
  map_public_ip_on_launch = false

  tags = {
    Name = "Private Subnet - ${var.AWS_REGION}a"
  }
}

resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "route-table" {
  vpc_id = aws_vpc.main.id
  route {
    gateway_id = aws_internet_gateway.internet-gateway.id
    cidr_block = "0.0.0.0/0"
  }
}

resource "aws_route_table_association" "route-table-association" {
  route_table_id = aws_route_table.route-table.id
  subnet_id = aws_subnet.main-public.id
}