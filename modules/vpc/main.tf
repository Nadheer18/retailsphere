resource "aws_vpc" "this" {

  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "retailsphere-${var.environment}-vpc"
    Environment = var.environment
  }
}

resource "aws_subnet" "public_a" {

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_1_cidr
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "retailsphere-public-a"
  }
}

resource "aws_subnet" "public_b" {

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_2_cidr
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "retailsphere-public-b"
  }
}

resource "aws_subnet" "private_a" {

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = "ap-south-1a"

  tags = {
    Name = "retailsphere-private-a"
  }
}

resource "aws_subnet" "private_b" {

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = "ap-south-1b"

  tags = {
    Name = "retailsphere-private-b"
  }
}

resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.this.id

  tags = {
    Name = "retailsphere-igw"
  }
}

resource "aws_route_table" "public" {

  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "retailsphere-public-rt"
  }
}

resource "aws_route_table_association" "public_a" {

  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {

  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}