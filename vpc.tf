resource "aws_vpc" "main" {
    cidr_block = "172.20.0.0/16"
    
    instance_tenancy     = "default"
    enable_dns_support   = "true"
    enable_dns_hostnames = "true"
    tags = {
        Name = "main-vpc"
    }
}

resource "aws_subnet" "main-public-1" {
  cidr_block = "172.20.1.0/24"
  vpc_id = aws_vpc.main.id
  map_public_ip_on_launch = true
  availability_zone = "eu-central-1a"

  tags = {
    Name = "main-public-1"
  }
}

resource "aws_subnet" "main-private-1" {
  cidr_block = "172.20.2.0/24"
  vpc_id = aws_vpc.main.id
  map_public_ip_on_launch = false
  availability_zone = "eu-central-1a"

  tags = {
    Name = "main-private-1"
  }
}

resource "aws_internet_gateway" "main-gateway" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "main-route-table" {
    vpc_id = aws_vpc.main.id 
    route {
        gateway_id = aws_internet_gateway.main-gateway.id
        cidr_block = "0.0.0.0/0"
    }
}

resource "aws_route_table_association" "main-route-table-for-public-1a" {
    subnet_id = aws_subnet.main-public-1.id
    route_table_id = aws_route_table.main-route-table.id
}