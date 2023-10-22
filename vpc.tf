resource "aws_vpc" "main-vpc" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "main-vpc"
    }
}

resource "aws_subnet" "main-public-1" {
    cidr_block = "10.0.1.0/24"
    vpc_id = aws_vpc.main-vpc.id
    map_public_ip_on_launch = true
    availability_zone = "eu-central-1a"

    tags = {
        Name = "main-public-1"
    }
}


resource "aws_subnet" "main-private-1" {
    cidr_block = "10.0.2.0/24"
    vpc_id = aws_vpc.main-vpc.id
    map_public_ip_on_launch = false
    availability_zone = "eu-central-1a"

    tags = {
        Name = "main-private-1"
    }
}


resource "aws_internet_gateway" "main-gw" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "main-gw"
  }
}

resource "aws_route_table" "main-public" {
  vpc_id = aws_vpc.main-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-gw.id

  }

  tags = {
    Name = "main-public"
  }
}

resource "aws_route_table_association" "main-public-1a" {
  subnet_id = aws_subnet.main-public-1.id
  route_table_id = aws_route_table.main-public.id
}