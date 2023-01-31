resource "aws_vpc" "Drohealth_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    "Name" = "Drohealth_vpc"
  }
}

resource "aws_subnet" "metabase_subnet_a" {
  vpc_id                  = aws_vpc.Drohealth_vpc.id
  availability_zone       = "us-east-1a"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "metabase_subnet_a"
  }
}

resource "aws_subnet" "metabase_subnet_b" {
  vpc_id                  = aws_vpc.Drohealth_vpc.id
  availability_zone       = "us-east-1b"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "metabase_subnet_b"
  }
}

resource "aws_internet_gateway" "metabase_igw" {
  vpc_id = aws_vpc.Drohealth_vpc.id
  tags = {
    "Name" = "metabase_igw"
  }
}

resource "aws_route_table" "metabase_route_table" {
  vpc_id = aws_vpc.Drohealth_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.metabase_igw.id
  }
}

resource "aws_route_table_association" "metabase_rt_a" {
  subnet_id      = aws_subnet.metabase_subnet_a.id
  route_table_id = aws_route_table.metabase_route_table.id
}

resource "aws_route_table_association" "metabase_rt_b" {
  subnet_id      = aws_subnet.metabase_subnet_b.id
  route_table_id = aws_route_table.metabase_route_table.id
}