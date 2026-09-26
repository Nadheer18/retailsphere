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
    Name = "retailsphere-${var.environment}-public-a"

    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "public_b" {

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_2_cidr
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "retailsphere-${var.environment}-public-b"

    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "private_a" {

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = "ap-south-1a"

  tags = {
    Name = "retailsphere-${var.environment}-private-a"

    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "private_b" {

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = "ap-south-1b"

  tags = {
    Name = "retailsphere-${var.environment}-private-b"

    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.this.id

  tags = {
    Name = "retailsphere-${var.environment}-igw"
  }
}

resource "aws_route_table" "public" {

  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "retailsphere-${var.environment}-public-rt"
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

resource "aws_eip" "nat" {

  count = var.enable_nat_gateway ? 1 : 0

  domain = "vpc"

  tags = {
    Name = "retailsphere-${var.environment}-nat-eip"
  }
}

resource "aws_nat_gateway" "nat" {

  count = var.enable_nat_gateway ? 1 : 0

  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public_a.id

  depends_on = [
    aws_internet_gateway.igw
  ]

  tags = {
    Name = "retailsphere-${var.environment}-nat"
  }
}

resource "aws_route_table" "private" {

  count = var.enable_nat_gateway ? 1 : 0

  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[0].id
  }

  tags = {
    Name = "retailsphere-${var.environment}-private-rt"
  }
}

resource "aws_route_table_association" "private_a" {

  count = var.enable_nat_gateway ? 1 : 0

  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private[0].id
}

resource "aws_route_table_association" "private_b" {

  count = var.enable_nat_gateway ? 1 : 0

  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private[0].id
}